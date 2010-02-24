
use CatalystX::Declare;

controller SPPM::Web::Controller::Equinocio {
    use Calendar::Simple;
    use DateTime;
    use SPPM::Web::Pod;
    use File::stat;

    action base as 'equinocio' under '/base' {
        $ctx->stash->{equinocio_dir} = $ctx->path_to('root','equinocio');
    }

    final action index as '' under base {
        opendir DIR, $ctx->stash->{equinocio_dir}
            or die "Error opening: $!";
        my @years = sort grep { /\d{4}/ } readdir DIR;
        closedir DIR;

        my $year = pop @years || DateTime->now->year;
        $ctx->res->redirect( $ctx->uri_for('/equinocio', $year) );

    }

    action equinocio (Int $year) as '' under base {
        if ($year !~ /^\d{4}$/) {
            $ctx->res->redirect( $ctx->uri_for('/') );
            $ctx->detach;
        }

        # Problems with $ctx->stash( x => y);
        $ctx->stash->{year} = $year;
        $ctx->stash->{now} = DateTime->now();
        $ctx->stash->{calendar_mar} = calendar(3, $year);
        $ctx->stash->{calendar_set} = calendar(9, $year);
    }

    under equinocio {

        final action year as '' {

            my $year_dir = join('/', $ctx->stash->{equinocio_dir}, 
                $ctx->stash->{year});     

            if ( ! -d $year_dir ) {
                $ctx->res->redirect( $ctx->uri_for('/') );
                $ctx->detach;
            }
            $ctx->stash(template => 'equinocio/year.tt');

        }

        action month (Str $month) as '' {
            unless ($month eq 'mar' || $month eq 'set') {
                $ctx->res->redirect( $ctx->uri_for('/') );
                $ctx->detach;
            }
            $ctx->stash->{month} = $month;
        }

        final action day (Int $day) as '' under month{
            
            my $year = $ctx->stash->{year};
            my $month = $ctx->stash->{month};
            
            if ($day !~ /^\d\d?$/) {
                $ctx->res->redirect( $ctx->uri_for('/equinocio') );
                $ctx->detach;
            }

            my $pod_file = join('/', $ctx->stash->{equinocio_dir}, 
                $year, $month, "$day.pod");     

            if (! -e $pod_file) {
                $ctx->res->redirect( $ctx->uri_for('/') );
                $ctx->detach;
            }
            $ctx->log->info($pod_file);
            my $mtime = ( stat $pod_file )->mtime;
            my $cached_pod = $ctx->cache->get("$pod_file $mtime");

            if (!$cached_pod) {
                my $parser = SPPM::Web::Pod->new(
                    StringMode      => 1,
                    FragmentOnly    => 1,
                    MakeIndex       => 0,
                    TopLinks        => 0,
                );

                open my $fh, '<:utf8', $pod_file
                    or die "Failed to open $pod_file: $!";

                $parser->parse_from_filehandle($fh);
                close $fh;

                $cached_pod = $parser->asString;
                $ctx->cache->set("$pod_file $mtime", $cached_pod, '12h' );
            }

            $ctx->stash(
                day => $day,
                pod => $cached_pod,
                template => 'equinocio/day.tt'
            );
            $ctx->forward('View::TT');

        }

    }
}

# Thanks for Advent Calendar of Catalyst. :-)


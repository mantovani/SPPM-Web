
use CatalystX::Declare;

controller SPPM::Web::Controller::Calendar {
        use Calendar::Simple;
        use DateTime;
        use SPPM::Web::Pod;
        use File::stat;

        action base as 'calendar' under '/base' {
            $ctx->stash->{calendar_dir} = $ctx->path_to('root','calendar');
        }

        final action index as '' under base {
            opendir DIR, $ctx->stash->{calendar_dir}
                or die "Error opening: $!";
            my @years = sort grep { /\d{4}/ } readdir DIR;
            closedir DIR;

            my $year = pop @years || $ctx->stash->{now}->year;
            $ctx->res->redirect( $ctx->uri_for('/calendar', $year) );

        }

        action calendar (Int $year) as '' under base {
            if ($year !~ /^\d{4}$/) {
                $ctx->res->redirect( $ctx->uri_for('/') );
                $ctx->detach;
            }

            # Problems with $ctx->stash( x => y);
            $ctx->stash->{year} = $year;
            $ctx->stash->{now} = DateTime->now();
            $ctx->stash->{calendar} = calendar(2, $year);
        }

        under calendar {

            final action year as '' {

                my $year_dir = join('/', $ctx->stash->{calendar_dir}, 
                    $ctx->stash->{year});     

                if ( ! -d $year_dir ) {
                    $ctx->res->redirect( $ctx->uri_for('/') );
                    $ctx->detach;
                }
                $ctx->stash(template => 'calendar/year.tt');

            }

            final action day (Int $day) as '' {
                my $year = $ctx->stash->{year};
                if ($day !~ /^\d\d?$/) {
                    $ctx->res->redirect( $ctx->uri_for('/calendar') );
                    $ctx->detach;
                }

                my $pod_file = join('/', $ctx->stash->{calendar_dir}, 
                    $year, "$day.pod");     

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
                    template => 'calendar/day.tt'
                );
                $ctx->forward('View::TT');

            }

    }
}

# Thanks for Advent Calendar of Catalyst. :-)


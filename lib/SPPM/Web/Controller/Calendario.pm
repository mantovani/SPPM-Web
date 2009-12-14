
use CatalystX::Declare;

controller SPPM::Web::Controller::Calendario {

        use DateTime;

        action base as 'calendario' under '/base' {
            $ctx->stash->{calendario_dir} = $ctx->path_to('root',
                'calendario');
        }

        final action index as '' under base {
            opendir DIR, $ctx->stash->{calendario_dir}
            or die "Error opening: $!";
            my @years = sort grep { /\d{4}/ } readdir DIR;
            closedir DIR;

            my $year = pop @years || DateTime->now->year;
            $ctx->res->redirect( $ctx->uri_for('/calendario', $year) );
        }

        action calendario (Int $year) as '' under base {
            if ($year !~ /^\d{4}$/) {
                $ctx->res->redirect( $ctx->uri_for('/') );
                $ctx->detach;
            }

            $ctx->stash->{year} = $year;
        }

}



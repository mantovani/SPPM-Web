
use CatalystX::Declare;

controller SPPM::Web::Controller::Calendario {
    use Class::CSV;
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

    final action year (Int $year) as '' under base {
        if ($year !~ /^\d{4}$/) {
            $ctx->res->redirect( $ctx->uri_for('/') );
            $ctx->detach;
        }

        my $f_csv = $ctx->path_to('root', 'calendario', "$year.csv");

        if (! -f $f_csv) {
            $ctx->res->redirect( $ctx->uri_for('/') );
            $ctx->detach;
        }

        my $csv = Class::CSV->parse(
            filename    => $f_csv,
            fields      => [qw/data name url/]
        );
            
        $ctx->stash->{events} = [ @{$csv->lines()} ]; 
        $ctx->stash->{year} = $year;

    }

}



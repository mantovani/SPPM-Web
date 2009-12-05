
use Calendar::Simple;
use CatalystX::Declare;

controller SPPM::Web::Controller::Calendar {

        action base as 'calendar' under '/base';

        final action day (Int $year, Int $day) as '' under base {
           
            goto RES_MAIN if ($year !~ /^\d{4}$/ || $day !~ /^\d\d?$/);

            my $pod_file = $ctx->path_to('root', $year, "$day.pod");     

            goto RES_MAIN unless -e $pod_file;

            $ctx->stash(
                calendar => Calendar::Simple::calendar(2, $year),
                pod => 'podtext'
            );
            $ctx->forward('View::TT');
            $ctx->detach;

RES_MAIN:
            $ctx->res->redirect('/');
            $ctx->detach;
        }

}



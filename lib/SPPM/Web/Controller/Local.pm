
use CatalystX::Declare;

controller SPPM::Web::Controller::Local {

    action base as '' under '/base';

    final action local(Str $local) as '' under base {
        my $legal_chars = quotemeta('.-_/');

        if ($local =~ /\.\./ || $local =~ /[^\w$legal_chars]/ ) {
            $ctx->res->redirect('/');
            $ctx->detach;
        }

        my $local_file = $ctx->path_to('root','templates', 'src',
            'local', "$local.tt");
        
        if (! -e $local_file) {
            $ctx->res->redirect('/');
            $ctx->detach;
        }

        $ctx->stash( template => 'local/' . $local . '.tt' );
        $ctx->forward('View::TT');

    }

}



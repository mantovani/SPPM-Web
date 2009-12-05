
use CatalystX::Declare;

controller SPPM::Web::Controller::Local {

        action base as '' under '/base';

        final action local(Str $local) as '' under base {
            my (@local_pages) = split(' ', $ctx->config->{local_pages});
          
            my $legal_chars = quotemeta('.-_/');

            goto RES_MAIN if ( $local =~ /\.\./ 
                || $local =~ /[^\w$legal_chars]/ );

            goto RES_MAIN if ( ! grep (/^$local$/, @local_pages ) );

            $ctx->stash( template => 'local/' . $local . '.tt' );
            $ctx->forward('View::TT');
            $ctx->detach;

RES_MAIN:
            $ctx->res->redirect('/');

        }

}



    {
        if ( $ctx->req->param eq 'POST' ) {
            my $infos = $ctx->req->body_params;

            my $check = $ctx->model('Encontros::Inscrico')->find(
                {   email       => $infos->{'email'},
                    encontro_id => $infos->{'encontro_id'}
                }
            );

            if ( !$check ) {
                my $insert
                    = $ctx->model('Encontros::Inscrico')->create($infos);
                $ctx->stash( template => 'encontrotecnico/ok.tt' );
            } else {
                $ctx->stash( template => 'encontrotecnico/not_ok.tt' );
            }
        }
    }


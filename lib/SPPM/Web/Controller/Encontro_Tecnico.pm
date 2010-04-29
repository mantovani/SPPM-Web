
use CatalystX::Declare;

controller SPPM::Web::Controller::Encontro_Tecnico {

    action base as 'encontrotecnico' under '/base' {

        $ctx->stash(
            db_participar   => $ctx->model('Encontros::Participar'),   
            db_encontros    => $ctx->model('Encontros::EncontrosTecnico'),
            db_inscricao    => $ctx->model('Encontros::Inscricao'),
        );

    }

    final action index as '' under base {

        $ctx->stash(
            encontros               => [$ctx->stash->{'db_encontros'}->search({ativo => 1})],
            check_encontros         => $ctx->stash->{'db_encontros'}->find({ativo => 1}),
            encontros_encerrados    => [$ctx->stash->{'db_encontros'}->search({ativo => 0})],
            check_encerrados        => $ctx->stash->{'db_encontros'}->find({ativo => 0})
            );
        $ctx->stash( template => 'encontrotecnico/listar.tt' );
        $ctx->forward('View::TT');

    }

    final action enjoy (Int $id) as 'inscrever' under base {
        $ctx->stash->{'id'} = $id;
        use aliased 'SPPM::Web::Form::EncontroTecnico' => 'FormCadas';
        my $form = FormCadas->new(
            item => $ctx->stash->{'db_inscricao'}->new_result({id => ''}),
        );

        if ($ctx->req->method eq 'GET') {

            # - Checa se o ID do evento existe e se ele está ativo.

            my $check_id = $ctx->stash->{'db_encontros'}->search({
                id    => $id
            })->find({ativo => 1});
            if ($check_id) {
                $ctx->stash->{'form'} = $form;
                $ctx->stash( template => 'encontrotecnico/inscrever.tt' );
                $ctx->forward('View::TT');
            } else {

                $ctx->res->redirect($ctx->uri_for('../','index'));
                
            }
        } elsif($ctx->req->method eq 'POST') {
            if($ctx->stash->{'db_inscricao'}->find({email => $ctx->req->params->{'email'}})) {

                $ctx->forward('check_exists');

            } else {
                $form->process(params => $ctx->req->params);
                if($form->validated) {

                  $ctx->forward('check_exists');

            
                } else {
                    $ctx->stash->{'form'} = $form;
                    $ctx->stash( template => 'encontrotecnico/inscrever.tt' );
                }
            }
        }
    }

    action check_exists (Str $string) is private {

        my $id = $ctx->stash->{'id'};
        my $inscrito = $ctx->stash->{'db_inscricao'}->find({email => $ctx->req->params->{'email'}});

        # - Checa se o email do inscrito já está cadastrado no evento(id do evento => $id )

        if (not $ctx->stash->{'db_participar'}->search({encontro => $id})->find({inscrito => $inscrito->id})) {
            my $participar = $ctx->stash->{'db_participar'}->create({encontro  => $id, inscrito => $inscrito->id});

            # - Verifica se já tem 50 inscritos na tabela.

            my $check_count = $ctx->stash->{'db_participar'}->search(encontro => $id)->count;
            if ($check_count >= 50) {
                $ctx->stash->{'db_encontros'}->find({ id => $id })->update({ativo => 0 });
            }

            $ctx->stash( template => 'encontrotecnico/ok.tt' );

        } else {

            $ctx->stash( template => 'encontrotecnico/ja_cadastrado.tt' );

        }

        $ctx->forward('View::TT');
    }

}



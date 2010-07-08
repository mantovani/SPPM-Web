
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

        $ctx->stash(
            release => $ctx->stash->{'db_encontros'}->find({id => $id})
        );
        $ctx->stash->{'id'} = $id;

        # - Form

        use aliased 'SPPM::Web::Form::EncontroTecnico' => 'FormCadas';
        my $form = FormCadas->new(
            item => $ctx->stash->{'db_inscricao'}->new_result({
            }),
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

                $ctx->res->redirect('/encontrotecnico');
                
            }
        } elsif($ctx->req->method eq 'POST') {

			# - Checa se o Encontro Ainda está ativo, antes de fazer qualquer coisa.

			my $max_participantes = $ctx->stash->{'db_encontros'}->find({id => $id})->max_participantes;
            my $check_count = $ctx->stash->{'db_participar'}->search(encontro => $id)->count;

			 # - Se já tiver ultrapassado o limite manda para a página de inscricao de novo.
            if ($check_count >= $max_participantes) {
                $ctx->res->redirect($ctx->uri_for('../','encontrotecnico'));
				$ctx->detach();
			}


            if($ctx->stash->{'db_inscricao'}->find({email => $ctx->req->params->{'email'}})) {

                $ctx->forward('check_exists');

            } else {
                $form->process(params => $ctx->req->params, ip => $ctx->req->hostname);
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

        # - Checa se o email do inscrito já está cadastrado no evento(id do evento => $id ).

        if (not $ctx->stash->{'db_participar'}->search({encontro => $id})->find({inscrito => $inscrito->id})) {
            $ctx->stash->{'db_participar'}->create({encontro  => $id, inscrito => $inscrito->id});

            # - Verifica se já passou o número máximo de participantes.

            my $max_participantes = $ctx->stash->{'db_encontros'}->find({id => $id})->max_participantes;
            my $check_count = $ctx->stash->{'db_participar'}->search(encontro => $id)->count;
            if ($check_count >= $max_participantes) {

                # - Ultrapassou agora o encontro_tecnicos não está mais disponível para outro cadastro.

                $ctx->stash->{'db_encontros'}->find({ id => $id })->update({ativo => 0 });
            }

            $ctx->stash( template => 'encontrotecnico/ok.tt' );

        } else {

            $ctx->stash( template => 'encontrotecnico/ja_cadastrado.tt' );

        }

        $ctx->forward('View::TT');
    }

}



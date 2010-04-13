
use CatalystX::Declare;

controller SPPM::Web::Controller::Encontro_Tecnico {

    action base as 'encontrotecnico' under '/base';

    final action index as '' under base {
        $ctx->stash(encontros => [$ctx->model('Encontros::EncontroTecnico')->all]);
        $ctx->stash( template => 'encontrotecnico/listar.tt' );
        $ctx->forward('View::TT');
    }

    final action enjoy (Int $id) as 'inscrever' under base {
        use aliased 'SPPM::Web::Form::EncontroTecnico' => 'FormCadas';
        my $form = FormCadas->new(
            item => $ctx->model('Encontros::Inscrico')->new_result({encontro_id => $id}),
        );
            
        if ($ctx->req->method eq 'GET') {
            my $check = $ctx->model('Encontros::EncontroTecnico')->find(
                { id   => $id }
            );
            if ($check) {
                $ctx->stash->{'form'} = $form;
                $ctx->stash( template => 'encontrotecnico/inscrever.tt' );
                $ctx->forward('View::TT');
            }
            else {
                $ctx->res->redirect($ctx->uri_for('../','index'));
            }
        } 
        elsif($ctx->req->method eq 'POST') {
            $form->process(params => $ctx->req->params);
            if($form->validated) {
                $ctx->stash( template => 'encontrotecnico/ok.tt' );                                    
            } else {
                $ctx->stash->{'form'} = $form;
                $ctx->stash( template => 'encontrotecnico/inscrever.tt' );
            }
            $ctx->forward('View::TT');
        }
    }

}



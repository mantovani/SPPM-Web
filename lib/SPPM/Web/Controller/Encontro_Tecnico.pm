
use CatalystX::Declare;

controller SPPM::Web::Controller::Encontro_Tecnico {

    action base as 'encontrotecnico' under '/base';

    final action index as '' under base {
        $ctx->stash(encontros => [$ctx->model('Encontros::EncontroTecnico')->all]);
        $ctx->stash( template => 'encontrotecnico/listar.tt' );
        $ctx->forward('View::TT');
    }

    final action enjoy (Int $id) as 'inscrever' under base {
        my $check = $ctx->model('Encontros::EncontroTecnico')->find(
            { id   => $id }
        );
        if ($check) {
            $ctx->stash->{'id'} = $id;
            $ctx->stash( template => 'encontrotecnico/inscrever.tt' );
            $ctx->forward('View::TT');
        } else {
            $ctx->res->redirect($ctx->uri_for('../','index'));
        }
    }

    final action subscribe as 'inserir' under base {
    
        if ( $ctx->req->method eq 'POST' ) {
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
             $ctx->forward('View::TT');
        }
        else {
            $ctx->res->redirect($ctx->uri_for('../','index'));
        }
    } 

}



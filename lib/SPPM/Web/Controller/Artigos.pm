package SPPM::Web::Controller::Artigos;

use Moose;
use MooseX::MethodAttributes;
use HTML::Scrubber;
use Gravatar::URL;
BEGIN { extends 'Catalyst::Controller'; }
use utf8;

sub base : Chained('/base') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{collection} = $c->model('Artigo');
    $c->stash(
        scrubber => sub {
            my $html     = shift;
            my $scrubber = HTML::Scrubber->new(

                allow => [qw[a p b i u hr br table tr td ul li]]
            );
            return $scrubber->scrub($html);
        },
        procurar => sub {
            my ( $year, $article ) = @_;
            return $c->model('MongoDB')->procurar( $year, $article );
        },
        gravatar => sub {
            my $email = shift;
            return gravatar_url( email => $email );
        }
    );
}

sub root : Chained('base') : PathPart('artigo') : Args(2) {
    my ( $self, $c, $year, $article ) = @_;
    $c->stash( year => $year, article => $article );

    my $artigo = $c->stash->{collection};

    eval {
        my $basedir = $c->path_to( 'root', 'artigos', $year );
        $artigo->basedir("$basedir");
        $artigo->file("$article.pod");
    };

    $c->stash( templates => 'local/error.tt' ) and return if $@;

    $c->stash(
        pod      => $artigo->content,
        template => 'local/artigo_pod.tt',
        eqtitle  => $artigo->title
    );

}

sub comentar : Chained('base') : PathPart('comentar') : Args(2) {
    my ( $self, $c, $year, $article ) = @_;
    $c->stash( year => $year, article => $article );
    $c->stash(
        nome    => $c->session->{'nome'},
        email   => $c->session->{'email'},
        apelido => $c->session->{'apelido'}
    );
    if ( %{ $c->req->body_params } ) {
        my $params = $c->req->body_params;
        my ( $email, $nome, $comentario ) =
          ( $params->{email}, $params->{nome}, $params->{comentario} );
        my $apelido = $params->{apelido} || '';
        $c->stash( email => $email, nome => $nome, apelido => $apelido );
        $c->session( email => $email, nome => $nome, apelido => $apelido );
        unless ( $email && $nome && $comentario ) {
            $c->stash->{error_msg} = 'Os campos com "*" são obrigatórios.';
            $c->forward( $c->view('Iframe') );
            return;
        }
        if ( length($comentario) > 1500 ) {
            $c->stash->{'comentario'} = $comentario;
            $c->stash->{error_msg} =
              'O máximo de caracteres permitidos são 1500 no comentário.';
            $c->forward( $c->view('Iframe') );
            return;
        }
        if ( length($nome) > 150 ) {
            $c->stash->{error_msg} = 'O nome pode ter até 150 caracteres';
            $c->forward( $c->view('Iframe') );
            return;
        }
        if ( $apelido and length($apelido) > 150 ) {
            $c->stash->{error_msg} = 'O apelido pode ter até 150 caracteres';
            $c->forward( $c->view('Iframe') );
            return;
        }
        if ( length($email) > 200 ) {
            $c->stash->{error_msg} = 'O email pode ter até 250 caracteres';
            $c->forward( $c->view('Iframe') );
            return;
        }
        if ( $email !~ /@/ ) {
            $c->stash->{error_msg} =
              'O email deve ter o seguinte formato: foo@bar.com';
            $c->forward( $c->view('Iframe') );
            return;
        }
        my $comentario_ok = $c->stash->{scrubber}->($comentario);
        $c->model('MongoDB')->c->insert(
            {
                comentario => $comentario_ok,
                year       => $year,
                article    => $article,
                email      => $email,
                nome       => $nome,
                apelido    => $apelido
            }
        );
    }
    $c->forward( $c->view('Iframe') );
}

__PACKAGE__->meta->make_immutable;

1;


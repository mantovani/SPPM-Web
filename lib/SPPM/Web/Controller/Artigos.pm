package SPPM::Web::Controller::Artigos;

use Moose;
use MooseX::MethodAttributes;
use Digest::MD5 qw (md5_hex);

BEGIN { extends 'Catalyst::Controller'; }

sub base : Chained('/base') PathPart('') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{collection} = $c->model('Artigo');
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
    my $md5;
    eval { $md5 = md5_hex($artigo->content); };
    if ($@) {
        eval { $md5 = md5_hex($artigo->title); };
        if ($@) {
        $md5 = join('-', 'artigo', $article, $year);
        }
    }

    $c->stash(
        pod      => $artigo->content,
        template => 'local/artigo_pod.tt',
        eqtitle  => $artigo->title,
        md5      => $md5,
    );

}

__PACKAGE__->meta->make_immutable;

1;


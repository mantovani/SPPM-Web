package SPPM::Web::Controller::Artigos;

use Moose;
use MooseX::MethodAttributes;
 
BEGIN { extends 'Catalyst::Controller'; }
use SPPM::Artigo;
use utf8;

sub artigo : Chained('/base') : PathPart('artigo') : Args(2) {
    my ( $self, $c, $year, $article ) = @_;

    my $basedir = $c->path_to('root', 'artigos', $year);
    my $artigo = SPPM::Artigo->new(basedir => "$basedir");
    $artigo->file("$article.pod");

    $c->stash(
        pod => $artigo->content,
        template => 'local/artigo_pod.tt',
        title => $artigo->title
    );

}

__PACKAGE__->meta->make_immutable;

1;


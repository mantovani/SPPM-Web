package SPPM::Web::Controller::Local;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' };

use utf8;

sub base :Chained('/base') : PathPart(''): CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash->{collection} = $c->model('Local');
}

sub local :Chained('base') : PathPart(''): Args(1) {
	my ($self, $c, $local) = @_;

    my $page = $c->stash->{collection};

    eval {
        my $basedir = $c->path_to('root', 'templates', 'src', 'local');
        $page->basedir("$basedir");
        $page->file("$local.tt");
    };

    my $template = $@ ? 'error.tt' : "$local.tt";
    $c->stash( template => "local/$template");

}

__PACKAGE__->meta->make_immutable;

1;


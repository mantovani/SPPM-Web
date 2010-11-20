package SPPM::Web::Controller::Local;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
use SPPM::Local;
use utf8;

sub base :Chained('/base') : PathPart(''): CaptureArgs(0) {}

sub local :Chained('base') : PathPart(''): Args(1) {
	my ($self, $c, $local) = @_;

    my $page;
    eval {
        my $basedir = $c->path_to('root', 'templates', 'src', 'local');
        $page = SPPM::Local->new(basedir => "$basedir");
        $page->file("$local.tt");
    };

    if ($@) {
        warn $@;
        $c->stash( template => "local/error.tt");
    } else {
        $c->stash( template => "local/$local.tt" );
    }

}

1;


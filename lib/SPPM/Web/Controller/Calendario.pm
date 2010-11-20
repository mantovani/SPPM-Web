package SPPM::Web::Controller::Calendario;
use Moose;

use namespace::autoclean;


BEGIN {extends 'Catalyst::Controller'; }


use Class::CSV;
use DateTime;

sub base : Chained('/base') PathPart('equinocio') CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash->{calendario_dir} = $c->path_to('root', 'calendario');
}

sub index : Chained('base') PathPart('') Args(0) {
    my ($self, $c) = @_;

    opendir DIR, $c->stash->{calendario_dir} or die "Error opening: $!";
    my @years = sort grep { /\d{4}/ } readdir DIR;
    closedir DIR;

    my $year = pop @years || DateTime->now->year;
    $c->res->redirect( $c->uri_for('/calendario', $year) );
}

sub year : Chained('base') Args(0) {
    my ($self, $c, $year) = @_;

    if ($year !~ /^\d{4}$/) {
        $c->res->redirect( $c->uri_for('/') );
        $c->detach;
    }

    my $f_csv = $c->path_to('root', 'calendario', "$year.csv");

    if (! -f $f_csv) {
        $c->res->redirect( $c->uri_for('/') );
        $c->detach;
    }

    my $csv = Class::CSV->parse(
        filename    => $f_csv,
        fields      => [qw/data name url/]
    );
        
    $c->stash->{events} = [ @{$csv->lines()} ]; 
    $c->stash->{year} = $year;

}

__PACKAGE__->meta->make_immutable;


1;



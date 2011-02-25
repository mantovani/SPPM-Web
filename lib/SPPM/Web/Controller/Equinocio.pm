
package SPPM::Web::Controller::Equinocio;

use Moose;
use MooseX::MethodAttributes;
BEGIN { extends 'Catalyst::Controller'; }

use Calendar::Simple;
use DateTime;
use SPPM::Web::Pod;
use File::stat;

sub base : Chained('/base') PathPart('equinocio') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{equinocio_dir} = $c->path_to( 'root', 'equinocio' );
}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;

    opendir DIR, $c->stash->{equinocio_dir}
      or die "Error opening: $!";
    my @years = sort grep { /\d{4}/ } readdir DIR;
    closedir DIR;

    my $year = pop @years || DateTime->now->year;
    $c->res->redirect( $c->uri_for( '/equinocio', $year ) );
}

sub equinocio : Chained('base') : PathPart('') : CaptureArgs(1) {
    my ( $self, $c, $year ) = @_;

    if ( $year !~ /^\d{4}$/ ) {
        $c->res->redirect( $c->uri_for('/') );
        $c->detach;
    }

    $c->stash(
        year         => $year,
        now          => DateTime->now(),
        calendar_mar => [ calendar( 3, $year ) ],
        calendar_set => [ calendar( 9, $year ) ]
    );
}

sub year : Chained('equinocio') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
    my $year_dir = join( '/', $c->stash->{equinocio_dir}, $c->stash->{year} );

    if ( !-d $year_dir ) {
        $c->res->redirect( $c->uri_for('/') );
        $c->detach;
    }
    $c->stash( template => 'equinocio/year.tt' );

}

sub month : Chained('equinocio') : PathPart('') : CaptureArgs(1) {
    my ( $self, $c, $month ) = @_;

    unless ( grep { /mar|set|test/ } $month ) {
        $c->res->redirect( $c->uri_for('/') );
        $c->detach;
    }
    $c->stash->{month} = $month;
}

sub month_view : Chained('month') : PathPart('') : Args(0) {
}

sub day : Chained('month') : PathPart('') : Args(1) {
    my ( $self, $c, $day ) = @_;
    my $year  = $c->stash->{year};
    my $month = $c->stash->{month};

    if ( $day !~ /^\d\d?$/ ) {
        $c->res->redirect( $c->uri_for('/equinocio') );
        $c->detach;
    }

    my $pod_dir =
      join( '/', $c->stash->{equinocio_dir}, $year, $month );

    my $artigo = $c->model('Artigo');

    eval {
        $artigo->basedir("$pod_dir");
        $artigo->file("$day.pod");
    };

    $c->stash( templates => 'local/error.tt' ) and return if $@;

    $c->stash(
        day      => $day,
        pod      => $artigo->content,
        eqtitle  => $artigo->title,
        md5      => $artigo->md5,
        template => 'equinocio/day.tt',
    );
    $c->forward('View::TT');

}

# Thanks for Advent Calendar of Catalyst. :-)
__PACKAGE__->meta->make_immutable;

1;


package SPPM::Web::Controller::Root;
use Moose;
use Digest::MD5 qw (md5_hex);

use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

SPPM::Controller::Root - Root Controller for SPPM

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub base : Chained('/') : PathPart('') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash( 
        md5 => md5_hex($c->req->uri->path), 
        path => $c->req->uri->path
    );
}

sub hidden_page : Path('/hidden_page') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( template => \'CONTEÚDO ESCONDIDO' );
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect('/principal');
}

sub default : Path {
    my ( $self, $c ) = @_;
    $c->response->body('Page not found');
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
}

=head1 AUTHOR

Thiago Rondon,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

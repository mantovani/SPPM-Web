package SPPM::Web::Controller::Root;
use Moose;

use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use utf8;

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
}

sub auto : Private {
    my ( $self, $c ) = @_;

    if (   $c->action eq $c->controller('Login')->action_for('login')
        || $c->action     eq $c->controller('Root')->action_for('index')
        || $c->controller eq $c->controller('Artigos')
        || $c->controller eq $c->controller('Calendario')
        || $c->controller eq $c->controller('Equinocio')
        || $c->controller eq $c->controller('Local') ) {
        return 1;
    }

    # If a user doesn't exist, force login
    if (!$c->user_exists
        or ( (      !$c->check_user_roles('admin')
                and !$c->check_user_roles('gerente')
                and !$c->check_user_roles('funcionario')
            )
        )
        ) {

        # Redirect the user to the login page
        $c->forward(qw/SPPM::Web::Controller::Login login/);

     # Return 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }

    # User found, so return 1 to continue with processing after this 'auto'
    return 1;
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

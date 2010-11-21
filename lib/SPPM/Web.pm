package SPPM::Web;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    Authentication
    Session
    Session::State::Cookie
    Session::Store::File
    ConfigLoader
    Static::Simple
	Unicode::Encoding
    Facebook
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in sppm_web.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'SPPM::Web',
);

__PACKAGE__->config->{'recaptcha'}->{'pub_key'} =
'6Le0CroSAAAAACWhFwcZ0K54ooBT6KBQ3VTfIoqz';

__PACKAGE__->config->{'recaptcha'}->{'priv_key'} =
'6Le0CroSAAAAAIAsTZ9CRMNdA88jktjzYMnVa6or';

__PACKAGE__->config( {
    ENCODING     => 'utf-8',
} );


# Start the application
__PACKAGE__->setup();


=head1 NAME

SPPM::Web - Catalyst based application

=head1 SYNOPSIS

    script/sppm_web_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<SPPM::Web::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Thiago Rondon,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

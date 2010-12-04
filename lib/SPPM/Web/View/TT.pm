package SPPM::Web::View::TT;

use Moose;
BEGIN { extends 'Catalyst::View::TT' }

__PACKAGE__->config(
    INCLUDE_PATH => [
        SPPM::Web->path_to( 'root', 'templates', 'src' ),
        SPPM::Web->path_to( 'root', 'templates', 'lib' )
    ],
    TEMPLATE_EXTENSION => '.tt',
    ENCODING           => 'utf8',
    WRAPPER            => 'site/wrapper',
    TIMER              => 0,
);

=head1 NAME

SPPM::Web::View::TT - TT View for SPPM::Web

=head1 DESCRIPTION

TT View for SPPM::Web.

=head1 SEE ALSO

L<SPPM::Web>

=head1 AUTHOR

Thiago Rondon,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

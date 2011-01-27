package SPPM::Web::View::Iframe;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    INCLUDE_PATH => [
        SPPM::Web->path_to( 'root', 'templates', 'src' ),
        SPPM::Web->path_to( 'root', 'templates', 'lib' )
    ],
    TEMPLATE_EXTENSION => '.tt',
    ENCODING           => 'utf8',
    WRAPPER            => 'site/wrapper_iframe',
    TIMER              => 0,
);

=head1 NAME

SPPM::Web::View::Iframe - TT View for SPPM::Web

=head1 DESCRIPTION

TT View for SPPM::Web.

=head1 SEE ALSO

L<SPPM::Web>

=head1 AUTHOR

Daniel Mantovani,,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

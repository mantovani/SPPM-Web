package SPPM::Web::Controller::News;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use REST::Google;
use REST::Google::Search::News;
use Cache::File;
use JSON;

REST::Google::Search->http_referer('http://sao-paulo.pm.org');

has 'news' => (
    is      => 'ro',
    isa     => 'Object',
    default => sub {
        return REST::Google::Search::News->new(
            q  => 'Perl',
            hl => 'pt-br',
            key =>
'ABQIAAAAAts6Q-bzHfaFjX6hknap6hTHda-5vSAheCDiovayKHKHiMLZ8BRewhFksScqss0nuCZZzwizJmyaxw',
        );
    },
    lazy => 1,
);

has cache => (
    is      => 'ro',
    isa     => 'Object',
    default => sub { Cache::File->new( cache_root => '/tmp/news' ) }
);

=head1 NAME

SPPM::Web::Controller::News - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub base : Chained('/base') PathPart('news') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash(
        get_news => sub {
            my $res = $self->news;
            die "response status failure" if $res->responseStatus != 200;
            my $data = $res->responseData;
            my @data_pt = grep { $_->{language} eq 'pt' } @{ $data->{results} };
            return \@data_pt;
        }
    );
}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;

    my $cached_news = $self->cache->get("news");

    if ( !$cached_news ) {
        my $content = $c->stash->{'get_news'}->();
        $self->cache->set( "news", encode_json $content, '12h' );
        $c->stash( cached_news => $content );
    }
    else {
        $c->stash( cached_news => decode_json $cached_news );
    }
}

=head1 AUTHOR

Daniel Mantovani,,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

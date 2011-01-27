package SPPM::Web::Model::MongoDB;

use Moose;
use MooseX::Method::Signatures;

BEGIN { extends 'Catalyst::Model::MongoDB' }

__PACKAGE__->config(
    host           => '127.0.0.1',
    port           => '27017',
    dbname         => 'site_sppm',
    collectionname => 'comentario',
    gridfs         => '',
);


method criar(Str $comentario, Int $year!, Str $article!, Str $email!, Str $name!, Str $apelido) {
	my $date = DateTime->now;
	my ($time) = (time);
	my $create = $self->c('comentar')->insert({
		article		=>	$article,
		year		=>	$year,
		time		=> 	$time,
		email		=>	$email,
		comentario	=>	$comentario,
		apelido		=>	$apelido
	});
	return $create;
}

method procurar(Int $year!, Str $article!) {
	my $result = $self->c->find({
		year	=>	$year,
		article	=>	$article
	});
	return $result;
}

=head1 NAME

SPPM::Web::Model::MongoDB - MongoDB Catalyst model component

=head1 SYNOPSIS

See L<SPPM::Web>.

=head1 DESCRIPTION

MongoDB Catalyst model component.

=head1 AUTHOR

Daniel Mantovani,,,,

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

no Moose;
__PACKAGE__->meta->make_immutable;

1;

package SPPM::Schema::Result::Inscricao;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('ForceUTF8');

=head1 NAME

SPPM::Schema::Result::Inscricao

=cut

__PACKAGE__->table("inscricao");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  is_auto_increment: 1
  is_nullable: 0
  size: 11

=head2 nome

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 email

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 telefone_comercial

  data_type: INT
  default_value: undef
  is_nullable: 0
  size: 11

=head2 telefone_celular

  data_type: INT
  default_value: undef
  is_nullable: 0
  size: 11

=head2 empresa_trabalha

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 ramo_trabalha

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 sabendo

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 observacao

  data_type: VARCHAR
  default_value: undef
  is_nullable: 1
  size: 250

=head2 ip

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 11

=head2 data_inscricao

  data_type: TIMESTAMP
  default_value: CURRENT_TIMESTAMP
  is_nullable: 0
  size: 14

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INT",
    default_value => undef,
    is_auto_increment => 1,
    is_nullable => 0,
    size => 11,
  },
  "nome",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 250,
  },
  "email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 250,
  },
  "telefone_comercial",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "telefone_celular",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "empresa_trabalha",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 250,
  },
  "ramo_trabalha",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 250,
  },
  "sabendo",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 250,
  },
  "observacao",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 250,
  },
  "ip",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 11,
  },
  "data_inscricao",
  {
    data_type => "TIMESTAMP",
    default_value => \"CURRENT_TIMESTAMP",
    is_nullable => 0,
    size => 14,
  },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 participars

Type: has_many

Related object: L<SPPM::Schema::Result::Participar>

=cut

__PACKAGE__->has_many(
  "participars",
  "SPPM::Schema::Result::Participar",
  { "foreign.inscrito" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-04-29 20:06:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mvkPiqlGfOUVOUdEseF6BA



# You can replace this text with custom content, and it will be preserved on regeneration
1;


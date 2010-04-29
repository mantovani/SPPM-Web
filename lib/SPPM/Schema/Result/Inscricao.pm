package Schema::Result::Inscricao;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 NAME

Schema::Result::Inscricao

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

=head2 empresa_trabalha_id

  data_type: INT
  default_value: undef
  is_foreign_key: 1
  is_nullable: 0
  size: 11

=head2 ramo_trabalha_id

  data_type: INT
  default_value: undef
  is_foreign_key: 1
  is_nullable: 0
  size: 11

=head2 sabendo_id

  data_type: INT
  default_value: undef
  is_foreign_key: 1
  is_nullable: 0
  size: 11

=head2 observacao

  data_type: VARCHAR
  default_value: undef
  is_nullable: 1
  size: 250

=cut

__PACKAGE__->add_columns(
    "id",
    {   data_type         => "INT",
        default_value     => undef,
        is_auto_increment => 1,
        is_nullable       => 0,
        size              => 11,
    },
    "nome",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 0,
        size          => 250,
    },
    "email",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 0,
        size          => 250,
    },
    "telefone_comercial",
    {   data_type     => "INT",
        default_value => undef,
        is_nullable   => 0,
        size          => 11
    },
    "telefone_celular",
    {   data_type     => "INT",
        default_value => undef,
        is_nullable   => 0,
        size          => 11
    },
    "empresa_trabalha_id",
    {   data_type      => "INT",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
        size           => 11,
    },
    "ramo_trabalha_id",
    {   data_type      => "INT",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
        size           => 11,
    },
    "sabendo_id",
    {   data_type      => "INT",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
        size           => 11,
    },
    "observacao",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 1,
        size          => 250,
    },
);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many( "empresas", "Schema::Result::Empresa",
    { "foreign.empresa" => "self.empresa_trabalho_id" },
);

=head1 RELATIONS

=head2 empresa_trabalha

Type: belongs_to

Related object: L<Schema::Result::Empresa>

=cut

__PACKAGE__->belongs_to( "empresa_trabalha", "Schema::Result::Empresa",
    { id => "empresa_trabalha_id" }, {}, );

=head2 ramo_trabalha

Type: belongs_to

Related object: L<Schema::Result::Ramo>

=cut

__PACKAGE__->belongs_to( "ramo_trabalha", "Schema::Result::Ramo",
    { id => "ramo_trabalha_id" }, {}, );

=head2 sabendo

Type: belongs_to

Related object: L<Schema::Result::FicouSabendo>

=cut

__PACKAGE__->belongs_to(
    "sabendo",
    "Schema::Result::FicouSabendo",
    { id => "sabendo_id" }, {},
);

=head2 participars

Type: has_many

Related object: L<Schema::Result::Participar>

=cut

__PACKAGE__->has_many( "participars", "Schema::Result::Participar",
    { "foreign.inscrito" => "self.id" },
);

# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-04-27 11:19:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xVR/JRBUZPD0n2giVx0HDQ

# You can replace this text with custom content, and it will be preserved on regeneration
1;


package Schema::Result::Inscrico;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/InflateColumn::DateTime ForceUTF8/);

=head1 NAME

Schema::Result::Inscrico

=cut

__PACKAGE__->table("inscricoes");

=head1 ACCESSORS

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
  is_nullable: 1
  size: 11

=head2 telefone_celular

  data_type: INT
  default_value: undef
  is_nullable: 1
  size: 11


=head2 empresa

  data_type: VARCHAR
  default_value: undef
  is_nullable: 1
  size: 250

=head2 sabendo

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 ramo

  data_type: VARCHAR
  default_value: undef
  is_nullable: 1
  size: 250

=head2 encontro_id

  data_type: INT
  default_value: undef
  is_nullable: 0
  size: 11

=head2 observacao

  data_type: VARCHAR
  default_value: undef
  is_nullable: 1
  size: 250

=cut

__PACKAGE__->add_columns(
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
        is_nullable   => 1,
        size          => 11
    },
    "telefone_celular",
    {   data_type     => "INT",
        default_value => undef,
        is_nullable   => 1,
        size          => 11
    },
    "empresa",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 1,
        size          => 250,
    },
    "sabendo",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 0,
        size          => 250,
    },
    "ramo",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 1,
        size          => 250,
    },
    "encontro_id",
    {   data_type     => "INT",
        default_value => undef,
        is_nullable   => 0,
        size          => 11
    },
    "observacao",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 1,
        size          => 250,
    },
);
__PACKAGE__->set_primary_key( "email", "encontro_id" );

# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-04-12 03:11:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4eaVJE6h9DHw/+lmOMxueg

# You can replace this text with custom content, and it will be preserved on regeneration
1;

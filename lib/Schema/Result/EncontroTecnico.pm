package Schema::Result::EncontroTecnico;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/InflateColumn::DateTime ForceUTF8/);
=head1 NAME

Schema::Result::EncontroTecnico

=cut

__PACKAGE__->table("encontro_tecnico");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  is_nullable: 0
  is_auto_increment: 1
  size: 11

=head2 nome

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 local

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 data

  data_type: DATE
  default_value: undef
  is_nullable: 0
  size: 10

=head2 descricao

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=cut

__PACKAGE__->add_columns(
    "id",
    {   data_type         => "INT",
        default_value     => undef,
        is_nullable       => 0,
        is_auto_increment => 1,
        size              => 11
    },
    "nome",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 0,
        size          => 250,
    },
    "local",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 0,
        size          => 250,
    },
    "data",
    {   data_type     => "DATE",
        default_value => undef,
        is_nullable   => 0,
        size          => 10
    },
    "descricao",
    {   data_type     => "VARCHAR",
        default_value => undef,
        is_nullable   => 0,
        size          => 250,
    },
);
__PACKAGE__->set_primary_key("id");

# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-04-12 03:11:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ftMWUt/p2R9B4qoVSnscMA

# You can replace this text with custom content, and it will be preserved on regeneration
1;

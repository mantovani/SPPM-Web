package Schema::Result::EncontrosTecnico;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('ForceUTF8');


=head1 NAME

Schema::Result::EncontrosTecnico

=cut

__PACKAGE__->table("encontros_tecnicos");

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

=head2 local

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 data

  data_type: DATETIME
  default_value: undef
  is_nullable: 0
  size: 19

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
  "local",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 250,
  },
  "data",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 participars

Type: has_many

Related object: L<Schema::Result::Participar>

=cut

__PACKAGE__->has_many(
  "participars",
  "Schema::Result::Participar",
  { "foreign.encontro" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-04-27 14:43:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XK1nFpzHmlFFQQABo4YpgA



# You can replace this text with custom content, and it will be preserved on regeneration
1;


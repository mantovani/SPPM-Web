package SPPM::Schema::Result::Admin;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('ForceUTF8');

=head1 NAME

SPPM::Schema::Result::Admin

=cut

__PACKAGE__->table("admin");

=head1 ACCESSORS

=head2 nome

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=head2 senha

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 250

=cut

__PACKAGE__->add_columns(
  "nome",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 250,
  },
  "senha",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 250,
  },
);
__PACKAGE__->set_primary_key("nome");


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-04-29 18:41:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0GvsyAIwOAYFKgylpcPLzw



# You can replace this text with custom content, and it will be preserved on regeneration
1;


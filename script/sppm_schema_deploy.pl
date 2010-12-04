#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use SPPM::Schema;

my $schema = SPPM::Schema->connect( 'dbi:mysql:dbname=sppm:host=localhost',
    'sppm', 'begin' );

sub run {
    my ($sql) = @_;
    print STDERR "\n$sql\n" if $ENV{DBIC_TRACE};
    $schema->storage->dbh_do( sub { $_[1]->do($sql) } );
}

for ( split /;/, $schema->storage->deployment_statements($schema) ) {
    if (/CREATE\s+TABLE\s+(\S+)/) {
        run $_;
    }
}

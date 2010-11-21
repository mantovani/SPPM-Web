
use Test::More tests => 6;
use strict;

use FindBin qw($Bin);

use_ok('SPPM::Web::Model::FS');

my $obj;

eval { $obj = SPPM::Web::Model::FS->new(basedir => "$Bin/test-notexist") };
is($@, '', 'basedir not exist');

eval { $obj = SPPM::Web::Model::FS->new(basedir => "$Bin/test-basedir") };
is($@, '', 'basedir exist');

eval { $obj->file('../local.tt') };
isnt($@, '', 'local with ..');

eval { $obj->file('local.tt') };
is($@, '', 'local.tt is ok');

ok($obj->fullpath);

1;


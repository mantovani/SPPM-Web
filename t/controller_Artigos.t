use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'SPPM::Web' }
BEGIN { use_ok 'SPPM::Web::Controller::Artigos' }

ok( request('/artigos')->is_success, 'Request should succeed' );
done_testing();

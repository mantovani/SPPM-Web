use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'SPPM::Web' }
BEGIN { use_ok 'SPPM::Web::Controller::Local' }

ok( request('/empresas')->is_success, 'Request should succeed' );
ok( request('/quemsomos')->is_success, 'Request should succeed' );
ok( request('/treinamento')->is_success, 'Request should succeed' );
ok( request('/encontrosocial')->is_success, 'Request should succeed' );
done_testing();

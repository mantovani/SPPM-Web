use strict;
use warnings;
use Test::More;


use Catalyst::Test 'SPPM::Web';
use SPPM::Web::Controller::News;

ok( request('/news')->is_success, 'Request should succeed' );
done_testing();


package SPPM::Web::Model::DB;

use Moose;

extends 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
        schema_class => 'SPPM::Schema',

        connect_info => {
            dsn      => 'dbi:mysql:host=localhost:dbname=sppm',
            user     => 'sppm',
            password => 'begin',
    }
);

1;



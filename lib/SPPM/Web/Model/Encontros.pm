use CatalystX::Declare;

model SPPM::Web::Model::Encontros extends
     Catalyst::Model::DBIC::Schema {

        $CLASS->config(

            schema_class => 'SPPM::Schema',

            connect_info => {
             dsn      => 'dbi:mysql:dbname=sppm',
             user     => 'root',
             password => '4rg63a',
        }
        
    );

}

=head1 NAME

SPPM::Web::Model::Encontros - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<SPPM::Web>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.4

=head1 AUTHOR

Daniel de Oliveira Mantovani

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
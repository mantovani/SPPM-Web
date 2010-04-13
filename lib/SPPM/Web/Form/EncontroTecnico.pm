package SPPM::Web::Form::EncontroTecnico;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

use utf8;
use namespace::autoclean;
use Moose::Util::TypeConstraints;

has '+item_class' => ( default => 'Encontros::Inscrico' );

has_field 'nome' => (
    type             => 'Text',
    label            => 'Nome do usuário',
    required_message => 'Obrigatório',
    required         => 1,
);
has_field 'email' => (
    type             => 'Email',
    label            => 'Email',
    unique           => 1,
    required         => 1,
    required_message => 'Obrigatório',
    unique_message   => 'Alguém já se cadastrou usando esse email',
);

has_field 'telefone_comercial' => (
    type             => 'Text',
    apply            => [ { check => qr/[0-9]{8,12}/ } ],
    label            => 'Telefone Comercial',
    required_message => 'Obrigatório, só número sem espaços.',
    required         => 1,
);

has_field 'telefone_celular' => (
    type             => 'Text',
    apply            => [ { check => qr/[0-9]{8,12}/ } ],
    label            => 'Telefone Celular',
    required_message => 'Obrigatório, só números sem espaços.',
    required         => 1,
);

has_field 'ramo' => (
    type             => 'Text',
    label            => 'Ramo de Trabalho',
    required_message => 'Obrigatório',
    required         => 1,
);
has_field 'sabendo' => (
    type             => 'Text',
    label            => 'Como ficou sabendo ?',
    required_message => 'Obrigatório',
    required         => 1,
);

has_field 'Participar' => ( type => 'Submit' );
no HTML::FormHandler::Moose;
1;


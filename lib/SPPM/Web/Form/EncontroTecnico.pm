package SPPM::Web::Form::EncontroTecnico;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

use utf8;
use strict;
use warnings;
use namespace::autoclean;
use Moose::Util::TypeConstraints;

subtype
    'tamanho_min' => as 'Str',
    => where { length($_) >= 6 },
    => message {'Precisa ter pelo menos seis caracteres.'};

has_field 'nome' => (
    type             => 'Text',
    label            => 'Nome Completo',
    required_message => 'Obrigatório',
    required         => 1,
    apply            => ['tamanho_min'],
);
has_field 'email' => (
    type             => 'Email',
    label            => 'Email',
    required         => 1,
    unique           => 1,
    unique_message   => 'Essa email já foi cadastrado',
    required_message => 'Obrigatório',
);

has_field 'telefone' => (
    type             => 'Text',
    label            => 'Telefone',
    required_message => 'Obrigatório',
    required         => 1,
    trim             => {
        transform => sub {
            my $string = shift;
            $string =~ s/[\s\-\+]//g;
            return $string;
            }
    },
    apply => [
        {   check   => qr/^[\d\s\-\+]{8,15}$/,
            message => 'Tem que ter no minimo 8 números e no máximo 15.'
        },
    ],
);

has_field 'ramo_trabalha' => (
    type             => 'Text',
    label            => 'Ramo de Trabalho',
    required_message => 'Obrigatório',
    required         => 1,
);

has_field 'empresa_trabalha' => (
    type             => 'Text',
    label            => 'Empresa que Trabalha',
    required_message => 'Obrigatório',
    required         => 1,
);

has_field 'sabendo' => (
    type             => 'Text',
    label            => 'Como ficou sabendo ?',
    required_message => 'Obrigatório',
    required         => 1,
);

has 'ip' => ( isa => 'Str', is => 'rw' );

before 'update_model' => sub {
    my $self = shift;
    $self->item->ip( $self->ip );
};

has_field 'Participar' => ( type => 'Submit', value => "Participar!" );
no HTML::FormHandler::Moose;
1;


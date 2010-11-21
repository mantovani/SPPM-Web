package SPPM::Web::Model::FS;

use Moose;

extends 'Catalyst::Model';

has legal_chars => (
    is => 'ro',
    isa => 'Str',
    default => quotemeta('.-_/')
);

has basedir => (
    is => 'rw',
    isa => 'Str',
    default => '/tmp'
);

after basedir => sub {
    my $self = shift;
    my $orig = shift;
    
    return if !$orig;

    die "Where is the basedir ?" if ! -d $orig;
};

has file => (
    is => 'rw',
    isa => 'Str',
);

after file => sub {
    my $self = shift;
    my $orig = shift;
    return if !$orig;
   
    die "This file is insane" 
        if $orig =~ /\.\./ || $orig =~ /[^\w$self->legal_chars]/;

    $self->fullpath(join('/', $self->basedir, $orig));

    die "What file?"
        if ! -f $self->fullpath;

};    
    
has fullpath => (
    is => 'rw',
    isa => 'Str',
    default => ''
);
    
1;


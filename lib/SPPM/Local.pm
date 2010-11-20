package SPPM::Local;

use Moose;

has legal_chars => (
    is => 'ro',
    isa => 'Str',
    default => quotemeta('.-_/')
);

has basedir => (
    is => 'rw',
    isa => 'Str',
    required => 1
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
};    
    
has fullpath => (
    is => 'rw',
    isa => 'Str',
    default => ''
);
        
1;


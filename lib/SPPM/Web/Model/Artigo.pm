package SPPM::Web::Model::Artigo;

use Moose;
extends 'SPPM::Web::Model::FS';

use Cache::File;
use File::stat;
use POSIX qw(strftime);
use DateTime;
use SPPM::Web::Pod;
use HTML::TreeBuilder::XPath;
use Digest::MD5 qw (md5_hex);

has cache => (
    is      => 'ro',
    isa     => 'Object',
    default => sub { Cache::File->new( cache_root => '/tmp' ) }
);

has title => (
    is      => 'rw',
    isa     => 'Str',
    default => ''
);

has md5 => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub {
        my $self = shift;
        return $self->has_content ? md5_hex($self->content) : undef;
    }

);

# predicate ? 
has has_content => (
    is => 'rw',
    isa => 'Int',
    default => 0
);

sub content {
    my $self = shift;
    my $file = $self->fullpath or return;

    my $mtime      = ( stat $file )->mtime;
    my $cached_pod = $self->cache->get("$file $mtime");

    if ( !$cached_pod ) {
        my $parser = SPPM::Web::Pod->new(
            StringMode   => 1,
            FragmentOnly => 1,
            MakeIndex    => 0,
            TopLinks     => 0,
        );

        open my $fh, '<:utf8', $file
            or die "Failed to open $file: $!";

        $parser->parse_from_filehandle($fh);
        close $fh;

        $cached_pod = $parser->asString;
        $self->cache->set( "$file $mtime", $cached_pod, '12h' );
    }

    my $tree  = HTML::TreeBuilder::XPath->new_from_content($cached_pod);
    my $title = $tree->findnodes('//h1')->[0]->as_text;
    $self->title($title);
    $tree->delete;

    $self->has_content(1);
    return $cached_pod;
}

1;


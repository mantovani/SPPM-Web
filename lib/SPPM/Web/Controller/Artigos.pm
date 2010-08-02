
use Catalyst;

use File::stat;
use POSIX qw(strftime);
use DateTime;
use SPPM::Web::Pod;

sub artigo : Chained('base') : PathPart('artigo') : Args(2) {
    my ( $self, $c, $year, $article ) = @_;
    my $legal_chars = quotemeta('.-_/');

    if ( $article =~ /\.\./ || $article =~ /[^\w$legal_chars]/ ) {
        $c->res->redirect('/');
        $c->detach;
    }

    my $pod_file = $c->path_to( 'root', 'artigos', $year, "$article.pod" );

    if ( !-e $pod_file ) {
        $c->res->redirect('/');
        $c->detach;
    }

    my $mtime      = ( stat $pod_file )->mtime;
    my $cached_pod = $c->cache->get("$pod_file $mtime");

    if ( !$cached_pod ) {
        my $parser = SPPM::Web::Pod->new(
            StringMode   => 1,
            FragmentOnly => 1,
            MakeIndex    => 0,
            TopLinks     => 0,
        );

        open my $fh, '<:utf8', $pod_file
          or die "Failed to open $pod_file: $!";

        $parser->parse_from_filehandle($fh);
        close $fh;

        $cached_pod = $parser->asString;
        $c->cache->set( "$pod_file $mtime", $cached_pod, '12h' );
    }

    $c->stash(
        pod      => $cached_pod,
        template => 'local/artigo_pod.tt'
    );

    $c->forward('View::TT');
}

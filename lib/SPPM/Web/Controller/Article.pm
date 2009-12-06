
use CatalystX::Declare;

controller SPPM::Web::Controller::Article {

        use File::stat;
        use POSIX qw(strftime);
        use DateTime;
        use SPPM::Web::Pod;

        action base as 'article' under '/base';

        final action article (Str $article) as '' under base {
            my $legal_chars = quotemeta('.-_/');

            if ($article =~ /\.\./ || $article =~ /[^\w$legal_chars]/ ) {
                $ctx->res->redirect('/');
                $ctx->detach;
            }

            my $pod_file = $ctx->path_to('root','artigos',"$article.pod");
            
            if (! -e $pod_file) {
                $ctx->res->redirect('/');
                $ctx->detach;
            }

            my $mtime = ( stat $pod_file )->mtime;
            my $cached_pod = $ctx->cache->get("$pod_file $mtime");

            if (!$cached_pod) {
                my $parser = SPPM::Web::Pod->new(
                    StringMode      => 1,
                    FragmentOnly    => 1,
                    MakeIndex       => 0,
                    TopLinks        => 0,
                );

                open my $fh, '<:utf8', $pod_file
                    or die "Failed to open $pod_file: $!";

                $parser->parse_from_filehandle($fh);
                close $fh;

                $cached_pod = $parser->asString;
                $ctx->cache->set("$pod_file $mtime", $cached_pod, '12h' );
            }


            $ctx->stash(
                pod => $cached_pod,
                template => 'local/artigo_pod.tt' 
            );
            
            $ctx->forward('View::TT');

        }

}



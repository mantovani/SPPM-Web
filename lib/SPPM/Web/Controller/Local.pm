

package SPPM::Web::Controller::Local;

use Moose;
use MooseX::MethodAttributes;
extends 'Catalyst::Controller';


sub base :Chained('/base') : PathPart(''): CaptureArgs(0) {}

sub local :Chained('base') : PathPart(''): Args(1) {
	my ($self, $c, $local) = @_;

        my $legal_chars = quotemeta('.-_/');

        if ($local =~ /\.\./ || $local =~ /[^\w$legal_chars]/ ) {
            $c->res->redirect('/');
            $c->detach;
        }

        my $local_file = $c->path_to('root','templates', 'src',
            'local', "$local.tt");
        
        if (! -e $local_file) {
            $c->res->redirect('/');
            $c->detach;
        }

        $c->stash( template => 'local/' . $local . '.tt' );
        $c->forward('View::TT');

}

1;



package SPPM::Web::Controller::Equinocio;

use Moose;
use MooseX::MethodAttributes;
BEGIN { extends 'Catalyst::Controller'; }

use Calendar::Simple;
use DateTime;
use SPPM::Web::Pod;
use File::stat;
use HTML::TreeBuilder::XPath;
use utf8;

sub base : Chained('/base') PathPart('equinocio') CaptureArgs(0) {
	my ($self, $c) = @_;
        $c->stash->{equinocio_dir} = $c->path_to('root','equinocio');
}

sub index : Chained('base') : PathPart('') : Args(0) {
	my ($self, $c) = @_;

        opendir DIR, $c->stash->{equinocio_dir}
            or die "Error opening: $!";
        my @years = sort grep { /\d{4}/ } readdir DIR;
        closedir DIR;

        my $year = pop @years || DateTime->now->year;
        $c->res->redirect( $c->uri_for('/equinocio', $year) );
}

sub equinocio : Chained('base') : PathPart('') : CaptureArgs(1) {
	my ($self, $c, $year) = @_;
        
	if ($year !~ /^\d{4}$/) {
            $c->res->redirect( $c->uri_for('/') );
            $c->detach;
        }

        $c->stash(
		year => $year,
		now => DateTime->now(),
		calendar_mar => [ calendar(3, $year) ],
		calendar_set => [ calendar(9, $year) ]
	);
}

sub year : Chained('equinocio') : PathPart('') : Args(0) {
	my ($self, $c) = @_;
	my $year_dir = join('/', $c->stash->{equinocio_dir}, 
                $c->stash->{year});     

	if ( ! -d $year_dir ) {
		$c->res->redirect( $c->uri_for('/') );
                $c->detach;
	}
	$c->stash(template => 'equinocio/year.tt');

}

sub month : Chained('equinocio') : PathPart(''): CaptureArgs(1) {
	my ($self, $c, $month) = @_;

	unless (grep {/mar|set|test/} $month) {
		$c->res->redirect( $c->uri_for('/') );
                $c->detach;
	}
	$c->stash->{month} = $month;
}

sub month_view : Chained('month') : PathPart(''): Args(0) {}

sub day : Chained('month') : PathPart('') : Args(1) {        
	my ($self, $c, $day) = @_;
	my $year = $c->stash->{year};
	my $month = $c->stash->{month};
            
	if ($day !~ /^\d\d?$/) {
		$c->res->redirect( $c->uri_for('/equinocio') );
		$c->detach;
	}

	my $pod_file = join('/', $c->stash->{equinocio_dir}, 
		$year, $month, "$day.pod");     

	if (! -e $pod_file) {
		$c->res->redirect( $c->uri_for('/') );
		$c->detach;
	}
	$c->log->info($pod_file);
	my $mtime = ( stat $pod_file )->mtime;
	#my $cached_pod = $c->cache->get("$pod_file $mtime");

	#if (!$cached_pod) {
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

                my $cached_pod = $parser->asString;
     #           $c->cache->set("$pod_file $mtime", $cached_pod, '12h' );
	#}


	my $tree  = HTML::TreeBuilder::XPath->new_from_content($cached_pod);
	my $title = $tree->findnodes('//h1')->[0]->as_text;
	$c->stash->{'eqtitle'} = $title;
	$tree->delete;


    	$c->stash(
		day => $day,
		pod => $cached_pod,
                template => 'equinocio/day.tt',
    	);
	$c->forward('View::TT');

}
# Thanks for Advent Calendar of Catalyst. :-)
__PACKAGE__->meta->make_immutable;

1;


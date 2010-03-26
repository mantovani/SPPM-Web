#!/usr/bin/env perl

# by maluco

use strict;
use warnings;

use utf8;

use constant ARTIGOS_DIR => "/home/sppm/catalyst/root/artigos";

package Artigos::POD;

use base 'Pod::Xhtml';
use utf8;

sub new {
    my $class = shift;
    $Pod::Xhtml::SEQ{L} = \&seqL;
    $class->SUPER::new(@_);
}

sub textblock {
    my $self   = shift;
    my ($text) = @_;
    $self->{_first_paragraph} ||= $text;

    if($self->{_in_author_block}){
            $text =~ /((?:[\w.]+\s+)+)/ and $self->{_author} = $1;
            $text =~ /<([^<>@\s]+@[^<>\s]+)>/ and $self->{_email} = $1;
            $self->{_in_author_block} = 0; # not anymore
    }

    return $self->SUPER::textblock(@_);
}

sub command {
    my $self = shift;
    my ($command, $paragraph, $pod_para) = @_;

    $self->{_title} = $paragraph
    if $command eq 'head1' and not defined $self->{_title};
                        
    $self->{_in_author_block} = 1
    if $command =~ /^head/ and 
        ($paragraph =~ /AUTHOR/ or $paragraph =~ /AUTOR/);

    return $self->SUPER::command(@_);
}

sub seqL {
    my ($self, $link) = @_;
    $self->{LinkParser}->parse($link);
    my $page = $self->{LinkParser}->page;
    my $kind = $self->{LinkParser}->type;
    my $targ = $self->{LinkParser}->node;
    my $text = $self->{LinkParser}->text;
                            
    if ($kind eq 'hyperlink'){
        return $self->SUPER::seqL($link);
    }
                                                
    $targ ||= $text;
    $text = Pod::Xhtml::_htmlEscape($text);
    $targ = Pod::Xhtml::_htmlEscape($targ);
                                                                
    return qq{<a href="http://search.cpan.org/perldoc?$targ">$text</a>};
}

sub title   { $_[0]->{_title} }
sub summary { $_[0]->{_first_paragraph} }
sub author  { $_[0]->{_author} }
sub email   { $_[0]->{_email} }

1;


package main;

use HTML::Tiny;

sub get_pod_dirs() { grep { /^\d{4}$/ } @_; }

sub get_pod_files() { grep { /pod$/ } @_; }

sub read_dir {
    my $directory = shift;

    opendir(AD, $directory) or die "Cannot open directory";
    my @files = readdir(AD);
    closedir(AD);

    @files;
}

sub main {
	
    my @pod_dirs = &get_pod_dirs(&read_dir(ARTIGOS_DIR));

    my $html = HTML::Tiny->new;

    foreach my $dir (reverse sort @pod_dirs) {
        print $html->h3($dir), "\n";
        my @year_files = &get_pod_files(&read_dir(join('/', ARTIGOS_DIR,
                    $dir)));

        my @files;
        foreach my $file (sort @year_files) {
            
            my $path_file = join('/', ARTIGOS_DIR, $dir, $file);

            my $parser = Artigos::POD->new(
                StringMode  => 1,
                FragmentOnly    => 1,
                MakeIndex       => 0,
                TopLinks        => 0,
            );

            open my $fh, '<:utf8', , $path_file
                or die "Failed to open $path_file: $!";

            $parser->parse_from_filehandle($fh);
            close $fh;
            
            my $f = {};
            $f->{file} = $file;

            $f->{uri} = $file;
            $f->{uri} =~ s/\.pod$//g;
            $f->{uri} = join('/', '/artigo', $dir, $f->{uri});

            $f->{title} = $parser->title;
            $f->{title} =~ s/\n//g;


            my $author = $parser->author;
            $author =~ s/,.*//;
            $f->{author} = $author ? " por " . $author : '';
            $f->{author} =~ s/\ $//;

            push(@files, $f);
        }

        print $html->ul( [map { 
                $html->li(
                $html->a( { href=> $_->{uri} },  
                join('', $_->{title},  $_->{author}, ".")  )
            )
                , "\n" }  @files ] ), "\n";
    }
}

main;
1;


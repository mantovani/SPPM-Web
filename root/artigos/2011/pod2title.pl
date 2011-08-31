#!/usr/bin/perl

use strict;
use warnings;
use 5.10.1;

use Text::Unaccent;
use File::Copy;

opendir my $dh, '/home/mantovani/Perl/Web/SPPM-Web/root/artigos/2011' or die $!;

parser();

sub files {
    return grep { $_ !~ /^\.|pod2title/ } readdir($dh);
}

sub parser {
    for my $file ( files() ) {
        open my $fh, '<', $file or die $!;
        my $all_file = join '', <$fh>;
        if ( $all_file =~ /head1 (.+)/ ) {
            my $title_clean = clean_title($1);
            my $title       = $1;
            move( $file, "clean/$title_clean" );
        }

        close $fh;
    }
}

sub clean_title {
    my $title = unac_string( 'utf8', shift );
    $title =~ s/[,\.\-\s!\(\)\?:\'\"]//g;
    return $title;
}

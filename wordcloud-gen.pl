#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

# TODO: should improve with more fancy regexes
my $mds = `cat *.lagda *.tex`;

$mds =~ s/\\begin\{.*\}//g;
$mds =~ s/\\end\{.*\}//g;
$mds =~ s/subsubsec//g;
$mds =~ s/subsec//g;
$mds =~ s/\\[a-zA-Z0-9]+//g;

my $arg = "--width 1280 --height 720 --background white --color blue";

my $tmp = 'wordcloud-tmp';
open(my $fh, '>', $tmp) or die "Failed to open file '$tmp', $!";
print $fh $mds;
close $fh;

print `cat $tmp | wordcloud_cli $arg --imagefile pic-wordcloud.png`;
print `rm $tmp`;

$mds =~ s/type//gi;
$mds =~ s/coe//gi;
$mds =~ s/path//gi;

open($fh, '>', $tmp) or die "Failed to open file '$tmp', $!";
print $fh $mds;
close $fh;

print `cat $tmp | wordcloud_cli $arg --imagefile pic-wordcloud-no-coe-path-type.png`;
print `rm $tmp`;
print "Generation done.\n";

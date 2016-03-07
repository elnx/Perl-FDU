#!/usr/bin/perl -w
use strict;
my @lines = split("\n", `netstat -an`);
my @tcp = grep(/^  TCP/, @lines);
my %count;
foreach my $link (@tcp) {
    my @tmp = split(/[ ]+/, $link);
    $count{$tmp[4]}++;
}
print "$_\t$count{$_}\n" foreach (keys %count);

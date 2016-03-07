#!/usr/bin/perl -w
use strict;
my ($i, $j);
foreach $i (1..9){
	foreach $j (1..9){
		if ($i <= $j) {
			print $i*$j;
			print "\t" if $j < 9;
		} else {
			print "\t";
		} 
	}
	print "\n"	;
}

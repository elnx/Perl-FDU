#!/usr/bin/perl -w
use strict;
my($line, $result);

print "Enter an empty line to quit. ";
while (1) {
	print "Enter your expression and type [ENTER] : ";
	$line = <STDIN>;
	chomp $line;
	last if not $line;
	$result = eval "$line";
	if ($line =~ /^[0-9\+\-\*\/\.\(\)]+$/ ) {	
		print "\tError : $@\n" if $@;
		print "\tResult: $result\n" if not $@;
	} else {
		print "\tEnter your expression correctly!\n"
	}
}

1;
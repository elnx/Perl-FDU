#!/usr/bin/perl -w
use strict;
my ($line, @result);

print "Enter a string: ";
$line = <STDIN>;
chomp $line;
exit if not $line;
$" = '\x';
@result = unpack("(A2)*", unpack("H*", $line));
print '\x' . "@result";

1;
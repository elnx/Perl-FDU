#!/usr/bin/perl -w
use strict;
sub fac {
    my $n = $_[0];
    if(1 == $n)
    {
        return 1;
    } else {
        return ($n * fac($n - 1));
    }
}
sub mysin {
    my $result = 0;
    my $temp = 0;
    my($x, $n) = @_;
    for (my $k = 0; $k < $n + 1; $k++) {
        $temp = (-1) ** $k;
        $temp *= $x ** (1 + 2*$k);
        $temp /= fac(1 + 2*$k);
        $result += $temp;
    }
    return $result;
}
#print "$_\t" . mysin(1, $_) . "\n" foreach (1..10)
foreach my $n (1..10) {
    print "$n\t" . mysin(1, $n) . "\n";
}

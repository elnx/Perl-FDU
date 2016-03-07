#!/usr/bin/perl -w
use strict;
use Math::BigInt lib => 'GMP';
use Benchmark;
my $two = Math::BigInt->new('2');
sub bigint {
        $two ** 500;
}
sub normal {
        2 ** 500;
}
timethese(-3,
        {
        bigint => 'bigint()',
        normal => 'normal()'
        }
);
1;
#!/usr/bin/perl -w
use strict;
use PDF::Create;

my $count = 0;
my($x, $y, @lines, $op);
my @op = ('-', '+');
while ($count < 40) {
	$x = int(rand(100));
	$y = int(rand(100));
	$op = int(rand(2));
	if (($op == 1 and $x + $y < 100) or ($op == 0 and $x - $y > 0)) {
		push @lines, "$x $op[$op] $y =";
		$count++;
	}
}

my $pdf = PDF::Create->new(
    'filename'     => 'quiz.pdf',
    'Author'       => 'hdt',
    'Title'        => 'Quiz for Zhou',
    'CreationDate' => [ localtime ]
);
my $root = $pdf->new_page('MediaBox' => $pdf->get_page_size('A4'));
my $page = $root->new_page;
my $font = $pdf->font('BaseFont' => 'Helvetica');
my $height = 780;
my $dist = 88;
foreach my $line (@lines) {
	$page->stringr($font, 12, $dist, $height, $line);
	$dist = ($dist + 144) % 576;
	$height -= 20 if $dist == 88;
}
$pdf->close;

1;
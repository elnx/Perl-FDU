#!/usr/bin/perl -w
use strict;
use Tk;
use Win32::Sound;
use List::Util qw(max);
my $main = new MainWindow;
$main->resizable(0,0);
my $ft = $main->Frame()->pack();
my $fb = $main->Frame()->pack();
my $f1 = $ft->Frame(-relief => 'ridge', -borderwidth => 5)->pack(-side => 'left');
my $f2 = $ft->Frame(-relief => 'ridge', -borderwidth => 5)->pack(-side => 'left');
my $f3 = $ft->Frame(-relief => 'ridge', -borderwidth => 5)->pack(-side => 'left');
my $play = $fb->Button(-text => 'Play', -command => \&play)->pack(-side => 'left');
my $quit = $fb->Button(-text => 'Quit', -command => sub { exit; })->pack(-side => 'left');

my($value1, $value2, $value3);
my $scale1 = $f1->Scale(-orient => 'vertical', -from => 200, -to => 2000, -length => 400, -variable => \$value1)->pack();
my $scale2 = $f2->Scale(-orient => 'vertical', -from => 200, -to => 2000, -length => 400, -variable => \$value2)->pack();
my $scale3 = $f3->Scale(-orient => 'vertical', -from => 200, -to => 2000, -length => 400, -variable => \$value3)->pack();

my($waveshape1, $waveshape2, $waveshape3);
$f1->Radiobutton(-text => 'sin',-value => 'sine', -variable => \$waveshape1)->pack();
$f1->Radiobutton(-text => 'sqr',-value => 'sqr', -variable => \$waveshape1)->pack();
$f1->Radiobutton(-text => 'tri',-value => 'tri', -variable => \$waveshape1)->pack();
$f1->Radiobutton(-text => 'saw',-value => 'saw', -variable => \$waveshape1)->pack();
$f2->Radiobutton(-text => 'sin',-value => 'sine', -variable => \$waveshape2)->pack();
$f2->Radiobutton(-text => 'sqr',-value => 'sqr', -variable => \$waveshape2)->pack();
$f2->Radiobutton(-text => 'tri',-value => 'tri', -variable => \$waveshape2)->pack();
$f2->Radiobutton(-text => 'saw',-value => 'saw', -variable => \$waveshape2)->pack();
$f3->Radiobutton(-text => 'sin',-value => 'sine', -variable => \$waveshape3)->pack();
$f3->Radiobutton(-text => 'sqr',-value => 'sqr', -variable => \$waveshape3)->pack();
$f3->Radiobutton(-text => 'tri',-value => 'tri', -variable => \$waveshape3)->pack();
$f3->Radiobutton(-text => 'saw',-value => 'saw', -variable => \$waveshape3)->pack();

my($enable1, $enable2, $enable3);
$f1->Checkbutton(-text => 'Enable', -onvalue => 1, -offvalue => 0, -variable => \$enable1)->pack();
$f2->Checkbutton(-text => 'Enable', -onvalue => 1, -offvalue => 0, -variable => \$enable2)->pack();
$f3->Checkbutton(-text => 'Enable', -onvalue => 1, -offvalue => 0, -variable => \$enable3)->pack();


$main->MainLoop;
sub play {
	my $WAV = new Win32::Sound::WaveOut(44100, 8, 2);
	my @wave = gen_wav($enable1, $enable2, $enable3);
	my $data = "";
	foreach my $v (@wave) {
		$data .= pack("CC", int $v, int $v);
	}
	$WAV->Load($data);
	$WAV->Write();
	1 until $WAV->Status();
	$WAV->Save('test.wav');
	$WAV->Unload();
}
sub gen_wav {
	my($a, $b, $c) = @_;
	my(@wave1, @wave2, @wave3);
	if ($a) {
		@wave1 = eval("$waveshape1($value1)");
	} else {
		@wave1 = (0) x 44100;
	}
	if ($b) {
		@wave2 = eval("$waveshape2($value2)");
	} else {
		@wave2 = (0) x 44100;
	}
	if ($c) {
		@wave3 = eval("$waveshape3($value3)");
	} else {
		@wave3 = (0) x 44100;
	}
	my @wave = map { ($wave1[$_] + $wave2[$_] + $wave3[$_])} 0..44099;
	my $amp = max(@wave);
	@wave = map {$wave[$_] / $amp * 255} 0..44099 unless $amp == 0;
	return @wave;
}
sub sine {
	my $freq = shift;
	my @v;
	my $counter = 0;
	my $inc = $freq / 44100;
	for my $i (1..44100) {
	    push @v, sin($counter*2*3.14) * 127 + 128;
	    $counter += $inc;
	}
	return @v;
}
sub tri {
	my $freq = shift;
	my @v;
	my $counter = 0;
	my $t = 44100 / $freq;
	my $flag = 1;
	$t = int $t;
	for my $i (1..44100) {
		$counter += $flag;
		push @v, $counter;
		if ($counter >= ($t / 2) or $counter <= 0) {
			$flag = -$flag;
		}
	}
	my $amp = max(@v);
	@v = map {$v[$_] / $amp * 255} 0..44099;
	return @v;
}
sub sqr {
	my $freq = shift;
	my @v;
	my $t = 44100 / $freq;
	$t = int $t;
	for my $i (1..44100) {
		if (($i % $t) < ($t / 2)) {
			push @v, 255;
		} else {
			push @v, 0;
		}
	}
	return @v;
}
sub saw {
	my $freq = shift;
	my @v;
	my $counter = 0;
	my $t = 44100 / $freq;
	$t = int $t;
	for my $i (1..44100) {
		if ($counter < $t) {
			push @v, $counter;
			$counter++;
		} else {
			push @v, $counter;
			$counter = 0;
		}
	}
	my $amp = max(@v);
	@v = map {$v[$_] / $amp * 255} 0..44099;
	return @v;
}

1;
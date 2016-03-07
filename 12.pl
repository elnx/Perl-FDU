#!/usr/bin/perl -w
use strict;
use Tk;
my $main = new MainWindow;
$main->resizable(0, 0);
my $data = '0';
my $flag = 1;
my $dot_count = 0;
my $symbol = '+-*/';
my $exp = $main->Entry(-width => 20, -state => 'disabled', -textvariable => \$data, -justify => 'center')->grid(-row => 0, -column => 0, -columnspan => 4, -sticky => 'nwse');
my $del = $main->Button(-text => '<-', -command => sub {$data = substr($data, 0, (length($data) -1));})->grid(-row => 1, -column => 0, -sticky => 'nwse');
my $clear = $main->Button(-text => 'C', -command => sub {$data = '0'; $flag = 1;})->grid(-row => 1, -column => 1, -columnspan => 2, -sticky => 'nwse');
my $eq = $main->Button(-text => '=', -command => sub {$data = eval($data); $flag = 1;})->grid(-row => 1, -column => 3, -sticky => 'nwse');
my $seven = $main->Button(-text => '7', -command => sub{insert('7');})->grid(-row => 2, -column => 0, -sticky => 'nwse');
my $eight = $main->Button(-text => '8', -command => sub{insert('8');})->grid(-row => 2, -column => 1, -sticky => 'nwse');
my $nine = $main->Button(-text => '9', -command => sub{insert('9');})->grid(-row => 2, -column => 2, -sticky => 'nwse');
my $div = $main->Button(-text => '/', -command => sub{insert('/');})->grid(-row => 2, -column => 3, -sticky => 'nwse');
my $four = $main->Button(-text => '4', -command => sub{insert('4');})->grid(-row => 3, -column => 0, -sticky => 'nwse');
my $five = $main->Button(-text => '5', -command => sub{insert('5');})->grid(-row => 3, -column => 1, -sticky => 'nwse');
my $six = $main->Button(-text => '6', -command => sub{insert('6');})->grid(-row => 3, -column => 2, -sticky => 'nwse');
my $mul = $main->Button(-text => '*', -command => sub{insert('*');})->grid(-row => 3, -column => 3, -sticky => 'nwse');
my $one = $main->Button(-text => '1', -command => sub{insert('1');})->grid(-row => 4, -column => 0, -sticky => 'nwse');
my $two = $main->Button(-text => '2', -command => sub{insert('2');})->grid(-row => 4, -column => 1, -sticky => 'nwse');
my $three = $main->Button(-text => '3', -command => sub{insert('3');})->grid(-row => 4, -column => 2, -sticky => 'nwse');
my $minus = $main->Button(-text => '-', -command => sub{insert('-');})->grid(-row => 4, -column => 3, -sticky => 'nwse');
my $zero = $main->Button(-text => '0', -command => sub{insert('0');})->grid(-row => 5, -column => 0, -sticky => 'nwse');
my $neg = $main->Button(-text => '+/-', -command => sub {$data = 0 - $data;})->grid(-row => 5, -column => 1, -sticky => 'nwse');
my $dot = $main->Button(-text => '.', -command => sub{insert('.');})->grid(-row => 5, -column => 2, -sticky => 'nwse');
my $plus = $main->Button(-text => '+', -command => sub{insert('+');})->grid(-row =>5, -column => 3, -sticky => 'nwse');


sub insert {
	my $char = shift;
	if ($flag eq 0) {
		if ($char eq '.') {
			$data .= $char if $dot_count eq 0;
			$dot_count = 1;
		} else {
			$data .= $char;
			$dot_count = 0 if (index($symbol, $char) ne -1);
		}
	} else {
		if ($char eq '.') {
			$data = '0.';
			$dot_count = 1;
		} else {
			if (index($symbol, $char) ne -1) {
				$data .= $char;
				$dot_count = 0;
			} else {
				$data = $char;
			}
		}
		$flag = 0;
	}
	
}
$main->MainLoop;


1;
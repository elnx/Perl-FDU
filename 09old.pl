#!/usr/bin/perl -w
use strict;
use Win32::IE::Mechanize;
my $url = "http://10.133.30.35/";
my $ie = Win32::IE::Mechanize->new( visible => 1 );
$ie->get($url);
$ie->follow_link( text => "courses");
sleep 1;
$ie->follow_link( text => "Perl Programming Language");
sleep 1;
#$ie->follow_link( text => "homework");

1;
#!/usr/bin/perl -w
use strict;
use Win32::Clipboard;
my $pad = Win32::Clipboard();
while ($pad->WaitForChange()) {
    print "Clipboard changed.\n";
    if ($pad->IsText()) {
    	exit if ($pad->GetText =~ /^http\:\/\//);
        print " text: \"" . $pad->GetText() . "\"\n";
    } else {
        print " not text.\n";
    }

}
#!/usr/bin/perl -w
use strict;
use Data::Dumper;
sub calc {
	my $x = shift;
	my @data = @{$x};
    if (judge($data[1]) == 0) {
		$data[1] = calc($data[1]);
	}
	if (judge($data[2]) == 0) {
		$data[2] = calc($data[2]);
	}
	if ($data[0] eq "+") {
        return $data[1] + $data[2];
	} elsif ($data[0] eq "*") {
		return $data[1] * $data[2];
	}
}

sub judge {
	my $element = shift;
	if (ref($element) eq "ARRAY") {
		return 0;
	} else {
		return 1;
	}
}

sub getInput {
	print "Input the expression : ";
	my $line = <STDIN>;
	chomp $line;
	$line =~ s/\s//g;
	exit if !$line;
	return 0 if $line =~ /[a-zA-Z\.]/;
	if (substr($line,length($line)-1,1) ne "#") {
		$line = join("", $line, "#");
	}
}

sub parseTree {
	my $data = pop;
	my ($stop, $top, $ch, @stack, @tree);
	$top = 0;
	$stack[0] = '#';
	while($top < length($data)) {
		$ch = substr($data, $top, 1);
		if ($ch eq "+") {
			my $op = pop(@stack);
			if($op eq '#' or $op eq '('  or  $op eq '['  or $op eq '{'){
				push(@stack, $op);
				push(@stack, $ch);
			} else {
				push(@stack, $op);
				while (1) {
					my $op = pop(@stack);
                    if ($op eq '#' or $op eq '(' or $op eq '[' or $op eq '{') {
						push(@stack, $op);
						push(@stack, $ch);
						last;
					} else {
						my @node;
						push(@node, $op); 
						push(@node, pop(@tree));
						push(@node, pop(@tree));
						push(@tree,[@node]);
					}
				}
			}
			$top = $top + 1;
			next;
		}
		if ($ch eq "*") {
			my $op = pop(@stack);
			if ($op ne "*") {
				push(@stack,$op);push(@stack,$ch);
			} else {
				push(@stack, $op);
				while (1) {
					my $op = pop(@stack);
					if ($op ne "*") {
						push(@stack, $op);
						push(@stack, $ch); 
						last;
					} else {
						my @node;
						push(@node, $op);
						push(@node, pop(@tree));
						push(@node, pop(@tree));
						push(@tree, [@node]);
					}
				}
			}
			$top = $top + 1;
			next;
		}
		if($ch eq '(' or $ch eq '{' or $ch eq '[') {
			push(@stack, $ch);
			$top = $top + 1;
			next;
		}
		if($ch eq ')' or $ch eq ']' or $ch eq '}'){
			while (1) {
				my $op = pop(@stack);
				if($op eq '('  or $op eq '['  or $op eq '{') {
				  	last;
				}
             	my @node;
			 	push(@node, $op);
				push(@node, pop(@tree));
			 	push(@node, pop(@tree));
				push(@tree,[@node]);
			}
			$top = $top + 1;
			next;
		}
		if ($ch eq '#') {
			while (1) {
				my $op = pop(@stack);
				if ($op eq '#') {
					last;
				} else {
					my @node;
					push(@node, $op);
					push(@node, pop(@tree));
					push(@node, pop(@tree));
					push(@tree, [@node]);
				}
			}
			$top = $top + 1;
			next;
		}
		if ($ch ge '0' and $ch le '9') {
			my $num = 0;
			while ($ch ge '0' and $ch le '9') {
				$num = $num * 10 + $ch;
				$top = $top +1;
				$ch = substr($data, $top, 1);
			}
			push(@tree, $num);
			next;
		} else {
			$top = $top + 1;
		}
	}
	return reverse @tree;
}



while (1) {
	my $expr = getInput();
	if (!$expr) {
		print "Don't be kidding me! Input your expression again!\n";
		next;
	}
	my @tree = parseTree($expr);
	print "The tree :\n" . Dumper(@tree) . " \n";
	my $result = calc($tree[0]);
	print "The result : $result\n";
}


1;
#!/usr/bin/perl
use strict;
use 5.010;

use List::Util qw/min/;

stamp(shift);

sub stamp {
    my $n = shift;
    my @S;

    $S[0] = {value => 0, 2 => 0, 5 => 0, 8 => 0, 14 => 0};

    for my $i (1..$n) {
	my $current = {value=>100000000000};
	my $which;
	for (2,5,8,14) {
	    if ($i - $_ >= 0) {
		if ($current->{value} > $S[$i - $_]{value}) {
		    $current = $S[$i - $_];
		    $which = $_;
		}
	    }
	}

	%{$S[$i]} = %$current;
	$S[$i]{value}++;
	$S[$i]{$which}++;
    }

    if ($S[$n]{value} >= 100000000000) {
	say "No solution";
    }
    else {
	for (sort {$a <=> $b} keys %{$S[$n]}) {
	    next if /value/;
	    say $_ . "=>" . $S[$n]{$_};
	}
	say "Total: " . $S[$n]{value};
    }
}

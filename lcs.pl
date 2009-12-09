#!/usr/bin/perl
use strict;
use 5.010;
use List::Util qw/max/;

say longest_common_subsequence($ARGV[0],$ARGV[1]);

sub longest_common_subsequence {
    my ($str1, $str2) = @_;
    my @map;
    my ($m, $n) =  map { length } ($str1, $str2);

    $map[$_][0] = 0 for 0..$m;
    $map[0][$_] = 0 for 0..$n;


    for my $i (1..$m) {
	for my $j (1..$n) {
	    $map[$i][$j] = max($map[$i-1][$j]   + score(i($str2, $i-1), '_'),
			       $map[$i][$j-1]   + score('_', i($str2, $j-1)), 
			       $map[$i-1][$j-1] + score(i($str1, $i-1), i($str2, $j-1)));
	}
    }

    my $str;

    my ($i, $j) = ($m, $n);
    while ($i != 0 and $j != 0) {
	if (i($str1, $i-1) eq i($str2, $j-1)) {
	    $str .= i($str1, $i-1);
	    $i--;
	    $j--;
	}
	elsif ($map[$i-1][$j] > $map[$i][$j-1]) {
	    $i--;
	}
	else {
	    $j--;
	}
    }

    $str = reverse $str;

    return $str;
}

sub i {
    my ($str, $i) = @_;
    return substr $str, $i, 1;
}

sub score {
    my ($a, $b) = @_;
    return 0 if $a ne $b;
    return 0 if $a eq '_';
    return 1;
}

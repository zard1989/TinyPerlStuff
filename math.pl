#!/usr/bin/perl
use strict;
use 5.010;

use autobox::Core;
use POSIX;

=head2 Todo
1. 支援括號
=cut

test(shift);

sub test {
    my $expr = shift || "1+2-3*4/2";
    say $expr, " = ", calc($expr);
}


sub calc {
    my $expr = shift;
    my @operands = infix_to_postfix($expr);
    say @operands->join(" ");

    my @stack;

    my %op = (
	'+' => sub {$_[0]+$_[1]},
	'-' => sub {$_[0]-$_[1]},
	'*' => sub {$_[0]*$_[1]},
	'/' => sub {$_[0]/$_[1]},
	);

    for my $op (@operands) {
	if ($op ~~ [qw{ + - * / }]) {
	    my $a = pop @stack;
	    my $b = pop @stack;

	    push @stack, $op{$op}->($b, $a);
	    
	    say "Doing: ", $op;
	}
	else {
	    push @stack, $op;
	}

	say "Stack: ", @stack->join(" ");
    }

    return $stack[0];
}

sub infix_to_postfix {
    my $expr = shift;

    my @operands;
    my @operators;

    my @tokens = split/\s*/, $expr;
    my $current_num = '';

    while (@tokens > 0) {
	my $token = shift @tokens;
	if (isdigit $token or $token eq '.') {
	    $current_num .= $token;
	}
	else {
	    if ($current_num ne '') {
		push @operands, $current_num;
		$current_num = '';
		my $last_op = $operators[-1];
		if ($last_op ~~ [qw{ * / }]) {
		    push @operands, pop @operators;
		}
	    }

	    if ($token ~~ [qw{ + - }] and @operators > 0) {
		push @operands, pop @operators;
	    }

	    push @operators, $token;
	}
    }

    push @operands, $current_num;

    while (my $op = pop @operators) {
	push @operands, $op;
    }

    return wantarray ? @operands : [@operands]->join(" ");
}

#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;

main:
{
my $kernBlock = 0;

	while(<>) {
		chomp;
		$kernBlock = 1 if( /lookup PairKerning \{/ );
		$kernBlock = 0 if( /} PairKerning;/ );
		if( $kernBlock ) {
			s/u1E/uni1E/g;
			# if( /pos (.*?) (.*) / ) {
			if( /pos uni(\w{4,5}) uni(\w{4,5})/ ) {
				my($l,$r) = ($1,$2);
				my $pair = sprintf("%c%c", hex($l),hex($r));
				print "$pair\tU+$l U+$r\n";
			}
		}
	}
}

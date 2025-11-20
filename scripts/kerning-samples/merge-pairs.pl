#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;

main:
{
	my %AllPairs = ();

	my $pairFile = "abyssinica-pairs.tsv";
	open( my $pairs, '<:encoding(UTF-8)', $pairFile ) or die "Can't open '$pairFile' for reading: $!";
	while( <$pairs> ) {
		chomp;
		# /^(\w+)\t(\w+)/;  # Perl does not yet recognize Extended-B as \w , so .* used here
		/^(.*)\t(.*?)$/;
		$AllPairs{$1} = $2;
	}
	close( $pairs );

	$pairFile = "noto-pairs.tsv";
	open( $pairs, '<:encoding(UTF-8)', $pairFile ) or die "Can't open '$pairFile' for reading: $!";
	while( <$pairs> ) {
		chomp;
		/^(.*)\t(.*?)$/;
		$AllPairs{$1} = $2;
	}
	close( $pairs );


	$pairFile = "nyala-pairs.tsv";
	open( $pairs, '<:encoding(UTF-8)', $pairFile ) or die "Can't open '$pairFile' for reading: $!";
	while( <$pairs> ) {
		chomp;
		/^(.*)\t(.*?)$/;
		$AllPairs{$1} = $2;
	}
	close( $pairs );


	foreach my $key (sort keys %AllPairs)  {
		print "$key\t$AllPairs{$key}\n";
	}
}

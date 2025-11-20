#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
# binmode(STDOUT, "encoding(UTF-8)");
binmode(STDERR, ":utf8");
use utf8;
use strict;

sub getChar {
$_ = shift;

	my $v = $_;
	return $v if( ($v =~ /\./) || ($v !~ /[0-9]/) );
	$v =~ s/uni//;
	return 	sprintf( "%c",  hex($v) );
}

main:
{
my $kernBlock = 0;
my %KernMap = ();
my %Pairs = ();

	while(<>) {
		chomp;

		$kernBlock = 1 if( /feature kern \{/ );
		$kernBlock = 0 if( /} kern;/ );
		if( $kernBlock ) {
			if( /pos (.*?) (.*) / ) {
				$Pairs{"$1|$2"} = $2;
			}
		}
	}

	foreach my $pair (sort keys %Pairs) {
		$pair =~ /(.*?)\|(.*?)/;
		my $key = $1;
		my $value = $Pairs{$pair};
		# print "$key = $value\n";

		$key   = getChar( $key );
		$value = getChar( $value );

		printf "$key$value\tU+%X U+%X\n", ord($key), ord($value);
	}
}

#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
# binmode(STDOUT, "encoding(UTF-8)");
binmode(STDERR, ":utf8");
use utf8;
use strict;

sub getChar {
$_ = shift;

	s/hhyaethiopic/uni1E7E0/;
	s/hhyuethiopic/uni1E7E1/;
	s/hhyiethiopic/uni1E7E2/;
	s/hhyaaethiopic/uni1E7E3/;
	s/hhyeeethiopic/uni1E7E4/;
	s/hhyeethiopic/uni1E7E5/;
	s/hhyoethiopic/uni1E7E6/;

	s/uni1217.gur/uni1E7E8/;
	s/hwiethiopic/uni1E7E9/;
	s/hweeethiopic/uni1E7EA/;
	s/hweethiopic/uni1E7EB/;

	s/uni1381.gur/uni1E7ED/;
	s/uni1382.gur/uni1E7EE/;

	s/uni124A.gur/uni1E7F0/;
	s/uni124C.gur/uni1E7F1/;
	s/uni124D.gur/uni1E7F2/;

	s/uni1385.gur/uni1E7F3/;
	s/uni1386.gur/uni1E7F4/;

	s/uni12B2.gur/uni1E7F5/;
	s/uni12B4.gur/uni1E7F6/;
	s/uni12B5.gur/uni1E7F7/;

	s/uni1312.gur/uni1E7F8/;
	s/uni1314.gur/uni1E7F9/;
	s/uni1315.gur/uni1E7FA/;

	s/uni1389.gur/uni1E7FB/;
	s/uni138A.gur/uni1E7FC/;

	s/uni138D.gur/uni1E7FD/;
	s/uni138E.gur/uni1E7FE/;

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
			if( /\@_uni(\w+) = \[(.*?)\];/ ) {
				my $key   = "\@_uni$1";
				my @values = split( / /, $2 );
				$KernMap{$key} = [ @values ];
			
			}
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

		if( $key =~ /^\@_/ ) {
			foreach my $k ( @{ $KernMap{$key} } ) {
				$k = getChar( $k );
				if( $value =~ /^\@_/ ) {
					foreach my $v ( @{ $KernMap{$value} } ) {
						$v = getChar( $v );
						# print "$k$v\n";
						printf "$k$v\tU+%X U+%X\n", ord($k), ord($v);
					}
				}
				else {
					$value = getChar( $value );
					# print "$k$value\n";
					printf "$k$value\tU+%X U+%X\n", ord($k), ord($value);
				}
			}
		}
		elsif( $value =~ /^\@_/ ) {
			$key   = getChar( $key );
			foreach my $v ( @{ $KernMap{$value} } ) {
				$v = getChar( $v );
				# print "$key$v\n";
				printf "$key$v\tU+%X U+%X\n", ord($key), ord($v);
			}
		}
		else {
			$key   = getChar( $key );
			$value = getChar( $value );
			# print "$key$value\n";

			printf "$key$value\tU+%X U+%X\n", ord($key), ord($value);
		}
	}

	if( 0 ) {
		foreach my $k (keys %KernMap) {
			print "$k = [ ";
			foreach my $v ( @{ $KernMap{$k} } ) {
				print "$v ";
			}
			print "]\n";
			
		}
	}
}

# @_uni1230 = [uni1230 uni1233 uni1235 uni12A8 uni12AB uni12AD uni12B8 uni12BB uni12BD uni130E uni130F uni2DD8 uni2DDB uni2DDD uniAB03 uniAB05];
#     pos uni1206 hhyaethiopic -70;
# 	my($word,$count) = split(/\t/);
# 	m/uni(\w{4}) uni(\w{4})/;
# 	my($l,$r) = ($1,$2);
# 	my $pair = sprintf("%c%c", hex($l),hex($r));
# 	print "$pair\tU+$l U+$r\n";

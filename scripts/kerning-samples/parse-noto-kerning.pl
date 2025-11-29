
#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
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


sub getID
{
my($base) = @_;

		if( $base =~ /^uni(\w{4})$/ ) {
			$base = getChar($base);
		}
		elsif( $base =~ m/^(uni\w{4})(\w)$/ ) {
			my $uchar  = $1;
			my $suffix = $2;
print "SUFFIX: $suffix\n";
			$base = sprintf( "%s$suffix", getChar( $uchar ) );
		}
		else {
# print "BASE: $base\n";
			# $base =~ m/^(\w+)\.(\w+)$/ ;
			# my $uchar = "uni$1";
			# my $suffix = $2;
# print "SUFFIX: $suffix\n";
			# $base = sprintf( "%s$suffix", getChar( $base ) );
			$base = getChar($base);
		}
	$base;

}

main:
{
my $kernFea = 0;

while( <> ) {
	if( /kern;/ ) {
		$kernFea = 0 ;
	}
	elsif( $kernFea ) {
		next unless( /^@/ || /^\s+pos/ );
		my $line = $_ ;
		#
		# classes
		#
		if( /^\@_(uni.*?) =/ ) {
			my $base = getID( $1 );

			$line =~ m/\[(.*?)\]/;
			my @list = split( / /, $1 );
			# @_uni1230 = [uni1230 uni1233 uni1235 uni12A8 uni12AB uni12AD uni12B8 uni12BB uni12BD uni130E uni130F uni2DD8 uni2DDB uni2DDD uniAB03 uniAB05];
			my $conv = "";
			for my $char (@list) {
				my $uchar = getID( $char );
				$conv .= "$uchar ";
			}
			print "# @"."_$base = [ $conv];\n";
		}
    		elsif( /pos \@_(uni.*?) (uni.*?) (.*?);/ ) {
			my ($l, $r, $v) = ( getID($1), getID($2), $3 );
			print "# pos @" ."_$l $r $v;\n";
		}
    		elsif( /pos (uni.*?) \@_(uni.*?) (.*?);/ ) {
			my ($l, $r, $v) = ( getID($1), getID($2), $3 );
			print "# pos $l @" . "_$r $v;\n";
		}
    		elsif( /pos \@_(uni.*?) \@_(uni.*?) (.*?);/ ) {
			my ($l, $r, $v) = ( getID($1), getID($2), $3 );
			print "# pos @" ."_$l @" . "_$r $v;\n";
		}
		elsif( /pos (.*?) (.*?) (.*?);/) {
			my ($l, $r, $v) = ( getID($1), getID($2), $3 );
			print "# pos $l $r $v;\n";
		}
		print $line;
	}
	elsif( /feature kern {/ ) {
		$kernFea = 1 ;
	}
}

}

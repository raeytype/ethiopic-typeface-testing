
#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;

sub getChar {
$_ = shift;

	s/u1E7/uni1E7/;
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
		elsif( $base =~ /^uni1E7\w{2}$/ || /^u1E7\w{2}$/) {
			$base = getChar($base);
		}
		elsif( $base =~ m/^(uni\w{4})(.*?)$/ ) {
			my $uchar  = $1;
			my $suffix = $2;
			$base = sprintf( "%s$suffix", getChar( $uchar ) );
		}
		else { # For names like: hhyaethiopic
# print "getID: HERE: $base\n";
			$base = getChar($base);
		}
	$base;

}

main:
{
my $kernFea = 0;

my %Classes = ();
my %ScalarScalar = ();
my %ScalarArray  = ();
my %ArrayScalar  = ();
my %ArrayArray   = ();

while( <> ) {
	if( /kern;/ || /PairKerning;/ ) {
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
			$Classes{$base} = $conv;
			print "# @"."_$base = [ $conv];\n";
		}
    		elsif( /pos \@_(uni.*?) (uni.*?) (.*?);/ ) {
			my ($l, $r, $v) = ( getID($1), getID($2), $3 );
			$ArrayScalar{"$l $r"} = $v;
			print "# pos @" ."_$l $r $v;\n";
		}
    		elsif( /pos (uni.*?) \@_(uni.*?) (.*?);/ ) {
			my ($l, $r, $v) = ( getID($1), getID($2), $3 );
			$ScalarArray{"$l $r"} = $v;
			print "# pos $l @" . "_$r $v;\n";
		}
    		elsif( /pos \@_(uni.*?) \@_(uni.*?) (.*?);/ ) {
			my ($l, $r, $v) = ( getID($1), getID($2), $3 );
			$ArrayArray{"$l $r"} = $v;
			print "# pos @" ."_$l @" . "_$r $v;\n";
		}
		elsif( /pos (.*?) (.*?) (.*?);/) {
			my ($l, $r, $v) = ( getID($1), getID($2), $3 );
			$ScalarScalar{"$l $r"} = $v;
			print "# pos $l $r $v;\n";
		}
		print $line;
	}
	elsif( /feature kern {/ || /PairKerning/ ) { # PairKerning from Abyssinica)
		$kernFea = 1 ;
	}
}

print "=======================\n";


print "feature kern {\n";

	for my $key (sort keys %Classes) {
		my @list = split( / /, $Classes{$key} );
		my $array = "[ ";
		for my $item (sort @list) {
			my $i = sprintf( "uni%04X ", ord($item) );
			$array .= $i;
		}
		$array .= "]";
		if( length($key) == 1 ) {
			print sprintf( "@". "_uni%04X = $array;\n", ord($key) );
		}
		else {
			$key =~ s/^(\w)(.*?)$/$1/;
			my $suffix = $2;	
			print sprintf( "@". "_uni%04X_$suffix = $array;\n", ord($key) );
		}
	}

print "\n  lookup kern_ethi {\n\n    lookupflag IgnoreMarks;\n";
    

	for my $key (sort keys %ArrayScalar) {
		my $v = $ArrayScalar{$key};
		my($l,$r) = split( / /, $key );
		if( length($l) == 1 ) {
			print sprintf( "    pos @". "_uni%04X uni%04X $v;\n", ord($l), ord($r) );
		}
		else {
			$l =~ s/^(\w)(.*?)$/$1/;
			my $suffix = $2;	
			print sprintf( "    pos @". "_uni%04X_$suffix uni%04X $v;\n", ord($l), ord($r) );
		}
	}

	for my $key (sort keys %ScalarArray) {
		my $v = $ScalarArray{$key};
		my($l,$r) = split( / /, $key );
		if( length($r) == 1 ) {
			print sprintf( "    pos uni%04X @"."_uni%04X $v;\n", ord($l), ord($r) );
		}
		else {
			$r =~ s/^(\w)(.*?)$/$1/;
			my $suffix = $2;	
			print sprintf( "    pos uni%04X @"."_uni%04X_$suffix $v;\n", ord($l), ord($r) );
		}
	}

	for my $key (sort keys %ArrayArray) {
		my $v = $ArrayArray{$key};
		my($l,$r) = split( / /, $key );
		if( (length($l) == 1) && (length($r) == 1) ) { # no suffixes
			print sprintf( "    pos @". "_uni%04X @"."_uni%04X $v;\n", ord($l), ord($r) );
		}
		elsif( (length($l) == 1) ) {  # $r has a suffix
			$r =~ s/^(\w)(.*?)$/$1/;
			my $suffix = $2;	
			print sprintf( "    pos @". "_uni%04X @"."_uni%04X_$suffix $v;\n", ord($l), ord($r) );
		}
		elsif( (length($r) == 1) ) {  # $l has a suffix
			$l =~ s/^(\w)(.*?)$/$1/;
			my $suffix = $2;	
			print sprintf( "    pos @". "_uni%04X_$suffix @"."_uni%04X $v;\n", ord($l), ord($r) );
		}
		else { # $l & $r both have suffixes
			$l =~ s/^(\w)(.*?)$/$1/;
			my $suffixL= $2;	
			$r =~ s/^(\w)(.*?)$/$1/;
			my $suffixR = $2;	
			print sprintf( "    pos @". "_uni%04X_$suffixL @"."_uni%04X_$suffixR $v;\n", ord($l), ord($r) );
		}
	}

	for my $key (sort keys %ScalarScalar) {
		my $v = $ScalarScalar{$key};
		my($l,$r) = split( / /, $key );
		print sprintf( "    pos uni%04X uni%04X $v;\n", ord($l), ord($r) );
	}

print<<END_KERN;
  } kern_ethi;

  script ethi; # Ethiopic
  lookup kern_ethi;
} kern;
END_KERN

}

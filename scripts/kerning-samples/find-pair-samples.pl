#!/usr/bin/perl -w

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;


my %Frequencies = ();
sub readFrequencies
{
my $filename = shift;

	open( my $file, '<:encoding(UTF-8)', $filename ) or die "Can't open '$filename' for reading: $!";
	while( <$file> ) {
		chomp;	
		next if ( /[.'‘’:]/ ); # these marks should be removed from the lexical file
		if ( /^[ጘ-ጞᎀᎃᎄᎇᎈᎋᎌᎏ𞟠-𞟾ⶓ-ⶖ\w]/ ) {
			s/\r//;
			# /^(\w+)\t(\w+)/;  # Perl does not yet recognize Extended-B as \w , so .* used here
			/^(.*?)\t(.*?)$/;
			if( exists($Frequencies{$1}) ) {
				# print STDERR "SUM: $1 = $Frequencies{$1} + $2\n";
				$Frequencies{$1} = $Frequencies{$1} + $2;
			}
			else {
				# print STDERR "SET: $1 = $2\n";
				$Frequencies{$1} = $2;
			}
		}
	}
}

sub findKeys
{
my $pair = shift;

	my @keys = grep( /$pair/,  keys %Frequencies );	
	my @orderedKeys = sort { $Frequencies{$a} <=> $Frequencies{$b} } @keys;
	return join ( "\t", @orderedKeys );
}


main:
{
	if( $#ARGV < 1 ) {
		print STDERR "Missing arguments.\nUsage: find-pair-samples.pl <language> <typeface>\n";
		exit(0);
	}

	if( $ARGV[0] eq "am" ) {
		readFrequencies( "am-unilex.tsv" );
	} elsif( $ARGV[0] eq "ti" ) {
		readFrequencies( "ti-unilex.tsv" );
	} elsif( $ARGV[0] eq "byn" ) {
		readFrequencies( "BlinWordList.txt" );
	} elsif( $ARGV[0] eq "sgw" ) {
		readFrequencies( "SahleJingo-NewOrthography-WordList.tsv" );
		readFrequencies( "WolfLeslau-NewOrthography-WordList.tsv" );
	} elsif( $ARGV[0] eq "all" ) {
		readFrequencies( "am-unilex.tsv" );
		readFrequencies( "ti-unilex.tsv" );
		readFrequencies( "BlinWordList.txt" );
		readFrequencies( "SahleJingo-NewOrthography-WordList.tsv" );
		readFrequencies( "WolfLeslau-NewOrthography-WordList.tsv" );
	}
	else {
		print STDERR "Unrecognized language \"$ARGV[0]\".\nMust be one of: am, byn, sgw, ti, all\n";
		exit(2);
	}

	my $pairFile ="";
	if( $ARGV[1] eq "abyssinica" ) {
		$pairFile = "abyssinica-pairs.tsv";
	} elsif( $ARGV[1] eq "noto" ) {
		$pairFile = "noto-pairs.tsv";
	} elsif( $ARGV[1] eq "nyala" ) {
		$pairFile = "nyala-pairs.tsv";
	} elsif( $ARGV[1] eq "all" ) {
		$pairFile = "merged-pairs.tsv";
	}
	else {
		print STDERR "Unrecognized typeface \"$ARGV[1]\".\nMust be one of: abyssinica, noto, nyala\n";
		exit(1);
	}

	

	my $count = 0;
	open( my $pairs, '<:encoding(UTF-8)', $pairFile ) or die "Can't open '$pairFile' for reading: $!";
	while( <$pairs> ) {
		$count++;
		chomp;
		next if( ($ARGV[0] eq "ti" ) && !/[ቐ-ቝኰ-ዅ]/ );             # Tigrinya filter
		next if( ($ARGV[0] eq "byn") && !/[ኰ-ኵዀ-ዅጘ-ጟⶓ-ⶖ]/ );       # Blin filter
		next if( ($ARGV[0] eq "sgw") && !/[ቐ-ቖጘ-ጞᎀᎃᎄᎇᎈᎋᎌᎏ𞟠-𞟾]/ );  # Gurage filter
		# print STDERR "$count Line: $_\n";
		# /^(\w+)\t(\w+)/;  # Perl does not yet recognize Extended-B as \w , so .* used here
		/^(.*)\t(.*?)$/;
		my ($pair, $unichars) = ($1,$2);
		print STDERR "$count: $pair\n";
		my $samples = findKeys( $pair );
		print "$pair\t$unichars\t$samples\n";
	}
}

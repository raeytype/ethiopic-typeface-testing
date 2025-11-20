#!/usr/bin/perl -w
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use utf8;
use strict;
# use encoding 'utf8';

main:
{
	while( <> ) {
		tr/ኸኹኺኻኼኽኾዀዂዃዄዅ/ሐሑሒሓሔሕሖ\x{1e7e8}\x{1e7e9}ሗ\x{1e7ea}\x{1e7eb}/;
		tr/\x{e044}\x{e045}\x{e046}\x{e047}/\x{1e7e8}\x{1e7e9}\x{1e7ea}\x{1e7eb}/;
		tr/ⷀⷁⷂⷃⷄⷅⷆ/ቐቑቒቓቔቕቖ/;
		tr/ⷈⷉⷊⷋⷌⷍⷎ/ኸኹኺኻኼኽኾ/;
		tr/ⷐⷑⷒⷓⷔⷕⷖ/\x{1e7e0}\x{1e7e1}\x{1e7e2}\x{1e7e3}\x{1e7e4}\x{1e7e5}\x{1e7e6}/;
		tr/ⷘⷙⷚⷛⷜⷝⷞ/ጘጙጚጛጜጝጞ/;
		tr/ᎁᎂ/\x{1e7ed}\x{1e7ee}/;
		tr/ቊቌቍ/\x{1e7f0}\x{1e7f1}\x{1e7f2}/;
		tr/ᎅᎆ/\x{1e7f3}\x{1e7f4}/;
		tr/ኲኴኵ/\x{1e7f5}\x{1e7f6}\x{1e7f7}/;
		tr/ጒጔጕ/\x{1e7f8}\x{1e7f9}\x{1e7fa}/;
		tr/ᎉᎊ/\x{1e7fb}\x{1e7fc}/;
		tr/ᎍᎎ/\x{1e7fd}\x{1e7fe}/;
		tr/አኧ/ኣአ/;
		print;
	}
}

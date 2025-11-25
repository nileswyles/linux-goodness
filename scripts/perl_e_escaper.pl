#!/usr/bin/perl

my $in = $ARGV[0];

my $in_fh;
open($in_fh, "<", $in);
seek($in_fh, 0, 0);

my $c;
while(my $bytes_read = read($in_fh, $c, 1)) {
	if (
		$c eq "\$" ||
		$c eq "\\" ||
		$c eq "\"" ||
		$c eq "\@" ||
		$c eq "\`" 
	) {
		print(STDOUT "\\");
	}
	print(STDOUT $c);
}

close($in_fh);

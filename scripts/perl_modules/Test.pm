package Test;

use strict;
use warnings;

sub MakeOutFolder {
	my ($path) = @_;
	$path .= "/test_out";
	system("mkdir $path 2> /dev/null");
	return $path;
}

1;

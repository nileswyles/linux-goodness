package File;

use strict;
use warnings;

# TODO: module that implements a function that takes a file path and generates a backup... with history

# can I do something similar for defining the arguments and remove addProcessors??
# why is this even a thing?
use constant {
	SUB_KEY => "sub",
	USAGE_KEY => "usage",
	VALUE_KEY => "value",

	HELP_ARG_KEY => "--help",
	VERSION_ARG_KEY => "--version",
};

# Processors DataStructure
# {
#	key: {
#		sub: ,
#		usage: , 
#		required?:,
#		format/regex/range?, should I leave up to implementer to implement in processor subroutines? What level of abstraction am I looking for here?
#		full_name? too much?: move up and hash reference to another key and do automagically?
#	}, ...
#
#	i.e. 
#	"-v" : {
#		sub: process_v(),
#		usage: "Description",
#
#	}
# }
#
# ARGH DataStructure
# {
#	key: value,
#	...
# }

my %PROCESSORS = {
	HELP_ARG_KEY => {
		SUB_KEY => &printUsage,
		USAGE_KEY => "Prints application usage."
	},
	VERSION_ARG_KEY => {
		SUB_KEY => &printVersion,
		USAGE_KEY => "Prints application version."
	}
};

my %ARGH = {};

sub printVersion {
	print("$::VERSION\n");
	exit;
}

sub printUsage {
	my $usage = "";
	foreach (keys %PROCESSORS) {
		my %processor = $PROCESSORS{$_};
		$usage .= "\t$_\t\t\t\t$processor{USAGE_KEY}\n";
	}
	$usage .= "\n";
	print($usage);
	exit;
}

sub parse {
	my $prev_key = "";
	%ARGH = {};
	if (::DEBUG) {
		print("PARSING\n");
	}
	# O1+n
	for (my $i = 0; $i < scalar(@ARGV); $i++) {
		if ($ARGV[$i] =~ /-(.+)/) {
			$prev_key = $ARGV[$i];
			$ARGH{$prev_key} = 1;
		} elsif ($prev_key eq "$ARGV[$i - 1]") {
			# if start of key_value
			$ARGH{$prev_key} = "$ARGV[$i]";
		} else {
			# support (unquoted?) spaces in key_value pairs
			$ARGH{$prev_key} .= " $ARGV[$i]";
		}
	}
	if (::DEBUG) {
		print("PARSING COMPLETE\n");
	}
	if ($ARGH{HELP_ARG_KEY}) {
		processArg(HELP_ARG_KEY);
	} elsif ($ARGH{VERSION_ARG_KEY}) {
		processArg(VERSION_ARG_KEY);
	}
}

sub addProcessors {
	# think about this somemore
	if (::DEBUG) {
		print("Added Processors \n");
	}
	my ($hashref) = @_;

	my %new_processors = %{$hashref};
	foreach (keys %PROCESSORS) {
		$PROCESSORS{$_} = $new_processors{$_};
	}
}

sub removeProcessors {
	foreach (@_) {
		delete $PROCESSORS{$_};
	}
}

sub processArg {
	my ($key) = @_;
	$PROCESSORS{$key}->($ARGH{$key});
}

sub processAll {
	foreach (keys %ARGH) {
		# These are processed in the parse function - they are prioritized over other args and cause the program to exit.
		#	Priority:
		#		- HELP
		#		- VERSION
		#		- OTHERS in "random" order? because key(set)? If need specific order, call processArg individually?
		if ($_ ne HELP_ARG_KEY && $_ ne VERSION_ARG_KEY) { 
			processArg($_);
		}
	}
}

1;

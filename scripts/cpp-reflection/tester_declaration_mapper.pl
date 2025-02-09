#!/bin/perl

my $PATH_TO_FILE = "";
my $TEST_NAME = "";
for (my $i = 0; $i < scalar(@ARGV); $i++) {
	if ($ARGV[$i] eq "-p" || $ARGV[$i] eq "--path") {
        $PATH_TO_FILE = $ARGV[++$i];
	} elsif ($ARGV[$i] eq "-t" || $ARGV[$i] eq "--test") {
        $TEST_NAME = $ARGV[++$i];
	}
}
if ($PATH_TO_FILE eq "") {
    print("This file is required.\n");
    exit(1);
}
open(my $fh, "<", $PATH_TO_FILE);
if (substr($PATH_TO_FILE, 0, 1) ne "/") {
    my $pwd = `pwd`;
    my $last_char = substr($pwd, -1, 1);
    if ($last_char eq "\n") {
        $pwd = substr($pwd, 0, length($pwd) - 1);
    }
    if ($last_char eq "/") {
        $pwd = substr($pwd, 0, length($pwd) - 1);
    }
    $PATH_TO_FILE = "$pwd/$PATH_TO_FILE";
}
if ($TEST_NAME eq "") {
    print("Generating test declaration-line_number map for:\n$PATH_TO_FILE\n\n");
}

# file_name
# testDeclarationName, file_name:line_number
# testDeclarationName2, file_name:line_number
my $line_number = 1;
while (<$fh>) {
    # TODO:
    #   don't include if inline commented. (negative lookbehind isn't working and I don't care to figure that out)
    if ($_ =~ /\/\/.*void (.*)\(TestArg \* .*\).*;/) {
    } else {
        if ($_ =~ /.*void (.*)\(TestArg \* .*\).*;/) {
            if ($TEST_NAME eq "") {
                print("$1, $PATH_TO_FILE:$line_number\n");
            } elsif ($TEST_NAME eq $1) {
                print("$PATH_TO_FILE:$line_number\n");
            }
        }
    }
    $line_number++;
}
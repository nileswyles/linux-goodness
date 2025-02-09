#!/bin/perl

my $buffer = "";
my $test_suite_string = "";
my $failed_tests = 0;
my @TEST_STRINGS = ();

sub printTestSuite {
    # print test suite
    print($test_suite_string);
    for (my $i = 0; $i < scalar(@TEST_STRINGS); $i++) {
        print($TEST_STRINGS[$i]);
    }
    $buffer .= "$_\n";
    print($buffer);
    $failed_tests = 0; # used to ignore test suites with no test suites with no failed tests.
    @TEST_STRINGS = ();
}

while (<STDIN>) {
    if ($_ =~ /Test Func: (.*) -> (.*)/) {
        # new test
        $buffer = "\n#######################################\n\n";
        $buffer .= "$_";
    } elsif ($_ =~ /Test Failed!/) {
        $buffer .= "$_";
        $TEST_STRINGS[$failed_tests++] = $buffer;
    } elsif ($_ =~ /(-+) (.+) (-+)/) {
        # new test suite
        $test_suite_string = "\n$_";
    } elsif ($failed_tests != 0 && $_ =~ /Failed Tests:/) {
        # new results
        $buffer = "\n#######################################\n\n";
        $buffer .= "$_";
    } elsif ($_ =~ /Segmentation fault/) {
        printTestSuite();
    } elsif ($failed_tests != 0 && $_ =~ /Results:/) {
        printTestSuite();
    } else {
        $buffer .= "$_";
    }
}
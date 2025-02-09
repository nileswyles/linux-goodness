#!/bin/perl

# should be at same directory as this script.
my $path_to_scripts_directory = `pwd`;
my $last_char = substr($path_to_scripts_directory, -1);
if ($last_char eq "\n") {
    $path_to_scripts_directory = substr($path_to_scripts_directory, 0, length($path_to_scripts_directory) - 1);
}
if ($last_char eq "/") {
    $path_to_scripts_directory = substr($path_to_scripts_directory, 0, length($path_to_scripts_directory) - 1);
}
if ($0 =~ /(\.)?(.*)?\/install.pl/) {
    if ($1 eq ".") {
        # if relative path
        $path_to_scripts_directory .= $2;
    } else {
        # if absolute path
        $path_to_scripts_directory = $2;
    }
} else {
    exit(1);
}

my $HOME = `echo -n \$HOME`;
my $SHELL_RC = "$HOME/.bashrc";
if ($ARGV[0] eq "g") {
    $SHELL_RC = "/etc/bash.bashrc";
}

my $COPY_CMD = "cp $SHELL_RC $SHELL_RC.bak";
print("$COPY_CMD\n");
system($COPY_CMD);

print("\nConfiguration\n\n");

# alias_name, script_path
#   TODO: yeah, idk this can be automated (i.e. just scan this directory...)
my %script_map = (
    "failed" => "$path_to_scripts_directory/tester_filter_failed.pl",
    "testscan" => "$path_to_scripts_directory/tester_filter_scanner.pl",
    "testfuncmap" => "$path_to_scripts_directory/tester_function_mapper.pl",
    "testdeclmap" => "$path_to_scripts_directory/tester_declaration_mapper.pl"
);

# search for alias entry in file. if not, append.
# Make sure they're updated everytime the shell is invoked. (caution against outliers?)
open(my $fh, '+<', $SHELL_RC) or die "Can't open +< $SHELL_RC: $!";

my @updated_aliases;

my $file = "";
while (<$fh>) {
    my $line = $_;
    my $found = 0;
    foreach (keys %script_map) {
        if ($line =~ /^alias $_/) {
            $line = "alias $_='$script_map{$_}'\n";
            $found = 1;
            print("Updated alias:\n\t$_\nFor script:\n\t$script_map{$_}\n\n");
            push(@updated_aliases, $_);
            delete $script_map{$_};
            break;
        }
    }
    if ($found eq 0) { 
        my $allow = 1;
        foreach (@updated_aliases) {
            # Only allow a single entry for script.
            if ($line =~ /^alias $_/) {
                $allow = 0;
                break;
            }
        }
        if ($allow) {
            $file .= $line;
        }
    }
}

foreach (keys %script_map) {
    $file .= "alias $_='$script_map{$_}'\n";
    print("New alias:\n\t$_\nFor script:\n\t$script_map{$_}\n\n");
    delete $script_map{$_};
}

if (scalar(%script_map) ne 0) {
    print("Something went. indeed\n");
}

seek($fh, 0, 0);
print $fh $file;
close($fh);
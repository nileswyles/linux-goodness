#!/usr/bin/perl -I/scripts/perl_modules
# convention is to install linux_goodness/scripts to the root folder.

use File;

my $path_to_scripts_directory = File::pathToContainingFolder(); # to work if located anywhere other than /scripts

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
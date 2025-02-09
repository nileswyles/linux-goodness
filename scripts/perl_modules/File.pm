package File;

use strict;
use warnings;

sub pwd {
	my $pwd = `pwd`;
	my $last_char = substr($pwd, -1);
	if ($last_char eq "\n") {
	    $pwd = substr($pwd, 0, length($pwd) - 1);
	}
	if ($last_char eq "/") {
	    $pwd = substr($pwd, 0, length($pwd) - 1);
	}
	return $pwd;
}

sub pathToContainingFolder {
	# remember $0 is first token of CLI string, so may be relative to pwd or absolute...
	# system launches a shell which can open anywhere... lmao so yeah convert to absolute.
	my $abs_path_to_containing_folder = $0; # assume absolute
	my $first_char = substr($0, 0, 1);
	if ($first_char ne "/") {
	    # if relative path
		my @SPLIT_PATH = split($0, "/");
		# hmm... how does this compare to substr? In the past, I expect the difference to be negligable
		my $i = 0;
		my $last_slash_index = 0;
		foreach(split(//, $0)) {
			if ($_ eq "/") {
				$last_slash_index = $i;
			}
			$i++;
		}
		# the filesystem ensures either starts like ./script.pl or ./folder/script.pl" or folder/script.pl
		# 	remember index will give me string up to slash which is perfect.
		my $relative = substr($0, 0, $last_slash_index); # folder/script.pl
		if ($first_char eq ".") {
			if ($last_slash_index > 2) { # ./folder/script.pl -> folder/script.pl
				$relative = substr($0, 2, $last_slash_index - 2);
			} else { # ./script.pl
				$relative = "";
			}
		}
	    $abs_path_to_containing_folder = pwd().$relative;
	}
	return $abs_path_to_containing_folder;
}

# current
#	current.bak.0
#	current.bak.1
#	current.bak.2

# on invocation
# 	current -> current.bak.3
sub generateBackup {
	my ($file_path) = @_;

	my $num_files = scalar(split(/ /, `ls $file_path*`)); # not an issue if this matches more because timestamps
	if ($num_files == 0) {
		# TODO: review module context stuff... wrt special variables, variables defined here, etc.
		#	update perl_perling
		print("File specified to generate backup does not exist:\n$file_path");
	} else {
		my $new_designator = $num_files - 1;
		system("cp $file_path $file_path.bak.$new_designator");
	}
}

1;

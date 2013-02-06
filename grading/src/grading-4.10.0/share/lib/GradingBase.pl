# Basic routines that get us through command-line processing.
# See the file COPYING in the main distribution directory for copyright notice.

use Getopt::Std;

$GRADELIB = $INC[0];

# Establish stderr handle
open (REAL_STDERR, ">&STDERR");

# Usage: Die MSG
sub Die {
    my $msg = shift;
    print REAL_STDERR "$msg\n";
    exit 2;
}

# Usage: Help [ NAME ]
sub Help {
    my ($name) = shift;
    if (! $name) {
	($name) = ($0 =~ m" ([^/.]+)(\.pl)?$ "x);
    }
    open (HELP, "$GRADELIB/GradingHelp.txt")
	|| Die ("Help file $GRADELIB/GradingHelp.txt not found.");
    while (<HELP>) {
	if (/^\s*>>>>\s*$name\s*$/) {
	    while (<HELP>) {
		last if (/^\s*>>>>|^\s*<<<</);
		print STDERR $_;
	    }
	    exit 0;
	}
    }
    Die ("No help found for $name.");
}

# Usage: Usage 
sub Usage {
    my ($name) = ($0 =~ m" ([^/.]+)(\.pl)?$ "x);

    open (HELP, "$GRADELIB/GradingHelp.txt")
	|| Die ("Invalid usage.");
    while (<HELP>) {
	if (/^\s*>>>>\s*$name\s*$/) {
	    $line = <HELP>;
	    if ($line =~ /^\s*Usage:/) {
		do {
		    print STDERR $line;
		    $line = <HELP>;
		} until ($line =~ /^\s*$|^\s*>>>>|^\s*<<<</);
		exit 2;
	    }
	}
    }
    Die ("Invalid usage.");
}

# Usage: Version 
sub Version {
    print STDERR "Grading software version @VERSION@.\n";
    print STDERR "Copyright (C) 1999-2008 by the Regents of the University of California.\n";
    exit 0;
}

###
# Command line parameters
###

# Usage: CmndLine [ OPTIONS [ MIN-ARGS [ MAX-ARGS ] ] ]
sub CmndLine {
    my ($options, $minargs, $maxargs) = @_;

    getopts ($options . "hV") || &Usage;

    Help () if ($opt_h);
    Version () if ($opt_V);

    ($#ARGV + 1 >= $minargs && (!defined($maxargs) || $#ARGV + 1 <= $maxargs))
	|| &Usage;
}

1;

# Get appropriate class master directory from user.
# See the file COPYING in the main distribution directory for copyright notice.

sub askForMaster {
    my ($n, $low, $high, $usage, $prompt) = @_;
    my ($dir, $class);
    if ($n < $low or ($high ne "" and $n > $high)) {
	print STDERR "$usage\n";
	exit 1;
    } 
    while (1) {
	print STDOUT "$prompt";
	$class = lc(<STDIN>);
	chomp $class;
	$dir = (getpwnam("$class"))[7];
	if ($dir eq "") {
	    print STDERR "The login '$class' does not appear to exist.\n";
	} elsif (! -d "$dir/grading") {
	    print STDERR "The $class account does not appear to be "
		. "configured for grading.\n";
	} else {
	    $ENV{'MASTERDIR'} = $dir;
	    return;
	}
    }
}


	
    

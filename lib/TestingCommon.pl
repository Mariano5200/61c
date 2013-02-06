# Routines used for unpacking and testing submissions.
# See the file COPYING in the main distribution directory for copyright notice.

use Config;

$signum = 1;
foreach $name (split(' ', $Config{sig_name})) {
    $signo{$name} = $signum;
    $signame[$signum] = $name;
    $signum += 1;
}

$SVN_PROG = '/usr/sww/bin/svn';

# Usage: TestsExist (ASSGN)
sub TestsExist {
    my $assgn = shift;

    return -r "$TEST_MAKEFILE_DIR/$assgn.mk";
}

# Usage: UnpackSubmission ASSGN SUBMISSION_FILE DIR [ NO-ERASE ]
sub UnpackSubmission {
    my ($assgn, $file, $dir, $noerase, $tar, @tar) = @_;

    if ( not -r $file ) {
	Note ("Attempt to unpack non-existent file: $file.");
	return 0;
    } 
    mkdir ($dir, 0700) if (! -d $dir);
    if (not (-d $dir && -w $dir)) {
	Note ("Invalid or unwritable directory: $dir.");
	return 0;
    } 

    System ("/bin/rm -rf $dir/.svn $dir/*") unless ($noerase);

    open (SUBMISSION, $file) || return 0;

    my $typeLine = <SUBMISSION>;
    my $code;
    if ($typeLine =~ /SVN submission/) {
	$code = UnpackSvnSubmission ($dir, $assgn);
    } else {
	$code = UnpackDirectSubmission ($dir, $assgn);
    }
    close SUBMISSION;

    System ("cd $dir; /bin/rm -f .SUBMISSION; " .
	    "echo $assgn $file > .SUBMISSION; chmod a-w .SUBMISSION");

    return $code;
}

# Usage: UnpackDirectSubmission DIR ASSGN
#   Unpack a submission from the file handle SUBMISSION for ASSGN into DIR,
#   where the submission is directly encoded in the file contents.
sub UnpackDirectSubmission {
    my ($dir, $assgn) = @_;
    my ($data, $tar);

    open (UNPACKER, "| cd $dir && uudecode && chmod a+r *.gz ") 
	or return 0;
    while (read SUBMISSION, $data, 8192) {
	syswrite UNPACKER, $data;
    }
    close UNPACKER or return 0;

    if ( -f "$dir/$assgn-handin.tar.gz" ) {
	$tar = "$assgn-handin.tar.gz";
    } else {
	@tar = GLOB ("$dir/*-handin.tar.gz");
	if ($#tar == 0) {
	    $tar = $tar[0];
	    $tar =~ s{.*/(.*)}{$1};
	} else {
	    Note ("Non-existent or ambiguous hand-in tar file.");
	    return 0;
	}
    }

    System ("cd $dir; gunzip -c $tar | tar xf -")
	|| return 0;

    return 1;
}

# Usage: UnpackSvnSubmission DIR ASSGN
#   Unpack a submission for ASSGN from the SVN repository, assuming that
#   file handle SUBMISSION contains second and succeeding lines of the
#   file produced by svn-log-submission.
sub UnpackSvnSubmission {
    my ($dir, $assgn) = @_;
    my $reposDir = <SUBMISSION>;
    my $rev = <SUBMISSION>;
    chomp $reposDir;
    chomp $rev;
    System ("$SVN_PROG export --force --ignore-externals $SVN_REPOSITORY_URL/$reposDir\@$rev $dir")
	or return 0;
    return 1;
}

# Global variable containing error details.
my $testMessage;

# Usage: TestAndDiagnose CMND OUTHANDLE 
sub TestAndDiagnose {
    my ($cmnd, $outhandle) = @_;
    my $lines;

    $testMessage = "";

    # Make sure that resource-limit signals aren't ignored by default.
    $SIG{XCPU} = "DEFAULT";
    $SIG{XFSZ} = "DEFAULT";

    if (not open (CMNDOUT, "$cmnd 2>&1 |")) {
	$testMessage = "could not execute '$cmnd'";
	return 0;
    }

    $lines = 0;
    while (<CMNDOUT>) {
	print $outhandle $_;
    }

    close (CMNDOUT);

    return 1 if ($? == 0);

    if (($? >> 8) == 0) {
	my $signal = ($? & 255);
	$testMessage = "Program terminated on ";
	if ($signal == $signo{BUS}) {
	    $testMessage .= "illegal memory reference (SIGBUS)";
	} elsif ($signal == $signo{SEGV}) {
	    $testMessage .= "illegal memory reference (SIGSEGV)";
	} elsif ($signal == $signo{ILL}) {
	    $testMessage .= "illegal instruction (SIGILL)";
	} elsif ($signal == $signo{FPE}) {
	    $testMessage .= "arithmetic exception (SIGFPE)";
	} elsif ($signal == $signo{XCPU}) {
	    $testMessage .= "CPU time limit exceeded (SIGXCPU)";
	} elsif ($signal == $signo{XFSZ}) {
	    $testMessage .= "output file size limit exceeded (SIGXFSZ)";
	} else {
	    $testMessage .= "signal \#$signal (SIG$signame[$signal])";
	}
	return 0;
    } else {
	$testMessage = "terminated with non-zero exit code $?";
	return 0;
    }
}

# Usage: RunTests ASSGN DIR LOGHANDLE
sub RunTests {
    my ($assgn, $dir, $log) = @_;
    my $testErrors;

    my $currentDir = CurrentDir ();

    chdir ($dir) || Fatal ("Could not change to test directory.");

    -r "$TEST_MAKEFILE_DIR/$assgn.mk"
	|| Fatal ("No test makefile for $assgn.");
    
    if (TestAndDiagnose ("$GMAKE -k -f $TEST_MAKEFILE_DIR/$assgn.mk", $log)) {
	print $log "\n<<All tests passed.\n";
    } else {
	if ($testMessage =~ 'non-zero exit code') {
	    print $log ("\n<<PROBLEM: One or more tests failed " .
			"($testMessage).\n\n");
	} else {
	    print $log "\n<<PROBLEM: $testMessage.\n";
	}
	$testErrors = 1;
    }

    chdir ($currentDir) 
	|| Fatal ("Could not change back directory $currentDir.");

    return ! $testErrors;
}

# Usage: MoveLog ASSGN LOG SUBM ISERROR [ PARTNER ... ]
sub MoveLog {
    my ($assgn, $log, $subm, $iserror, @partners) = @_;
    my ($baseSubm, $login, $timestamp) = $subm =~ m" (([^/]+)\.([^/]+))$ "x;
    my ($destDir, $destFile);
    my $logDir = "$LOG_DIR/$assgn";

    -r $log || Fatal ("Cannot read log $log.");

    $destDir = $iserror ? "$logDir/failed" : "$logDir/ok";

    InitDir ($logDir, 02770);

    -d $logDir && -w $logDir || Fatal ("Cannot create $logDir.");

    InitDir ($destDir, 02770);

    -d $destDir && -w $destDir || Fatal ("Cannot create log in $destDir.");
    $destFile = "$destDir/$baseSubm";
    System ("/bin/cp -f $log $destFile < /dev/null")
	|| Fatal ("Could not copy log into $destFile.");
    chmod (0660, $destFile);
    foreach my $partner (@partners) {
	next if $partner eq $login;
	symlink ($baseSubm, "$destDir/$partner.$timestamp");
    }

    1;
}

# Usage: TestSubmission SUBM ASSGN DIR [ PARTNER ... ]

sub TestSubmission {
    my ($subm, $assgn, $dir0, @partners) = @_;
    my $logName;

    ($assgn) = $subm =~ m" ([^/]+)/[^/]+$ "x if (!$assgn);
    my ($baseSubm, $timestamp) = $subm =~ m" /([^/]+\.([0-9]{12}))$ "x;

    if (! $timestamp) {
	Warn ("Submission $subm has invalid name.");
	return 0;
    }

    my $time = TimeStampToTime ($timestamp);

    $dir = $dir0;
    if (! $dir0) {
	$dir = "/tmp/grdtst$$";
	AddClean ($dir);
	System ("/bin/rm -rf $dir");
	mkdir ($dir, 0700) 
	    || Fatal ("Could not create temporary directory for testing.");
    } 

    $logName = "/tmp/grdlog$$";
    AddClean ($logName);
    unlink ($logName);

    open (SUBMISSION_LOG, ">$logName") 
	|| Fatal ("Could not create submission log file $logName.");
    my $timeStr = localtime ($time);
    Note ("\nProcessing $baseSubm, Assgn: $assgn, Subm: $timeStr.");

    if (! UnpackSubmission ($assgn, $subm, $dir)) {
	Note ("Problems with unpacking.");
	print SUBMISSION_LOG "<<PROBLEM: Could not unpack submission.";
    } else {
	if (-r "$dir/MY.PARTNERS") {
	    print SUBMISSION_LOG 
		"--PARTNERS: " . `/bin/cat "$dir/MY.PARTNERS"` . "\n";
	} else {
	    print SUBMISSION_LOG "\n";
	}

	if ($time > $ASSGN_DUE{$assgn}) {
	    my $late = (($time - $ASSGN_DUE{$assgn}) / 3600);
	    my $lateDay = int ($late / 24);
	    my $lateMsg = "";

	    if ($lateDay > 1) {
		$lateMsg = $lateDay . " days, ";
	    } elsif ($lateDay > 0) {
		$lateMsg = "1 day, ";
	    }
	    $lateMsg .= sprintf ("%4.1f hours", $late - 24.0 * $lateDay);
	    Note ("   [Late by $lateMsg].");
	    print SUBMISSION_LOG
		"\nNOTE: submitted $timeStr, $lateMsg late.\n\n";
	}

	if (RunTests ($assgn, $dir, SUBMISSION_LOG)) {
	    Note ("Successful submission.");
	    close (SUBMISSION_LOG);
	    MoveLog ($assgn, $logName, $subm, 0, @partners);
	} else {
	    Note ("Submission had problems.");
	    close (SUBMISSION_LOG);
	    MoveLog ($assgn, $logName, $subm, 1, @partners);
	}
    }

    unlink ($logName);
    DeleteClean ($logName);

    if (!$dir0) {
	System ("/bin/rm -rf $dir");
	DeleteClean ($dir);
    }
}
    
# Usage MailResult SUBM ...
sub MailResult {
    my ($arg, $subm, $file, $assgn, $subject, $stamp, $time, $headerMsg, $log);
    foreach $arg (@_) {
	($assgn, $subm, $login, $stamp) = 
	    ($arg =~ m{ /([^/]+)/(([^/]+)\.([^/]+))$ }x);
				      
	InitDir ("$LOG_DIR/$assgn", 02770);
	InitDir ("$LOG_DIR/$assgn/mailed", 02770);

	defined ($assgn) 
	    || Fatal ("Ill-formed submission name to MailResult: $arg");
	    
	my $recipient = MailingAddress ($login);

	next if (! $recipient ||
		 -e "$LOG_DIR/$assgn/mailed/$subm" || 
		 (! (-e "$LOG_DIR/$assgn/ok/$subm") 
		  && ! (-e "$LOG_DIR/$assgn/failed/$subm")));
		 
	$time = localtime (TimeStampToTime ($stamp));
	if (-e "$LOG_DIR/$assgn/ok/$subm") {
	    $log = "$LOG_DIR/$assgn/ok/$subm";
	    $headerMsg = 
		"Your submission of assignment $assgn at $time successfully\n" .
		    "compiled and passed our tests.  The log is appended.\n" .
		    "\nThis is an automated account; please do not respond to it.\n\n";
	    $subject = 
		"Successful test for submission of assignment $assgn on $time";
	    $headerMsg .= `$GMAKE -f $TEST_MAKEFILE_DIR/$assgn.mk OK 2>/dev/null`;
	    if (-e "$LOG_DIR/$assgn/failed/$subm") {
		Warn ("Submission $subm for $assgn both succeeded and failed!");
	    }
	} else {
	    $log = "$LOG_DIR/$assgn/failed/$subm";
	    $headerMsg = 
		"Your submission of assignment $assgn at $time had some problems\n" .
		    "The log is appended.\n" .
		    "\nThis is an automated account; please do not respond to it.\n\n";
	    $subject = 
		"Problems with submission of assignment $assgn on $time";
	    $headerMsg .= `$GMAKE -f $TEST_MAKEFILE_DIR/$assgn.mk NOT-OK 2>/dev/null`;
	}
	     
	open (COPY_LOG, $log) 
	    || Fatal ("Log file $log unreadable.");

	if (open (MAILING, "| $MAIL_PROG -s '$subject' $recipient")) {
	    print MAILING $headerMsg;
	    print MAILING "\nLog:\n--------------------------------------------------\n";
	    while (<COPY_LOG>) {
		s/^~/~~/;
		print MAILING $_;
	    }
	    close (COPY_LOG);
	    close (MAILING);
	    Note ("Mailed to $recipient.");
	    if ($? == 0) {
		open (TOUCH, ">$LOG_DIR/$assgn/mailed/$subm") 
		    || Fatal ("Could not record mailing: $!");
		close (TOUCH);
		next;
	    }
	}

	Warn ("Problem mailing result of submission $subm");
    }
}

1;

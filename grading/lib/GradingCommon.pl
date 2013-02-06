# See the file COPYING in the main distribution directory for copyright notice.
# Standard header file for grading programs.

use Carp;
use Time::Local;
use POSIX qw(:errno_h);

# NOTE: We assume that this script runs setuid ONLY via run-as-class-master,
#       so that the MASTERDIR and GRADINGDIR environment variables are 
#       secure.  Cleanse them here.

if ($ENV{'MASTERDIR'} =~ /(.+)/) {
    $ENV{'MASTERDIR'} = $1;
}

if ($ENV{'GRADINGDIR'} =~ /(.+)/) {
    $ENV{'GRADINGDIR'} = $1;
}

# Find grading subdirectory
$DIR = $ENV{'GRADINGDIR'};
if ($DIR eq "") {
    exists ($ENV{'MASTERDIR'}) || die ("MASTERDIR not defined.");
    $DIR = "$ENV{'MASTERDIR'}/grading";
}

# Initialize locking
$have_lock = 0;

######################################################################

###
# Standard directories and files
###

# Directory containing grade log and archive data.
$ALL_GRADE_DIR = "$DIR/all-grades";

# Collected roster of all grades.
$ALL_GRADES = "$ALL_GRADE_DIR/grade-log";

# Collected log of all grades manually rejected during sweep-grades.
$REJECTED_GRADES = "$ALL_GRADE_DIR/rejected-grade-log";

# Directory containing submissions (each assignment in its own subdirectory).
$SUBMISSION_DIR = "$DIR/submissions";

# Directory containing bug submissions (each assignment in its 
# own subdirectory).
$BUG_SUBMISSION_DIR = "$DIR/bugs";

# Directory containing run logs.
$LOG_DIR = "$DIR/logs";

# File containing special exceptions on deadlines.
$DEADLINE_EXCEPTIONS = "$DIR/deadline-exceptions";

# Directory containing grade files for semi-public use.
# Should be protected 750, in the staff group.
$SECRET_DIR = "$DIR/secret";

# File containing main roster culled from registration files.
$MAIN_ROSTER = "$SECRET_DIR/roster";

# Directory containing registration information.
$REGISTER_DIR = "$DIR/register";

# Directory containing acceptance tests for assignments.
$PRETEST_DIR = "$DIR/pretest";

# Directory containing grade archive.
$REPOSITORY_DIR = "$DIR/PRCS";

# Teams
$TEAM_DIR = "$DIR/teams";

# Testing directory
$TEST_DIR = "$DIR/testing";

# Makefiles for directing tests
$TEST_MAKEFILE_DIR = "$TEST_DIR/mk";

# Lock directory
$LOCK_DIR = "$DIR/locks";

# Global write lock
$LOCK_FILE = "$LOCK_DIR/LOCK";

# Waiting times between probes of $LOCK_FILE
@LOCK_PROBES = (1, 2, 4, 8, 16);

# Maximum time allowed on grading lock in seconds.
$LOCK_EXPIRATION = 300;

# Maximum time allowed for grading one submission before run-tests warns
# of expired locks, in seconds.
$MAX_GRADING_TIME = 900;

# Backward-compatibility kludge: full path name of finger-info-setting
# program, which is passed first and last names.
$DEFAULT_REGISTRATION_HOOK = "/share/b/grading/bin/set-finger-info";

######################################################################

###
# Standard utilities.
###

###
# Time
###

# Usage: ToTime TIME
#    Returns a UNIX time value for the local time TIME, if it is a valid 
#    time string having the format "mm/dd/yyyy", "mm/dd/yyyy:hh:mm", 
#    or "mm/dd/yyyy:hh:mm:ss". Otherwise returns the undefined value.
sub ToTime {
    my $time = shift;
    my ($mon,$day,$year,$hour,$min, $sec) = 
      ($time =~ m=([0-9]{1,2})/([0-9]{1,2})/([0-9]{4})(?::([0-9]{1,2}):([0-9]{1,2})(?::([0-9]{1,2}))?)?=);
    if (! defined ($hour)) {
	$hour = 23; $min = 59;
    }
    if (! defined ($sec)) {
	$sec = 0;
    }
    if (!defined ($mon) || $mon > 12 || $mon == 0 
	|| $day == 0 || $day > 31 || $hour > 23 || $min > 59) {
	return undef;
    }
    return timelocal($sec, $min, $hour, $day, $mon-1, $year);
}

# Usage: FileTime FILENAME
#   Return mtime of FILENAME.
sub FileTime {
    my $fileName = shift;
    return (stat ($fileName))[9];
}

# Usage: TimeStampToTime TIME
#   Given a timestamp (from a Message-Id), return a UNIX time.
sub TimeStampToTime {
    my ($year, $mon, $day, $hour, $min, $sec) = 
	($_[0] =~ /(....)(..)(..)(..)(..)(..)?/);
    $sec = 0 if (not defined ($sec));
    return timegm ($sec, $min, $hour, $day, $mon-1, $year);
}    

# Usage: TimeToTimeStamp UNIXTIME
#   Given a UNIX time, return a timestamp as from a Message-Id, format
#   YYYYMMDDHHMM, in UTC.
sub TimeToTimeStamp {
    my $time = shift;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime ($time);
    return sprintf ("%04d%02d%02d%02d%02d", 
		    1900+$year, $mon+1, $mday, $hour, $min, $sec);
}
 
###
# Messages
###

# Usage: Fatal MSG
sub Fatal {
    my $msg = shift;
    print REAL_STDERR "$msg\n";
    &CleanUp;
    exit 2;
}

# Usage: Warn MSG
sub Warn {
    my $msg = shift;
    print REAL_STDERR "Warning: $msg\n";
}

# Usage: Note MSG
sub Note {
    my $msg = shift;
    print REAL_STDERR "$msg\n";
}

###
# RE utilities
###

# Usage: CheckPatn PATN
#    True if /PATN/ is a valid regular expression.
sub CheckPatn {
    return eval (/$_[0]/ || 1);
}

###
# System commands/info.
###

# Usage: System CMND
#     Execute CMND as for 'system', returning true for 0 exit code.
sub System {
    return (system (@_) == 0);
}

sub MyLogin {
    return (getpwuid($<))[0] || Fatal ("Can't tell who I am.");
}

sub CurrentDir {
    my $pwd = `pwd`;
    chomp $pwd;
    return $pwd;
}

sub Lock {
    my ($probe, $try, @stats, $mkdir_ok);
    return if ($have_lock);
    my $old_umask = umask ();
    for ($try = 0; $try < 2; $try += 1) {
	for ($probe = 0; $probe <= $#LOCK_PROBES; $probe += 1) {
	    umask (0);
	    $mkdir_ok = mkdir ("$LOCK_FILE", 0777);
	    umask ($old_umask);
	    if ($mkdir_ok) {
		$have_lock = 1;
		return 1;
	    }
	    sleep $LOCK_PROBES[$probe];
	}
	@stats = stat $LOCK_FILE;
	if ($#stats > 0) {
	    if ($stats[10] - time () > $LOCK_EXPIRATION) {
		if (Yorn ("Lock busy, but expired.  Shall I break it?")) {
		    rmdir $LOCK_FILE;
		}
	    } else {
		die "Grading files busy. Please try later.\n";
	    }
	}
    }
    die "Grading files busy. Please try later.\n";
}

sub Unlock {
    if ($have_lock) {
	$have_lock = 0;
	rmdir $LOCK_FILE;
    }
}

# Protect BLOCK_REFERENCE
# Mask selected signals temporarily and execute BLOCK_REFERENCE
sub Protect {
    local $SIG{HUP} = "IGNORE";
    local $SIG{INT} = "IGNORE";
    local $SIG{QUIT} = "IGNORE";
    local $SIG{TERM} = "IGNORE";
    local $SIG{TSTP} = "IGNORE";
    &{$_[0]}();
}

# GetPermissions @COMMAND
# If not currently running with class-master effective ID, seek to
# run COMMAND with class permissions.
sub GetPermissions {
    if ($> != (stat ($ENV{"MASTERDIR"}))[4]) {
	exec "$MASTER_PROGRAM", @_;
	die "Could not execute $MASTER_PROGRAM.";
    }
}

# GLOB PATHPATN
# Array of all names of existing files or directories matching PATHPATN, 
# where match is defined as for shell expansion of *.  Assumes that all 
# wildcard characters are in the last component of the path.  
# [It's here only because glob blows up on large results, and fails
# with an error message when a directory in PATHPATN does not exist
# (in the latter case, we sensibly return the empty array).]
sub GLOB {
    my ($dir0,$base) = ($_[0] =~ m{ ^(.*/)?([^/]*)$ }x);
    $dir = $dir0;
    if ($dir eq "") {
	$dir = "./";
    }		   
    $base =~ s/\./\\./g;
    $base =~ s/\*/.*/g;
    $base =~ s/\?/./g;
    chop $dir;
    opendir (GLOBDIR, $dir) || return ();

    my @result;
    if ($base =~ /^\\\./) {
	@result = grep { /^$base$/ } readdir (GLOBDIR);
    } else {
	@result = grep { /^$base$/ and /^[^.]/ } readdir (GLOBDIR);
    } 
    closedir GLOBDIR;
    foreach (@result) {
	$_ = "$dir0$_";
    }
    return sort (@result);
}


###
# Interactive responses
###

# Usage: Yorn MSG
#     Read a yes/no response from STDIN, prompting with MSG.  Return true
#     iff answer is yes.
sub Yorn {
    my $msg = shift;
    while (1) {
	print STDERR "$msg [yes/no] ";
	$_ = <STDIN>;
	/^y(es)?$/i && do { return 1; };
	/^no?$/i && do { return 0; };
	print STDERR "Please answer 'yes' or 'no'\n";
    }
}

# Usage: Fetch MSG
#     Read a non-empty line from STDIN, prompting with MSG.
sub Fetch {
    my $msg = shift;
    my $result;
    $result = "";
    while ($result eq "") {
	print STDERR "$msg";
	$result = <STDIN>;
	$result =~ s/^\s*//;
	$result =~ s/\s*$//;
    }
    return $result;
}

# Usage: Fetch0 MSG
#     Read a line (possibly empty) from STDIN, prompting with MSG.
sub Fetch0 {
    my $msg = shift;
    my $result;
    print STDERR "$msg";
    $result = <STDIN>;
    $result =~ s/^\s*//;
    $result =~ s/\s*$//;
    return $result;
}

###
# Grading database queries.
###

# Usage: StudentExists LOGIN
#    True iff LOGIN is a student registered in this class.
sub StudentExists {
    my ($login) = @_;
    return (-e "$REGISTER_DIR/$login") ? 1 : 0;
}

# Usage: TeamExists TEAM
#    True iff TEAM is a registered team name.
sub TeamExists {
    my ($team) = @_;
    return (-e "$TEAM_DIR/$team") ? 1 : 0;
}

# Usage: TeamMembers TEAM
#    A list of the members of TEAM as a whitespace-separated string.
sub TeamMembers {
    my ($team) = @_;
    open (TEAM, "/share/b/grading/bin/team-members $team|");
    my $line = <TEAM>;
    # FIXME: On Solaris, it appears that ALL pipes started with open give 
    # non-zero on close.  Apparently, they use lseek to test for a pipe and 
    # then get confused and sends its result as the return code.  So don't 
    # check exit code for now.
    close (TEAM);
    $line =~ s/^.*?:\s*//;
    return $line;
}

# Usage: GetCode LOGIN
#    The codeword supplied by LOGIN during registration
sub GetCode {
    my ($login) = @_;
    open (REGISTRATION, "<$REGISTER_DIR/$login") || return "?$login?";
    while (<REGISTRATION>) {
	if (/^Code:\s*(.*)/) {
	    close REGISTRATION;
	    return $1;
	}
    }
    close REGISTRATION;
    return "?$login?";
}

# Usage: AssignmentExists ASSIGN
#    True iff ASSIGN is listed among the recognized assignment names.
sub AssignmentExists {
    my ($assign) = @_;
    return exists $ASSIGNMENTS{$assign};
}

# Usage: ValidFormat FORMAT
#    True iff FORMAT is a known submission format.
sub ValidFormat {
    return $_[0] eq 'standard' or $_[0] eq 'svn';
}

# Usage: ReaderExists LOGIN
#     True (1) iff reader with given LOGIN exists.
sub ReaderExists {
    my ($login) = @_;
    return exists $READERS{$login};
}

# Usage: Basename (STRING) 
sub Basename {
    $_[0] =~ m{ ([^/]*)$ }x;
    return $1;
}

# Usage: ExistingSubmissions LOGIN ASSGN
sub ExistingSubmissions {
    my ($login, $assgn) = @_;
    my @matches = map (Basename ($_), GLOB ("$SUBMISSION_DIR/$assgn/$login.*"));
    return @matches;
}
    
# Usage: SubmissionExists LOGIN ASSGN
sub SubmissionExists {
    return ExistingSubmissions($_[0], $_[1]) != 0;
}

# Usage MailingAddress LOGIN
sub MailingAddress {
    my $login = shift;
    if (TeamExists ($login)) {
	return undef;
    }
    if (not open (REGISTER, "$REGISTER_DIR/$login")) {
	Warn ("Could not read registration data for $login");
	return undef;
    }
    my $address = $login;
    while (<REGISTER>) {
	if (/^Email:\s*(\S+)/) {
	    $address = $1;
	}
    }
    close REGISTER;
    return $address;
}
    
# Usage SubmissionMap ASSGN
#    A reference to a hash mapping logins to references to lists of 
#    submissions for ASSGN, and mapping submissions to references to lists 
#    of logins of submitters.  Here, a  "submission" is of the form
#    "<login>.<timestamp>".
sub SubmissionMap {
    my $assgn = shift;
    my $dir = "$SUBMISSION_DIR/$assgn";
    my ($result, $login, $realSubm);
    if (not opendir (SUBMISSIONS, $dir)) {
	return { };
    }
    $result = { };
    my @allSubmissions = readdir (SUBMISSIONS);
    closedir (SUBMISSIONS);
    foreach my $subm (@allSubmissions) {
	next if $subm !~ /^(\S+)\.\d+$/;
	$login = $1;
	$f = "$dir/$subm";
	$realSubm = RealSubmission ($f);
	next if $realSubm !~ /^(\S+)\.\d+$/;
	$$result{$login} = ($$result{$login} or []);
	$$result{$realSubm} = ($$result{$realSubm} or []);
	push @{$$result{$login}}, $realSubm;
	push @{$$result{$realSubm}}, $login;
    }
    return $result;
}
	    
# Usage Partnerships MAP LOGIN
#    A list of all distinct partnerships containing LOGIN implied by MAP.
#    MAP has format produced by SubmissionMap, above.  Each partnership is 
#    a string containing logins separated by spaces.
sub Partnerships {
    my $map = shift;
    my $login = shift;
    my %partnerships;
    my $submissions = $$map{$login};
    if ($submissions) {
	foreach my $subm (@$submissions) {
	    $partnerships{join (' ', sort (@{$$map{$subm}}))} = 1;
	}
    }
    return keys (%partnerships);
}

# Usage IsPartnerSubmission FILE
#    True iff FILE represents a submission by a partner.  FILE must be the 
#    pathname of a file under the submission directory.
sub IsPartnerSubmission {
    my $file = shift;
    return -l $file;
}

# Usage RealSubmission FILE
#    The basename of the file containing the actual submission for the 
#    submission contained in FILE.  This is FILE itself, unless it represents
#    a partner's entry, in which case it is the name under which the project
#    was actually submitted.
sub RealSubmission {
    my $file = shift;
    my $base;
    if ($base = readlink ($file)) {
	return $base;
    } else {
	$file =~ m{.*/(.*)};
	return $1;
    }
}

# Usage GetDeadlineExceptions 
#    A hash mapping ASSGN/LOGIN and ASSGN/TEAM pairs to deadlines specific
#    to those pairs, as indicated by the deadline-exceptions file.  If 
#    WARN, print warnings of anomalies, otherwise ignore.
sub GetDeadlineExceptions {
    my $warn = shift;
    my %lateException;
    open (EXCEPTIONS, $DEADLINE_EXCEPTIONS) or return ();
    while (<EXCEPTIONS>) {
	if (my ($assgn, $id, $time) = /^\s*([^\s#]\S*)\s+(\S+)\s+(\S+)/) {
	    if (not AssignmentExists($assgn)) {
		Warn ("Nonexistent assignment ($1) " .
		      "in lateness exception file.") if $warn;
		next;
	    }
	    if (not StudentExists ($id) and not TeamExists ($id)) {
		Warn ("Nonexistent student or team ($2) " .
		      "in lateness exception file.") if $warn;
		next;
	    }
	    if (not defined ToTime ($time)) {
		Warn ("Invalid time ($3) in lateness exception file.") if $warn;
		next;
	    }
	    $lateException{"$assgn/$id"} = ToTime ($time);
	}
    }
    close EXCEPTIONS;
    return %lateException;
}
###
# Utilities for initialization
###

# Usage: InitDir DIR MODE [ GROUP-ID ]
sub InitDir {
    my ($dir) = shift;
    my ($mode) = shift;
    my ($group) = shift;
    my ($old_umask) = umask ();
    my ($dev,$ino,$omode,$nlink,$uid,$ogid,$rdev,$size) = stat $dir;

    if (not defined $uid) {
	umask 0;
	mkdir ($dir, $mode) or Warn ("Could not create directory $dir.");
	umask ($old_umask);
    }

    if (defined ($group)) {
	$gid = scalar (getgrnam ($group));
	if ($gid != $ogid and chown ($>, $gid, $dir) != 1) {
	    Warn ("Could not set group of $dir to $group.");
	    return 0;
	};
    }
    if ($mode != ($omode & 03777) and chmod ($mode, $dir) != 1) {
	Warn ("Could not set mode of $dir to $mode.");
	return 0;
    };
    return 1;
}

# Usage: ShellQuote ARG
# Returns ARG quoted in such a way that when interpolated into a shell command,
# it will denote the original value of ARG.
sub ShellQuote {
    my $arg = shift;
    $arg =~ s/([\$"`\\])/\\$1/g;
    return "\"$arg\"";
}

###
# Clean up
###

undef %CLEAN_ME;
sub Clean1 {
    my $file = shift;
    $file =~ s{/+$}{};
    if (-l $file || ! -d _) {
	unlink ($file);
    } else {
	if (opendir (CLEANDIR, $file)) {
	    for my $subfile (readdir (CLEANDIR)) {
		if ($subfile ne "." and $subfile ne "..") {
		    Clean1 ("$file/$subfile");
		}
	    }
	    closedir (CLEANDIR);
	}
	rmdir ($file);
    }
}	

sub CleanUp {
    if (%CLEAN_ME) {
	foreach (keys %CLEAN_ME) {
	    Clean1 $_;
	}
    }
    Unlock;
}

sub AddClean {
    foreach (@_) {
	unless (m"^/") { Fatal ("Cleanups must have full path names."); }
	$CLEAN_ME{$_} = 1;
    }
}

sub DeleteClean {
    foreach (@_) {
	delete $CLEAN_ME{$_};
    }
}

###
# Tests
###

# Usage: IsNumeric GRADE
sub IsNumeric {
    if ($_[0] =~ /^-?[.0-9]+$/ ) {
	return 1;
    } else {
	return 0;
    }
}

# Establish clean-up routines

$SIG{'INT'} = $SIG{'QUIT'} = $SIG{'TERM'} = sub { CleanUp (); exit 1; };


###
# Parameter file handling.
###

# Usage: assign NAME -max MAX [ -absolute-max AMAX ] [ -weight W ] \
#               [ -partners ] [ -no-submit ] [ -instructors-only ] \
#               [ -no-assigned-readers ] [ -due DATE ] [ -reader-due DATE ] \
#               [ -category key ] [ -no-display ] \
#               [ -req FILE ] [ -accept PATN ] [ -rej PATN ] [ -rejl PATN ] \
#               [ -hidden ] ... 

sub assign {
    my $name = shift;
    if (! defined ($name)) {
	Fatal ("Command 'assign' must have arguments");
    } elsif (exists $ASSIGNMENTS{$name}) {
	Fatal ("Duplicate declaration of assignment $name");
    } elsif ($name =~ m{[./: \t]}) {
	Fatal ("Assignment name ($name) contains space, '.', '/', or ':'.");
    } elsif (":Login:Name:Total:Last:Name:SID:Grade:" =~ /:$name:/) {
	Fatal ("Assignment may not be named $name.");
    } elsif ($IS_CATEGORY{$name}) {
	Fatal ("Assignment $name has the same name as a category.");
    }

    $ASSIGNMENTS{$name} = 1;
    push (@ASSIGNMENT_LIST, $name);

    $ASSGN_ABSMAX{$name} = 0;
    $ASSGN_WEIGHT{$name} = 1;
    $ASSGN_PARTNERS{$name} = 0;
    $ASSGN_SUBMIT{$name} = 1;
    $ASSGN_USE_READERS{$name} = 1;
    $ASSGN_ASSIGNED_READERS{$name} = 1;

    while ($_ = shift) {
      OPTION: {
	  /^-max$/ && $_[0] =~ /^[0-9]+(\.[0-9]*)?$/ && do {
	      $ASSGN_MAX{$name} = $_[0]; shift; last OPTION; };
	  /^-absolute-max$/ && $_[0] =~ /^[0-9]+(\.[0-9]*)?$/ && do {
	      $ASSGN_ABSMAX{$name} = $_[0]; shift; last OPTION; };
	  /^-weight$/ && $_[0] =~ /^[0-9]+(\.[0-9]*)?$/ && do {
	      $ASSGN_WEIGHT{$name} = $_[0]; shift; last OPTION; };
	  /^-partners$/ && do {
	      $ASSGN_PARTNERS{$name} = 1; last OPTION; };
	  /^-no-submit$/ && do {
	      $ASSGN_SUBMIT{$name} = 0; last OPTION; };
	  /^-instructors?-only$/ && do {
	      $ASSGN_USE_READERS{$name} = 0; last OPTION; };
	  /^-no-assigned-readers$/ && do {
	      $ASSGN_ASSIGNED_READERS{$name} = 0; last OPTION; };
	  /^-due$/ && defined(ToTime($_[0])) && do {
	      $ASSGN_DUE{$name} = ToTime($_[0]); shift; last OPTION; };
	  /^-reader-due$/ && defined(ToTime($_[0])) && do {
	      $ASSGN_READER_DUE{$name} = ToTime($_[0]); shift; last OPTION; };
	  /^-req$/ && defined ($_[0]) && do {
	      if ($_[0] =~ /\s/) {
		  Fatal ("Required filename '$_[0]' contains whitespace");
	      }
	      $ASSGN_REQUIRED{$name} .= shift () . " "; last OPTION; };
	  /^-accept$/ && defined ($_[0]) && do {
	      $ASSGN_ACCEPT{$name} .= shift () . " "; last OPTION; };
	  /^-rej$/ && defined ($_[0]) && do {
	      $ASSGN_REJECT{$name} .= shift () . " "; last OPTION; };
	  /^-rejl$/ && defined ($_[0]) && do {
	      $ASSGN_REJECTL{$name} .= shift () . " "; last OPTION; };
	  /^-category$/ && defined ($_[0]) && do {
	      my $category = shift;
	      if ($ASSIGNMENTS{$category}) {
		  Fatal ("Category $category has the same name as an assignment.");
	      }
	      $IS_CATEGORY{$category} = 1;
	      $ASSGN_CATEGORY{$name} = $category; last OPTION; };
	  /^-hidden$/ && do {
	      $ASSGN_HIDDEN{$name} = 1; last OPTION; };
	  Fatal ("Illegal option to 'assign': $_ " . join (" ", @_));
      }
    }

    if (! defined ($ASSGN_MAX{$name})) {
	Fatal ("No -max option to 'assign $name' command.");
    }
    if (exists $ASSGN_READER_DUE{$name} && ! exists $ASSGN_DUE{$name}) {
	Fatal ("In 'assign $name' there is a -reader-due option, but no -due.");
    }
    if (! exists $ASSGN_READER_DUE{$name} 
	|| $ASSGN_READER_DUE{$name} <= $ASSGN_DUE{$name}) {
	$ASSGN_READER_DUE{$name} = $ASSGN_DUE{$name} + 3*24*3600;
    }

    if ($ASSGN_ABSMAX{$name} < $ASSGN_MAX{$name}) {
	$ASSGN_ABSMAX{$name} = $ASSGN_MAX{$name};
    }
    if (! $ASSGN_USE_READERS{$name}) {
	$ASSGN_ASSIGNED_READERS{$name} = 0;
    }

    if (! exists $ASSGN_CATEGORY{$name}) {
	$IS_CATEGORY{"General"} = 1;
	$ASSGN_CATEGORY{$name} = "General";
    }

    return 1;
}

# Usage: reader LOGIN [ -instructor ] [ -no-remind ] \
#                     [ -grade ASSIGN_PATN LOGIN_PATN ] ...
sub reader {
    my $login = shift;

    if (! defined($login)) {
	Fatal ("Command 'reader' must have arguments.");
    } elsif (exists $READERS{$login}) {
	Fatal ("Reader $login defined twice.");
    } elsif ($login =~ m{[./:]}) {
	Fatal ("Reader name '$login' contains '.', ':', or '/'.");
    }

    $READERS{$login} = 1;
    $READER_REMIND{$login} = 1;
    $AUTHORIZED{$login} = 1;
    my ($gradePatn, $assgnPatn, $loginPatn);
    $gradePatn = "";
    while (@_) {
	if ($_[0] eq "-instructor") {
	    $READER_IS_INSTRUCTOR{$login} = 1; shift; 
	} elsif ($_[0] eq "-no-remind") {
	    $READER_REMIND{$login} = ""; shift; 
	} elsif ($_[0] eq "-grade") {
	    ($_, $assgnPatn, $loginPatn) = @_;
	    if (! $assgnPatn || ! $loginPatn) {
		Fatal ("A -grade option for $login has the wrong format");
	    }
	    CheckPatn ($loginPatn)
		|| Fatal ("Invalid login pattern in -grade for $login: $loginPatn");
	    CheckPatn ($assgnPatn)
		|| Fatal ("Invalid assignment pattern in -grade for $login: $assgnPatn");
	    $gradePatn .= "|" if ($gradePatn);
	    $gradePatn .= "(($assgnPatn)::($loginPatn))";
	    splice (@_, 0, 3);
	} else {
	    Fatal ("Invalid argument to 'reader' command: $_[0]");
	}
    }

    if ($gradePatn) {
	$READER_ASSIGNMENTS{$login} = "^($gradePatn)\$";
    } else {
	$READER_ASSIGNMENTS{$login} = "^.*\$";
    }
    return 1;
}	

# Usage: set VARNAME VAL
sub set {
    my ($var, $val) = @_;
    if ((",MAIL_PROG,SUBMIT_PROG,REGISTER_PROG,GMAKE,CLASSROOT,CLASSPREFIX,"
	 . "COURSE,SUPERVISOR,STAFF_GROUP,EXTRA_REGISTRATION_HOOK,"
	 . "MASTER_PROGRAM,OPEN_TEAMS,SVN_REPOSITORY_URL,"
	 . "SVN_SUBMISSION_PATN,SVN_SUBMITTER_PATN,SVN_ASSGN_PATN,")
	=~ /,$var,/) {
	$$var = $val;
    } else {
	Fatal ("Attempt to set unknown parameter: $var");
    }
}

# Usage: gradescale [ -throw-out-lowest N CATEGORY ] ... \
#                   MIN-SCORE LETTER-GRADE  ... 

sub gradescale {
    my ($n, $category, $letter, $min);
    while ($_[0] eq "-throw-out-lowest") {
	if ($_[1] =~ /[0-9]+/ && defined ($_[2])) {
	    shift;
	    $n = shift; $category = shift;
	    unless ($IS_CATEGORY{$category}) {
		Fatal ("Undefined category '$category' in gradescale.");
	    }
	    $THROW_OUT_LOWEST{$category} = $n;
	} else {
	    Fatal ("Invalid option to gradescale: $_ " . join(" ",@_));
	}
    }

    while (@_) {
	$_[0] =~ /^[0-9]+(\.[0-9]*)?$/ && defined ($_[1]) && do {
	    $GRADE_SCALE{$_[1]} = $_[0]; shift; shift;
	    next;
	};
	Fatal ("Invalid score to gradescale: $_[0] " . join(" ",@_));
    }
}

######################################################################

###
# Set defaults
###

$PROJECT_NAME = "GradeReports";
$SUBMIT_PROG = '/share/b/grading/bin/copy-submission';
$REGISTER_PROG = '/share/b/grading/bin/access-registration';
$MAIL_PROG = "mailx";
$GMAKE = "gmake";
$OPEN_TEAMS = 0;
undef %AUTHORIZED;

###
# Set parameters concerning current assignments, etc.
###

open (PARAMS, "$DIR/params") || Fatal ("Cannot open $DIR/params: $!");
$cmnd = "";
while (<PARAMS>) {
    chomp;
    s/^\s*//;
    s/\s*$//;

    next if /^\#/;
    next if /^$/;

    if (/\\$/) {
	chop; $cmnd .= $_; next;
    } else {
	$cmnd .= $_;
    }

    @args = ($cmnd =~ m"('[^']*'|\S+)"g);

    foreach $arg (@args) {
	$arg =~ s{ ^'(.*)'$ }{$1}x;
    }

    $_ = $args[0];
    @_ = @args; shift @_;

    SET: {
       /^assign$/ && do { &assign; last SET; };
       /^reader$/ && do { &reader; last SET; };
       /^set$/ && do { &set; last SET; };
       /^gradescale$/ && do { &gradescale; last SET; };
       Fatal ("Invalid command in $DIR/params:\n\t$cmnd");
    }
 
    $cmnd = "";
}

###
# Set derived defaults
###

defined ($CLASSROOT) or
    defined ($ENV{'MASTER'}) and $CLASSROOT = $ENV{'MASTER'} or
    ($CLASSROOT) = ($ENV{'MASTERDIR'} =~ m{ ([^/]+)$ }x);

$CLASSROOT = $ENV{'MASTER'} if (! defined ($CLASSROOT));
$COURSE = $CLASSROOT if (! defined ($COURSE));
$STAFF_GROUP = "$CLASSROOT-staff" if (! defined ($STAFF_GROUP));
$SUPERVISOR = $CLASSROOT if (! defined ($SUPERVISOR));
$MASTER_PROGRAM = "run-as-$COURSE" if (! defined ($MASTER_PROGRAM));
$CLASSPREFIX = "$CLASSROOT-" if (! defined ($CLASSPREFIX));

###
# Insure that all standard directories exist, and have proper accessibility.
###

return 1 if ($noinit);

($classUID = getpwnam ($CLASSROOT))
    || Fatal ("Could not find UID of class master ($CLASSROOT).");
if ($< == $classUID) {
    # I am the class root. 

    InitDir ($SUBMISSION_DIR, 0770, $STAFF_GROUP);
    InitDir ($BUG_SUBMISSION_DIR, 02770, $STAFF_GROUP);
    InitDir ($ALL_GRADE_DIR, 02750, $STAFF_GROUP);
    InitDir ($SECRET_DIR, 02750, $STAFF_GROUP);
    InitDir ($REGISTER_DIR, 03755, $STAFF_GROUP);
    InitDir ($PRETEST_DIR, 0755);
    InitDir ($REPOSITORY_DIR, 0700);
    InitDir ($TEAM_DIR, 0775, $STAFF_GROUP);
    InitDir ($LOG_DIR, 0770, $STAFF_GROUP);
    InitDir ($TEST_DIR, 02770, $STAFF_GROUP);
    InitDir ($TEST_MAKEFILE_DIR, 02770, $STAFF_GROUP);
    InitDir ($LOCK_DIR, 02777);
}

1;

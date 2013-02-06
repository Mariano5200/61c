# Fetch values of configuration parameters, etc.
# See the file COPYING in the main distribution directory for copyright notice.

$noinit = 1;

unshift (@INC, '@LIBDIR@');
require "GradingBase.pl";
CmndLine ("d", 1);
require "GradingCommon.pl";

foreach $name (@ARGV) {
    die "Invalid name" if ($name !~ /^[_A-Za-z0-9]+$/);
    if ($opt_d) {
	print ("$name='" . eval ("\$$name") . "';\n");
    } else {
	print ((eval "\$$name") . "\n");
    }
}

exit 0;

	

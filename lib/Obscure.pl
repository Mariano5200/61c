# Subroutine for "obscuring" a set of (numeric) SIDs.
# See the file COPYING in the main distribution directory for copyright notice.

sub obfuscate {
    my @keys = @_;
    my (%map, %counts, %present, %OK, $i);

    for $key (@keys) {
	if ($present{$key}) {
	    $map{$key} = "_" x 8;
	    delete $OK{$key};
	} elsif ($key !~ /[0-9]{8}/) {
	    $map{$key} = $key;
	} else {
	    $OK{$key} = 1;
	    for ($i = 0; $i < 8; $i += 1) {
		$count{$i . substr ($key, $i, 1)} += 1;
	    }
	}
	$present{$key} = 1;
    }
	
    @keys = keys %OK;
    # Now all @keys are unique, and 8 digits long.  $count{xy} is 
    # (approx.) the number of keys having digit y at position x.
    
    my ($key1, $k, $n, $c);
    foreach $key0 (@keys) {
	$key1 = "." x 8;
      FIND: while (1) {
	  $c = "";
	  for ($j = 0; $j < 8; $j += 1) {
	      next if (substr ($key1, $j, 1) ne ".");
	      $n = $count{$j . substr ($key0, $j, 1)};
	      if (!$c || $c > $n) {
		  $k = $j; $c = $n;
	      }
	  }
	  substr ($key1, $k, 1) = substr ($key0, $k, 1);

	  foreach $key (@keys) {
	      if ($key ne $key0 && $key =~ /$key1/) {
		  next FIND;
	      }
	  }
	  last FIND;
      }

	$map{$key0} = $key1;
    }

    return %map;
}

1;

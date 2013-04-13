#! /usr/bin/env python3

import sys
import subprocess
import re

if (len(sys.argv) >= 2):
     runs = int(sys.argv[1])
else:
    runs = 5
total = 0

pat = re.compile("[0-9]*\.?[0-9]*")
if __name__ == '__main__':
    run = 0
    while (run < runs):
        proc = subprocess.Popen('./bench-small', stdout=subprocess.PIPE)
        result = proc.communicate()[0].decode("utf-8")
        curr = pat.match(result).group()
        print("Run {0}: {1} Gflops".format(run, curr))
        total += float(curr)
        run += 1
    total /= runs
    print("\nAverage Run: " + str(total) + " Gflops")
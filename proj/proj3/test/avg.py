#! /usr/bin/env python3

import sys
import subprocess
import re

if (len(sys.argv) >= 2):
     runs = int(sys.argv[1])
     file = str(sys.argv[2])
else:
    runs = 5
    file = ""


def avg(l):
    return sum(l)/len(l)

all_runs = {}
pat = re.compile("[0-9]*\.?[0-9]*")
if __name__ == '__main__':
    for bs in range(100,1600, 50):
        if bs not in [100, 150,300]:
            for n in range(400,1501, 50):
                for m in range(32, 100, 2):
                    total, run = 0
                    while (run < runs):
                        proc = subprocess.Popen([file,
                         str(n), str(m), str(bs)], stdout=subprocess.PIPE)
                        result = proc.communicate()[0].decode("utf-8")
                        curr = pat.match(result).group()
                        print("Run {0}: N: {1}, M: {2}, BS: {3}\t{4} Gflops".format(run, n, m, bs, curr))
                        total += float(curr)
                        run += 1
                    total /= runs
                    print("\nAveraged: \t" + str(total) + " Gflops")
                    if bs not in all_runs:
                        all_runs[bs] = [total]
                    else:
                        all_runs[bs] += [total]
    for key, value in all_runs:
        mean = avg(value)
        print("Blocksize: ", key, "\t", mean, "Gflops")
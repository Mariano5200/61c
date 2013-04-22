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
n_sizes = [400,533,711,948,1264,512,768,1024,1000,800,
439,499,571,859,907,1213,1333]
#bounded 400,1500
n_sizes.sort()
m_sizes = [32,100,64,97,37,43,61,78,83,50] #bounded 32,100
m_sizes.sort()
bs_sizes = [400,800,1600,1000,1200,1400]
bs_sizes = [500,700,1500,2000,900,1300]
bs_sizes.sort()
for bs in bs_sizes:
    all_runs[bs] = []

bad_shit = False
bs2 = 0
if __name__ == '__main__':
    for bs in bs_sizes:
        if not (bad_shit and bs2 == bs):
            for n in n_sizes:
                for m in m_sizes:
                    total = 0
                    run = 0
                    while (run < runs):
                        proc = subprocess.Popen([file,
                        str(n), str(m), str(bs)], stdout=subprocess.PIPE)
                        result = proc.communicate()[0].decode("utf-8")
                        curr = pat.match(result).group()
                        try:
                            curr = float(curr)
                        except ValueError:
                            print("ERROR:\t Run {0}: N: {1}, M: {2}, BS: {3}".format(run, n, m, bs))
                            bad_shit = True
                            bs2 = bs
                            break
                        print("Run {0}: N: {1}, M: {2}, BS: {3}\t{4} Gflops".format(run, n, m, bs, curr))
                        total += curr
                    total /= runs
                    if total > 0:
                        print("Averaged: \t\t\t" + str(total) + " Gflops\n")
                    all_runs[bs] += [total]
    print(all_runs)
    print()
    for item in all_runs:
        mean = avg(all_runs[iten])
        print("Blocksize: ", str(item), "\t", mean, "Gflops")
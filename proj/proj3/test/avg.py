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
600,439,499,571,829,859,907,1213,1333,1499,700,1300,1111]
#bounded 400,1500
n_sizes.sort()
m_sizes = [32,100,64,48,97,37,43,53,61,78,83,50] #bounded 32,100
m_sizes.sort()
bs_sizes = [400,800,1600,512,1024,750,1000,1200,500,700,
1200,1400]
bs_sizes.sort()



if __name__ == '__main__':
    for bs in bs_sizes:
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
                        break
                    print("Run {0}: N: {1}, M: {2}, BS: {3}\t{4} Gflops".format(run, n, m, bs, curr))
                    total += curr
                    run += 1
                total /= runs
                if total > 0:
                    print("Averaged: \t\t\t" + str(total) + " Gflops\n")
                if bs not in all_runs:
                    all_runs[bs] = [total]
                else:
                    all_runs[bs] += [total]
    for key, value in all_runs:
        mean = avg(value)
        print("Blocksize: ", key, "\t", mean, "Gflops")
HOME = /home/ff/cs61c
UNAME = $(shell uname)

# running on hive machines
ifeq ($(UNAME),Linux)
CC = gcc -std=gnu99 -fopenmp -O3
GOTO = $(HOME)/bin/GotoBLAS2_Linux
GOTOLIB = $(GOTO)/libgoto2_nehalemp-r1.13.a
endif

# running on 200 SD machines
# Goto modified for my mac/project.
ifeq ($(UNAME),Darwin)
CC = gcc -std=gnu99 -fopenmp -O3
GOTO = ./GotoBLAS2
GOTOLIB = $(GOTO)/libgoto2_nehalemp-r1.13.a
endif

INCLUDES = -I$(GOTO)
OMP = -fopenmp
LIBS = -lpthread
# a pretty good flag selection for this machine...
CFLAGS = -msse4 -fopenmp -O3 -pipe -fno-omit-frame-pointer

all:	bench-naive bench-small bench-openmp

# triple nested loop implementation
bench-naive: benchmark.o sgemm-naive.o
	$(CC) -o $@ $(LIBS) benchmark.o sgemm-naive.o $(GOTOLIB)

# your implementation for part 1
bench-small: benchmark.o sgemm-small.o
	$(CC) -o $@ $(LIBS) benchmark.o sgemm-small.o $(GOTOLIB)
# your implementation for part 2
bench-openmp: benchmark.o sgemm-openmp.o
	$(CC) -o $@ $(LIBS) $(OMP) benchmark.o sgemm-openmp.o $(GOTOLIB)

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCLUDES) $<

clean:
	rm -f *~ bench-naive bench-small bench-openmp avg avg40 *.o

# Because I'm lazy....
bn: bench-naive
	./bench-naive
bs: bench-small
	./bench-small
bo: bench-openmp
	./bench-openmp
avg:  benchmark_avg.o sgemm-small.o
	$(CC) -o avg $(LIBS) benchmark_avg.o sgemm-small.o $(GOTOLIB)
	touch tmp
	for i in {1..20}; do ./bench-small >> tmp; done
	echo "Average Gflops: "
	$((paste -sd+ tmp | bc / 20))
	rm tmp

avg40:  benchmark_avg_40.o sgemm-small.o
	$(CC) -o avg40 $(LIBS) benchmark_avg_40.c sgemm-small.c $(GOTOLIB)
	touch tmp
	for i in {1..20}; do ./avg40 >> tmp; done
	echo "Average Gflops 40x40: "
	paste -sd+ tmp | bc
	rm tmp

avgall: avg avg40

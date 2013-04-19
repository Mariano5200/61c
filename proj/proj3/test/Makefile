HOME = /home/ff/cs61c
UNAME = $(shell uname)
HOST = $(shell hostname | cut -c1-8)
DATE = $(shell date "+%Y-%m-%d-%H:%M:%S")

# running on hive machines
ifeq ($(UNAME),Linux)
CC = gcc -std=gnu99 -fopenmp -O3
GOTO = $(HOME)/bin/GotoBLAS2_Linux
GOTOLIB = $(GOTO)/libgoto2_nehalemp-r1.13.a
endif

# running on 200 SD machines
ifeq ($(UNAME),Darwin)
CC = gcc -std=gnu99 -fopenmp -O3
# GOTO = $(HOME)/bin/GotoBLAS2
GOTO = ../GotoBLAS2
GOTOLIB = $(GOTO)/libgoto2_nehalemp-r1.13.a
endif

# My dir for local builds
ifeq ($(HOST),mountain)
GOTO = ../GotoBLAS2
GOTOLIB = $(GOTO)/libgoto2_nehalemp-r1.13.a
endif
ifeq ($(HOST),Mountain)
GOTO = ../GotoBLAS2
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
bench-small-2: benchmark.o sgemm-small-2.o
	$(CC) -o $@ $(LIBS) benchmark.o sgemm-small-2.o $(GOTOLIB)
# your implementation for part 2
bench-openmp: benchmark.o sgemm-openmp.o
	$(CC) -o $@ $(LIBS) $(OMP) benchmark.o sgemm-openmp.o $(GOTOLIB)

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCLUDES) $<

clean:
	rm -f *~ bench-naive bench-small bench-openmp *.o tmp

# Because I'm lazy....
bn: bench-naive
	./bench-naive
bs: bench-small
	./bench-small
bo: bench-openmp
	./bench-openmp
avg: test

test: bench-openmp
	echo "Single Run:"
	./bench-openmp > single_run_$(DATE).txt
	echo "Averaged Runs:"
	./avg.py 2 ./bench-openmp 2>&1 avg_cache_$(DATE).txt
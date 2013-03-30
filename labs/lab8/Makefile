CC=gcc
CFLAGS=-fopenmp -O3 -g -std=c99
LDFLAGS=-fopenmp

all: v_add hello dotp

v_add: v_add.o

hello: hello.o

dotp: dotp.o

clean:
	rm -f v_add v_add.o hello.o hello dotp dotp.o 


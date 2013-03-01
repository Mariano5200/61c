#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>

void transpose( int n, int blocksize, int *dst, int *src ) {
    int a,b,i,j;
    /* TODO: implement blocking (two more loops) */
    for(i = 0; i < n; i += blocksize)
        for(j = 0; j < n; j += blocksize)
          for (a = i; a < blocksize+i && a < n; a += 1)
            for (b = j; b < blocksize+j && b < n; b += 1)
            dst[b + a*n] = src[a + b*n];
}

int main( int argc, char **argv ) {
    int n = 2000,i,j;
    int blocksize = 600; /* TODO: find a better block size */

    /* allocate an n*n block of integers for the matrices */
    int *A = (int*)malloc( n*n*sizeof(int) );
    int *B = (int*)malloc( n*n*sizeof(int) );

    /* initialize A,B to random integers */
    srand48( time( NULL ) );
    for( i = 0; i < n*n; i++ ) A[i] = lrand48( );
    for( i = 0; i < n*n; i++ ) B[i] = lrand48( );

    /* measure performance */
    struct timeval start, end;

    gettimeofday( &start, NULL );
    transpose( n, blocksize, B, A );
    gettimeofday( &end, NULL );

    double seconds = (end.tv_sec - start.tv_sec) + 1.0e-6 * (end.tv_usec - start.tv_usec);
    printf( "%g milliseconds\n", seconds*1e3 );

    /* check correctness */
    for( i = 0; i < n; i++ )
        for( j = 0; j < n; j++ )
            if( B[j+i*n] != A[i+j*n] ) {
	        printf("Error!!!! Transpose does not result in correct answer!!\n");
	        exit( -1 );
            }

    /* release resources */
    free( A );
    free( B );
    return 0;
}


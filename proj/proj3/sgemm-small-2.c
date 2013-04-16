#include <nmmintrin.h>
#include <omp.h>

void sgemm( int m, int n, int d, float *A, float *C )
{
    #pragma omp parallel
    {
    #pragma vectorize unroll optimize("", on)
    for( int j = 0; j < n; j++ ) {
        #pragma vectorize unroll optimize("", on)
        for( int k = 0; k < m; k++ ) {
            __m128 a1;
            a1 = _mm_load1_ps(A+j*(n+1)+k*(n));
            int i;
            int ntmp = n/8*8;
            #pragma vectorize optimize("", on)
			#pragma omp for private(i)
            for(i = 0; i < ntmp; i += 8 ) {
                float *ikn = A+i+k*(n);
                float *ijn = C+i+j*n;
                __m128 a2 = _mm_loadu_ps(ikn);
                __m128 a3 = _mm_loadu_ps(ikn+4);
                __m128 mulres = _mm_mul_ps(a1, a2);
                __m128 mulres2 = _mm_mul_ps(a1, a3);
                __m128 sum = _mm_add_ps(_mm_loadu_ps(ijn), mulres);
                __m128 sum3 = _mm_add_ps(_mm_loadu_ps(ijn+4), mulres2);

                _mm_storeu_ps(ijn, sum);
                _mm_storeu_ps(ijn+4, sum3);
            }
			// #pragma omp for
            for (i = i; i < n; i++) {
                C[i+j*n] += A[i+k*n] * A[j*(n+1)+k*n];
            }
      }
    }
}
}

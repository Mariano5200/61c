#include <nmmintrin.h>
void sgemm( int m, int n, int d, float *A, float *C )
{
  //__m128 x;
  int c = 0;
  for( int j = 0; j < n; j++ ) {
      for( int k = 0; k < m; k++ ) {
	  __m128 a1;
	  a1 = _mm_load1_ps(A+j*(n+1)+k*(n));
	  //int arr[4];
	  int t;
	  int r;
	  int i;
	  //if (n%8 == 0) {
	      for(i = 0; i < (n/20)*20; i += 20 ) {
		  //t = i+k*(n);
		  //r = i+j*n;
	      __m128 a2 = _mm_loadu_ps(A+i+k*(n));
	      __m128 mulres = _mm_mul_ps(a1, a2);
	      __m128 sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n), mulres);
	      _mm_storeu_ps(C+i+j*n, sum);

	      a2 = _mm_loadu_ps(A+i+k*(n)+4);
	      mulres = _mm_mul_ps(a1, a2);
	      sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n+4), mulres);
	      _mm_storeu_ps(C+ i+j*n+4, sum);

	      a2 = _mm_loadu_ps(A+i+k*(n)+8);
	      mulres = _mm_mul_ps(a1, a2);
	      sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n+8), mulres);
	      _mm_storeu_ps(C+ i+j*n+8, sum);

	      a2 = _mm_loadu_ps(A+i+k*(n)+12);
	      mulres = _mm_mul_ps(a1, a2);
	      sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n+12), mulres);
	      _mm_storeu_ps(C+ i+j*n+12, sum);

	      a2 = _mm_loadu_ps(A+i+k*(n)+16);
	      mulres = _mm_mul_ps(a1, a2);
	      sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n+16), mulres);
	      _mm_storeu_ps(C+ i+j*n+16, sum);
	      //_mm_storeu_ps(C+r, _mm_add_ps(_mm_loadu_ps(C+r),_mm_mul_ps(a1, _mm_loadu_ps(A+t))));
	      //_mm_storeu_ps(C+r+4, _mm_add_ps(_mm_loadu_ps(C+r+4),_mm_mul_ps(a1, _mm_loadu_ps(A+t+4))));
	      //_mm_storeu_ps(C+r+8, _mm_add_ps(_mm_loadu_ps(C+r+8),_mm_mul_ps(a1, _mm_loadu_ps(A+t+8))));
	      //_mm_storeu_ps(C+r+12, _mm_add_ps(_mm_loadu_ps(C+r+12),_mm_mul_ps(a1, _mm_loadu_ps(A+t+12))));
	      //_mm_storeu_ps(C+r+16, _mm_add_ps(_mm_loadu_ps(C+r+16),_mm_mul_ps(a1, _mm_loadu_ps(A+t+16))));
	      //_mm_storeu_ps(C+r+20, _mm_add_ps(_mm_loadu_ps(C+r+20),_mm_mul_ps(a1, _mm_loadu_ps(A+t+20))));
	      //_mm_storeu_ps(C+r+24, _mm_add_ps(_mm_loadu_ps(C+r+24),_mm_mul_ps(a1, _mm_loadu_ps(A+t+24))));
	      //_mm_storeu_ps(C+r+28, _mm_add_ps(_mm_loadu_ps(C+r+28),_mm_mul_ps(a1, _mm_loadu_ps(A+t+28))));
	      //_mm_storeu_ps(C+r+32, _mm_add_ps(_mm_loadu_ps(C+r+32),_mm_mul_ps(a1, _mm_loadu_ps(A+t+32))));
	      //_mm_storeu_ps(C+r+36, _mm_add_ps(_mm_loadu_ps(C+r+36),_mm_mul_ps(a1, _mm_loadu_ps(A+t+36))));
	  }
	      //}
	  /*for(i=0; i < (n/8)*8; i += 8) {
	      t = i+k*n;
	      r = i+j*n;
	      _mm_storeu_ps(C+r, _mm_add_ps(_mm_loadu_ps(C+r),_mm_mul_ps(a1, _mm_loadu_ps(A+t))));
	      _mm_storeu_ps(C+r+4, _mm_add_ps(_mm_loadu_ps(C+r+4),_mm_mul_ps(a1, _mm_loadu_ps(A+t+4))));
	      }*/
          /*else {
	      for(i = 0; i < (n/20)*8; i += 20) {
	      //t = i+k*(n);
	      //r = i+j*n;
	      __m128 a2 = _mm_loadu_ps(A+i+k*(n));
	      __m128 mulres = _mm_mul_ps(a1, a2);
	      __m128 sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n), mulres);
	      _mm_storeu_ps(C+ i+j*n, sum);

	      a2 = _mm_loadu_ps(A+i+k*(n)+4);
	      mulres = _mm_mul_ps(a1, a2);
	      sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n+4), mulres);
	      _mm_storeu_ps(C+ i+j*n+4, sum);

	      a2 = _mm_loadu_ps(A+i+k*(n)+8);
	      mulres = _mm_mul_ps(a1, a2);
	      sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n+8), mulres);
	      _mm_storeu_ps(C+ i+j*n+8, sum);

	      a2 = _mm_loadu_ps(A+i+k*(n)+12);
	      mulres = _mm_mul_ps(a1, a2);
	      sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n+12), mulres);
	      _mm_storeu_ps(C+ i+j*n+12, sum);

	      a2 = _mm_loadu_ps(A+i+k*(n)+16);
	      mulres = _mm_mul_ps(a1, a2);
	      sum = _mm_add_ps(_mm_loadu_ps(C+ i+j*n+16), mulres);
	      _mm_storeu_ps(C+ i+j*n+16, sum);


	      }*/
	      if (n%20 != 0) {
	      for (; i < n; i++) {
		  C[i+j*n] += A[i+k*n] * A[j*(n+1)+k*n];
	      }
	      }
	      //}
      }

  }
}

#include <nmmintrin.h>
#include <omp.h>

#define min(X,Y) (X < Y ? X : Y)
// #define blocksize 200

void sgemm( int m, int n, int d, float *A, float *C, int bs )
{
    //__m128 x;
  int upb = (n/40)*40;
  int upb2 = (n/4)*4;
  //int jn, kn;
  //  int blocksize = 400;
  float *t;
  float *r;
  int blocksize = bs;
  __m128 a1, a2, a21, a22, a23, a24, c1, c2, c3, c4, c5;
  //#pragma omp parallel for private(a1, a2, a21, a22, a23, a24,c1,c2,c3,c4,c5,t,r)
  for(int j = 0; j < n; j+=blocksize ) {
      //int jn = j*n;
      for(int  k = 0; k < m; k+=blocksize ) {
	  		  for(int i = 0; i < n; i += blocksize ) {
  #pragma omp parallel for private(a1, a2, a21, a22, a23, a24,c1,c2,c3,c4,c5,t,r)

	  for (int a = j; a < min(j + blocksize,n) ; a++) {
	      int jn = a*n;
	      for (int b = k; b < min(k + blocksize, m); b++) {
		  int kn = b*n;
		  a1 = _mm_load1_ps(A+jn+a+kn);
		  // int i;
		  //float *t;
		  //float *r;
		      int c;
		      for(c = i; c < min(i + blocksize, upb); c += 40 ) {
			  t = A+c+kn;
			  r = C+c+jn;
			  a2 = _mm_loadu_ps(t);
			  a21 = _mm_loadu_ps(t+4);
			  a22 = _mm_loadu_ps(t+8);
			  a23 = _mm_loadu_ps(t+12);
			  a24 = _mm_loadu_ps(t+16);
			  c1 = _mm_add_ps(_mm_mul_ps(a2, a1), _mm_loadu_ps(r));
			  c2 = _mm_add_ps(_mm_mul_ps(a21, a1), _mm_loadu_ps(r+4));
			  c3 = _mm_add_ps(_mm_mul_ps(a22, a1), _mm_loadu_ps(r+8));
			  c4 = _mm_add_ps(_mm_mul_ps(a23, a1), _mm_loadu_ps(r+12));
			  c5 = _mm_add_ps(_mm_mul_ps(a24, a1), _mm_loadu_ps(r+16));
			  _mm_storeu_ps(r, c1);
			  _mm_storeu_ps(r+4, c2);
			  _mm_storeu_ps(r+8, c3);
			  _mm_storeu_ps(r+12, c4);
			  _mm_storeu_ps(r+16, c5);

			  a2 = _mm_loadu_ps(t+20);
			  a21 = _mm_loadu_ps(t+24);
			  a22 = _mm_loadu_ps(t+28);
			  a23 = _mm_loadu_ps(t+32);
			  a24 = _mm_loadu_ps(t+36);
			  c1 = _mm_add_ps(_mm_mul_ps(a2, a1), _mm_loadu_ps(r+20));
			  c2 = _mm_add_ps(_mm_mul_ps(a21, a1), _mm_loadu_ps(r+24));
			  c3 = _mm_add_ps(_mm_mul_ps(a22, a1), _mm_loadu_ps(r+28));
			  c4 = _mm_add_ps(_mm_mul_ps(a23, a1), _mm_loadu_ps(r+32));
			  c5 = _mm_add_ps(_mm_mul_ps(a24, a1), _mm_loadu_ps(r+36));
			  _mm_storeu_ps(r+20, c1);
			  _mm_storeu_ps(r+24, c2);
			  _mm_storeu_ps(r+28, c3);
			  _mm_storeu_ps(r+32, c4);
			  _mm_storeu_ps(r+36, c5);
			  //mulres = _mm_mul_ps(a1, a2);
			  //mulres1 = _mm_mul_ps(a1, a21);
			  //mulres2 = _mm_mul_ps(a1, a22);
			  //mulres3 = _mm_mul_ps(a1, a23);
			  //mulres4 = _mm_mul_ps(a1, a24);
		      }
		      for(; c < min(i+blocksize,upb2); c+=4) {
			  t = A+c+b*n;
			  r = C+c+a*n;
			  _mm_storeu_ps(r, _mm_add_ps(_mm_loadu_ps(r),_mm_mul_ps(a1,
										 _mm_loadu_ps(t))));
		      }
		      for (; c < min(i+blocksize, n); c++) {
			  C[c+a*n] += A[c+b*n] * A[a*(n+1)+b*n];
		      }

		  }
	      }
	  }
      }
  }
}

/* int min(int a, int b) { */
/*     if (a < b) { */
/* 	return a; */
/*     } */
/*     return b; */
/* } */

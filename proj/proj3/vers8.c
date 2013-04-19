#include <nmmintrin.h>
void sgemm( int m, int n, int d, float *A, float *C )
{

    /*for( int i = 0; i < n; i++ )
    for( int k = 0; k < m; k++ )
      for( int j = 0; j < n; j++ )
      C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];*/
    //if (n%20 == 0) {
	int jn, kn, i, j, k, upb;
	upb = (n/8)*8;
	int upb2 = (m/4)*4;
	//__m128 c1,c2,c3,c4,c5,temp1,temp2,temp3,temp4,temp5,a11,a12,a13,a14,a15,a21,a22,a23,a24;
	__m128 c1, c2, c3, c4, c5, a21,a22, a23, a24;
	float *t;
	float *r;
	float *p;
	if (n == 40) {
	for(j = 0; j < n; j++ ) {
	    jn = j*n;
	    for(i = 0; i < (n/20)*20; i+=20 ) {
		p = C+i+jn;
		c1 = _mm_loadu_ps(p);
		c2 = _mm_loadu_ps(p+4);
		c3 = _mm_loadu_ps(p+8);
		c4 = _mm_loadu_ps(p+12);
		c5 = _mm_loadu_ps(p+16);

		for(k = 0; k < upb2; k+=4) {
		    kn=k*n;
		    t = A+(i+kn);
		    r = A+(jn+j+kn);
		    //C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
		    //a11 = _mm_loadu_ps(t);
		    //a12 = _mm_loadu_ps(t+4);
		    //a13 = _mm_loadu_ps(t+8);
		    //a14 = _mm_loadu_ps(t+12);
		    //a15 = _mm_loadu_ps(t+16);

		    //a2 = _mm_load1_ps(r);

		    /*temp1 = _mm_mul_ps(a11,a2);
		      temp2 = _mm_mul_ps(a12,a2);
		      temp3 = _mm_mul_ps(a13,a2);
		      temp4 = _mm_mul_ps(a14,a2);
		      temp5 = _mm_mul_ps(a15,a2);*/
                    a21 = _mm_load1_ps(r);
		    a22 = _mm_load1_ps(r+n);
		    a23 = _mm_load1_ps(r+(2*n));
		    a24 =  _mm_load1_ps(r+(3*n));

		    //c1 = _mm_add_ps(c1, _mm_add_ps(_mm_add_ps(_mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t)), _mm_mul_ps(a22, _mm_loadu_ps(t+n))), _mm_mul_ps(a23, _mm_loadu_ps(t+(2*n)))),
		    //_mm_mul_ps(a24, _mm_loadu_ps(t+(3*n)))));
		    c1 = _mm_add_ps(c1, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+(3*n))),
						   _mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+(2*n))),
							      _mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t)), _mm_mul_ps(a22, _mm_loadu_ps(t+n))))));
		    c2 = _mm_add_ps(c2, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+4+(3*n))),
						   _mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+4+(2*n))),
							      _mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t+4)), _mm_mul_ps(a22, _mm_loadu_ps(t+4+n))))));
		    c3 = _mm_add_ps(c3, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+8+(3*n))),
						   _mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+8+(2*n))),
							      _mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t+8)), _mm_mul_ps(a22, _mm_loadu_ps(t+8+n))))));
		    c4 = _mm_add_ps(c4, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+12+(3*n))),
						   _mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+12+(2*n))),
							      _mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t+12)), _mm_mul_ps(a22, _mm_loadu_ps(t+12+n))))));
		    c5 = _mm_add_ps(c5, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+16+(3*n))),
						   _mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+16+(2*n))),
							      _mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t+16)), _mm_mul_ps(a22, _mm_loadu_ps(t+16+n))))));
		    //c2 = _mm_add_ps(_mm_mul_ps(a12,a2),c2);
		    //c3 = _mm_add_ps(_mm_mul_ps(a13,a2),c3);
		    //c4 = _mm_add_ps(_mm_mul_ps(a14,a2),c4);
		    //c5 = _mm_add_ps(_mm_mul_ps(a15,a2),c5);

		}
		for(;k < m; k++) {
		    kn=k*n;
		    t = A+(i+kn);
		    r = A+(jn+j+kn);
		    a21 = _mm_load1_ps(r);
		    c1 = _mm_add_ps(c1, _mm_mul_ps(_mm_loadu_ps(t), a21));
		    c2 = _mm_add_ps(c2, _mm_mul_ps(_mm_loadu_ps(t+4), a21));
		    c3 = _mm_add_ps(c3, _mm_mul_ps(_mm_loadu_ps(t+8), a21));
		    c4 = _mm_add_ps(c4, _mm_mul_ps(_mm_loadu_ps(t+12), a21));
		    c5 = _mm_add_ps(c5, _mm_mul_ps(_mm_loadu_ps(t+16), a21));

		}
		_mm_storeu_ps(p, c1);
		_mm_storeu_ps(p+4, c2);
		_mm_storeu_ps(p+8, c3);
		_mm_storeu_ps(p+12, c4);
		_mm_storeu_ps(p+16, c5);

	    }
	}
	} else {
	for(j = 0; j < n; j++ ) {
	    jn = j*n;
	    for(i = 0; i < upb; i+=8 ) {
		p = C+i+jn;
		c1 = _mm_loadu_ps(p);
		c2 = _mm_loadu_ps(p+4);
		//c3 = _mm_loadu_ps(p+8);
		//c4 = _mm_loadu_ps(p+12);
		//c5 = _mm_loadu_ps(p+16);

		for(k = 0; k < upb2; k+=4) {
		    kn=k*n;
		    t = A+(i+kn);
		    r = A+(jn+j+kn);
		    //C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
		    //a11 = _mm_loadu_ps(t);
		    //a12 = _mm_loadu_ps(t+4);
		    //a13 = _mm_loadu_ps(t+8);
		    //a14 = _mm_loadu_ps(t+12);
		    //a15 = _mm_loadu_ps(t+16);

		    //a2 = _mm_load1_ps(r);

		    /*temp1 = _mm_mul_ps(a11,a2);
		      temp2 = _mm_mul_ps(a12,a2);
		      temp3 = _mm_mul_ps(a13,a2);
		      temp4 = _mm_mul_ps(a14,a2);
		      temp5 = _mm_mul_ps(a15,a2);*/
                    a21 = _mm_load1_ps(r);
		    a22 = _mm_load1_ps(r+n);
		    a23 = _mm_load1_ps(r+(2*n));
		    a24 =  _mm_load1_ps(r+(3*n));

		    //c1 = _mm_add_ps(c1, _mm_add_ps(_mm_add_ps(_mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t)), _mm_mul_ps(a22, _mm_loadu_ps(t+n))), _mm_mul_ps(a23, _mm_loadu_ps(t+(2*n)))),
		    //_mm_mul_ps(a24, _mm_loadu_ps(t+(3*n)))));
		    c1 = _mm_add_ps(c1, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+(3*n))),
						   _mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+(2*n))),
							      _mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t)), _mm_mul_ps(a22, _mm_loadu_ps(t+n))))));
		    c2 = _mm_add_ps(c2, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+4+(3*n))),
						   _mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+4+(2*n))),
							      _mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t+4)), _mm_mul_ps(a22, _mm_loadu_ps(t+4+n))))));
		    //c3 = _mm_add_ps(c3, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+8+(3*n))),
		    //_mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+8+(2*n))),
		    //_mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t+8)), _mm_mul_ps(a22, _mm_loadu_ps(t+8+n))))));
	    //c4 = _mm_add_ps(c4, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+12+(3*n))),
		    //_mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+12+(2*n))),
		    //_mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t+12)), _mm_mul_ps(a22, _mm_loadu_ps(t+12+n))))));
//c5 = _mm_add_ps(c5, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+16+(3*n))),
		    //_mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+16+(2*n))),
		    //_mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t+16)), _mm_mul_ps(a22, _mm_loadu_ps(t+16+n))))));
		    //c2 = _mm_add_ps(_mm_mul_ps(a12,a2),c2);
		    //c3 = _mm_add_ps(_mm_mul_ps(a13,a2),c3);
		    //c4 = _mm_add_ps(_mm_mul_ps(a14,a2),c4);
		    //c5 = _mm_add_ps(_mm_mul_ps(a15,a2),c5);

		}
		for(;k < m; k++) {
		    kn=k*n;
		    t = A+(i+kn);
		    r = A+(jn+j+kn);
		    a21 = _mm_load1_ps(r);
		    c1 = _mm_add_ps(c1, _mm_mul_ps(_mm_loadu_ps(t), a21));
		    c2 = _mm_add_ps(c2, _mm_mul_ps(_mm_loadu_ps(t+4), a21));
		    //c3 = _mm_add_ps(c3, _mm_mul_ps(_mm_loadu_ps(t+8), a21));
		    //c4 = _mm_add_ps(c4, _mm_mul_ps(_mm_loadu_ps(t+12), a21));
		    //c5 = _mm_add_ps(c5, _mm_mul_ps(_mm_loadu_ps(t+16), a21));

		}
		_mm_storeu_ps(p, c1);
		_mm_storeu_ps(p+4, c2);
		//_mm_storeu_ps(p+8, c3);
		//_mm_storeu_ps(p+12, c4);
		//_mm_storeu_ps(p+16, c5);

	    }
	    for(; i < (n/4)*4; i+= 4) {
		p = C+i+jn;
		c1 = _mm_loadu_ps(p);
		for (k =0; k < (m/4)*4; k +=4) {
		    kn=k*n;
		    t = A+(i+kn);
		    r = A+(jn+j+kn);
		    a21 = _mm_load1_ps(r);
		    a22 = _mm_load1_ps(r+n);
		    a23 = _mm_load1_ps(r+(2*n));
		    a24 =  _mm_load1_ps(r+(3*n));
		    c1 = _mm_add_ps(c1, _mm_add_ps(_mm_mul_ps(a24, _mm_loadu_ps(t+(3*n))),
						   _mm_add_ps(_mm_mul_ps(a23, _mm_loadu_ps(t+(2*n))),
							      _mm_add_ps(_mm_mul_ps(a21, _mm_loadu_ps(t)), _mm_mul_ps(a22, _mm_loadu_ps(t+n))))));
		}
		for(;k < m; k++) {
		    kn=k*n;
		    t = A+(i+kn);
		    r = A+(jn+j+kn);
		    a21 = _mm_load1_ps(r);
		    c1 = _mm_add_ps(c1, _mm_mul_ps(_mm_loadu_ps(t), a21));
		}
		_mm_storeu_ps(p, c1);
	    }

	    for (; i < n; i ++) {
		for (k = 0; k < m; k++) {
		    C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
		}
	    }
	}
	//}
	}
}

#include <nmmintrin.h>
void sgemm( int m, int n, int d, float *A, float *C )
{

    /*for( int i = 0; i < n; i++ )
    for( int k = 0; k < m; k++ )
      for( int j = 0; j < n; j++ )
      C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];*/
    if (n%20 == 0) {
        int jn, kn, i, j, k, upb;
        upb = (n/20)*20;
        __m128 c1,c2,c3,c4,c5,temp1,temp2,temp3,temp4,temp5,a11,a12,a13,a14,a15,a2;
        float *t;
        float *r;
        float *p;
        for(j = 0; j < n; j++ ) {
            jn = j*n;
            for(i = 0; i < upb; i+=20 ) {
            p = C+i+jn;
            c1 = _mm_loadu_ps(p);
            c2 = _mm_loadu_ps(p+4);
            c3 = _mm_loadu_ps(p+8);
            c4 = _mm_loadu_ps(p+12);
            c5 = _mm_loadu_ps(p+16);

            for(k = 0; k < m; k++ ) {
                kn=k*n;
                t = A+(i+kn);
                r = A+(jn+j+kn);
                //C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
                a11 = _mm_loadu_ps(t);
                a12 = _mm_loadu_ps(t+4);
                a13 = _mm_loadu_ps(t+8);
                a14 = _mm_loadu_ps(t+12);
                a15 = _mm_loadu_ps(t+16);

                a2 = _mm_load1_ps(r);

                /*temp1 = _mm_mul_ps(a11,a2);
                  temp2 = _mm_mul_ps(a12,a2);
                  temp3 = _mm_mul_ps(a13,a2);
                  temp4 = _mm_mul_ps(a14,a2);
                  temp5 = _mm_mul_ps(a15,a2);*/


                c1 = _mm_add_ps(_mm_mul_ps(a11,a2),c1);
                c2 = _mm_add_ps(_mm_mul_ps(a12,a2),c2);
                c3 = _mm_add_ps(_mm_mul_ps(a13,a2),c3);
                c4 = _mm_add_ps(_mm_mul_ps(a14,a2),c4);
                c5 = _mm_add_ps(_mm_mul_ps(a15,a2),c5);

            }
            _mm_storeu_ps(p, c1);
            _mm_storeu_ps(p+4, c2);
            _mm_storeu_ps(p+8, c3);
            _mm_storeu_ps(p+12, c4);
            _mm_storeu_ps(p+16, c5);

            }
        }
    } else if(n%8==0) {
    int jn, kn, i, j, k, upb;
    //upb = (n/20)*20;
    __m128 c1,c2,c3,c4,c5,temp1,temp2,temp3,temp4,temp5,a11,a12,a13,a14,a15,a2;
    float *t;
    float *r;
    float *p;
    for(j = 0; j < n; j++ ) {
        jn = j*n;
        for(i = 0; i < n; i+=8 ) {
        p = C+i+jn;
        c1 = _mm_loadu_ps(p);
        c2 = _mm_loadu_ps(p+4);

        for(k = 0; k < m; k++ ) {
            kn=k*n;
            t = A+(i+kn);
            r = A+(jn+j+kn);
            //C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
            a11 = _mm_loadu_ps(t);
            a12 = _mm_loadu_ps(t+4);

            a2 = _mm_load1_ps(r);

            /*temp1 = _mm_mul_ps(a11,a2);
              temp2 = _mm_mul_ps(a12,a2);
              temp3 = _mm_mul_ps(a13,a2);
              temp4 = _mm_mul_ps(a14,a2);
              temp5 = _mm_mul_ps(a15,a2);*/


            c1 = _mm_add_ps(_mm_mul_ps(a11,a2),c1);
            c2 = _mm_add_ps(_mm_mul_ps(a12,a2),c2);

        }
        _mm_storeu_ps(p, c1);
        _mm_storeu_ps(p+4, c2);
        }
    }
    } else if(n%8 == 4) {
    int jn, kn, i, j, k, upb;
    //upb = (n/20)*20;
    __m128 c1,c2,c3,c4,c5,temp1,temp2,temp3,temp4,temp5,a11,a12,a13,a14,a15,a2;
    float *t;
    float *r;
    float *p;
    upb = (n/8)*8;
    for(j = 0; j < n; j++ ) {
        jn = j*n;
        for(i = 0; i < upb; i+=8 ) {
        p = C+i+jn;
        c1 = _mm_loadu_ps(p);
        c2 = _mm_loadu_ps(p+4);

        for(k = 0; k < m; k++ ) {
            kn=k*n;
            t = A+(i+kn);
            r = A+(jn+j+kn);
            //C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
            a11 = _mm_loadu_ps(t);
            a12 = _mm_loadu_ps(t+4);

            a2 = _mm_load1_ps(r);

            /*temp1 = _mm_mul_ps(a11,a2);
              temp2 = _mm_mul_ps(a12,a2);
              temp3 = _mm_mul_ps(a13,a2);
              temp4 = _mm_mul_ps(a14,a2);
              temp5 = _mm_mul_ps(a15,a2);*/


            c1 = _mm_add_ps(_mm_mul_ps(a11,a2),c1);
            c2 = _mm_add_ps(_mm_mul_ps(a12,a2),c2);

        }
        _mm_storeu_ps(p, c1);
        _mm_storeu_ps(p+4,c2);
        }
        p = C+i+jn;
        c1 = _mm_loadu_ps(p);
        for (k =0; k < m; k ++) {
        kn=k*n;
        t = A+(i+kn);
        r = A+(jn+j+kn);
        //C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
        a11 = _mm_loadu_ps(t);

        a2 = _mm_load1_ps(r);
        c1 = _mm_add_ps(_mm_mul_ps(a11,a2),c1);

        }
        _mm_storeu_ps(p, c1);
    }
    } else if (n%8 < 4) {
    int jn, kn, i, j, k, upb;
    upb = (n/8)*8;
    __m128 c1,c2,c3,c4,c5,temp1,temp2,temp3,temp4,temp5,a11,a12,a13,a14,a15,a2;
    float *t;
    float *r;
    float *p;
    for(j = 0; j < n; j++ ) {
        jn = j*n;
        for(i = 0; i < upb; i+=8 ) {
        p = C+i+jn;
        c1 = _mm_loadu_ps(p);
        c2 = _mm_loadu_ps(p+4);

        for(k = 0; k < m; k++ ) {
            kn=k*n;
            t = A+(i+kn);
            r = A+(jn+j+kn);
            //C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
            a11 = _mm_loadu_ps(t);
            a12 = _mm_loadu_ps(t+4);

            a2 = _mm_load1_ps(r);

            /*temp1 = _mm_mul_ps(a11,a2);
              temp2 = _mm_mul_ps(a12,a2);
              temp3 = _mm_mul_ps(a13,a2);
              temp4 = _mm_mul_ps(a14,a2);
              temp5 = _mm_mul_ps(a15,a2);*/


            c1 = _mm_add_ps(_mm_mul_ps(a11,a2),c1);
            c2 = _mm_add_ps(_mm_mul_ps(a12,a2),c2);

        }
        _mm_storeu_ps(p, c1);
        _mm_storeu_ps(p+4,c2);
        }
        for (; i < n; i ++) {
        for (k = 0; k < m; k++) {
            C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
        }
        }
    }
    } else if(n%8 > 4) {
    int jn, kn, i, j, k, upb;
    upb = (n/8)*8;
    __m128 c1,c2,c3,c4,c5,temp1,temp2,temp3,temp4,temp5,a11,a12,a13,a14,a15,a2;
    float *t;
    float *r;
    float *p;
    for(j = 0; j < n; j++ ) {
        jn = j*n;
        for(i = 0; i < upb; i+=8 ) {
        p = C+i+jn;
        c1 = _mm_loadu_ps(p);
        c2 = _mm_loadu_ps(p+4);

        for(k = 0; k < m; k++ ) {
            kn=k*n;
            t = A+(i+kn);
            r = A+(jn+j+kn);
            //C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
            a11 = _mm_loadu_ps(t);
            a12 = _mm_loadu_ps(t+4);

            a2 = _mm_load1_ps(r);

            /*temp1 = _mm_mul_ps(a11,a2);
              temp2 = _mm_mul_ps(a12,a2);
              temp3 = _mm_mul_ps(a13,a2);
              temp4 = _mm_mul_ps(a14,a2);
              temp5 = _mm_mul_ps(a15,a2);*/


            c1 = _mm_add_ps(_mm_mul_ps(a11,a2),c1);
            c2 = _mm_add_ps(_mm_mul_ps(a12,a2),c2);

        }
        _mm_storeu_ps(p, c1);
        _mm_storeu_ps(p+4,c2);
        }
        p = C+i+jn;
        c1 = _mm_loadu_ps(p);
        for (k =0; k < m; k ++) {
        kn=k*n;
        t = A+(i+kn);
        r = A+(jn+j+kn);
        //C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
        a11 = _mm_loadu_ps(t);

        a2 = _mm_load1_ps(r);
        c1 = _mm_add_ps(_mm_mul_ps(a11,a2),c1);

        }
        _mm_storeu_ps(p, c1);
        i += 4;
        for (; i < n; i ++) {
        for (k = 0; k < m; k++) {
            C[i+j*n] += A[i+k*(n)] * A[j*(n+1)+k*(n)];
        }
        }
    }
    }

}

#include "mex.h"

void allComb(int n, int m, int p, double* C, int *s, int* col, int m0);
/*
 * function G = comb(n, m)
 * 
 * Generate all combinations in \choose(n, m).
 *
 * Input
 *   n       -  parameter
 *   m       -  parameter
 *
 * Output
 *   C       -  all combinations, m x \choose(n, m)
 *
 * History
 *   create  -  Feng Zhou, 02-28-2010
 *   modify  -  Feng Zhou, 02-28-2010
 */
void mexFunction(int nlhs, mxArray *plhs[ ], int nrhs, const mxArray *prhs[ ]) {

    // n
    int n = int(*mxGetPr(prhs[0]));
    
    // m
    int m = int(*mxGetPr(prhs[1]));
    
    // k = \choose(n, m)
    int k = 1;
    for (int i = m + 1; i <= n; ++i) {
        k *= i;
    }
    for (int i = 2; i <= n - m; ++i) {
        k /= i;
    }
    
    // C
    plhs[0] = mxCreateDoubleMatrix(m, k, mxREAL);
    double *C = mxGetPr(plhs[0]);

    int s[100] = {0};
    int col[1];
    *col = 0;
    // recursively generate
    allComb(n, m, m, C, s, col, m);
}

/*
 * Recursively generate all combinations in \choose(n, m).
 */
void allComb(int n, int m, int p, double* C, int* s, int* col, int m0) {

    // touch the end
    if (m <= 0) {
        for (int i = 0; i < m0; ++i) {
            C[*col + i] = s[i];
        }
        *col += m0;
        return;
    }

    s[--p] = n;
    allComb(n - 1, m - 1, p, C, s, col, m0);
    ++p;
    
    if (n > m) {
        allComb(n - 1, m, p, C, s, col, m0);
    }     
}

#include "mex.h"
#include "matrix.h"
#include <stack>
#include <algorithm>

/*
 * function L = relabel_L_fast(L0, labels)
 *
 * Input
 *   L0      -  label matrix, h x w
 *   labels  -  label, mSeg0 x 1
 *
 * Output
 *   L       -  label matrix, h x w
 *
 * History
 *   create  -  Feng Zhou, 03-20-2009
 *   modify  -  Feng Zhou, 12-21-2009
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // L0
    double *L0 = mxGetPr(prhs[0]);
    int h = mxGetM(prhs[0]);
    int w = mxGetN(prhs[0]);

    // labels
    double *labels = mxGetPr(prhs[1]);

    // L
    plhs[0] = mxCreateDoubleMatrix(h, w, mxREAL);
    double *L = mxGetPr(plhs[0]);

    // visit each region
    for (int i = 0; i < h * w; ++i) {
        double cSeg0 = L0[i];
        int j = int(cSeg0 - 1);
        // printf("j %d\n", j);
        double cSeg = labels[j];
        L[i] = cSeg;
    }
}

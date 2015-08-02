#include "mex.h"
#include "matrix.h"
#include <stack>
#include <algorithm>

/*
 * function Hst = computeRegionHist_fast(Q, L, k, mSeg)
 *
 * Compute the histogram of each region.
 *
 * Input
 *   Q       -  quantized image, h x w
 *   L       -  label, h x w
 *   k       -  #quantity
 *   mSeg    -  #segments in the video
 *
 * Output
 *   Hst     -  histogram, mSeg x k
 *
 * History
 *   create  -  Feng Zhou, 03-20-2009
 *   modify  -  Feng Zhou, 12-21-2009
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Q
    double *Q = mxGetPr(prhs[0]);
    int h = mxGetM(prhs[0]);
    int w = mxGetN(prhs[0]);

    // L
    double *L = mxGetPr(prhs[1]);

    // k
    int k = int(*mxGetPr(prhs[2]));

    // mSeg
    int mSeg = int(*mxGetPr(prhs[3]));

    // Hst
    plhs[0] = mxCreateDoubleMatrix(mSeg, k, mxREAL);
    double *Hst = mxGetPr(plhs[0]);

    // init
    for (int i = 0; i < mSeg * k; ++i) {
        Hst[i] = 0;
    }

    // visit each region
    for (int i = 0; i < h * w; ++i) {
        double v = Q[i];
        double cSeg = L[i];

        int j = int((v - 1) * mSeg + cSeg - 1);
        Hst[j] = Hst[j] + 1;
    }
}

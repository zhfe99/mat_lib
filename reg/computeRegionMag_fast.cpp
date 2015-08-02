#include "mex.h"
#include "matrix.h"
#include <stack>
#include <algorithm>

/*
 * function mags = computeRegionMag_fast(L, M, mSeg)
 *
 * Input
 *   L       -  label, h x w
 *   M       -  magnitude, h x w
 *   mSeg    -  #segments in the video
 *
 * Output
 *   mags    -  cumulative magnitude, mSeg x 1
 *
 * History
 *   create  -  Feng Zhou, 03-20-2009
 *   modify  -  Feng Zhou, 12-21-2009
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // L
    double *L = mxGetPr(prhs[0]);
    int h = mxGetM(prhs[0]);
    int w = mxGetN(prhs[0]);

    // M
    double *M = mxGetPr(prhs[1]);

    // mSeg
    int mSeg = int(*mxGetPr(prhs[2]));

    // mags
    plhs[0] = mxCreateDoubleMatrix(mSeg, 1, mxREAL);
    double *mags = mxGetPr(plhs[0]);

    // init
    for (int i = 0; i < mSeg; ++i) {
        mags[i] = 0;
    }

    // visit each region
    for (int i = 0; i < h * w; ++i) {
        double cSeg = L[i];

        int j = int(cSeg - 1);
        mags[j] = mags[j] + M[i];
    }
}

#include "mex.h"
#include "matrix.h"
#include <stack>
#include <algorithm>

/*
 * function Hst = computeRegionHof_fast(L, Bin0, Bin1, Mag0, Mag1, nBin, mSeg)
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
    // L
    double *L = mxGetPr(prhs[0]);
    int h = mxGetM(prhs[0]);
    int w = mxGetN(prhs[0]);

    // Bin0
    double *Bin0 = mxGetPr(prhs[1]);

    // Bin1
    double *Bin1 = mxGetPr(prhs[2]);

    // Mag0
    double *Mag0 = mxGetPr(prhs[3]);

    // Mag1
    double *Mag1 = mxGetPr(prhs[4]);

    // nBin
    int nBin = int(*mxGetPr(prhs[5]));

    // mSeg
    int mSeg = int(*mxGetPr(prhs[6]));

    // Hst
    plhs[0] = mxCreateDoubleMatrix(mSeg, nBin, mxREAL);
    double *Hst = mxGetPr(plhs[0]);

    // init
    for (int i = 0; i < mSeg * nBin; ++i) {
        Hst[i] = 0;
    }

    // visit each region
    int c, bin0, bin1, j;
    double mag0, mag1;
    for (int i = 0; i < h * w; ++i) {
        c = int(L[i]);
        bin0 = int(Bin0[i]);
        bin1 = int(Bin1[i]);
        mag0 = Mag0[i];
        mag1 = Mag1[i];

        j = (bin0 - 1) * mSeg + c - 1;
        Hst[j] += mag0;
        j = (bin1 - 1) * mSeg + c - 1;
        Hst[j] += mag1;
    }
}

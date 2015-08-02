#include "mex.h"
#include "matrix.h"
#include <stack>
#include <algorithm>

/*
 * function [areas, xDs, yDs] = computeRegionSpa_fast(L, XD, YD, mSeg)
 *
 * Input
 *   L       -  label, h x w
 *   XD      -  x difference, h x w
 *   YD      -  y difference, h x w
 *   mSeg    -  #segments in the video
 *
 * Output
 *   areas   -  area size, mSeg x 1
 *   xDs     -  differency sum in X position, mSeg x 1
 *   yDs     -  differency sum in Y position, mSeg x 1
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

    // XD
    double *XD = mxGetPr(prhs[1]);

    // YD
    double *YD = mxGetPr(prhs[2]);

    // mSeg
    int mSeg = int(*mxGetPr(prhs[3]));

    // areas
    plhs[0] = mxCreateDoubleMatrix(mSeg, 1, mxREAL);
    double *areas = mxGetPr(plhs[0]);

    // xDs
    plhs[1] = mxCreateDoubleMatrix(mSeg, 1, mxREAL);
    double *xDs = mxGetPr(plhs[1]);

    // yDs
    plhs[2] = mxCreateDoubleMatrix(mSeg, 1, mxREAL);
    double *yDs = mxGetPr(plhs[2]);

    // init
    for (int i = 0; i < mSeg; ++i) {
        areas[i] = 0;
        xDs[i] = 0;
        yDs[i] = 0;
    }

    // visit each region
    for (int i = 0; i < h * w; ++i) {
        double cSeg = L[i];

        int j = int(cSeg - 1);
        areas[j] = areas[j] + 1;
        xDs[j] = xDs[j] + XD[i];
        yDs[j] = yDs[j] + YD[i];
    }
}

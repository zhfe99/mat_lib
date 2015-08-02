#include "mex.h"
#include <deque>
using namespace std;

/*
 * function [sizs, xCens, yCens] = maskRegStat(L, mL)
 *
 * Check the region's properties.
 *
 * Input
 *   L       -  label matrix, h x w (uint16)
 *   mL      -  #label
 *
 * Output
 *   sizs    -  region size, 1 x mL
 *   xCens   -  x center of each region, 1 x mL
 *   yCens   -  y center of each region, 1 x mL
 *
 * History
 *   create  -  Feng Zhou, 03-20-2009
 *   modify  -  Feng Zhou, 12-21-2009
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // L
    unsigned short *L = (unsigned short*) mxGetData(prhs[0]);
    int h = mxGetM(prhs[0]);
    int w = mxGetN(prhs[0]);
    int n = h * w;

    // mL
    int mL = int(*mxGetPr(prhs[1]));

    // printf("mL %d mR %d mRMa %d\n", mL, mR, mRMa);

    // sizs
    plhs[0] = mxCreateDoubleMatrix(1, mL, mxREAL);
    double *sizs = mxGetPr(plhs[0]);

    // xCens
    plhs[1] = mxCreateDoubleMatrix(1, mL, mxREAL);
    double *xCens = mxGetPr(plhs[1]);

    // yCens
    plhs[2] = mxCreateDoubleMatrix(1, mL, mxREAL);
    double *yCens = mxGetPr(plhs[2]);

    // init
    for (int i = 0; i < mL; ++i) {
        sizs[i] = 0;
        xCens[i] = 0;
        yCens[i] = 0;
    }

    // loop over each pixel
    int k = 0, l, i, j;
    for (j = 0; j < w; ++j) {
        for (i = 0; i < h; ++i) {
            l = L[k] - 1;
            sizs[l] += 1;
            xCens[l] += j + 1;
            yCens[l] += i + 1;
            k++;
        }
    }

    // loop over each region
    for (l = 0; l < mL; ++l) {
        if (sizs[l] > 0) {
            xCens[l] /= sizs[l];
            yCens[l] /= sizs[l];
        }
    }
}

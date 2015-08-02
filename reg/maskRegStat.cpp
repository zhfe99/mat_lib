#include "mex.h"
#include <deque>
using namespace std;

/*
 * function [idxR2L, IdxL2R, idxR2T, sizs, xCens, yCens] = maskRegStat(L, R, mL, mR, mRMa)
 *
 * Check the region's properties.
 *
 * Input
 *   L       -  label matrix, h x w (uint16)
 *   R       -  region matrix, h x w (uint16)
 *   mL      -  #label
 *   mR      -  #region
 *   mRMa    -  maximum #region
 *
 * Output
 *   idxR2L  -  region id -> label id, 1 x mR
 *   IdxL2R  -  label id -> region id, mL x mRMa
 *   idxR2T  -  region id -> label count, 1 x mR
 *   sizs    -  region size, 1 x mR
 *   xCens   -  x center of each region, 1 x mR
 *   yCens   -  y center of each region, 1 x mR
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

    // R
    unsigned short *R = (unsigned short*) mxGetData(prhs[1]);

    // mL
    int mL = int(*mxGetPr(prhs[2]));

    // mR
    int mR = int(*mxGetPr(prhs[3]));

    // mRMa
    int mRMa = int(*mxGetPr(prhs[4]));

    // printf("mL %d mR %d mRMa %d\n", mL, mR, mRMa);

    // idxR2L
    plhs[0] = mxCreateDoubleMatrix(1, mR, mxREAL);
    double *idxR2L = mxGetPr(plhs[0]);

    // IdxL2R
    plhs[1] = mxCreateDoubleMatrix(mL, mRMa, mxREAL);
    double *IdxL2R = mxGetPr(plhs[1]);

    // idxR2T
    plhs[2] = mxCreateDoubleMatrix(1, mR, mxREAL);
    double *idxR2O = mxGetPr(plhs[2]);

    // sizs
    plhs[3] = mxCreateDoubleMatrix(1, mR, mxREAL);
    double *sizs = mxGetPr(plhs[3]);

    // xCens
    plhs[4] = mxCreateDoubleMatrix(1, mR, mxREAL);
    double *xCens = mxGetPr(plhs[4]);

    // yCens
    plhs[5] = mxCreateDoubleMatrix(1, mR, mxREAL);
    double *yCens = mxGetPr(plhs[5]);

    // cos
    int* cos = new int[mL];

    // init
    for (int i = 0; i < mR; ++i) {
        idxR2L[i] = 0;
        sizs[i] = 0;
        xCens[i] = 0;
        yCens[i] = 0;
        idxR2O[i] = 0;
    }
    for (int i = 0; i < mL * mRMa; ++i) {
        IdxL2R[i] = 0;
    }
    for (int i = 0; i < mL; ++i) {
        cos[i] = 0;
    }

    // loop over each pixel
    int k = 0, r, l, i, j;
    for (j = 0; j < w; ++j) {
        for (i = 0; i < h; ++i) {
            r = R[k] - 1;
            l = L[k];
            sizs[r] += 1;
            idxR2L[r] = l;
            xCens[r] += j + 1;
            yCens[r] += i + 1;
            k++;
        }
    }

    // loop over each region
    for (r = 0; r < mR; ++r) {
        l = int(idxR2L[r] - 1);
        j = cos[l] * mL + l;
        IdxL2R[j] = r + 1;
        idxR2O[r] = ++cos[l];
        xCens[r] /= sizs[r];
        yCens[r] /= sizs[r];
    }

    delete[] cos;
}

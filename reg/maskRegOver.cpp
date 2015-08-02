#include "mex.h"
#include <deque>
using namespace std;

/*
 * function Ov = maskRegOver(T, L, L0, R0, mR0, mRMa0, rad)
 *
 * Split the region's properties.
 *
 * Input
 *   T       -  count matrix in current frame, h x w (uint16)
 *   L       -  label matrix in current frame, h x w (uint16)
 *   L0      -  label matrix in last frame, h x w (uint16)
 *   R0      -  region matrix in last frame, h x w (uint16)
 *   mR0     -  #region in last frame
 *   coRMa   -  maximum #region
 *   rad     -  radius
 *
 * Output
 *   Ov      -  overlap matrix, mR0 x coRMa
 *
 * History
 *   create  -  Feng Zhou, 03-20-2009
 *   modify  -  Feng Zhou, 12-21-2009
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // T
    unsigned short *T = (unsigned short*) mxGetData(prhs[0]);
    int h = mxGetM(prhs[0]);
    int w = mxGetN(prhs[0]);
    int n = h * w;

    // L
    unsigned short *L = (unsigned short*) mxGetData(prhs[1]);

    // L0
    unsigned short *L0 = (unsigned short*) mxGetData(prhs[2]);

    // R0
    unsigned short *R0 = (unsigned short*) mxGetData(prhs[3]);

    // mR0
    int mR0 = int(*mxGetPr(prhs[4]));

    // coRMa
    int coRMa = int(*mxGetPr(prhs[5]));

    // rad
    int rad = int(*mxGetPr(prhs[6]));

    // Ov
    plhs[0] = mxCreateDoubleMatrix(mR0, coRMa, mxREAL);
    double *Ov = mxGetPr(plhs[0]);

    // init
    for (int i = 0; i < mR0 * coRMa; ++i) {
        Ov[i] = 0;
    }

    // loop over each pixel
    int i, j, k, r, l, l0, t, di, dj, i2, j2, k2;
    for (j = 0; j < w; ++j) {
        for (i = 0; i < h; ++i) {
            k = j * h + i;

            r0 = R0[k] - 1;
            l0 = L0[k];

            // if (r == 1) {
            //     printf("here r %d l %d l0 %d\n", r, l, l0);
            // }

            // loop in a region
            for (int di = -rad; di <= rad; ++di) {
                for (int dj = -rad; dj <= rad; ++dj) {
                    i2 = i + di;
                    j2 = j + dj;
                    // out of boundary
                    if (i2 < 0 || i2 >= h || j2 < 0 || j2 >= w) {
                        continue;
                    }
                    k2 = j2 * h + i2;

                    // check matched
                    l = L[k2];
                    t = T[k2] - 1;

                    // if (r == 1) {
                    //     printf("here r %d l0 %d l %d k %d k2 %d i %d j %d i2 %d j2 %d\n", r, l0, l, k, k2, i, j, i2, j2);
                    // }

                    if (l == l0) {
                        Ov[t0 * mR + r] += 1;
                    }
                }
            }
        }
    }
}

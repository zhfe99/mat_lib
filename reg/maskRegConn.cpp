#include "mex.h"
#include <deque>
using namespace std;

/*
 * function [R, mR, mRs] = maskRegConn(L, mL)
 *
 * Find the connected regions.
 *
 * Remark
 *   mR == sum(mRs)
 *
 * Input
 *   L       -  label matrix, h x w (uint16)
 *   mL      -  #label
 *
 * Output
 *   R       -  region matrix, h x w (uint16)
 *   mR      -  #connected regions in total
 *   mRs     -  #regions for each label, 1 x mL
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

    // R
    plhs[0] = mxCreateNumericMatrix(h, w, mxUINT16_CLASS, mxREAL);
    unsigned short *R = (unsigned short*) mxGetData(plhs[0]);

    // mR
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    double *mR = mxGetPr(plhs[1]);

    // mRs
    plhs[2] = mxCreateDoubleMatrix(1, mL, mxREAL);
    double *mRs = mxGetPr(plhs[2]);

    // init
    *mR = 0;
    int* Vis = new int[n];
    for (int i = 0; i < n; ++i) {
        Vis[i] = 0;
        R[i] = 0;
    }
    for (int i = 0; i < mL; ++i) {
        mRs[i] = 0;
    }

    // neighbor
    int dx[8];
    dx[0] = -1;
    dx[1] = 1;
    dx[2] = -h;
    dx[3] = h;
    dx[4] = -h - 1;
    dx[5] = -h + 1;
    dx[6] = h - 1;
    dx[7] = h + 1;

    int p, q, r, l, lr;
    deque<int> que;

    // loop each pixel
    for (p = 0; p < n; ++p) {
        if (Vis[p] == 1) {
            continue;
        }

        // starting from p with label l
        (*mR) += 1;
        l = L[p] - 1;
        mRs[l] += 1;
        Vis[p] = 1;
        R[p] = int(*mR);
        que.push_back(p);

        // check the connected region
        while (!que.empty()) {
            q = que.front();
            que.pop_front();

            // check its 8 neighbor
            for (int i = 0; i < 8; ++i) {
                int r = q + dx[i];

                // out-of-boundary
                if (r < 0 || r >= n) {
                    continue;
                }

                // already visited
                if (Vis[r] == 1) {
                    continue;
                }

                // not interested label
                lr = L[r] - 1;
                if (lr != l) {
                    continue;
                }

                Vis[r] = 1;
                R[r] = int(*mR);
                que.push_back(r);
            }
        }
    }

    delete[] Vis;
}

#include "mex.h"
#include "matrix.h"
#include <stack>
#include <algorithm>

/*
 * function labels = mexMergeAdjacentRegions(A, ind)
 *
 * Input
 *   A       -  connected adjacency matrix, mSeg0 x mSeg0
 *   ind     -  index of connected pairs
 *
 * Output
 *   labels  -  new labels
 *
 * History
 *   create  -  Feng Zhou, 03-20-2009
 *   modify  -  Feng Zhou, 12-21-2009
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // A
    double *adjmat = mxGetPr(prhs[0]);

    // dimension
    const mwSize *dims = mxGetDimensions(prhs[0]);
    int numRegion = dims[0];

    // labels
    plhs[0] = mxCreateDoubleMatrix(numRegion, 1, mxREAL);

    // init
    double *labels = mxGetPr( plhs[0] );
    for( int ix = 0; ix < numRegion; ++ix )
        labels[ix] = 0;

    // ind
    double *ind = mxGetPr( prhs[1] );
    const mwSize *dm = mxGetDimensions( prhs[1] );

    // adjust
    int curLabel = 1;
    for( int ix = 0; ix < dm[0]; ++ix ) {
        int index = ind[ix];
        int x = static_cast<int>(index / numRegion);
        int y = index % numRegion;
        // mexPrintf( "index: %d, x: %d, y: %d, adjmat[%d]: %.1f\n", index, x, y, index, adjmat[index] );
        if (labels[x] != 0 && labels[y] != 0) {
            if( labels[x] != labels[y] ) {
                mexPrintf( "x: %d, y: %d, labels[x]: %.1f, labels[y]: %.1f\n", x, y, labels[x], labels[y] );
                mexPrintf( "curLabel: %d\n", curLabel );
                mexErrMsgTxt( "Error in merging." );
            }
            else
                continue;
        }

        std::stack<int> toCheck;
        toCheck.push( y );
        while( !toCheck.empty() ) {
            int tempY = toCheck.top();
            toCheck.pop();
            if( labels[tempY] != 0 )
                continue;
            labels[tempY] = curLabel;
            for( int jx = 0; jx < numRegion; ++jx ) {
                if(adjmat[jx * numRegion+tempY] != 0)
                    toCheck.push( jx );
            }
            // mexPrintf( "\t\\\\\\\\\\ size of toCheck: %d\n", toCheck.size() );
            //std::stack<int>::iterator it = toCheck.begin
        }
        curLabel++;
    }
}

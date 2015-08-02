#include "mex.h"
#include "mcv.h"

/*
 * function [hr, nF, width, height, fps] = mcvVReader(fname)
 * 
 * Usage:
 *          [hr, nF, width, height, fps] = mcvVReader(fname)
 *          F = mcvVReader(hr)
 *          mcvVReader(hr)
 *
 * History
 *   create  -  Feng Zhou, 04-15-2011
 *   modify  -  Feng Zhou, 04-15-2011
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    // open
    if (nlhs == 5 && nrhs == 1) {
	// fname
        char* fname = mxArrayToString(prhs[0]);

        // open file
        McvCapture* capture = new McvCapture(fname);

        // nF
        plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
        double *nF = mxGetPr(plhs[1]);
        *nF = capture->nF;

        // width
	plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
        double *width = mxGetPr(plhs[2]);
        *width = capture->width;

        // height
        plhs[3] = mxCreateDoubleMatrix(1, 1, mxREAL);
        double *height = mxGetPr(plhs[3]);
        *height = capture->height;

        // fps
        plhs[4] = mxCreateDoubleMatrix(1, 1, mxREAL);
        double *fps = mxGetPr(plhs[4]);
        *fps = capture->fps;

        // store
        ObjectHandle<McvCapture> *handle = new ObjectHandle<McvCapture>(capture);
        plhs[0] = handle->to_mex_handle();

    // read frame
    } else if (nlhs == 1 && nrhs == 1) {
        // hr
        McvCapture& capture = get_object<McvCapture>(prhs[0]);

        // read one frame
        IplImage *ImgCv = cvQueryFrame(capture.p);

        // convert
        plhs[0] = ImgCv2ImgMt(ImgCv);

    // close
    } else if (nlhs == 0 && nrhs == 1) {
        ObjectHandle<McvCapture>* handle = ObjectHandle<McvCapture>::from_mex_handle(prhs[0]);
        delete handle;

    } else {

    }
}

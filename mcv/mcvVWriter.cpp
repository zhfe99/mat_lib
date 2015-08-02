#include "mex.h"
#include "mcv.h"

/*
 * function varargout = mcvVWriter(varargin)
 *
 * Usage:
 *         hw = mcvVWriter(fname, width, height, fps)
 *         mcvVWriter(hw, F)
 *         mcvVWriter(hw)
 *
 * History
 *   create  -  Feng Zhou, 08-26-2011
 *   modify  -  Feng Zhou, 08-26-2011
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    // open
    if (nlhs == 1 && nrhs == 4) {
        // fname
	char* fname = mxArrayToString(prhs[0]);

	// width
	double *width = mxGetPr(prhs[1]);

        // height
        double *height = mxGetPr(prhs[2]);

	// fps
        double *fps = mxGetPr(prhs[3]);

	// create
	McvWriter *writer = new McvWriter(fname, *width, *height, *fps);

        // store
        ObjectHandle<McvWriter> *handle = new ObjectHandle<McvWriter>(writer);
        plhs[0] = handle->to_mex_handle();

    // write frame
    } else if (nlhs == 0 && nrhs == 2) {
        // hr
        McvWriter& writer = get_object<McvWriter>(prhs[0]);

        // read one frame
        IplImage *ImgCv = ImgMt2ImgCv(prhs[1]);

        // write
	cvWriteFrame(writer.p, ImgCv);

	// release
	cvReleaseImage(&ImgCv);

    // close
    } else if (nlhs == 0 && nrhs == 1) {
        ObjectHandle<McvWriter>* handle = ObjectHandle<McvWriter>::from_mex_handle(prhs[0]);
        delete handle;

    } else {
      printf("else nlhs %d nrhs %d\n", nlhs, nrhs);
    }
}

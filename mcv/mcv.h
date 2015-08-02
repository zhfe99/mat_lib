#ifndef MCV_H
#define MCV_H

#include "mex.h"
#include "opencv/cv.h"
#include "opencv/highgui.h"
#include "ObjectHandle.h"

/*
 * Convert from Matlab Image data to OpenCV IplImage data.
 */
IplImage* ImgMt2ImgCv(const mxArray* ImgMt)
{
    if (mxIsDouble(ImgMt)) {
        mexErrMsgTxt("double ImgMat not supported");
        return NULL;
    }

    // dimension
    mwSize ndims = mxGetNumberOfDimensions(ImgMt);
    if (ndims != 3) {
        mexErrMsgTxt("ImgMat must be a three-fold matrix");
        return NULL;
    }
    const mwSize *dims = mxGetDimensions(ImgMt);
    int rows = dims[0];
    int cols = dims[1];
    int chans = dims[2];
    // mexPrintf("height %d width %d dim %d\n", dims[0], dims[1], dims[2]);

    // create ImgCv
    IplImage* ImgCv = cvCreateImage(cvSize(cols, rows), IPL_DEPTH_8U, chans);

    // data
    unsigned char* ImgMtData = (unsigned char*) mxGetData(ImgMt);
    unsigned char* ImgCvData = (unsigned char*) ImgCv->imageData;

    // copy
    int step = ImgCv->widthStep;
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            ImgCvData[chans * j + 2] = ImgMtData[rows * j + i];
            ImgCvData[chans * j + 1] = ImgMtData[rows * j + i + rows * cols];
            ImgCvData[chans * j    ] = ImgMtData[rows * j + i + rows * cols * 2];
        }
        ImgCvData += step;
    }

    return ImgCv;
}

/*
 * Convert from OpenCV IplImage data to Matlab Image data.
 */
mxArray* ImgCv2ImgMt(const IplImage* ImgCv)
{
    // empty image
    if (ImgCv == NULL) {
        return mxCreateDoubleMatrix(0, 0, mxREAL);
    }

    // dimension
    int rows = ImgCv->height;
    int cols = ImgCv->width;
    int chans = ImgCv->nChannels;
    mwSize dims[3] = {rows, cols, chans};
    if (chans != 3) {
        mexErrMsgTxt("ImgMat must be a three-fold matrix");
        return NULL;
    }
    // mexPrintf("height %d width %d dim %d\n", dims[0], dims[1], dims[2]);

    // create mat
    mxArray* ImgMt = mxCreateNumericArray(3, dims, mxUINT8_CLASS, mxREAL);

    // data
    unsigned char* ImgMtData = (unsigned char*) mxGetData(ImgMt);
    unsigned char* ImgCvData = (unsigned char*) ImgCv->imageData;

    // copy
    int step = ImgCv->widthStep;
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            ImgMtData[rows * j + i] = ImgCvData[chans * j + 2];
            ImgMtData[rows * j + i + rows * cols] = ImgCvData[chans * j + 1];
            ImgMtData[rows * j + i + rows * cols * 2] = ImgCvData[chans * j];
        }
        ImgCvData += step;
    }

    return ImgMt;
}

/*
 * Convert from Matlab Pt data to OpenCV Pt data.
 */
CvPoint2D32f* PtMt2PtCv(const mxArray* PtMt, int nPt)
{
    // PtMt
    double *pPtMt = mxGetPr(PtMt);

    // PtCv
    CvPoint2D32f* PtCv = (CvPoint2D32f*) cvAlloc(nPt * sizeof(CvPoint2D32f));

    // copy
    for (int i = 0; i < nPt; ++i) {
        PtCv[i].x = pPtMt[i * 2];
        PtCv[i].y = pPtMt[i * 2 + 1];
    }

    return PtCv;
}

/*
 * Convert from OpenCV Pt data to Matlab Pt data.
 */
mxArray* PtCv2PtMt(const CvPoint2D32f* PtCv, int nPt)
{
    // PtMt
    mxArray* PtMt = mxCreateDoubleMatrix(2, nPt, mxREAL);

    // copy
    double *pPtMt = mxGetPr(PtMt);
    for (int i = 0; i < nPt; ++i) {
        pPtMt[i * 2] = PtCv[i].x;
        pPtMt[i * 2 + 1] = PtCv[i].y;
    }

    return PtMt;
}

// reader class
class McvCapture {
 public:
    CvCapture* p;
    double nF;
    double width;
    double height;
    double fps;

    McvCapture(const char* fname) {
        p = cvCaptureFromFile(fname);
        if (!p) {
            mexErrMsgTxt("Could not initialize capturing");
        }

        // property
        nF = cvGetCaptureProperty(p, CV_CAP_PROP_FRAME_COUNT);
        width = cvGetCaptureProperty(p, CV_CAP_PROP_FRAME_WIDTH);
        height = cvGetCaptureProperty(p, CV_CAP_PROP_FRAME_HEIGHT);
        fps = cvGetCaptureProperty(p, CV_CAP_PROP_FPS);

        mexPrintf("McvCapture created: nF %.0f width %.0f height %.0f fps %.0f\n", nF, width, height, fps);
    }

    ~McvCapture() {
        cvReleaseCapture(&p);
        mexPrintf("McvCapture destroyed.\n");
    }
};

// writer class
class McvWriter {
 public:
    CvVideoWriter* p;
    double nF;
    double width;
    double height;
    double fps;

    McvWriter(const char* fname, double w, double h, double f) {
        // image size
        CvSize imgSize;
        imgSize.width = w;
        imgSize.height = h;

        // create
        //p = cvCreateVideoWriter(fname, CV_FOURCC('D', 'I', 'V', 'X'), f, imgSize);
        p = cvCreateVideoWriter(fname, CV_FOURCC('M', 'P', '4', '2'), f, imgSize);
        if (!p) {
            mexErrMsgTxt("Could not initialize writer");
        }

        mexPrintf("McvWriter created: width %.0f height %.0f fps %.0f\n", w, h, f);

        // property
        nF = 0;
        width = w;
        height = h;
        fps = f;
    }

    ~McvWriter() {
        cvReleaseVideoWriter(&p);
        mexPrintf("McvWriter destroyed.\n");
    }
};

#endif

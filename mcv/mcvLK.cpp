#include "mex.h"
#include "mcv.h"

/*
 * function [Pt2, vis] = mcvLK(Img1, Img2, Pt1)
 *
 * History
 *   create  -  Feng Zhou, 04-16-2011
 *   modify  -  Feng Zhou, 04-16-2011
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    // Img1
    const mxArray* ImgMt1 = prhs[0];
    IplImage* ImgCv1 = ImgMt2ImgCv(ImgMt1);

    // Img2
    const mxArray* ImgMt2 = prhs[1];
    IplImage* ImgCv2 = ImgMt2ImgCv(ImgMt2);

    // Pt1
    int nPt = mxGetN(prhs[2]);
    CvPoint2D32f* PtCv1 = PtMt2PtCv(prhs[2], nPt);

    // Pt2
    CvPoint2D32f* PtCv2 = (CvPoint2D32f*) cvAlloc(nPt * sizeof(CvPoint2D32f));

    // RBG -> Grey
    IplImage* Grey1 = cvCreateImage(cvGetSize(ImgCv1), 8, 1);
    cvCvtColor(ImgCv1, Grey1, CV_BGR2GRAY);

    IplImage* Grey2 = cvCreateImage(cvGetSize(ImgCv2), 8, 1);
    cvCvtColor(ImgCv2, Grey2, CV_BGR2GRAY);

    // Pyramid
    IplImage* Pyr1 = cvCreateImage(cvGetSize(ImgCv1), 8, 1);
    IplImage* Pyr2 = cvCreateImage(cvGetSize(ImgCv2), 8, 1);

    // parameter
    CvSize winSiz = cvSize(10, 10);
    int level = 3;
    char* visCv = (char*) cvAlloc(nPt);
    CvTermCriteria crit = cvTermCriteria(CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 20, 0.03);
    int flags = 0;

    // LK
    cvCalcOpticalFlowPyrLK(Grey1, Grey2, Pyr1, Pyr2, PtCv1, PtCv2, nPt, winSiz, level, visCv, 0, crit, flags);

    // copy to output: Pt2
    plhs[0] = PtCv2PtMt(PtCv2, nPt);

    // copy to output: vis
    plhs[1] = mxCreateDoubleMatrix(1, nPt, mxREAL);
    double *visMt = mxGetPr(plhs[1]);
    for (int i = 0; i < nPt; ++i) {
        visMt[i] = visCv[i];
    }

    // free
    cvReleaseImage(&ImgCv1);
    cvReleaseImage(&ImgCv2);
    cvFree(&PtCv1);
    cvFree(&PtCv2);
    cvReleaseImage(&Grey1);
    cvReleaseImage(&Grey2);
    cvReleaseImage(&Pyr1);
    cvReleaseImage(&Pyr2);
    cvFree(&visCv);
}

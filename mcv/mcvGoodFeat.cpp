#include "mex.h"
#include "mcv.h"

/*
 * function Pt = mcvGoodFeat(Img, nPtMa, dstMi)
 *
 * A wrapper of OpenCV function "cvGoodFeaturesToTrack" for Matlab.
 *
 * History
 *   create  -  Feng Zhou, 04-16-2011
 *   modify  -  Feng Zhou, 04-16-2011
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    // Img
    const mxArray* ImgMt = prhs[0];
    IplImage* ImgCv = ImgMt2ImgCv(ImgMt);

    // nPtMa
    int nPtMa = int(*mxGetPr(prhs[1]));

    // dstMi
    double dstMi = *mxGetPr(prhs[2]);

    // RBG -> Grey
    IplImage* Grey = cvCreateImage(cvGetSize(ImgCv), 8, 1);
    cvCvtColor(ImgCv, Grey, CV_BGR2GRAY);

    // Pt
    CvPoint2D32f* PtCv = (CvPoint2D32f*) cvAlloc(nPtMa * sizeof(CvPoint2D32f));

    // temp structure
    IplImage* Eig = cvCreateImage(cvGetSize(Grey), 32, 1);
    IplImage* Tmp = cvCreateImage(cvGetSize(Grey), 32, 1);

    // parameter
    double quality = 0.01;
    int nPt = nPtMa;
    int win_size = 10;

    // good feat
    cvGoodFeaturesToTrack(Grey, Eig, Tmp, PtCv, &nPt, quality, dstMi, 0, 3, 0, 0.04);

    // refine
    cvFindCornerSubPix(Grey, PtCv, nPt, cvSize(win_size, win_size), cvSize(-1, -1), cvTermCriteria(CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 20, 0.03));

    // copy to output: Pts
    plhs[0] = PtCv2PtMt(PtCv, nPt);

    // free
    cvReleaseImage(&ImgCv);
    cvReleaseImage(&Grey);
    cvFree(&PtCv);
    cvReleaseImage(&Eig);
    cvReleaseImage(&Tmp);
}

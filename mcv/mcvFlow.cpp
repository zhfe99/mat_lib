#include "mex.h"
#include "mcv.h"
#include "mexopencv.hpp"

/*
 * function F = mcvFlow(Img1, Img2)
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

    // RGB -> Grey
    IplImage* Grey1 = cvCreateImage(cvGetSize(ImgCv1), 8, 1);
    cvCvtColor(ImgCv1, Grey1, CV_BGR2GRAY);

    IplImage* Grey2 = cvCreateImage(cvGetSize(ImgCv2), 8, 1);
    cvCvtColor(ImgCv2, Grey2, CV_BGR2GRAY);

    // compute the optical flow
    IplImage* F = cvCreateImage(cvGetSize(Grey1), IPL_DEPTH_32F, 2);
    // cv::Mat flow_mat = cv::cvarrToMat(flow);

    cv::Mat Grey1Mat = cv::cvarrToMat(Grey1);
    cv::Mat Grey2Mat = cv::cvarrToMat(Grey2);
    cv::Mat FMat = cv::cvarrToMat(F);

    cv::calcOpticalFlowFarneback(Grey1Mat, Grey2Mat, FMat,
                                 sqrt(2) / 2.0, 5, 10, 2, 7, 1.5, cv::OPTFLOW_FARNEBACK_GAUSSIAN);

    // copy to output: vis
    plhs[0] = MxArray(FMat);

    // free
    cvReleaseImage(&ImgCv1);
    cvReleaseImage(&ImgCv2);
    cvReleaseImage(&Grey1);
    cvReleaseImage(&Grey2);
    cvReleaseImage(&F);
}

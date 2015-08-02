/* Demo of modified Lucas-Kanade optical flow algorithm.
 * See the printf below */

#include "mex.h"
//#include "include/dlfcn.h"

#include "opencv/cv.h"
#include "opencv/cxcore.h"
#include "opencv/highgui.h"
#include <stdio.h>
#include <ctype.h>
#include <time.h>
#include <iostream>
#include <sstream>

/* Input Arguments */
#define	I_IN1	input[0]
#define I_IN2   input[1]
#define I_OUT   input[2]

IplImage *image = 0, *grey = 0, *prev_grey = 0, *pyramid = 0, *prev_pyramid = 0;
int win_size = 10;
const int MAX_COUNT = 200;
CvPoint2D32f* points[2] = {0, 0};
char* status = 0;
int flags = 0;
CvPoint pt1, pt2;
int ptcount=0;
clock_t init, final;

void mexFunction(int output_size, mxArray *output[], int input_size, const mxArray *input[]) {
    
    char* input_buf1, *input_buf2, *input_buf3;
    /* copy the string data from input[0] into a C string input_ buf.    */
    input_buf1 = mxArrayToString(I_IN1);
    input_buf2 = mxArrayToString(I_IN2);
    input_buf3 = mxArrayToString(I_OUT);
    
    init = clock();
    IplImage* img1, *img2, *stacked;
    int i, k, c;
    
    img1 = cvLoadImage(input_buf1, 1);
    if( ! img1 )
        fprintf(stderr, "unable to load image from %s", input_buf1 );
    img2 = cvLoadImage(input_buf2, 1);
    if( ! img2 )
        fprintf( stderr, "unable to load image from %s", input_buf2 );
    
    /* stack two images */
    stacked = cvCreateImage( cvSize( MAX(img1->width, img2->width),
										img1->height + img2->height ),
										IPL_DEPTH_8U, 3 );

	cvZero( stacked );
	cvSetImageROI( stacked, cvRect( 0, 0, img1->width, img1->height ) );
	cvAdd( img1, stacked, stacked, NULL );
	cvSetImageROI( stacked, cvRect(0, img1->height, img2->width, img2->height) );
	cvAdd( img2, stacked, stacked, NULL );
	cvResetImageROI( stacked );
    
    /* allocate all the buffers */
    grey = cvCreateImage( cvGetSize(img1), 8, 1 );
    prev_grey = cvCreateImage( cvGetSize(img1), 8, 1 );
    pyramid = cvCreateImage( cvGetSize(img1), 8, 1 );
    prev_pyramid = cvCreateImage( cvGetSize(img1), 8, 1 );
    points[0] = (CvPoint2D32f*)cvAlloc(MAX_COUNT*sizeof(points[0][0]));
    points[1] = (CvPoint2D32f*)cvAlloc(MAX_COUNT*sizeof(points[0][0]));
    status = (char*)cvAlloc(MAX_COUNT);
    flags = 0;
    
    cvCvtColor( img2, grey, CV_BGR2GRAY );
    cvCvtColor( img1, prev_grey, CV_BGR2GRAY );
    
    /* automatic initialization */
    IplImage* eig = cvCreateImage( cvGetSize(grey), 32, 1 );
    IplImage* temp = cvCreateImage( cvGetSize(grey), 32, 1 );
    double quality = 0.01;
    double min_distance = 10;
    
    ptcount = MAX_COUNT;
    
    /* detect features in the first image */
    cvGoodFeaturesToTrack( grey, eig, temp, points[0], &ptcount,
            quality, min_distance, 0, 3, 0, 0.04 );
    cvFindCornerSubPix( grey, points[0], ptcount,
            cvSize(win_size, win_size), cvSize(-1, -1),
            cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 20, 0.03));
    cvReleaseImage( &eig );
    cvReleaseImage( &temp );
    
    /* find the location of the feats in the second image */
    if( ptcount > 0 ) {
        cvCalcOpticalFlowPyrLK(prev_grey, grey, prev_pyramid, pyramid,
                points[0], points[1], ptcount, cvSize(win_size, win_size), 3, status, 0,
                cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 20, 0.03), flags );
        flags |= CV_LKFLOW_PYR_A_READY;
        for (i = k = 0; i < 1; i++ ) {

            pt1 = cvPoint(cvRound(points[0][i].x),cvRound(points[0][i].y));
            pt2 = cvPoint(cvRound(points[1][i].x),cvRound(points[1][i].y+img1->height));

            if( !status[i] ){
                cvCircle( image, pt1, 3, CV_RGB(0, 0, 255), -1, 8, 0);
                cvCircle( image, pt2, 3, CV_RGB(0, 0, 255), -1, 8, 0);
                continue;
            }

            points[1][k++] = points[1][i];
            cvCircle( stacked, pt1, 3, CV_RGB(0, 255, 0), -1, 8, 0); 
            cvCircle( stacked, pt2, 3, CV_RGB(0, 255, 0), -1, 8, 0);            

            cvLine( stacked, pt1, pt2, CV_RGB(255, 0, 255), 1, 8, 0 );
        }
        ptcount = k;
    }

    /* show the result */   
    cvNamedWindow("LKMatch", 1);
    cvShowImage("LKMatch", stacked );
    cvResizeWindow("LKMatch", img1->width, img1->height );

    /* save the result */
    // cvSaveImage(input_buf3, stacked);
   
    final = clock()-init;
    
    cvReleaseImage( &stacked );
    cvReleaseImage( &img1 );
    cvReleaseImage( &img2 );
}

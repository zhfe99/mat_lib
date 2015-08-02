/* Demo of modified Lucas-Kanade optical flow algorithm.
 * See the printf below */

#include "mex.h"
//#include "include/dlfcn.h"

#include "/opt/local/include/opencv/cv.h"
#include "/opt/local/include/opencv/highgui.h"
#include <stdio.h>
#include <ctype.h>
#include <time.h>
#include <iostream>
#include <sstream>

/* Input Arguments */
#define	I_IN input[0]

IplImage *image = 0, *grey = 0, *prev_grey = 0, *pyramid = 0, *prev_pyramid = 0, *swap_temp;
int win_size = 10;
const int MAX_COUNT = 500;
CvPoint2D32f* points[2] = {0, 0}, *swap_points;
char* status = 0;
int need_to_init = 0;
int night_mode = 0;
int flags = 0;
int add_remove_pt = 0;
int stop = 0;
CvPoint pt,pttl,ptdr;

int need_to_add = 0;
int countadd = 0;
int countlast = 0;
CvPoint2D32f* pointadd[1] = {0};
int m=0;
int flag = 1;
int imgseq=0;

int* ptcolor = 0;

int ptcount=0;

clock_t init, final;

void mexFunction(int output_size, mxArray *output[], int input_size, const mxArray *input[]) {
    
    char* input_buf;
    /* copy the string data from input[0] into a C string input_ buf. */
    input_buf = mxArrayToString(I_IN);
    CvCapture* capture = 0;

    capture = cvCaptureFromAVI(input_buf);
    if (!capture) {
        fprintf(stderr, "Could not initialize capturing...\n");
    }

    cvNamedWindow( "LkDemo", 0 );

    for(;;) {
        init = clock();
        IplImage* frame = 0;
        int i, k, c;
        
        frame = cvQueryFrame( capture );
        if (!frame)
            break;

        if (!image) {
            /* allocate all the buffers */
            image = cvCreateImage(cvGetSize(frame), 8, 3);
            image->origin = frame->origin;
            grey = cvCreateImage( cvGetSize(frame), 8, 1 );
            prev_grey = cvCreateImage( cvGetSize(frame), 8, 1 );
            pyramid = cvCreateImage( cvGetSize(frame), 8, 1 );
            prev_pyramid = cvCreateImage( cvGetSize(frame), 8, 1 );
            points[0] = (CvPoint2D32f*)cvAlloc(MAX_COUNT * sizeof(points[0][0]));
            points[1] = (CvPoint2D32f*)cvAlloc(MAX_COUNT * sizeof(points[0][0]));
            pointadd[0] = (CvPoint2D32f*)cvAlloc(MAX_COUNT * sizeof(points[0][0]));
            ptcolor = (int*)cvAlloc(MAX_COUNT*sizeof(ptcolor[0]));
            status = (char*)cvAlloc(MAX_COUNT);
            flags = 0;
        }

        cvCopy( frame, image, 0 );
        cvCvtColor( image, grey, CV_BGR2GRAY );
        //CvRect rect = cvRect(image->width/2-50, 0, 100,image->height*0.6);
        
        if (night_mode)
            cvZero( image );

        countlast = ptcount;
        if (need_to_add) {
            /* automatic initialization */
            IplImage* eig = cvCreateImage(cvGetSize(grey), 32, 1);
            IplImage* temp = cvCreateImage(cvGetSize(grey), 32, 1);
            double quality = 0.01;
            double min_distance = 10;
            
            countadd = MAX_COUNT;
            //cvSetImageROI(grey, rect);
            //cvSetImageROI(eig, rect);
            //cvSetImageROI(temp, rect);
            
            cvGoodFeaturesToTrack(grey, eig, temp, pointadd[0], &countadd, quality, min_distance, 0, 3, 0, 0.04);
            cvFindCornerSubPix(grey, pointadd[0], countadd, cvSize(win_size, win_size), cvSize(-1, -1), cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 20, 0.03));

            //for(l=0;l<countadd;l++)
            //	pointadd[0][l].x = pointadd[0][l].x + image->width/2-50;
            cvReleaseImage( &eig );
            cvReleaseImage( &temp );
            //cvResetImageROI(grey);
            for (m = 0; m < countadd; m++) {
                flag = 1;
                for (i = 0; i < countlast; i++) {
                    double dx = pointadd[0][m].x - points[0][i].x;
                    double dy = pointadd[0][m].y - points[0][i].y;

                    if( dx*dx + dy*dy <= 100 ) {
                        flag = 0;
                        break;
                    }
                }

                if (flag==1) {
                    points[0][ptcount++] = pointadd[0][m];
                    cvCircle(image, cvPointFrom32f(points[1][ptcount-1]), 3, CV_RGB(255, 0, 0), -1, 8, 0);
                }
                if (ptcount >= MAX_COUNT) {
                    break;
                }
            }
        }

        if (need_to_init) {
            /* automatic initialization */
            IplImage* eig = cvCreateImage( cvGetSize(grey), 32, 1 );
            IplImage* temp = cvCreateImage( cvGetSize(grey), 32, 1 );
            double quality = 0.01;
            double min_distance = 10;
            
            ptcount = MAX_COUNT;
            cvGoodFeaturesToTrack(grey, eig, temp, points[1], &ptcount, quality, min_distance, 0, 3, 0, 0.04);
            cvFindCornerSubPix(grey, points[1], ptcount, cvSize(win_size, win_size), cvSize(-1, -1), cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 20, 0.03));
            cvReleaseImage( &eig );
            cvReleaseImage( &temp );
            add_remove_pt = 0;
            /* set the point color */
            for( i=0; i<ptcount; i++ ){
                switch (i%5) {
                    case 0:
                        ptcolor[i] = 0;
                        break;
                    case 1:
                        ptcolor[i] = 1;
                        break;
                    case 2:
                        ptcolor[i] = 2;
                        break;
                    case 3:
                        ptcolor[i] = 3;
                        break;
                    case 4:
                        ptcolor[i] = 4;
                        break;
                    default:
                        ptcolor[i] = 0;
                }
            }
        }
        else if( ptcount > 0 ) {
            cvCalcOpticalFlowPyrLK( prev_grey, grey, prev_pyramid, pyramid,
                    points[0], points[1], ptcount, cvSize(win_size, win_size), 3, status, 0,
                    cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 20, 0.03), flags );
            flags |= CV_LKFLOW_PYR_A_READY;
            for( i = k = 0; i < ptcount; i++ ) {
                if( add_remove_pt ) {
                    double dx = pointadd[0][m].x - points[1][i].x;
                    double dy = pointadd[0][m].y - points[1][i].y;

                    if( dx*dx + dy*dy <= 25 ) {
                        add_remove_pt = 0;
                        continue;
                    }
                }

                pt = cvPointFrom32f(points[1][i]);
                pttl.x = pt.x-3; pttl.y = pt.y-3; // point top left
                ptdr.x = pt.x+3; ptdr.y = pt.y+3; // point down right

                if( !status[i] ){
                    pt = cvPointFrom32f(points[0][i]);
                    cvCircle( image, pt, 3, CV_RGB(0, 0, 255), -1, 8, 0);
                    continue;
                }

                pt = cvPointFrom32f(points[1][i]);
                points[1][k] = points[1][i];
                if(i<countlast){
                    /* matched feats */
                    ptcolor[k] = ptcolor[i];
                    switch (ptcolor[k]) {
                        case 0:
                            cvCircle( image, pt, 3, CV_RGB(0, 255, 0), -1, 8, 0);
                            break;
                        case 1:
                            cvCircle( image, pt, 3, CV_RGB(255, 255, 0), -1, 8, 0);
                            break;
                        case 2:
                            cvCircle( image, pt, 3, CV_RGB(0, 255, 255), -1, 8, 0);
                            break;
                        case 3:
                            cvCircle( image, pt, 3, CV_RGB(255, 0, 255), -1, 8, 0);
                            break;
                        case 4:
                            cvCircle( image, pt, 3, CV_RGB(255, 0, 0), -1, 8, 0);                            
                            break;
                        default:
                            cvCircle( image, pt, 3, CV_RGB(0, 255, 0), -1, 8, 0);
                    }
                }
                else
                    /* new feats */
                    switch (k%5) {
                        case 0:
                            //  void cvRectangle( CvArr* img, CvPoint pt1, CvPoint pt2, double color, int thickness=1 );
                            cvRectangle( image, pttl, ptdr, CV_RGB(0, 255, 0), -1, 8, 0);
                            ptcolor[k] = 0;
                            break;
                        case 1:
                            cvRectangle( image, pttl, ptdr, CV_RGB(255, 255, 0), -1, 8, 0);
                            ptcolor[k] = 1;
                            break;
                        case 2:
                            cvRectangle( image, pttl, ptdr, CV_RGB(0, 255, 255), -1, 8, 0);
                            ptcolor[k] = 2;
                            break;
                        case 3:
                            cvRectangle( image, pttl, ptdr, CV_RGB(255, 0, 255), -1, 8, 0);
                            ptcolor[k] = 3;
                            break;
                        case 4:
                            cvRectangle( image, pttl, ptdr, CV_RGB(255, 0, 0), -1, 8, 0);
                            ptcolor[k] = 4;
                            break;
                        default:
                            cvRectangle( image, pttl, ptdr, CV_RGB(0, 255, 0), -1, 8, 0);
                    }
                    k++;
            }
            ptcount = k;
        }

        if( add_remove_pt && ptcount < MAX_COUNT ) {
            points[1][ptcount++] = cvPointTo32f(pt);
            cvFindCornerSubPix( grey, points[1] + ptcount - 1, 1,
                    cvSize(win_size, win_size), cvSize(-1, -1),
                    cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, 20, 0.03));
            add_remove_pt = 0;
        }

        CV_SWAP( prev_grey, grey, swap_temp );
        CV_SWAP( prev_pyramid, pyramid, swap_temp );
        CV_SWAP( points[0], points[1], swap_points );
        need_to_init = 0;
        cvShowImage( "LkDemo", image );

        std::string filename = "Rst/Rst";
        std::string seq;
        std::ostringstream fs;
        fs << imgseq << "\n";
        std::istringstream input(fs.str());
        input >> seq>> imgseq;
        filename += seq + ".jpg";
        cvSaveImage(filename.c_str(), image);
        imgseq++;
        if(imgseq>500)
            break;

        c = cvWaitKey(10);
        if( (char)c == 27 )
            break;
        switch( (char) c ) {
            case 'r':
                need_to_init = 1;
                break;
            case 'c':
                ptcount = 0;
                break;
            case 'n':
                night_mode ^= 1;
                break;
            default:
                ;
        }
        if (ptcount<100) {
            need_to_init =1;
        }
        if (ptcount>50&&ptcount<MAX_COUNT) {
            need_to_add = 1;
        }
        final = clock()-init;
    }

    cvReleaseCapture( &capture );
    cvDestroyWindow("LkDemo");
    
}

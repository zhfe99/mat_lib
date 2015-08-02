//Implementation of the Gaussian mixture model background subtraction from:
//
//"Improved adaptive Gausian mixture model for background subtraction"
//Z.Zivkovic
//International Conference Pattern Recognition, UK, August, 2004
//
//The algorithm similar to the standard Stauffer&Grimson algorithm with
//additional selection of the number of the Gaussian components based on:
//
//"Recursive unsupervised learning of finite mixture models "
//Z.Zivkovic, F.van der Heijden
//IEEE Trans. on Pattern Analysis and Machine Intelligence, vol.26, no.5, pages 651-656, 2004
//
//
//Example usage: See the matlab file mexCvBSLib.m
//
//Author: Z.Zivkovic, www.zoranz.net
//Date: 28-February-2007
//Using ObjectHandle.h from Tim Bailey

#include "ObjectHandle.h"
#include "CvPixelBackgroundGMM.h"

class MyClass {
    CvPixelBackgroundGMM* pGMM;

public:
    MyClass(int width, int height) {
        pGMM = cvCreatePixelBackgroundGMM(width, height);
        //mexPrintf("MyClass created.\n");
    }

    ~MyClass() {
        cvReleasePixelBackgroundGMM(&pGMM);
        //mexPrintf("MyClass destroyed.\n");
    }

    void process(unsigned char* imagein, unsigned char* imageout) {
        cvUpdatePixelBackgroundGMMTiled(pGMM, imagein, imageout);
    }

    void setParameters(double* pars) {
        //      mexPrintf("fAlphaT: %f\n", pars[0]);
        pGMM->fAlphaT = (float) pars[0];

        //      mexPrintf("fTb: %f\n", pars[1]);
        pGMM->fTb = (float) pars[1];

        //      mexPrintf("bShadowDetection: %f\n", pars[2]);
        pGMM->bShadowDetection = (int) pars[2];

        //      mexPrintf("fTau: %f\n", pars[3]);
        pGMM->fTau = (float) pars[3];
    }
};

/* Input Arguments */
#define I_IN prhs[0]
#define PDATA_IN prhs[1]
#define PARS_IN prhs[2]

/* Output Arguments */
#define I_OUT plhs[0]

/* Main function */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int nD;
    const int *rND;
    MyClass *mine = 0;

    if (nrhs == 0) {
        mexErrMsgTxt("Need at least one input argument.");
        return;
    }

    // Matlab: mexCvBSLib(hBS)
    // Close
    if (nlhs == 0 && nrhs == 1) {
        //release memory
        ObjectHandle<MyClass>* handle = ObjectHandle<MyClass>::from_mex_handle(prhs[0]);
        delete handle;
        return;
    }

    // dimension
    nD = mxGetNumberOfDimensions(I_IN);
    rND = mxGetDimensions(I_IN);
    if ((nD != 3) || (rND[2] != 3)) {
        mexErrMsgTxt("Need RGB image");
        return;
    }

    // Matlab: hBS = mexCvBSLib(F)
    // create
    if (nlhs == 1 && nrhs == 1) {
        //RGB image is provoded
        mine = new MyClass(rND[0], rND[1]);

        //mexPrintf("Pointer before: %#x\n", mine);
        ObjectHandle<MyClass> *handle = new ObjectHandle<MyClass>(mine);

        //mexPrintf("Pointer after: %#x\n", mine);
        plhs[0] = handle->to_mex_handle();

        // Matlab: imMask0 = mexCvBSLib(F, hBS)
        // Current
    } else if (nlhs == 1 && nrhs == 2) {
        //update background
        MyClass& mine = get_object<MyClass>(PDATA_IN);

        // Create a matrix for the return argument
        I_OUT = mxCreateNumericArray(2, rND, mxUINT8_CLASS, mxREAL);

        /* Assign pointers to the various parameters */
        unsigned char* imageout = (unsigned char*) mxGetData(I_OUT);
        unsigned char* imagein = (unsigned char*) mxGetData(I_IN);
        mine.process(imagein,imageout);

        // Matlab: mexCvBSLib(F, hBS, [.01, 4 * 4, 1, .5])
        // Parameter
    } else if ( nlhs == 0 && nrhs == 3) {
        MyClass& mine = get_object<MyClass>(PDATA_IN);
        double* pars = (double*) mxGetData(PARS_IN);
        mine.setParameters(pars);

    } else {
        mexErrMsgTxt("Bad input.");
    }
}

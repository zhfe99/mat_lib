Contents:
//Implementation of the Gaussian mixture model background subtraction from:
//
//"Improved adaptive Gausian mixture model for background subtraction"
//Z.Zivkovic 
//International Conference Pattern Recognition, UK, August, 2004
//
// and
//
//"Efficient Adaptive Density Estimapion per Image Pixel for the Task of Background Subtraction"
//Z.Zivkovic, F. van der Heijden 
//Pattern Recognition Letters, vol. 27, no. 7, pages 773-780, 2006.

Source code:
-CvPixelBackgroundGMM.h
-CvPixelBackgroundGMM.cpp 

Matlab wrap-around:
-mexCvBSLib.cpp
-ObjectHandle.h (from Tim Bailey)
(compile in matlab using ">>mex mexCvBSLib.cpp CvBSLib.lib"
or ">>mex mexCvBSLib.cpp CvPixelBackgroundGMM.cpp")

Precompiled libraries:
-CvBSLib.lib - Windows
-mexCvBSLib.dll - Windows Matlab
-mexCvBSLib.mexglx - Linux Matlab

This work may not be copied or reproduced 
in whole or in part for any commercial purpose. 
Permission to copy in whole or in part without payment of fee is granted 
for nonprofit educational and research purposes provided that all such
whole or partial copies include the following: 
-this notice; 
-an acknowledgment of the authors and individual 
contributions to the work; 
Copying, reproduction, or republishing for any other purpose 
shall require a license. Please contact the author in such cases.
All the code is provided without any guarantee.

Author: Zoran Zivkovic, www.zoranz.net
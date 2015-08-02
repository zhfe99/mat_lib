% A makefile for compling all functions in this folder.
%
% History
%   create     -  Feng Zhou (zhfe99@gmail.com), 02-03-2012
%   modify     -  Feng Zhou (zhfe99@gmail.com), 10-31-2013

libcv_inc = '-I/opt/local/include';
libcv_lib = '-L/opt/local/lib/ -lopencv_core -lopencv_ml -lopencv_highgui -lopencv_imgproc -lopencv_video';

libcv_inc = '-I/opt/local/include';
libcv_lib = '-L/opt/local/lib/ -lopencv_core -lopencv_ml -lopencv_highgui -lopencv_imgproc -lopencv_video';

mex('mcvGoodFeat.cpp', libcv_inc, libcv_lib);
mex('mcvLK.cpp', libcv_inc, libcv_lib);
mex('mcvVReader.cpp', libcv_inc, libcv_lib);

% return;
mex('mcvVWriter.cpp', libcv_inc, libcv_lib);
mex mexCvBSLib.cpp CvPixelBackgroundGMM.cpp;
mex mcvFlow.cpp MxArray.cpp -I/opt/local/include -L/opt/local/lib/ -lopencv_core -lopencv_ml -lopencv_highgui -lopencv_imgproc -lopencv_video % CLANG_CXX_LIBRARY = libc++
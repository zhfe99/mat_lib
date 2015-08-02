% function [Pt2s, vis] = mcvFlow(Img1, Img2, Pt1s)
%
% A wrapper of funciton "calcOpticalFlowFarneback" in OpenCV.
%
% Input
%   Img1    -  1st image
%   Img2    -  2nd image
%   Pt1s    -  initial position of points on the 1st image
%
% Output
%   Pt2s    -  updated position points on the 1st image
%   vis     -  visibility of points
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-17-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-20-2013

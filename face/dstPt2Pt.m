function d = dstPt2Pt(Pt1, Pt2)
% Compute the distance between two points set.
%
% Input
%   Pt1     -  1st point set, 2 x nPt
%   Pt2     -  2nd point set, 2 x nPt
%
% Output
%   dst     -  distance
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-11-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

Gap = (Pt1 - Pt2) .^ 2;
d = mean(sqrt(sum(Gap)));

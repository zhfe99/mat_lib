function [areas, xDs, yDs] = computeRegionSpa(L, cSegs, mSeg)
% Compute spatial prior of each region.
%
% Input
%   L       -  label image, h x w
%   cSegs   -  segment index, 1 x mSeg
%   mSeg    -  #region
%
% Output
%   areas   -  area size, mSeg x 1
%   xDs     -  differency sum in X position, mSeg x 1
%   yDs     -  differency sum in Y position, mSeg x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-09-2013

% dimension
[h, w] = size(L);

% distance to center
[XD, YD] = computeRegionSpaXY([h w]);
% [XD, YD] = meshgrid(-w / 2 + 1 : w / 2, -h / 2 + 1 : h / 2);
% XD = XD .^ 2;
% YD = YD .^ 2;

% each segment
[areas, xDs, yDs] = zeross(mSeg, 1);
for iL = 1 : length(cSegs)
    cL = cSegs(iL);

    %% active pixels
    idxL = find(L == cL);
    areas(cL) = length(idxL);

    %% spatial prior
    xDs(cL) = sum(XD(idxL));
    yDs(cL) = sum(YD(idxL));
end

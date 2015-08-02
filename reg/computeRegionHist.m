function Hst = computeRegionHist(Q, bins, L, cSegs, mSeg)
% Compute histogram of all the segments.
%
% Remarks
%   k = prod(bins)
%
% Input
%   Q       -  quantized image, h x w
%   bins    -  bins, 1 x nBin
%   L       -  label, h x w
%   cSegs   -  segment index, 1 x nSeg
%   mSeg    -  #segments in the video
%
% Output
%   Hst     -  histogram, mSeg x k
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-18-2013

% dimension
k = prod(bins);
nSeg = length(cSegs);

% per region
Hst = zeros(mSeg, k);
for iSeg = 1 : nSeg
    cSeg = cSegs(iSeg);

    %% active pixels
    idxL = find(L == cSeg);

    %% label value of pixel
    idxB = sort(Q(idxL));
    [v, iA, ~] = unique(idxB);

    %% add to the bin
    mm = [0; iA(1 : end - 1)];
    freq = iA - mm;
    Hst(cSeg, v) = Hst(cSeg, v) + freq';
end

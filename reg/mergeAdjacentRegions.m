function [L, A] = mergeAdjacentRegions(L0, A0, Hst0, th)
% Merge regions.
%
% Input
%   L0      -  original label, h x w
%   A0      -  original adjacency, mSeg0 x mSeg0
%   Hst0    -  histogram, mSeg0 x k
%   th      -  threshold
%
% Output
%   L       -  label, h x w
%   A       -  new adjacency, mSeg x mSeg
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-02-2013

% dimension
mSeg0 = size(A0, 1);

% adjacency matrix
if length(find(A0 ~= A0')) > 0
    error('incorrect A0');
end

% distance
D = zeros(mSeg0, mSeg0);
ind = find(A0);
for ix = 1 : length(ind)
    [x, y] = ind2sub([mSeg0, mSeg0], ind(ix));
    if x ~= y
        D(x, y) = histDist(Hst0(x, :), Hst0(y, :));
    end
end

% merge region
AD = D < th & D ~= 0;
ind = find(AD);
labels = mexMergeAdjacentRegions(double(AD), ind - 1);

% adjust label
ind = find(labels == 0);
labels(ind) = max(labels(:)) + [1 : length(ind)];

mSeg = max(labels(:));
L = zeros(size(L0));
spstats = regionprops(L0, 'PixelIdxList');

for ix = 1 : mSeg0
    L(spstats(ix).PixelIdxList) = labels(ix);
end

% adjust adjacency
nseg = mSeg;
imh = size(L, 1);

A = eye([mSeg mSeg], 'uint8');

% get adjacency
dx = uint8(L ~= L(:, [2 : end, end]));
dy = L ~= L([2 : end, end], :);

ind1 = find(dy);
ind2 = ind1 + 1;
s1 = L(ind1);
s2 = L(ind2);
A(s1 + nseg * (s2 - 1)) = 1;
A(s2 + nseg * (s1 - 1)) = 1;

ind3 = find(dx);
ind4 = ind3 + imh;
s3 = L(ind3);
s4 = L(ind4);
A(s3 + nseg * (s4 - 1)) = 1;
A(s4 + nseg * (s3 - 1)) = 1;

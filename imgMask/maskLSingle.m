function [L, IdxL2R, xCens, yCens] = maskLSingle(L0, mSeg)
% Obtain the contour of a binary image.
%
% Input
%   L0      -  original label matrix, h x w
%
% Output
%   L       -  new label matrix, h x w
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 11-08-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-18-2013

L = uint16(L0);

% find the connected region
[R, mReg, mRegs] = maskRegConn(L, mSeg);
mRMa = max(mRegs);

% region stat
[idxR2L, IdxL2R, ~, sizs, xCens, yCens] = maskRegStat(L, R, mSeg, mReg, mRMa);

% region size
Siz = zeros(mSeg, mRMa);
idx = find(IdxL2R ~= 0);
Siz(idx) = sizs(IdxL2R(idx));

% sort
[~, IdxSiz] = sort(Siz, 2, 'descend');

% pick the large region
ind = sub2ind([mSeg, mRMa], 1 : mSeg, IdxSiz(:, 1)');
idx = IdxL2R(ind);
idx(idx == 0) = [];
vis = zeros(1, mReg);
vis(idx) = 1;

% compute the new label
L = vis(R);
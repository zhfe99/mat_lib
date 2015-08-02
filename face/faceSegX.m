function [X, dims] = faceSegX(wsData, nms, varargin)
% Obtain sample matrix from face sequence for temporal segmentation.
%
% Input
%   wsData  -  face data
%   nms     -  feature name list, 1 x nFt (cell)
%   varargin
%     X0    -  flag, 'y' | {'n'}
%
% Output
%   X       -  sample matrix, dim x n
%   dims    -  feature dimension, 1 x nFt
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
isX0 = psY(varargin, 'X0', 'n');

% all existed features
[nm0s, dim0s] = faceFts;

% all available features
XA = []; dimAs = []; nmAs = {};
if isfield(wsData, 'Dst') || isfield(wsData, 'Dst0')
    stNm = select(isX0, 'Dst0', 'Dst');
    [Dst, dstNms] = stFld(wsData, stNm, 'dstNms');
    dstDims = dim0s(strloc(dstNms, nm0s));

    XA = [XA; Dst];
    dimAs = [dimAs, dstDims];
    nmAs = cellCate(nmAs, dstNms);
end
if isfield(wsData, 'Agl') || isfield(wsData, 'Agl0')
    stNm = select(isX0, 'Agl0', 'Agl');
    [Agl, aglNms] = stFld(wsData, stNm, 'aglNms');
    aglDims = dim0s(strloc(aglNms, nm0s));

    XA = [XA; Agl];
    dimAs = [dimAs, aglDims];
    nmAs = cellCate(nmAs, aglNms);
end
if isfield(wsData, 'Shp') || isfield(wsData, 'Shp0')
    stNm = select(isX0, 'Shp0', 'Shp');
    [Shp, shpNms] = stFld(wsData, stNm, 'shpNms');
    shpDims = dim0s(strloc(shpNms, nm0s));

    XA = [XA; Shp];
    dimAs = [dimAs, shpDims];
    nmAs = cellCate(nmAs, shpNms);
end
if isfield(wsData, 'HstL') || isfield(wsData, 'HstL0')
    stNm1 = select(isX0, 'HstL0', 'HstL');
    stNm2 = select(isX0, 'HstU0', 'HstU');
    [HstL, hstLNms, HstU, hstUNms] = stFld(wsData, stNm1, 'hstLNms', stNm2, 'hstUNms');
    hstLDims = dim0s(strloc(hstLNms, nm0s));
    hstUDims = dim0s(strloc(hstUNms, nm0s));

    XA = [XA; HstL; HstU];
    dimAs = [dimAs, hstLDims, hstUDims];
    nmAs = cellCate(nmAs, hstLNms, hstUNms);
end
sA = n2s(dimAs);

% all features
nFt = length(nms);
inds = strloc(nms, nmAs);
Xs = cellss(1, nFt);
for iFt = 1 : nFt
    ind = inds(iFt);
    if ind == 0
        error(['unknown feature: ' nms{iFt}]);
    end

    Xs{iFt} = XA(sA(ind) : sA(ind + 1) - 1, :);
end
X = cat(1, Xs{:});
dims = dimAs(inds);

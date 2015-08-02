function wsGeo = geoDst(X0, wsIdx, varargin)
% Distance between two points.
%
% Input
%   X1        -  original position, dim0 x nF
%   wsIdx
%     IdxPt1  -  index of 1st point set, dim x nP
%     IdxPt2  -  index of 2nd point set, dim x nP
%   varargin
%
% Output
%   wsGeo
%     X1      -  position of 1st point set, dim x nP x nF
%     X2      -  position of 2nd point set, dim x nP x nF
%     DstLn   -  the distance line, dim x 2 x nP x nF
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 03-11-2010
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option

% point index
[IdxPt1, IdxPt2] = stFld(wsIdx, 'IdxPt1', 'IdxPt2');

% dimension
[dim0, nF] = size(X0);
[dim, nP] = size(IdxPt1);

[X1, X2] = zeross(dim, nP, nF);
DstLn = zeross(dim, 2, nP, nF);

% frame
for iF = 1 : nF

    % pair
    for iP = 1 : nP
    
        % point
        x1 = X0(IdxPt1(:, iP), iF);
        x2 = X0(IdxPt2(:, iP), iF);
        X1(:, iP, iF) = x1;
        X2(:, iP, iF) = x2;
        
        % distance line
        DstLn(:, 1, iP, iF) = x1;
        DstLn(:, 2, iP, iF) = x2;
    end
end

% store
wsGeo.X1 = X1;
wsGeo.X2 = X2;
wsGeo.DstLn = DstLn;

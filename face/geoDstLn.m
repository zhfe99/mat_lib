function wsGeo = geoDstLn(X0, wsIdx, varargin)
% Distance between point and line.
%
% Input
%   X0       -  original position, dim0 x nF
%   wsIdx
%     IdxPt  -  index of the point, dim x nP
%     IdxLn  -  index of the line, dim x nS x nP
%   varargin
%     v      -  value of expansion of Ln, {0}
%
% Output
%   wsGeo
%     X      -  the point, dim x nP x nF
%     Y      -  the line, dim x nS x nP x nF
%     Z      -  the closest point on the line, dim x nP x nF
%     DstLn  -  the line of distance, dim x 2 x nP x nF
%     Ln     -  the line, dim x 2 x nP x nF
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 03-11-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
v = ps(varargin, 'v', 0);

% point index
[IdxPt, IdxLn] = stFld(wsIdx, 'IdxPt', 'IdxLn');

% dimension
[dim0, nF] = size(X0);
[dim, nS, nP] = size(IdxLn);

if nS ~= 2
    error('unsupported yet');
end

[Z, X] = zeross(dim, nP, nF);
Y = zeross(dim, nS, nP, nF);
[DstLn, Ln] = zeross(dim, 2, nP, nF);

% frame
for iF = 1 : nF

    % pair
    for iP = 1 : nP
    
        % point
        x = X0(IdxPt(:, iP), iF);
        X(:, iP, iF) = x;
        
        y1 = X0(IdxLn(:, 1, iP), iF);
        y2 = X0(IdxLn(:, 2, iP), iF);
        Y(:, 1, iP, iF) = y1;
        Y(:, 2, iP, iF) = y2;
        
        % closest point
        z = y1 + (y2 - y1) * (x - y1)' * (y2 - y1) / ((y2 - y1)' * (y2 - y1));
        Z(:, iP, iF) = z;
        
        % distance line
        DstLn(:, 1, iP, iF) = x;
        DstLn(:, 2, iP, iF) = z;
        
        % line
        y1n = y1 + v * (y1 - y2);
        y2n = y2 + v * (y2 - y1);
        Ln(:, 1, iP, iF) = y1n;
        Ln(:, 2, iP, iF) = y2n;
    end
end

% store
wsGeo.X = X;
wsGeo.Y = Y;
wsGeo.Z = Z;
wsGeo.DstLn = DstLn;
wsGeo.Ln = Ln;

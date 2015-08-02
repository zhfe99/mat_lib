function wsGeo = geoArc(X0, wsIdx, varargin)
% Computer the arc.
%
% Input
%   X0       -  original position, dim0 x nF
%   wsIdx
%     IdxPt  -  index of the point, dim x 3 x nP
%   varargin
%     v      -  value of expansion of Ln, {0}
%     nA     -  #samples on the arc, {10}
%
% Output
%   wsGeo
%     X     -  points determining the arc, dim x 3 x nP x nF
%     Arc   -  points composing the arc, dim x nA x nP x nF
%     Bd    -  points on the boundary of the arc, dim x 3 x nP x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-11-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
v = ps(varargin, 'v', 0);
v2 = ps(varargin, 'v2', .5);
nA = ps(varargin, 'nA', 10);

% point index
IdxPt = stFld(wsIdx, 'IdxPt');

% dimension
[dim0, nF] = size(X0);
[dim, tmp, nP] = size(IdxPt);

if tmp ~= 3
    error('unknown composition of arc');
end

[X, Bd] = zeross(dim, 3, nP, nF);
Arc = zeross(dim, nA, nP, nF);

% frame
for iF = 1 : nF

    % pair
    for iP = 1 : nP
        % point
        x  = X0(IdxPt(:, 1, iP), iF);
        y1 = X0(IdxPt(:, 2, iP), iF);
        y2 = X0(IdxPt(:, 3, iP), iF);

        X(:, 1, iP, iF) = x;
        X(:, 2, iP, iF) = y1;
        X(:, 3, iP, iF) = y2;

        % arc
        dst1 = norm(x - y1);
        dst2 = norm(x - y2);
        r = min(dst1, dst2) * v2;
        z1 = x + r * (y1 - x) / norm(y1 - x);
        z2 = x + r * (y2 - x) / norm(y2 - x);
   
        % angle
        ang1 = atan2(z1(2) - x(2), z1(1) - x(1));
        ang2 = atan2(z2(2) - x(2), z2(1) - x(1));

        % sampling on the arc
        if ang1 < ang2
            ang1 = ang1 + pi * 2;
        end
        angs = linspace(ang1, ang2, nA);

        for iA = 1 : nA
            Arc(1, iA, iP, iF) = x(1) + r * cos(angs(iA));
            Arc(2, iA, iP, iF) = x(2) + r * sin(angs(iA));
        end

        % boundary
        y1n = y1 + v * (y1 - x);
        y2n = y2 + v * (y2 - x);
        Bd(:, 1, iP, iF) = y1n;
        Bd(:, 2, iP, iF) = x;
        Bd(:, 3, iP, iF) = y2n;
    end
end

% store
wsGeo.X = X;
wsGeo.Arc = Arc;
wsGeo.Bd = Bd;

function h = shPts(X, varargin)
% Show multiple points in the 2-D figure.
%
% Input
%   X        -  point position, 2 x n
%   varargin
%     show option
%     mkCl   -  marker color, {'y'}
%     mkSiz  -  size of markers, {5}
%     mkEg   -  flag of marker edge, {'y'} | 'n'
%
% Output
%   h        -  figure content handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-03-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
mkCl = ps(varargin, 'mkCl', 'y');
mkSiz = ps(varargin, 'mkSiz', 6);
isMkEg = psY(varargin, 'mkEg', 'y');

h = plot(X(1, :), X(2, :), 'o', 'MarkerSize', mkSiz, 'MarkerFaceColor', mkCl);

if isMkEg
    set(h, 'MarkerEdgeColor', 'k');
end

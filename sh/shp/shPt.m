function ha = shPt(Pt, varargin)
% Show one point in the 2D or 3D in figure.
%
% Input
%   Pt       -  point position, d x n
%   varargin
%     show option
%     mk     -  marker, {'o'}
%     mkCl   -  marker color, {'y'}
%     mkSiz  -  size of markers, {5}
%     mkEg   -  flag of marker edge, {'y'} | 'n'
%     mkEgCl -  color of marker edge, {'none'}
%
% Output
%   h        -  figure content handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-03-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 02-20-2014

% show option
psSh(varargin);

% function option
mk = ps(varargin, 'mk', 'o');
mkCl = ps(varargin, 'mkCl', 'r');
mkClF = ps(varargin, 'mkClF', 'none');
mkSiz = ps(varargin, 'mkSiz', 6);
mkEgCl = ps(varargin, 'mkEgCl', 'none');
lnWid = ps(varargin, 'lnWid', 1);

% dimension
d = size(Pt, 1);

if d == 2
    ha.haPt = plot(Pt(1, :), Pt(2, :), mk, 'MarkerSize', mkSiz, 'color', mkCl, 'MarkerFaceColor', mkClF, 'linewidth', lnWid);
else
    ha.haPt = plot3(Pt(1, :), Pt(2, :), Pt(3, :), mk, 'MarkerSize', mkSiz, 'color', mkCl, 'MarkerFaceColor', mkClF, 'linewidth', lnWid);
end

% if isMkEg
%     set(ha.haPt, 'MarkerEdgeColor', 'k');
% end

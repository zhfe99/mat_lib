function shPtUpd(ha, Pt, varargin)
% Show one point in the 2-D figure.
%
% Input
%   ha      -  original figure content handle
%   Pt      -  point position, d x n
%   varargin
%     mk     -  marker, {'o'}
%     mkCl   -  marker color, {'y'}
%     mkSiz  -  size of markers, {5}
%     mkEg   -  flag of marker edge, {'y'} | 'n'
%     mkEgCl -  color of marker edge, {'none'}
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-03-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 2015-11

% dimension
d = size(Pt, 1);

% function option
mk = ps(varargin, 'mk', '');
mkCl = ps(varargin, 'mkCl', '');
mkClF = ps(varargin, 'mkClF', '');
mkSiz = ps(varargin, 'mkSiz', 0);

if d == 2
    set(ha.haPt, 'XData', Pt(1, :), 'YData', Pt(2, :));
else
    set(ha.haPt, 'XData', Pt(1, :), 'YData', Pt(2, :), 'ZData', Pt(3, :));
end

if ~isempty(mk)
    set(ha.haPt, 'marker', mk);
end
if ~isempty(mkClF)
    set(ha.haPt, 'markerfacecolor', mkClF);
end
if mkSiz > 0
    set(ha.haPt, 'MarkerSize', mkSiz);
end

function shMSeg(seg1, seg2, n1, n2, varargin)
% Show the segmentation in 2-D matrix.
%
% Input
%   seg1     -  1st segmentation
%   seg2     -  2nd segmentation
%   n1       -  length
%   n2       -  length
%   varargin
%     bdWid  -  line width (for boundary), {1}
%     bdCl   -  line color (for boundary), {[.5 .5 1]}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 09-11-2011
%   modify   -  Feng Zhou (zhfe99@gmail.com), 07-06-2014

% function option
bdWid = ps(varargin, 'bdWid', 1);
bdCl = ps(varargin, 'bdCl', [.5 .5 1]);

if bdWid == 0
    return;
end

% dimension
if isempty(seg1)
    m1 = 0;
else
    s1 = seg1.s;
    m1 = length(s1) - 1;
    n1 = s1(end) - 1;
end

if isempty(seg2)
    m2 = 0;
else
    s2 = seg2.s;
    m2 = length(s2) - 1;
    n2 = s2(end) - 1;
end

% plot segmentation boundary
hold on;

% horizontal
for i1 = 2 : m1
    plot([0 n2] + .5, [s1(i1) s1(i1)] - .5, '-', 'Color', bdCl, 'LineWidth', bdWid); 
end

% vertical    
for i2 = 2 : m2
    plot([s2(i2) s2(i2)] - .5, [0 n1] + .5, '-', 'Color', bdCl, 'LineWidth', bdWid);
end

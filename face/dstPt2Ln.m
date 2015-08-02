function d = dstPt2Ln(Pt, Lns)
% Compute the distance between one point and one line segment.
%
% Input
%   Pt      -  point, dim x nPt
%   Lns     -  line segment, dim x nEnd (default 2) x nPt
%
% Output
%   dst     -  distance
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-11-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[dim, nEnd, nPt] = size(Lns);

if nEnd ~= 2
    error('unsupported');
end

ds = zeros(1, nPt);
pt = zeros(3, 1);
Ln = zeros(3, 2);

for i = 1 : nPt
    pt(1 : dim) = Pt(:, i);
    Ln(1 : dim, :) = Lns(:, :, i);

    p = pt;
    q1 = Ln(:, 1);
    q2 = Ln(:, 2);
    ds(i) = norm(cross(q2 - q1, p - q1)) / norm(q2 - q1);
end
d = mean(ds);

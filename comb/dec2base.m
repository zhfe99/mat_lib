function [Vis, idx] = dec2base(dec, b, m)
% Convert decimal to specific base.
%
% Example
%   dec = 19, b = 3, m = 3  ->  Vis = [0, 1, 0; ...
%                                      1, 0, 0; ...
%                                      0, 0, 1];
%
% Input
%   dec     -  decimal value
%   b       -  numeric base
%   m       -  number of bits
%
% Output
%   Vis     -  binary matrix, b x m
%              each column has at most one element with one
%   idx     -  index vector, 1 x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-04-2015

Vis = zeros(b, m);
idx = zeros(1, m);

d = dec;
for i = 1 : m

    a = mod(d, b) + 1;
    idx(i) = a;
    Vis(a, i) = 1;

    d = floor(d / b);
end

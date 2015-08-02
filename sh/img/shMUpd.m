function shMUpd(h, M)
% Show matrix in 2-D space.
%
% Input
%   h       -  figure handle
%   F       -  image, h x w
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

set(h.M, 'CData', M);

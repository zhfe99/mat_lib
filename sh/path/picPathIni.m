function X = picPathIni(siz, n)
% Put picture on synthetic path.
%
% Input
%   siz     -  image size, 1 x 2
%   n       -  #images
%
% Output
%   X       -  position
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-27-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

w = siz(2);
X = [1 : w : ((n - 1) * w + 1); ...
     zeros(1, n)];

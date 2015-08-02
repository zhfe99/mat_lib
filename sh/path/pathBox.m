function Box = pathBox(X, angs, siz)
% Put image on the synthetic path.
%
% Input
%   X0      -  center, 2 x n
%   angs    -  angles, 1 x n
%   siz     -  size, 1 x 2
%
% Output
%   Box     -  image position, 3 x 2 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-27-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

h = siz(1);
w = siz(2);

n = length(angs);
Box = zeros(3, 2, n);
for i = 1 : n
    Box(1, 1, i) = X(1, i) - (w / 2) * cos(angs(i) / 180 * pi);
    Box(1, 2, i) = X(1, i) + (w / 2) * cos(angs(i) / 180 * pi);
    
    Box(2, 1, i) = X(2, i) - (w / 2) * sin(angs(i) / 180 * pi);
    Box(2, 2, i) = X(2, i) + (w / 2) * sin(angs(i) / 180 * pi);
    
    Box(3, 1, i) = 0;
    Box(3, 2, i) = h - 1;
end

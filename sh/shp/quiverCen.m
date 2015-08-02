function X = quiverCen(cen, angs, lens)
% Obtain the key points of one quiver with specific parameter.
%
% Input
%   cen     -  center cordinate, 2 x 1
%   angs    -  directions, 2 x 1
%   lens    -  length, 2 x 1
%
% Output
%   X       -  position of key points, 2 x 4
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-08-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

x0 = cen(1); y0 = cen(2);
angs = angs * pi / 180;
ang1 = angs(1); ang2 = angs(2);
len1 = lens(1); len2 = lens(2);

ang3 = pi / 2 - ang1 - ang2;
ang4 = ang1 - ang2;

x1 = x0 + len1 * cos(ang1);
y1 = y0 - len1 * sin(ang1);

x2 = x0 - len1 * cos(ang1);
y2 = y0 + len1 * sin(ang1);

x3 = x2 + len2 * sin(ang3);
y3 = y2 - len2 * cos(ang3);

x4 = x2 + len2 * cos(ang4);
y4 = y2 - len2 * sin(ang4); 

X = [x1 x2 x3 x4; ...
     y1 y2 y3 y4];

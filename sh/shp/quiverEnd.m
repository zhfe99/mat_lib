function X = quiverEnd(head, tail, ang, len)
% Obtain the key points of one quiver with specific parameter.
%
% Input
%   head    -  head of quiver, 2 x 1
%   tail    -  tail of quiver, 2 x 1
%   ang     -  direction
%   len     -  length
%
% Output
%   X       -  position of key points, 2 x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-09-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

ang1 = atan2(head(2) - tail(2), head(1) - tail(1));
ang2 = ang * pi / 180;
ang3 = pi / 2 - ang1 - ang2;
ang4 = pi / 2 - ang1 + ang2;

x2 = head(1); y2 = head(2);

x3 = x2 - len * sin(ang3);
y3 = y2 - len * cos(ang3);

x4 = x2 - len * sin(ang4);
y4 = y2 - len * cos(ang4); 

X = [x3 x4; ...
     y3 y4];

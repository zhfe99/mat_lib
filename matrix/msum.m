function M = msum(Ms)
% Matrix sum.
%
% Input
%   Ms      -  matrix set, 1 x m (cell), h x w
%
% Output
%   M       -  matrix, h x w
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-27-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-05-2013

M = Ms{1};
for i = 2 : length(Ms)
    M = M + Ms{i};
end
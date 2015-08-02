function l = binSearchL(as, c)
% Binary search the left boundary in an increasing array.
% such that
%   as(l) is the first element satisfying as(l) <= c
%
% Remark
%   The array could contain duplicated elements.
%
% Example 1
%   Input:  as = [1 1 3 4 4 10 19], c = 4
%   Call:   l = binSearchL(as, c)
%   Output: l = 4
%
% Example 2
%   Input:  as = [1 1 3 4 4 10 19], c = 5
%   Call:   l = binSearchL(as, c)
%   Output: l = 6
%
% Input
%   as      -  increasing array, 1 x n
%   c       -  value to match
%
% Output
%   l       -  left boundary
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 07-15-2014
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-15-2014

% dimension
n = length(as);

% search for the left boundary
i = 1;
j = n;
while i < j
    k = floor((i + j) / 2);
    if as(k) < c
        i = k + 1;
    else
        j = k;
    end
end
l = i;
% if as(i) == c
%     l = i;
% else
%     l = 0;
%     r = 0;
%     return;
% end

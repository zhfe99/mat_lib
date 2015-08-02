function r = binSearchR(as, c)
% Binary search the right boundary in an increasing array,
% such that
%   as(r) is the last element satisfying as(r) <= c
%
% Remark
%   The array could contain duplicated elements.
%
% Example 1
%   Input:  as = [1 1 3 4 4 10 19], c = 4
%   Call:   r = binSearchR(as, c)
%   Output: r = 5
%
% Example 2
%   Input:  as = [1 1 3 4 4 10 19], c = 5
%   Call:   r = binSearchR(as, c)
%   Output: r = 7
%
% Input
%   as      -  increasing array, 1 x n
%   c       -  value to match
%
% Output
%   l       -  left boundary
%   r       -  right boundary
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 07-15-2014
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-15-2014

% dimension
n = length(as);

% search for the right boundary
i = 1;
j = n;
while i < j
    k = floor((i + j) / 2);
    if as(k) <= c
        i = k + 1;
    else
        j = k;
    end
end
if as(i) == c
    r = i;
else
    r = i - 1;
end

function gaps = pathGap(X, amp, isEq)
% Put on the synthetic path.
%
% Input
%   X0      -  orginal position, 2 x n
%   X       -  synthetic path, 2 x n
%   s       -  original segmentation (for deciding the key frame in each segment), 1 x (m + 1)
%
% Output
%   angV    -  angle value, 1 x n
%   angP    -  relative position, 1 x n
%   pos     -  position
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-27-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

n = size(X, 2);
XD = diff(X, 1, 2);
gaps = sqrt(sum(XD .^ 2)) * amp;
if isEq
    gaps = zeros(1, n - 1) + mean(gaps);
end

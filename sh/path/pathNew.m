function [angs, idx, ang0s] = pathNew(X0, X, s)
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

% original path
[ang0s, mags] = derX(X0);

% synthetic path
angs = derX(X);

% direction
idx = findMaxMag(mags, s);
angs = angs - ang0s(idx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function idx = findMaxMag(mags, s, w)
% Find the most smooth point (with the maximum velocity) of a motion.
%
% Input
%   mags  -  magtitude of derivative, 1 x n
%   s     -  segmentation position, 1 x m 
%   w     -  band width, {5}
%
% Output
%   pos   -  new position, 1 x n

if ~exist('w', 'var')
    w = 5;
end

% dimension
n = length(mags);
m = length(s) - 1;
pos = zeros(1, m);

for iM = 1 : m
    velMax = 0; pos(iM) = s(iM);
    for i = s(iM) : s(iM + 1) - w
        head = i; tail = i + w - 1;
        vel = sum(mags(head : tail)) / w;
        if vel > velMax
            velMax = vel;
            pos(iM) = i + floor(w / 2);
        end
    end
end

blockP = frame2block(1 : n, s);
idx = pos(blockP);

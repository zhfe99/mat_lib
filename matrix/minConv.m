function mis = minConv(xs, wF, dire)
% Find the minimum value over a window.
%
% Input
%   xs      -  original values, 1 x nF
%   wF      -  window, 1 | 2 | 3 | ...
%   dire    -  direction, 'left' | 'right' | 'both'
%
% Output
%   mas     -  maximum values, 1 x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-10-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-05-2013

% dimension
nF = length(xs);

% index
cFs = 1 : nF;
Ran0 = vdoCacheIdx(cFs, nF, wF, dire);

% convole
mis = zeros(1, nF);
for iF = 1 : nF
    idx = Ran0(1, iF) : Ran0(2, iF);
    mis(iF) = min(xs(idx));
end

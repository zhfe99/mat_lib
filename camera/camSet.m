function [cams, cam0s] = camSet(tag)
% Select a specified set of camera.
%
% Input
%   tag     -  tag, 1 | 2
%
% Output
%   cams    -  camera, 1 x k (cell)
%   cam0s   -  camera, 1 x k0 (cell)
%   camss   -  camera array, 1 x m (cell), 1 x ni (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-13-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-23-2014

% camera array
if tag == 1
    r = 50; m = 8; nMa = 40;
    [camss, ns] = camArray(r, m, nMa);

elseif tag == 2
    r = 40; m = 8; nMa = 40;
    [camss, ns] = camArray(r, m, nMa);
    
else
    error('unknwon tag: %d', tag);
end

% dimension
m = length(camss);

% all cameras
c = 0;
for i = 1 : m
    ni = length(camss{i});
    for j = 1 : ni
        c = c + 1;
        I(:, c) = [i; j];
    end
end

k = size(I, 2);
cam0s = cell(1, k);
for c = 1 : k
    i = I(1, c);
    j = I(2, c);
    cam0s{c} = camss{i}{j};
end

% sub-set
if tag == 1 || tag == 2
    I = [m, m - 1, m - 2, 2; ...
         1,    10,    20, 1];

else
    error('unknown tag: %d', tag);
end

k = size(I, 2);
cams = cell(1, k);
for c = 1 : k
    i = I(1, c);
    j = I(2, c);
    cams{c} = camss{i}{j};
end

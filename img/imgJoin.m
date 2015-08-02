function F = imgJoin(dire, Fs, varargin)
% Joint image.
%
% Input
%   dire    -  direction, 'horz' | 'vert'
%   Fs      -  image stacks, 1 x m (cell)
%   varargin
%     seam  -  insert a seam between images, 'y' | {'n'}
%     cl    -  color of the seam, {0}
%     wid   -  width of the seam
%
% Output
%   F       -  jointed image
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-24-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-10-2013

% function option
isSeam = psY(varargin, 'seam', 'n');
cl = ps(varargin, 'cl', 0);
wid = ps(varargin, 'wid', 1);

% dimension
m = length(Fs);
[siz, nC] = imgInfo(Fs{1});

% index
[idxXs, idxYs] = cellss(1, m);
if strcmp(dire, 'horz')
    idxYs = vec2block(1 : siz(2), m);
    for i = 1 : m
        idxXs{i} = 1 : siz(1);
    end
elseif strcmp(dire, 'vert')

else
    error('unknown direction: %s', dire);
end

% put in one image
F = zeros(siz(1), siz(2), nC, 'uint8');
for iC = 1 : nC
    for i = 1 : m
        F(idxXs{i}, idxYs{i}, iC) = Fs{i}(idxXs{i}, idxYs{i}, iC);
    end
end

% add seam
if isSeam
    for i = 1 : m - 1
        F(idxXs{i}, idxYs{i}(end - wid + 1 : end), :) = cl;
    end
end
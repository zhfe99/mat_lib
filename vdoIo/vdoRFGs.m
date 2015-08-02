function Fs = vdoRFGs(hr, pFs, siz)
% Read a sequence of frames.
%
% Input
%   hr      -  video handle
%   pFs     -  frame index, 1 x m (cell)
%   siz     -  size, [] | 1 x 2
%
% Output
%   Fs      -  frame set, 1 x m (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-24-2013

% dimension
nF = length(pFs);

% read frames
Fs = zeros(siz(1), siz(2), nF, 'uint8');
prCIn('vdoRFGs', nF, .1);
for iF = 1 : nF
    prC(iF);

    F0 = vdoR(hr, pFs(iF));
    F0 = rgb2gray(F0);
    Fs(:, :, iF) = imresize(F0, siz);
end
prCOut(nF);

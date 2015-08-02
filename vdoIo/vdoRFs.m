function Fs = vdoRFs(hr, pFs, siz)
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
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-17-2013

% dimension
nF = hr.nF;
m = length(pFs);

% read frames
Fs = cell(1, m);
prCIn('vdoRFs', m, .1);
for iF = 1 : m
    prC(iF);
    pF = pFs(iF);

    if pF < 1 || pF > nF
        continue;
    end

    %% read
    F = vdoR(hr, pF);

    %% resize
    if exist('siz', 'var') && ~isempty(siz)
        F = imresize(F, siz);
    end

    %% store
    Fs{iF} = F;
end
prCOut(m);

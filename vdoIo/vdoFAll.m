function Fs = vdoFAll(hr)
% Read all frames from a video source.
%
% Input
%   fpath   -  video path or a video handle
%
% Output
%   Fs      -  frame set, 1 x nF (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-06-2013

prIn('vdoFAll');

% dimension
nF = hr.nF;
Fs = cell(1, nF);

% read all frames
prCIn('frame', nF, .1);
for iF = 1 : nF
    prC(iF);

    Fs{iF} = vdoR(hr, iF);

    % end of the video
    if isempty(Fs{iF})
        Fs(iF : end) = [];
        break;
    end
end
prCOut(nF);

% close
vdoROut(hr);

prOut;

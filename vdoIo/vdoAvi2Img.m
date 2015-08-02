function vdoAvi2Img(hr, imgFold, pFs, pathform, fps, siz)
% Convert an image sequence to a AVI file.
%
% Input
%   hr        -  handle to the original sequence
%   imgFold   -  fold to save image file
%   pFs       -  index of frams to read, 1 x nF
%   pathform  -  form of image, 'frame_%04d.jpg' | [] | ...
%   fps       -  frame rate, 30 | [] | ...
%   siz       -  image size, [] | 1 x 2
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify    -  Feng Zhou (zhfe99@gmail.com), 07-15-2014

prIn('vdoAvi2Img');

% input video
[nF0, fps0, siz0] = stFld(hr, 'nF', 'fps', 'siz');

% #frame index
if isempty(pFs)
    pFs = 1 : nF0;
end
nF = length(pFs);

% frame rate
if isempty(fps)
    fps = fps0;
end

% new size
if ~exist('siz', 'var') || isempty(siz)
    siz = siz0;
    isNewSiz = 0;
else
    isNewSiz = 1;
end

% frame index
idx = 0 : nF - 1;

% image name format
if isempty(pathform)
    pathform = 'frame_%04d.jpg';
end
    
% info
infoPath = sprintf('%s/info.mat', imgFold);

% fold
reMkdir(imgFold);
save(infoPath, 'nF', 'siz', 'fps', 'pathform', 'idx');

% each frame
prCIn('frame', nF, .1);
for iF = 1 : nF
    prC(iF);
    pF = pFs(iF);

    % original image
    F = vdoR(hr, pF);
    
    % new size
    if isNewSiz
        F = imresize(F, siz);
    end
    
    imgPath = sprintf(['%s/' pathform], imgFold, iF - 1);
    imwrite(F, imgPath);
end
prCOut(nF);

prOut;

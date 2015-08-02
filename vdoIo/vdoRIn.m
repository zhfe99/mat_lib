function hr = vdoRIn(fpath, varargin)
% Create a video handler for reading.
%
% Input
%   fpath    -  video path or frame set
%   varargin
%     comp   -  compressing mode, {'vdo'} | 'img' | 'mat' | 'qkr' | 'mcv' | 'frs'
%     form   -  format, {'uint8'} | 'double'
%     cl     -  color, {'rgb'} | 'gray'
%
% Output
%   hr
%     vdo    -  video handler
%     comp   -  compressing mode
%     fpath  -  video path
%     siz    -  size, [height, width]
%     fps    -  fps
%     nF     -  #frames
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 06-17-2015

% function option
comp = ps(varargin, 'comp', 'vdo');
form = ps(varargin, 'form', 'uint8');
cl = ps(varargin, 'cl', 'rgb');

% VideoReader
if strcmp(comp, 'vdo')
    %% path
    if ~exist(fpath, 'file')
        error('File does not exist: %s', fpath);
    end

    %% store info
    hr.vdo = VideoReader(fpath);
    nF = hr.vdo.NumberOfFrames;
    siz = [hr.vdo.Height, hr.vdo.Width];
    fps = round(hr.vdo.FrameRate);

% image or mat sequence
elseif strcmp(comp, 'img') || strcmp(comp, 'mat')
    %% path
    if strcmp(fpath(end - 2 : end), 'avi')
        fpath = fpath(1 : end - 4);
    end
    if ~exist(fpath, 'dir')
        error('Fold does not exist: %s', fpath);
    end

    %% store info
    infopath = sprintf('%s/info.mat', fpath);
    [nF, siz, fps, pathform, idx] = matFld(infopath, 'nF', 'siz', 'fps', 'pathform', 'idx');
    hr.pathform = pathform;
    hr.idx = idx;

% kinect image sequence
elseif strcmp(comp, 'kin')
    %% path
    if strcmp(fpath(end - 2 : end), 'avi')
        fpath = fpath(1 : end - 4);
    end
    if ~exist(fpath, 'dir')
        error('Fold does not exist: %s', fpath);
    end

    %% store info
    infopath = sprintf('%s/info.mat', fpath);
    [nF, sizD, sizC, fps, pathformD, pathformC, idx] = matFld(infopath, 'nF', 'sizD', 'sizC', 'fps', 'pathformD', 'pathformC', 'idx');
    hr.pathformD = pathformD;
    hr.pathformC = pathformC;
    hr.sizD = sizD;
    hr.sizC = sizC;
    siz = sizC;
    hr.idx = idx;

% qkr sequence (for optical flow)
elseif strcmp(comp, 'qkr')

    %% path
    if strcmp(fpath(end - 2 : end), 'avi')
        fpath = fpath(1 : end - 4);
    end
    if ~exist(fpath, 'dir')
        error('Fold does not exist: %s', fpath);
    end

    %% store info
    infopath = sprintf('%s/info.mat', fpath);
    [nF, siz, fps, pathformX, pathformY, idx] = matFld(infopath, 'nF', 'siz', 'fps', 'pathformX', 'pathformY', 'idx');
    hr.pathformX = pathformX;
    hr.pathformY = pathformY;
    hr.idx = idx;

% opencv
elseif strcmp(comp, 'mcv')
    [hr.vdo, nF, w, h, fps] = mcvVReader(fpath);
    siz = [h, w];
    fps = round(fps);

% frame
elseif strcmp(comp, 'frs')
    hr.Fs = fpath;
    siz = imgInfo(hr.Fs{1});
    nF = length(hr.Fs);
    fps = 30;
    fpath = 'non';

else
    error('unknown comp: %s', comp);
end

% print information
prIn('vdoRIn', '%s', fpath);
pr('nF %d, siz %d x %d, fps %d, comp %s, form %s, cl %s', ...
   nF, siz(1), siz(2), fps, comp, form, cl);

% store
hr.comp = comp;
hr.fpath = fpath;
hr.nF = nF;
hr.siz = siz;
hr.fps = fps;
hr.form = form;
hr.cl = cl;

prOut;

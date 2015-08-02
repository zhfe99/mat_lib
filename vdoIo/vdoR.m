function [F, F2] = vdoR(hr, iF, nm)
% Read frame from video.
%
% Input
%   hr      -  video handler
%   iF      -  frame index
%   nm      -  name, only used if video is a mat file
%
% Output
%   F       -  frame, h x w x 3 (uint8) | h x w (double) | h x w (uint8)
%   F2      -  only used when nm == 'kin'
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-19-2014

% specified in addPath.m
% global footpath;

% VideoReader
if strcmp(hr.comp, 'vdo')
    F = read(hr.vdo, iF);

elseif strcmp(hr.comp, 'img')
    imgpath = sprintf(['%s/' hr.pathform], hr.fpath, hr.idx(iF));
    % imgpath = sprintf(['%s/%s/' hr.pathform], footpath, hr.fpath, hr.idx(iF));
    F = imread(imgpath);

elseif strcmp(hr.comp, 'mat')
    matpath = sprintf(['%s/' hr.pathform], hr.fpath, hr.idx(iF));
    F = load(matpath);

    if exist('nm', 'var') && ~isempty(nm)
        F = F.(nm);
    end
    
elseif strcmp(hr.comp, 'kin')
    imgpathC = sprintf(['%s/' hr.pathformC], hr.fpath, hr.idx(iF));
    F = imread(imgpathC);

    imgpathD = sprintf(['%s/' hr.pathformD], hr.fpath, hr.idx(iF));
    F2 = imread(imgpathD);

elseif strcmp(hr.comp, 'qkr')
    qkrPathX = sprintf(['%s/' hr.pathformX], hr.fpath, hr.idx(iF));
    qkrPathY = sprintf(['%s/' hr.pathformY], hr.fpath, hr.idx(iF));
    X = read_qkimage_raw_data(qkrPathX);
    Y = read_qkimage_raw_data(qkrPathY);

    %% re-size
    if size(X, 1) ~= hr.siz(1) || size(X, 2) ~= hr.siz(2)
        X = imresize(X, hr.siz);
        Y = imresize(Y, hr.siz);
    end

    %% store
    F.VX = X;
    F.VY = Y;

% OpenCV
elseif strcmp(hr.comp, 'mcv')
    F = mcvVReader(hr.vdo);
    
% frame set
elseif strcmp(hr.comp, 'frs')
    F = hr.Fs{iF};
end

% uint8 -> double
if strcmp(hr.form, 'double')
    F = im2double(F);
end

% rgb -> gray
if strcmp(hr.cl, 'gray')
    F = rgb2gray(F);
end

% post-processing
if isfield(hr, 'post') && strcmp(hr.post, 'grbg')
    F = demosaic(F, 'grbg');
end

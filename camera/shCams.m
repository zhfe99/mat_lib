function Ps = shCams(cams, varargin)
% Show multiple camera.
%
% Input
%   cams    -  camera, 1 x m (cell)
%   Cord    -  mocap data
%   varargin
%     sca   -  scale, {5}
%     lnCl  -  color of line, {'k'}
%     feCl  -  color of face, {'k'}
%     ang   -  viewpoint angle, {[]}
%
% Output
%   Ps      -  camera coordinates
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-13-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 11-03-2013

% show option
psSh(varargin);

% function option
sca = ps(varargin, 'sca', 5);
lnCl = ps(varargin, 'lnCl', 'k');
lnWid = ps(varargin, 'lnWid', 1);
feCl = ps(varargin, 'feCl', 'k');
ang = ps(varargin, 'ang', []);

% dimension
m = length(cams);

% each camera
hold on;
Ps = cellss(1, m);
for i = 1 : m
    [~, Ps{i}] = shCam(cams{i}, 'sca', sca, 'lnCl', lnCl, 'feCl', feCl, 'lnWid', lnWid);
end

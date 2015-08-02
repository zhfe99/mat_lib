function setCamBox(Ps, Cord, varargin)
% Set position of camera.
%
% Input
%   Ps      -  camera position, 1 x nCam (cell), 5 x 3
%   Cord    -  3D position, 3 x kJ x nF
%   varargin
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-13-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 12-22-2013

% set bounding box of the camera
P = cat(1, Ps{:})';
if ~isempty(Cord)
    P = [P, reshape(Cord, 3, [])];
end

box = xBox(P([1 3 2], :), st('mar', .1));
setAx(box, []);
axis off;

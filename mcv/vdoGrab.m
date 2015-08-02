function F = vdoGrab(fig)
% Capture current frame.
%
% Input
%   fig     -  figure
%
% Output
%   F       -  frame
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 01-29-2014

% make sure the figures units are in pixels
oldUnits = get(fig, 'Units');
set(fig, 'Units', 'pixels');
unitCleanup = onCleanup(@()set(fig, 'Units', oldUnits));

pixelsperinch = get(0, 'screenpixelsperInch');
pos = get(fig, 'position');
set(fig, 'paperposition', pos ./ pixelsperinch);

% render
renderer = get(fig, 'renderer');
if strcmp(renderer, 'painters')
    renderer = 'opengl';
end

% Turn off warning in case opengl is not supported and
% hardcopy needs to use zbuffer
warnstate = warning('off', 'MATLAB:addframe:warningsTurnedOff');
warnCleanup = onCleanup(@()warning(warnstate));

% grap the frame
% F = getframe(gcf);

% more fast, but will crash sometimes
frame = hardcopy(fig, ['-d' renderer], ['-r' num2str(round(pixelsperinch))]);
F.cdata = frame;
F.colormap = [];

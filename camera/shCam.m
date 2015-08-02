function [P, P1] = shCam(cam, varargin)
% Plot a camera.
%
% Input
%   cam     -  camera
%     R     -  rotation
%     t     -  translation
%   varargin
%     sca   -  scale, {5}
%     lnCl  -  color of line, {'k'}
%     feCl  -  color of face, {'k'}
%     gt    -  face, {0}
%
% Output
%   P       -  camera at the center of world, 3 x 5
%   P1      -  coordinate of the camera, 3 x 5
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-13-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 12-22-2013

% show option
psSh(varargin);

% function option
sca = ps(varargin, 'sca', 5);
lnCl = ps(varargin, 'lnCl', 'k');
lnWid = ps(varargin, 'lnWid', 1);
feCl = ps(varargin, 'feCl', 'k');
gt = ps(varargin, 'gt', 0);

% camera
[R, t] = stFld(cam, 'R', 't');

P = sca * [   0    0   0; ...
            0.5  0.5 0.8; ...
            0.5 -0.5 0.8; ...
           -0.5  0.5 0.8; ...
           -0.5 -0.5 0.8]';

P1 = R' * P - repmat(t, [1, 5]);
P1 = P1';
maxp = max(max(P1));
% axis(2 * [-maxp maxp -maxp maxp -maxp maxp]);

% draw face
if ~gt
    line([P1(1, 1), P1(2, 1)], [P1(1, 3), P1(2, 3)], [P1(1, 2), P1(2, 2)], 'color', lnCl, 'lineWidth', lnWid);
    line([P1(1, 1), P1(3, 1)], [P1(1, 3), P1(3, 3)], [P1(1, 2), P1(3, 2)], 'color', lnCl, 'lineWidth', lnWid);
    line([P1(1, 1), P1(4, 1)], [P1(1, 3), P1(4, 3)], [P1(1, 2), P1(4, 2)], 'color', lnCl, 'lineWidth', lnWid);
    line([P1(1, 1), P1(5, 1)], [P1(1, 3), P1(5, 3)], [P1(1, 2), P1(5, 2)], 'color', lnCl, 'lineWidth', lnWid);
    line([P1(2, 1), P1(3, 1)], [P1(2, 3), P1(3, 3)], [P1(2, 2), P1(3, 2)], 'color', lnCl, 'lineWidth', lnWid);
    line([P1(3, 1), P1(5, 1)], [P1(3, 3), P1(5, 3)], [P1(3, 2), P1(5, 2)], 'color', lnCl, 'lineWidth', lnWid);
    line([P1(5, 1), P1(4, 1)], [P1(5, 3), P1(4, 3)], [P1(5, 2), P1(4, 2)], 'color', lnCl, 'lineWidth', lnWid);
    line([P1(4, 1), P1(2, 1)], [P1(4, 3), P1(2, 3)], [P1(4, 2), P1(2, 2)], 'color', lnCl, 'lineWidth', lnWid);

    cameraPlane = [P1(2, 1) P1(2, 3) P1(2, 2); ...
                   P1(4, 1) P1(4, 3) P1(4, 2); ...
                   P1(3, 1) P1(3, 3) P1(3, 2); ...
                   P1(5, 1) P1(5, 3) P1(5, 2)];
    faces = [2 1 3 4];
    egCl = feCl;
    patch('Vertices', cameraPlane, 'Faces', faces, 'FaceVertexCData', hsv(6), 'FaceColor', feCl, 'FaceAlpha', 0.1, 'EdgeColor', egCl, 'lineWidth', lnWid);
    
else
    line([P1(1, 1), P1(2, 1)], [P1(1, 3), P1(2, 3)], [P1(1, 2), P1(2, 2)], 'color', 'k', 'LineStyle', '--');
    line([P1(1, 1), P1(3, 1)], [P1(1, 3), P1(3, 3)], [P1(1, 2), P1(3, 2)], 'color', 'k', 'LineStyle', '--');
    line([P1(1, 1), P1(4, 1)], [P1(1, 3), P1(4, 3)], [P1(1, 2), P1(4, 2)], 'color', 'k', 'LineStyle', '--');
    line([P1(1, 1), P1(5, 1)], [P1(1, 3), P1(5, 3)], [P1(1, 2), P1(5, 2)], 'color', 'k', 'LineStyle', '--');
    line([P1(2, 1), P1(3, 1)], [P1(2, 3), P1(3, 3)], [P1(2, 2), P1(3, 2)], 'color', 'k', 'LineStyle', '--');
    line([P1(3, 1), P1(5, 1)], [P1(3, 3), P1(5, 3)], [P1(3, 2), P1(5, 2)], 'color', 'k', 'LineStyle', '--');
    line([P1(5, 1), P1(4, 1)], [P1(5, 3), P1(4, 3)], [P1(5, 2), P1(4, 2)], 'color', 'k', 'LineStyle', '--');
    line([P1(4, 1), P1(2, 1)], [P1(4, 3), P1(2, 3)], [P1(4, 2), P1(2, 2)], 'color', 'k', 'LineStyle', '--');

%     cameraPlane =[P1(2,1) P1(2,3) P1(2,2);  P1(4,1) P1(4,3) P1(4,2); P1(3,1) P1(3,3) P1(3,2);P1(5,1) P1(5,3) P1(5,2)];
%     faces =[2 1 3 4];
%     patch('Vertices',cameraPlane,'Faces',faces,'FaceVertexCData',hsv(6),'FaceColor','k','FaceAlpha',0.05);
end

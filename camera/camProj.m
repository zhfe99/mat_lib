function [PC, QCR] = camProj(QC, cam)
% Project a mocap data to 2-D.
%
% Input
%   QC      -  coordinate in 3-D, 3 x kJ x nF
%   cam     -  camera
%     R     -  rotation
%     t     -  translation
%
% Output
%   PC      -  coordinate in 2-D, 2 x kJ x nF
%   QCR     -  rotated coordinate in 3-D, 3 x kJ x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-13-2013
%   modify  -  Feng Zhou (zhfe99@gmail.com), 12-29-2013

% dimension
[~, kJ, nF] = size(QC);

% camera
[R, t] = stFld(cam, 'R', 't');

% 3D-2D projection
M = [R(1, :); R(2, :); zeros(1, 3)];
taff = [t(1); t(2); 1];

% each frame
PC = zeros(2, kJ, nF);
QCR = zeros(3, kJ, nF);
for iF = 1 : nF
    QCi = QC(:, :, iF);
    
    %% rotate in 3d
    QCR(:, :, iF) = R' * QCi - repmat(t, 1, kJ);
        
    %% project in 2d
    PC(:, :, iF) = M(1 : 2, :) * QCi + repmat(taff(1 : 2), [1 kJ]);
end

function [Agn, A] = aliFaceLM(Trk, meS, par)
% Align face landmarks to the mean shape.
%
% Input
%   Trk     -  tracking points, 132 x nF
%   meS     -  mean for tracking points, 132 x 1
%   par     -  parameter
%     alg   -  transformation type, {'aff'} | 'pro'
%     part  -  part of face used to compute the transformation, {'noseA3'}
%
% Output
%   Agn     -  aligned tracking points, 132 x nF
%   A       -  transformation matrix, 3 x 3 x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-22-2013

% function option
alg = ps(par, 'alg', 'aff');
part = ps(par, 'part', 'noseA3');

nF = size(Trk, 2);

% points with which to align each frame to subject mean
idx = indFaceLM(part);
Agn = zeros(132, nF);
As = zeros(3, 3, nF);

xyM = reshape(meS, [], 2);
xyMA = xyM(idx, :);

% affine
if strcmp(alg, 'aff')
    for iF = 1 : nF
        xy = reshape(Trk(:, iF), [], 2);
        xyA = xy(idx, :);

        %% transformation
        [Z, A] = mkaffine(xyA, xyMA);

        %% new coordinate
        xyNew = xy * A(1 : 2, 1 : 2)' + repmat(A(1 : 2, 3)', 66, 1);
        Agn(:, iF) = xyNew(:);
        As(:, :, iF) = A;
    end
    A = As;

% procusters
elseif strcmp(alg, 'pro')

    for iF = 1 : nF
        xy = reshape(Trk(:, iF), [], 2);
        xyA = xy(idx, :);

        %% procrustes
        [~, ~, transform] = procrustes(xyMA, xyA);
        A = zeros(3, 3);
        A(1 : 2, 1 : 2) = (transform.T * transform.b)';
        A(1 : 2, 3) = transform.c(1, :)';

        %% new coordinate
        xyNew = xy * A(1 : 2, 1 : 2)' + repmat(A(1 : 2, 3)', 66, 1);
        Agn(:, iF) = xyNew(:);
        As(:, :, iF) = A;
    end
    A = As;

else
    error('unknown algorithm');
end

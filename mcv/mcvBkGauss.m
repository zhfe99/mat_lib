function [areas, VHs, VIs, VJs] = mcvBkGauss(hr, parFlow, parImg)
% Obtain the optical flow for each frame of the specified video.
%
% Input
%   hr       -  video handle
%   parFlow  -  flow parameter
%     Siz    -  size, 2 x nH, {[2 4; 2 4]}
%     nB     -  #bins, {4}
%     win    -  window size, {2}
%     sig    -  sigma, {2}
%
% Output
%   areas    -  area position, 1 x nH (cell), see function areaDiv for more details
%   VHs      -  optical flow histogram, 1 x nH (cell), Siz(1, iH) x Siz(2, iH) x nB x nF
%   VIs      -  optical flow in column (y) direction, 1 x nH (cell), Siz(1, iH) x Siz(2, iH) x nF
%   VJs      -  optical flow in row (x) direction, 1 x nH (cell), Siz(1, iH) x Siz(2, iH) x nF
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 06-20-2013

% function parameter
Siz = ps(parFlow, 'Siz', [2 4; 2 4]);
nB = ps(parFlow, 'nB', 4);
win = ps(parFlow, 'win', 2);
sig = ps(parFlow, 'sig', 2);

% dimension
nH = size(Siz, 2);
siz = hr.siz; siz = siz(:);
Siz = [Siz, siz];
nF = hr.nF;

% bin position
areas = areaDiv(Siz);
[VHs, VIs, VJs] = cellss(1, nH);
for c = 1 : nH
    VHs{c} = zeross(Siz(1, c), Siz(2, c), nB, nF);
    [VIs{c}, VJs{c}] = zeross(Siz(1, c), Siz(2, c), nF);
end

Fs = zeros(siz(1), siz(2), 2);
prIn(1);
for iF = 2 : nF
    prCo(iF - 1, nF - 1, .01);

    % index
    iFCurr = mod(iF - 1, 2) + 1;
    iFLast = mod(iF, 2) + 1;

    % read
    F0 = vRead(hr, iF);

    % blur
    F = imgBlur(F0, parImg);
    Fs(:, :, iFCurr) = F;

    % optical flow
    [VJ, VI] = optFlowLk(Fs(:, :, iFLast), Fs(:, :, iFCurr), [], win, sig, 3e-6);

    % histogram
    for c = nH : -1 : 1
        if c == nH
            VIs{c}(:, :, iF) = areaAve(VI, areas{c});
            VJs{c}(:, :, iF) = areaAve(VJ, areas{c});
            VHs{c}(:, :, :, iF) = areaHst(VI, VJ, areas{c}, nB);
        else
            VIs{c}(:, :, iF) = areaAve(VIs{c + 1}(:, :, iF), areas{c});
            VJs{c}(:, :, iF) = areaAve(VJs{c + 1}(:, :, iF), areas{c});
            for iB = 1 : nB
                VHs{c}(:, :, iB, iF) = areaAve(VHs{c + 1}(:, :, iB, iF), areas{c});
            end
        end
    end
end
prIn(0);

% first frame
for c = 1 : nH
    VIs{c}(:, :, 1) = VIs{c}(:, :, 2);
    VJs{c}(:, :, 1) = VJs{c}(:, :, 2);
    VHs{c}(:, :, :, 1) = VHs{c}(:, :, :, 2);
end

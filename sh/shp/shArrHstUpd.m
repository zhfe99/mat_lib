function shArrHstUpd(ha, Hst, varargin)
% Show directional bins
%
% Input
%   XI      -  center position in i axis, h x w
%   XJ      -  center position in j axis, h x w
%   Hst     -  histogram, h x w x nB
%   varargin
%     show option
%     bk    -  flag of plotting background, 'y' | {'n'}
%     maL   -  maximum length, {[]}
%
% Output
%   h       
%     hVs   -  flow handler, h x w x nB (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
[h, w, nB] = size(Hst);

% flow
arrAng = linspace(-pi, pi, nB + 1) + pi / nB;
arrAng(end) = [];
for i = 1 : h
    for j = 1 : w
        hst = Hst(i, j, :);
        hst = ha.maL * hst / (sqrt(sum(hst(:) .^ 2)) + eps);

        arrJs = cos(arrAng) .* hst(:)';
        arrIs = sin(arrAng) .* hst(:)';
        for iB = 1 : nB
            set(ha.HV{i, j, iB}, 'XData', [0, arrJs(iB)] + ha.XJ(i, j), 'YData', [0, arrIs(iB)] + ha.XI(i, j));
        end
    end
end

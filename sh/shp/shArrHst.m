function ha = shArrHst(XI, XJ, Hst, varargin)
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
%   ha      
%     hVs   -  flow handler, h x w x nB (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
maL = ps(varargin, 'maL', []);
isBk = psY(varargin, 'bk', 'y');

% dimension
[h, w, nB] = size(Hst);

hold on;

% maximum length
if isempty(maL)
    maL = .9 * min(abs(XI(1, 1) - XI(2, 1)), abs(XJ(1, 1) - XJ(1, 2))) / 2;
end

% background
if isBk
    % circle
    cirCl = [1 1 1] * .4;
    cirAng = linspace(-pi, pi, 100);
    cirIs = sin(cirAng) * maL;
    cirJs = cos(cirAng) * maL;

    % ring
    rinCl = [1 1 1] * .4;
    rinAng = linspace(-pi, pi, nB + 1);
    rinAng(end) = [];
    rinIs = sin(rinAng) * maL;
    rinJs = cos(rinAng) * maL;

    for i = 1 : h
        for j = 1 : w
            plot(cirJs + XJ(i, j), cirIs + XI(i, j), '-', 'LineWidth', 1, 'Color', cirCl);
            for iB = 1 : nB
                plot([0, rinJs(iB)] + XJ(i, j), [0, rinIs(iB)] + XI(i, j), '--', 'LineWidth', 1, 'Color', rinCl);
            end
        end
    end
end

% flow
HV = cell(h, w, nB);
arrCl = 'y';
arrAng = linspace(-pi, pi, nB + 1) + pi / nB;
arrAng(end) = [];
for i = 1 : h
    for j = 1 : w
        hst = Hst(i, j, :);
        hst = maL * hst / (sqrt(sum(hst(:) .^ 2)) + eps);

        arrJs = cos(arrAng) .* hst(:)';
        arrIs = sin(arrAng) .* hst(:)';
        for iB = 1 : nB
            HV{i, j, iB} = plot([0, arrJs(iB)] + XJ(i, j), [0, arrIs(iB)] + XI(i, j), '-', 'LineWidth', 1, 'Color', arrCl);
        end
    end
end

% store
ha.XI = XI;
ha.XJ = XJ;
ha.HV = HV;
ha.maL = maL;

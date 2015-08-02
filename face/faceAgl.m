function wsAgl = faceAgl(src, wsRg, wsPath, varargin)
% Extract the angle feature of each frame.
%
% Input
%   src       -  nsf source
%   wsRg      -  shape data
%   wsPath    -  path to save
%   varargin
%     savL    -  save level, {2}
%
% Output
%   wsAgl
%     aglNms  -  feature names, 1 x nA (cell)
%     Agl     -  angle feature, nA x nF
%     Agl0    -  angle feature, nA x nF
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 03-07-2010
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
savL = ps(varargin, 'savL', 2);

% load
if savL == 2 && exist(wsPath.agl, 'file')
    prom('m', 'old %s agl: %s\n', src.magic, src.subNm);
    wsAgl = matFld(wsPath.agl, 'wsAgl');
    return;
end
prom('m', 'new %s agl: %s\n', src.magic, src.subNm);

% shape
[nF, Agn] = stFld(wsRg, 'nF', 'Agn');

% position
MouTwoIdx = [49, 49, 49; ...
             51, 59, 51; ...
             61, 66, 59; ...
             55, 55, 55; ...
             53, 57, 53; ...
             63, 64, 57];
mouTwoNms = {'mouUp', 'mouDw', 'mouAll'};

% extract
Idxs = {MouTwoIdx};
m = length(Idxs);
nPs = cellDim(Idxs, 2);
Agls = cell(1, m);

for i = 1 : m
    Idx = Idxs{i};
    Agls{i} = zeros(nPs(i), nF);
    for iP = 1 : nPs(i)
        for iF = 1 : nF
            xy1 = Agn([0, 66] + Idx(1, iP), iF);
            xy2 = Agn([0, 66] + Idx(2, iP), iF);
            xy3 = Agn([0, 66] + Idx(3, iP), iF);
            a = norm(xy1 - xy2);
            b = norm(xy1 - xy3);
            c = norm(xy2 - xy3);
            aglL = acos((a * a + b * b - c * c) / (2 * a * b));
            
            if size(Idx, 1) > 2
                xy1 = Agn([0, 66] + Idx(4, iP), iF);
                xy2 = Agn([0, 66] + Idx(5, iP), iF);
                xy3 = Agn([0, 66] + Idx(6, iP), iF);
                a = norm(xy1 - xy2);
                b = norm(xy1 - xy3);
                c = norm(xy2 - xy3);
                aglR = acos((a * a + b * b - c * c) / (2 * a * b));

                aglL = (aglL + aglR) / 2;
            end
        
            Agls{i}(iP, iF) = aglL;
        end
    end
end
Agl = cat(1, Agls{:});

% normalization
Agl = Agl - repmat(Agl(:, 1), 1, nF);

% store
wsAgl.nms = cellCate(mouTwoNms);
wsAgl.Agl = Agl;

% save
if savL > 0
    save(wsPath.agl, 'wsAgl');
end

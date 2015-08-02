function wsDst = faceDst(src, wsRg, wsPath, varargin)
% Extract the distance feature from face image.
%
% Input
%   src      -  face source
%   wsRg     -  shape data
%   wsPath   -  path to save
%   varargin
%     savL   -  save level, {2}
%
% Output
%   wsDst
%     Dst    -  distance feature, nD x nF
%     nms    -  feature names, 1 x nD (cell)
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 03-07-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
savL = ps(varargin, 'savL', 2);

% load
if savL == 2 && exist(wsPath.dst, 'file')
    prom('m', 'old %s dst: %s\n', src.magic, src.subNm);
    wsDst = matFld(wsPath.dst, 'wsDst');
    return;
end
prom('m', 'new %s dst: %s\n', src.magic, src.subNm);

% shape
[nF, Agn] = stFld(wsRg, 'nF', 'Agn');

nms  = {'browIn', 'browOut', 'eyeHei', 'lipHei', 'lipWid', 'lipGap', 'teeHei'};
algs = { 'Pt2Ln',   'Pt2Ln',  'Pt2Pt',  'Pt2Pt',  'Pt2Pt',  'Pt2Ln',  'Pt2Pt'};
nD = length(nms);
Idx = cell(2, nD);
base = 0;

% eyebrow inner
base = base + 1;
Idx{1, base} = [22, 23];
Idx{2, base} = [37, 43; ...
                40, 46];

% eyebrow outer
base = base + 1;
Idx{1, base} = [18, 27];
Idx{2, base} = [37, 43; ...
                40, 46];

% eye height
base = base + 1;
Idx{1, base} = [38; 39; 44; 45];
Idx{2, base} = [42; 41; 48; 47];

% lip height
base = base + 1;
Idx{1, base} = [51; 52; 53];
Idx{2, base} = [59; 58; 57];

% lip width
base = base + 1;
Idx{1, base} = 49;
Idx{2, base} = 55;

% lip gap
base = base + 1;
Idx{1, base} = [49, 55];
Idx{2, base} = [37, 43; ... 
                40, 46];

% teeth height
base = base + 1;
Idx{1, base} = [61; 62; 63];
Idx{2, base} = [66; 65; 64];

% extract
Dst = zeros(nD, nF);
for iD = 1 : nD
    idx1 = Idx{1, iD};
    idx2 = Idx{2, iD};

    % point to point
    if strcmp(algs{iD}, 'Pt2Pt')    
        for iF = 1 : nF
            Pt1 = [Agn(idx1, iF)'; Agn(idx1 + 66, iF)'];
            Pt2 = [Agn(idx2, iF)'; Agn(idx2 + 66, iF)'];
            Dst(iD, iF) = dstPt2Pt(Pt1, Pt2);
        end

    % point to line segment
    elseif strcmp(algs{iD}, 'Pt2Ln') 
        nPt = length(idx1);
        for iF = 1 : nF
            Pt = [Agn(idx1, iF)'; Agn(idx1 + 66, iF)'];
            Lns = zeros(2, 2, nPt);
            for iPt = 1 : nPt
                Lns(:, :, iPt) = [Agn(idx2(:, iPt), iF)'; Agn(idx2(:, iPt) + 66, iF)'];
            end
            Dst(iD, iF) = dstPt2Ln(Pt, Lns);
        end
    else
        error('unknown algorithm');
    end
end

% normalization
Dst0 = Dst;
for iD = 1 : nD
    if strcmp(nms{iD}, 'teeHei')
        Dst(iD, :) = Dst0(iD, :) / Dst0(4, 1);
    else
        Dst(iD, :) = Dst0(iD, :) / Dst0(iD, 1);
    end
end

% store
wsDst.nms = nms;
wsDst.Dst = Dst;

% save
if savL > 0
    save(wsPath.dst, 'wsDst');
end

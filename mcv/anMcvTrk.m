function anMcvTrk(Trk, Vis, inPath, outPath, varargin)
% Animate the multiple tracking points for MED data.
%
% Input
%   src      -  med src
%   wsTrk    -  tracking data
%   varargin
%     save option
%     parIn  -  reading parameter
%     parOut -  writing parameter
%     lenMa  -  maximum number, {5}
%
% Output
%   wsTrk
%     Trk    -  tracking point, 2 x nPtMa x nF
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 03-20-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 05-23-2013

prIn('anMcvTrk');

% function option
lenMa = ps(varargin, 'lenMa', 5);
ftSiz = 20;

% path
hr = vdoRIn(inPath, 'comp', 'img');

% dimension
[~, nF] = size(Vis);

% figure
figSiz = [480 640];
Ax = iniAx(1, 2, 1, figSiz + 1, 'hGap', .1, 'wGap', .1, 'hs', [1 7]);

% output video
hw = vdoWIn(outPath, 'fps', 30, 'siz', figSiz', 'comp', 'mcv');

% show image
prCIn('frame', nF, .1);
% [hTras, hPts] = cellss(1, nPtMa);
for iF = 1 : nF
    prC(iF);
    
    % read current frame
    F = vdoR(hr, iF);
    
    % text
    s = sprintf('Frame: %d/%d', iF, nF);
    
    % image
    if iF == 1
        hT = shStr(s, 'ax', Ax{1}, 'ftSiz', ftSiz);
        hImg = shImg(F, 'ax', Ax{2});
        hTrk = shTrk(Trk(:, :, iF), Vis(:, iF), lenMa);
    else
        shStrUpd(hT, s);
        shImgUpd(hImg, F);
        hTrk = shTrkUpd(hTrk, Trk(:, :, iF), Vis(:, iF));
    end

    hw = vdoW(hw);
end
prCOut(nF);
vdoWOut(hw);
vdoROut(hr);

prOut;

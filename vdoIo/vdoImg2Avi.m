function vdoImg2Avi(hr, aviPath)
% Convert an image sequence to a AVI file.
%
% Input
%   hr       -  handle to the original sequence
%   aviPath  -  path to avi file
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 01-13-2014

fig = 1;

% input video
[nF, fps, siz] = stFld(hr, 'nF', 'fps', 'siz');

% output video
hw = vdoWIn(aviPath, 'fps', fps, 'siz', siz, 'comp', 'vdo');

% figure size
figSiz = siz;
Ax = iniAx(fig, 1, 1, figSiz, 'wGap', 0, 'hGap', 0);

% each frame
prCIn('frame', nF, .1);
for iF = 1 : nF
    prC(iF);

    F = vdoR(hr, iF);
    if iF == 1
        haImg = shImg(F, 'ax', Ax{1});
    else
        shImgUpd(haImg, F);
    end
    hw = vdoW(hw);
end
prCOut(nF);
vdoWOut(hw);

close(fig);
pause(.1);
function [Trk, Vis] = mcvTrkLK(hr, parTrk)
% An implementation of the KLT tracker based on OpenCV.
%
% Input
%   hr       -  video handler
%   parTrk   -  tracking parameter
%     nPtMa  -  maximum number of tracking points, {200}
%     dstMi  -  minimum distance between any two tracking points in space, {10}
%     veoMa  -  maximum velocity between any two tracking points in time, {10}
%     thUpd  -  minimum points that are available from the previous image, {120}
%               otherwise the algorithm will update all the points
%     deb    -  debug flag, 'y' | {'n'}
%
% Output
%   Trk      -  tracking point, 2 x nPtMa x nF
%   Vis      -  label of tracking points, nPtMa x nF
%               0: no tracking points
%               1: begin of a new tracking point
%               2: keeping updated
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 03-20-2011
%   modify   -  Feng Zhou (zhfe99@gmail.com), 01-04-2014

% function option
nPtMa = ps(parTrk, 'nPtMa', 200);
dstMi = ps(parTrk, 'dstMi', 10);
veoMa = ps(parTrk, 'veoMa', .1);
thUpd = ps(parTrk, 'thUpd', 50);
isDeb = psY(parTrk, 'deb', 'n');
prIn('mcvTrkLK', 'nPtMa %d, dstMi %d, veoMa %.2f, thUpd %d', nPtMa, dstMi, veoMa, thUpd);

% #maximum frames 
nF = min(hr.nF, 50000);

Trk = zeros(2, nPtMa, nF);
Vis = zeros(nPtMa, nF);
wsDeb = [];

% per frame
prCIn('frame', nF, .1);
for iF = 1 : nF
    prC(iF);

    % read current frame
    Img = vdoR(hr, iF);

    % end of the file
    if isempty(Img)
        nF = iF - 1;
        break;
    end

    % good feature to track
    PtGood = mcvGoodFeat(Img, nPtMa, dstMi);
    nPtGood = size(PtGood, 2);

    % init
    if iF == 1
        Pt = PtGood;
        Trk(:, 1 : nPtGood, iF) = PtGood;
        Vis(1 : nPtGood, iF) = 1;
        siz = imgInfo(Img);

    % update
    else
        % Lucas-Kanade
        [PtUpd, vis] = mcvLK(Img0, Img, Pt0);
        
        % discard features that are moving too fast
        veos = real(sqrt(sum((PtUpd - Pt0) .^ 2)));
        vis2 = veos < min(siz) * veoMa;

        % index of kept features
        vis = vis == 1 & vis2;
        nPtUpd = length(find(vis));

        % partially update some feature points
        if nPtUpd > thUpd
            % discard features that are too close
            Dst = conDst(PtUpd(:, vis), PtGood);
            dsts = min(Dst);
            PtGood = PtGood(:, dsts > dstMi ^ 2);
            nPtGood = min(nPtMa - nPtUpd, size(PtGood, 2));
            PtGood = PtGood(:, 1 : nPtGood);

            nPt = nPtUpd + nPtGood;
            Pt = zeros(2, nPt);

            % update
            p = 0;
            for i = 1 : nPtMa
                % old features
                if i <= nPt0 && vis(i)
                    Pt(:, i) = PtUpd(:, i);
                    Vis(i, iF) = 2;
                    Trk(:, i, iF) = Pt(:, i);

                % new features
                elseif p < nPtGood
                    p = p + 1;
                    Pt(:, i) = PtGood(:, p);
                    Vis(i, iF) = 1;
                    Trk(:, i, iF) = Pt(:, i);
                end
            end

        % fully re-initialize all feature points
        else
            Pt = PtGood;
            Trk(:, 1 : nPtGood, iF) = PtGood;
            Vis(1 : nPtGood, iF) = 1;
        end
    end
    nPt = size(Pt, 2);

    % debg
    if isDeb
        wsDeb = deb(isDeb, wsDeb, iF, Img, Trk(:, :, 1 : iF), Vis(:, 1 : iF), 5);
    end

    % store
    Pt0 = Pt;
    Img0 = Img;
    nPt0 = nPt;
end
prCOut(nF);
vdoROut(hr);

% store
Trk(:, :, nF + 1 : end) = [];
Vis(:, nF + 1 : end) = [];

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function wsDebg = deb(isDebg, wsDebg, iF, Img, Trk, Vis, lenMa)
% debug

if ~isDebg
    wsDebg = [];
    return;
end

% dimension
nPtMa = size(Trk, 2);

% axes
if isempty(wsDebg)
    Ax = iniAx(1, 1, 1, [400 700], 'hGap', 0, 'wGap', 0);
    [wsDebg.hPts, wsDebg.hTras] = cellss(1, nPtMa);
end

% show image
if iF == 1
    wsDebg.hImg = shImg(Img, 'ax', Ax{1});
    hold on;

else
    shImgUpd(wsDebg.hImg, Img);
end

% show pt
mkSiz = 5;
for iPt = 1 : nPtMa
    % trajectory
    Tra = [];
    for iF2 = iF : -1 : max(iF - lenMa + 1, 1);
        Tra = [Trk(:, iPt, iF2), Tra];

        if Vis(iPt, iF2) == 0 || Vis(iPt, iF2) == 1
            break;
        end
    end

    if Vis(iPt, iF) == 0
        if ~isempty(wsDebg.hTras{iPt})
            set(wsDebg.hTras{iPt}, 'XData', [], 'YData', []);
            wsDebg.hTras{iPt} = [];
            
            set(wsDebg.hPts{iPt}, 'XData', [], 'YData', []);
            wsDebg.hPts{iPt} = [];
        end
    elseif Vis(iPt, iF) == 1
        if ~isempty(wsDebg.hTras{iPt})
            set(wsDebg.hTras{iPt}, 'XData', [], 'YData', []);

            set(wsDebg.hPts{iPt}, 'XData', [], 'YData', []);
        end

        [mk, cl] = genMkCl(iPt);
        wsDebg.hTras{iPt} = plot(Tra(1, :), Tra(2, :), '-', 'Color', cl, 'LineWidth', 1);
        wsDebg.hPts{iPt} = plot(Tra(1, end), Tra(2, end), mk, 'Color', cl, 'MarkerSize', mkSiz);

    else
        set(wsDebg.hTras{iPt}, 'XData', Tra(1, :), 'YData', Tra(2, :));
        set(wsDebg.hPts{iPt}, 'XData', Tra(1, end), 'YData', Tra(2, end));
    end
end

drawnow;

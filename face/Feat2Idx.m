function wsIdx = Feat2Idx(feat)
% Obtain the related AUs in the specified part.
%
% Input
%   feat    -  facial part, 'mou' | 'mou2' | 'eye' | 'all'
%              'mou':  AU 11 ~ AU 27
%              'mou2': AU 11 ~ AU 27, AU 50
%              'eye':  AU 01 ~ AU 09
%              'all':  AU 01 ~ AU 27
%
% Output
%   aus     -  AU index, 1 x nAu
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-17-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% browIn
if strcmp(feat, 'browIn')
    IdxPt = [23 22; 0 0]; IdxPt(2, :) = IdxPt(1, :) + 66;
    IdxLn = zeros(2, 2, 2);
    IdxLn(1, :, 1) = [43 46]; IdxLn(2, :, 1) = IdxLn(1, :, 1) + 66;
    IdxLn(1, :, 2) = [40 37]; IdxLn(2, :, 2) = IdxLn(1, :, 2) + 66;
    
    wsIdx.IdxPt = IdxPt;
    wsIdx.IdxLn = IdxLn;
    wsIdx.alg = 'Pt2Ln';

% browOut
elseif strcmp(feat, 'browOut')
    IdxPt = [27 18; 0 0]; IdxPt(2, :) = IdxPt(1, :) + 66;
    IdxLn = zeros(2, 2, 2);
    IdxLn(1, :, 1) = [43 46]; IdxLn(2, :, 1) = IdxLn(1, :, 1) + 66;
    IdxLn(1, :, 2) = [40 37]; IdxLn(2, :, 2) = IdxLn(1, :, 2) + 66;
    
    wsIdx.IdxPt = IdxPt;
    wsIdx.IdxLn = IdxLn;
    wsIdx.alg = 'Pt2Ln';

% eyeHei
elseif strcmp(feat, 'eyeHei')
    IdxPt1 = [38 39 44 45; 0 0 0 0]; IdxPt1(2, :) = IdxPt1(1, :) + 66;
    IdxPt2 = [42 41 48 47; 0 0 0 0]; IdxPt2(2, :) = IdxPt2(1, :) + 66;
    
    wsIdx.IdxPt1 = IdxPt1;
    wsIdx.IdxPt2 = IdxPt2;
    wsIdx.alg = 'Pt2Pt';

% lipHei
elseif strcmp(feat, 'lipHei')
    IdxPt1 = [51 52 53; 0 0 0]; IdxPt1(2, :) = IdxPt1(1, :) + 66;
    IdxPt2 = [59 58 57; 0 0 0]; IdxPt2(2, :) = IdxPt2(1, :) + 66;
    
    wsIdx.IdxPt1 = IdxPt1;
    wsIdx.IdxPt2 = IdxPt2;
    wsIdx.alg = 'Pt2Pt';

% teeHei
elseif strcmp(feat, 'teeHei')
    IdxPt1 = [61 62 63; 0 0 0]; IdxPt1(2, :) = IdxPt1(1, :) + 66;
    IdxPt2 = [66 65 64; 0 0 0]; IdxPt2(2, :) = IdxPt2(1, :) + 66;
    
    wsIdx.IdxPt1 = IdxPt1;
    wsIdx.IdxPt2 = IdxPt2;
    wsIdx.alg = 'Pt2Pt';

% mouAll
elseif strcmp(feat, 'mouAll')
    IdxPt = zeros(2, 3, 2);
    IdxPt(1, :, 1) = [55 54 56]; IdxPt(2, :, 1) = IdxPt(1, :, 1) + 66;
    IdxPt(1, :, 2) = [49 60 50]; IdxPt(2, :, 2) = IdxPt(1, :, 2) + 66;

    wsIdx.IdxPt = IdxPt;
    wsIdx.alg = 'arc';

else
    error(['unknown feature name:' feat]);
end


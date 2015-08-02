function wsGeo = Idx2Geo(Trk, wsIdx)
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

alg = wsIdx.alg;
if strcmp(alg, 'Pt2Ln')
    wsGeo = geoDstLn(Trk, wsIdx, 'v', 1);
    wsGeo.alg = 'Pt2Ln';

elseif strcmp(alg, 'Pt2Pt')
    wsGeo = geoDst(Trk, wsIdx, 'v', 1);
    wsGeo.alg = 'Pt2Pt';

elseif strcmp(alg, 'arc')
    wsGeo = geoArc(Trk, wsIdx, 'v', 1, 'v2', 1);
    wsGeo.alg = 'arc';
    
else
    error('unknown index type');
end

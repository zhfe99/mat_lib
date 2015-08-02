function h = showGeo(wsGeo, iF, varargin)
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

alg = wsGeo.alg;
if strcmp(alg, 'Pt2Ln')
    h = showDstLn(wsGeo, iF, varargin{:}, 'mkSiz', 5, 'mkCol', 'y', 'dstLnWid', 2, 'dstLnCol', 'r');

elseif strcmp(alg, 'Pt2Pt')
    h = showDst(wsGeo, iF, varargin{:}, 'mkSiz', 5, 'mkCol', 'y', 'dstLnWid', 2, 'dstLnCol', 'r');

elseif strcmp(alg, 'arc')
    h = showArc(wsGeo, iF, varargin{:}, 'mkSiz', 0, 'mkCol', 'y', 'arcLnWid', 2, 'arcLnCol', 'r');
    
else
    error('unknown index type');
end

function aus = part2aus(auPart)
% Obtain the related AUs in the specified part.
%
% Input
%   auPart  -  facial part, 'eye' | 'mou' | 'mou2' | 'all' | 'all2'
%              'eye' :  AU 01 ~ AU 09
%              'mou' :  AU 11 ~ AU 27
%              'mou2':  AU 11 ~ AU 27, AU 50
%              'all' :  AU 01 ~ AU 27
%              'all2':  AU 01 ~ AU 27, AU 50
%
% Output
%   aus     -  AU index, 1 x nAu
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-02-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

if strcmp(auPart, 'eye')
    aus = 1 : 9;

elseif strcmp(auPart, 'mou')
    aus = 11 : 27;

elseif strcmp(auPart, 'mou2')
    aus = 11 : 27;
    aus = [aus 50];

elseif strcmp(auPart, 'all')
    aus = 1 : 27;

elseif strcmp(auPart, 'all2')
    aus = 1 : 27;
    aus = [aus 50];

else
    error(['unknown action unit part: ' auPart]);
end

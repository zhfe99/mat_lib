function [idx, idxCs] = indFaceLM(part)
% Obtain the point index of facial part.
%
% Input
%   part    -  facial part, 'all' | 'outer' | 'eyebrow' | 'eye' | 'nose' | 'mouth' | 'lip'
%
% Output
%   idx     -  point index, 1 x m
%   idxCs   -  contour index composed by consecutive points, 1 x n (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-16-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-26-2013

% outer
idx1 = 1 : 17;
idxCs1 = {1 : 17};

% eyebrow
idx2 = 18 : 27; 
idxCs2 = {18 : 22, 23 : 27};

% eye
idx3 = 37 : 48;
idxCs3 = {[37 : 42, 37], [43 : 48, 43]};

% nose
idx4 = 28 : 36;
idxCs4 = {[28 : 36, 31]};

% mouth
idx5 = 49 : 66;
idxCs5 = {[49 : 60, 49], [61 : 66, 61]};

% lip
idx6 = 49 : 60;
idxCs6 = {[49 : 60, 49]};

% eye corner
idx8 = [37, 40, 43, 46];
idxCs8 = {37, 40, 43, 46};

if strcmp(part, 'all')
    idx = [idx1, idx2, idx3, idx4, idx5];
    idxCs = cellCate(idxCs1, idxCs2, idxCs3, idxCs4, idxCs5);

elseif strcmp(part, 'outer')
    idx = idx1;
    idxCs = idxCs1;

elseif strcmp(part, 'eyebrow')
    idx = idx2;
    idxCs = idxCs2; 
    
elseif strcmp(part, 'eye')
    idx = idx3;
    idxCs = idxCs3;

elseif strcmp(part, 'eyeR')
    idx = 43 : 48;
    idxCs = {[43 : 48, 43]};

elseif strcmp(part, 'upperR')
    idx = [23 : 27, 43 : 48];
    idxCs = cellCate([23 : 27], [43 : 48, 43]);

elseif strcmp(part, 'upper')
    idx = [idx2, idx3];
    idxCs = cellCate(idxCs2, idxCs3);

elseif strcmp(part, 'nose')
    idx = idx4;
    idxCs = idxCs4;
    
elseif strcmp(part, 'mou') || strcmp(part, 'mouth')
    idx = idx5;
    idxCs = idxCs5;    

elseif strcmp(part, 'lip')
    idx = idx6;
    idxCs = idxCs6;
    
elseif strcmp(part, 'lipN')
    idx = [idx6, 30 : 36];
    idxCs = cellCate(idxCs6, [30 : 36, 31]);

elseif strcmp(part, 'lipR')
    idx = 54 : 56;
    idxCs = {54 : 56};
    
elseif strcmp(part, 'lipR2')
    idx = 55;
    idxCs = {55};

elseif strcmp(part, 'teeth')
    idx = 61 : 66;
    idxCs = {[61 : 66, 61]};
    
elseif strcmp(part, 'noseA1')
    % only nose
    idx = [28 : 36];
    idxCs = {[28 : 36, 31]};

elseif strcmp(part, 'noseA2')
    % nose + inner corner
    idx = [28 : 36, 40, 43];
    idxCs = {[28 : 36, 31], 40, 43};

elseif strcmp(part, 'noseA3')
    % nose + inner corner + outter corner
    idx = [28 : 36, 37, 40, 43, 46];
    idxCs = {[28 : 36, 31], 37, 40, 43, 46};

elseif strcmp(part, 'lipA')
    idx = 49 : 60;
    idxCs = {[49 : 60, 49]};

elseif strcmp(part, 'eyecorner')
    idx = idx8;
    idxCs = idxCs8;
    
else
    error(['unknown facial part: ' part]);
end


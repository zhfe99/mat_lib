function R = randRot(dP, dQ)
% Synthesize a random rotation.
%
% Input
%   dP      -  #dimension, [] | 2 | 3
%   dQ      -  #dimension, [] | 2 | 3
%
% Output
%   R       -  rotation, dP x dQ
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-04-2014
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-17-2014

% default dP
if ~exist('dP', 'var') || isempty(dP)
    dP = 2;
end

% default dQ
if ~exist('dQ', 'var') || isempty(dQ)
    dQ = dP;
end

% 2D-2D
if dP == 2 && dQ == 2
    ang = rand(1) * pi;
    sa = sin(ang);
    ca = cos(ang);
    R = [sa ca; -ca sa];

% 3D-2D
elseif dP == 2 && dQ == 3
    R = randRot(3, 3);
    R = R([1 2], :);
    
% 3D-3D
elseif dP == 3 && dQ == 3    
    ang = rand(1) * pi;
    sa1 = sin(ang);
    ca1 = cos(ang);
    
    ang = rand(1) * pi;
    sa2 = sin(ang);
    ca2 = cos(ang);
    
    ang = rand(1) * pi;
    sa3 = sin(ang);
    ca3 = cos(ang);
    
    R1 = [1, 0, 0; 0, ca1, -sa1; 0, sa1, ca1];
    R2 = [ca2, 0, sa2; 0, 1, 0; -sa2, 0, ca2];
    R3 = [ca3, -sa3, 0; sa3, ca3, 0; 0, 0, 1];
    
    R = R1 * R2 * R3;
else
    error('unknown dP %d dQ %d', dP, dQ);
end
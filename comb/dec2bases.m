function [mergss, mgs] = dec2bases(kT, kCb)
% Convert decimal to specific base.
%
% Example
%   dec = 19, b = 3, m = 3  ->  Vis = [0, 1, 0; ...
%                                      1, 0, 0; ...
%                                      0, 0, 1];  
%
% Input
%   dec     -  decimal value
%   b       -  numeric base
%   m       -  number of bits
%
% Output
%   Vis     -  binary matrix, b x m
%              each column has at most one element with one
%   idx     -  index vector, 1 x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

global footpath; % specified in addPath.m
path = sprintf('%s/data/nsf/dec2bases_%d_%d.mat', footpath, kT, kCb);

if exist(path, 'file')
    [mergss, mgs] = matFld(path, 'mergss', 'mgs');
    return;
end

if kT == kCb
    kMg = 1;
else
    kMg = kT ^ kCb - 1;
end

[mergss, mgs] = cellss(1, kMg);

nT = 0;
for iMg = 1 : kMg
    if kT == kCb
        Vis = eye(kT);
        mg = 1 : kT;
    else
        [Vis, mg] = dec2base(iMg, kT, kCb);
    end
    mergs = cell(1, kT);

    % index of AU combination (component) in each merged AU combination
    flag = true;
    head0 = 0;
    for c = 1 : kT
        % each component is one of the kB AU combinations
        mergs{c} = find(Vis(c, :));

        % each component cannot be empty
        if kT <= kCb && isempty(mergs{c})
            flag = false;
            break;

        % each component can be empty
        elseif isempty(mergs{c})
           continue;
        end

        % Since it is the same case by switching the order of merge,
        % we use only one of them
        head = mergs{c}(1);
        if head < head0
            flag = false;
            break;
        end
        head0 = head;
    end
    if ~flag, continue; end

    nT = nT + 1;
    mergss{nT} = mergs;
    mgs{nT} = mg;
end
mergss(nT + 1 : end) = [];
mgs(nT + 1 : end) = [];

% save
save(path, 'mergss', 'mgs');

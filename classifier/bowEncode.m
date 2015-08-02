function Y = bowEncode(Xs, bow)
% Given the bag-of-words model, return the representation of the input.
%
% Input
%   Xs      -  sample matrix, 1 x m (cell), d0 x ni
%   bow     -  BoW model
%     Me    -  cluster centers, d0 x d
%
% Output
%   Y       -  new sample matrix, d x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-05-2014
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-27-2014

prIn('bowEncode');

% bow
Me = stFld(bow, 'Me');

% dimension
m = length(Xs);
[d0, d] = size(Me);

% per sample
Y = zeros(d, m);
for i = 1 : m
    %% feature-cluster distance
    D = conDst(Xs{i}, Me);
    
    %% closest-center
    [~, idx] = min(D, [], 2);
    
    %% histogram
    for c = 1 : d
        Y(c, i) = length(find(idx == c));
    end
end

prOut;

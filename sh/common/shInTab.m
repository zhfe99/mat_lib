function lns = shInTab(X, form, varargin)
% Print result in latex table.
%
% Input
%   X          -  data, nAlg x nBin
%   form       -  format, '%.2f' | ...
%   varargin
%     tabWrap  -  wrap of table, {'y'} | 'n'
%     B        -  bold table, {[]} | nAlg x nBin
%     algs     -  algorithm names, {[]} | 1 x nAlg (cell)
%     bins     -  bin names, {[]} | 1 x nBin (cell)
%
% Output
%   lns        -  lines, 1 x nAlg (cell)
%
% History
%   create     -  Feng Zhou (zhfe99@gmail.com), 07-02-2015
%   modify     -  Feng Zhou (zhfe99@gmail.com), 07-02-2015

% function option
isTabWrap = psY(varargin, 'tabWrap', 'y');
B = ps(varargin, 'B', []);
algs = ps(varargin, 'algs', []);
bins = ps(varargin, 'bins', []);

% dimension
[nAlg, nBin] = size(X);

% each line
lnNums = cell(1, nAlg);
for iAlg = 1 : nAlg
    % algorithm name
    if ~isempty(algs)
        ln = strcat(algs{iAlg}, ' & ');
    else
        ln = '';
    end

    % number bin
    for iBin = 1 : nBin
        if iBin > 1
            ln = strcat(ln, ' & ');
        end

        % element
        ele = sprintf(form, X(iAlg, iBin));

        % bold wrap
        if ~isempty(B) && B(iAlg, iBin)
            ele = sprintf('\\\\mathbf{%s}', ele);
        end

        % $ wrap
        ele = sprintf('$%s$', ele);

        ln = strcat(ln, ele);
    end

    % sub fix
    if iAlg < nAlg
        ln = strcat(ln, ' \\\\');
    end

    % store
    lnNums{iAlg} = ln;
end

% table wrap
if isTabWrap
    lnHead = sprintf('\\\\begin{tabular}{');
    if isempty(algs)
        m = nBin;
    else
        m = nBin + 1;
    end
    for iBin = 1 : m
        lnHead = [lnHead 'c'];
        if iBin < m
            lnHead = [lnHead '|'];
        else
            lnHead = [lnHead '}'];
        end
    end

    lnTail = sprintf('\\\\end{tabular}');
end

% head
lnBins = cell(1, 2);
if ~isempty(bins)
    lnBins{1} = '';
    for iBin = 1 : nBin
        lnBins{1} = [lnBins{1} ' & ' bins{iBin}];
    end
    lnBins{1} = [lnBins{1} ' \\\\'];
    lnBins{2} = '\\hline';
end

% combine
lns = {lnHead, lnBins{:}, lnNums{:}, lnTail};

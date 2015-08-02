function ind = saveLns(lns, outpath, varargin)
% Save lines of string into a file.
%
% Input
%   lines      -  lines, 1 x n (list)
%   outpath    -  output path, string
%   varargin
%     skipEmp  -  flag of skipping empty line, {'y'} | 'n'
%     subx     -  subfix of each line, '' | {'\n'} | ...
%
% History
%   create     -  Feng Zhou (zhfe99@gmail.com), 07-02-2015
%   modify     -  Feng Zhou (zhfe99@gmail.com), 07-02-2015

% function option
isSkipEmp = psY(varargin, 'skipEmp', 'y');
subx = ps(varargin, 'subx', '\n');

% dimension
n = length(lns);

fio = fopen(outpath, 'w');

% each line
for i = 1 : n
    % skip empty line
    if isSkipEmp && isempty(lns{i})
        continue;
    end

    fprintf(fio, lns{i});

    % print subx in the end of each line
    if ~isempty(subx)
        fprintf(fio, subx);
    end
end

fclose(fio);

function fileEmail(foldpath)

pnos = dir(foldpath);

for i = 1 : length(pnos)
    s0 = pnos(i).name;
    
    if strcmp(s0, '.') || strcmp(s0, '..') 
        continue;
    end
    
    if pnos(i).isdir
        path0 = cd;
        cd(s0);
        fileEmail('.');
        cd(path0);
    elseif strcmp(s0(end - 1 : end), '.m')
        fprintf('%s\n', s0);
        scanFile([foldpath '/' s0]);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%
function scanFile(fpath)

% open
fid = fopen(fpath, 'rt');
if fid == -1
    error(['can not open file ' fpath]);
end;

maxL = 1000;
lines = cell(1, maxL);
co = 0;
head1 = '%   modify';
head2 = '%   create';
nH = length(head1);
name = '  Feng Zhou'; nN = length(name);
mail = ' (zhfe99@gmail.com)';
isMod = 0;
while ~feof(fid)
    co = co + 1;
    line = fgetl(fid);
    
    lines{co} = line;
    n = length(line);
    if n <= nH
        continue;
    end
    
    if ~strcmp(line(1 : nH), head1) && ~strcmp(line(1 : nH), head2)
        continue;
    end

    i = nH + 1;
    while i <= n && line(i) ~= '-'
        i = i + 1;
    end
    if i > n
        fprintf('error -\n');
        return;
    end
    
    if ~strcmp(line(i + 1 : i + nN), name)
        fprintf('error name\n');
        return;
    end
    
    i = i + nN;
    if line(i + 1) == ','
        lines{co} = [line(1 : i), mail, line(i + 1 : end)];
        isMod = 1;
    end
end
fclose(fid);

if isMod
    fid = fopen(fpath, 'w');
    for i = 1 : co
        fprintf(fid, '%s\n', lines{i});
    end
    fclose(fid);
end

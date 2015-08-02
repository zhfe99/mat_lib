function fileDate(foldpath)

tiNow = datestr(now, 'mm-dd-yyyy');
pnos = dir(foldpath);

for i = 1 : length(pnos)
    s0 = pnos(i).name;
    
    if strcmp(s0, '.') || strcmp(s0, '..') 
        continue;
    end
    
    if pnos(i).isdir
        path0 = cd;
        cd(s0);
        fileDate('.');
        cd(path0);
    
    elseif length(s0) > 2 && strcmp(s0(end - 1 : end), '.m')
        ti0 = datestr(pnos(i).date, 'mm-dd-yyyy');
        scanFile([foldpath '/' s0], s0, ti0);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function scanFile(fpath, fname, ti0)

% open
fid = fopen(fpath, 'rt');
if fid == -1
    error(['can not open file ' fpath]);
end;

maxL = 1000;
lines = cell(1, maxL);
co = 0;
head = '%   modify';
nH = length(head);
isMod = 0;
while ~feof(fid)
    co = co + 1;
    line = fgetl(fid);
    
    lines{co} = line;
    n = length(line);
    if n <= nH
        continue;
    end
    
    if ~strcmp(line(1 : nH), head)
        continue;
    end

    i = nH + 1;
    while i <= n && line(i) ~= ','
        i = i + 1;
    end
    if i > n
        fprintf('error ,\n');
        return;
    end
    i = i + 1;
    
    ti = line(i + 1 : end);
    if ~strcmp(ti0, ti)
        lines{co} = [line(1 : i), ti0];
        isMod = 1;
    end
end
fclose(fid);

if isMod
    fprintf('%s\n', fname);
    fid = fopen(fpath, 'w');
    for i = 1 : co
        fprintf(fid, '%s\n', lines{i});
    end
    fclose(fid);

    ti0a = [ti0(end - 3 : end) ti0(1 : 2) ti0(4 : 5)];
    cmd = sprintf('touch -m -t %s0101 %s', ti0a, fname);
    system(cmd);
end

function fileDataNow(foldpath)

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
        ti = datestr(pnos(i).date, 'mm-dd-yyyy');

        if strcmp(tiNow, ti)
            fprintf('%s\n', s0);
            scanFile([foldpath '/' s0], tiNow);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function scanFile(fpath, tiNow)

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
    if ~strcmp(tiNow, ti)
        lines{co} = [line(1 : i), tiNow];
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

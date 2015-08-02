function foldRemove(foldpath)

pnos = dir(foldpath);
for i = 1 : length(pnos)
    s0 = pnos(i).name;
    
    if strcmp(s0, '.') || strcmp(s0, '..') 
        continue;
    end
    
    if pnos(i).isdir
        continue;
    end
    
    if length(s0) > 15
        if strcmp(s0(1 : 14), 'xxxx - xxxx - ') 
            s = s0;
            s(1 : 14) = [];
            comm = sprintf('mv "%s" "%s"', s0, s);
            system(comm);
            fprintf('%s ==> %s\n', s0, s);
        end
    end
end
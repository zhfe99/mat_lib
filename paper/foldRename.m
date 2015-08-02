function foldRename(foldpath)

pnos = dir(foldpath);
for i = 1 : length(pnos)
    s0 = pnos(i).name;
    
    if strcmp(s0, '.') || strcmp(s0, '..') 
        continue;
    end
    
    if pnos(i).isdir
        path0 = cd;
        cd(s0);
        foldRename('.');
        cd(path0);
    end
    
    if length(s0) > 4
        if strcmp(s0(1 : 4), 'xxxx') 
            continue;
        end
        
        x = str2double(s0(1 : 4));
        if ~isnan(x)
            continue;
        end
    end
    
%     if length(s0) > 15
%         vis = s0(1 : 15) == '-';
%         if sum(vis) == 2
%             ps = find(vis);
%             s2 = s0(ps(1) + 2 : ps(2) - 2);
% 
%             vis2 = s2 == 'x';
%             ps2 = find(vis2);
%             if length(ps2) < 4 && length(ps2) > 0
%                 p1 = ps2(1); p2 = ps2(end);
%                 s = s0;
%                 s(ps(1) + 1 + p1 : ps(1) + 1 + p2) = [];
%                 comm = sprintf('mv "%s" "%s"', s0, s);
%                 system(comm);
%                 fprintf('%s ==> %s\n', s0, s);
%             end
%         end
%     end

    [f, s] = paperRename(s0);
    comm = sprintf('mv "%s" "%s"', s0, s);
    
    if f
        fprintf('%s ==> %s\n', s0, s);
        system(comm);
    end
end
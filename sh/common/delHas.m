function delHas(has)
% Delete handle.
%
% Input
%   ha      -  handle
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-01-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-10-2013

for i = 1 : length(has)
    if ~isempty(has{i})
        delete(has{i});
    end
end
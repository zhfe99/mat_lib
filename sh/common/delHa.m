function delHa(ha)
% Delete handle.
%
% Input
%   ha      -  handle
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-01-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-10-2013

if ~isempty(ha)
    delete(ha);
end
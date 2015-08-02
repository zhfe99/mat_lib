function [nms, dims, parts, types] = faceFts
% Obtain the all feature names.
%
% Output
%   nms      -  feature names, 1 x nFt (cell)
%   dims     -  feature dimension, 1 x nFt
%   parts    -  facial part for visualization, 1 x nFt (cell)
%               see function "indFaceLM" for more details
%   types    -  feature types, 1 x nFt (cell)
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 03-02-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

nms   = {'browIn', 'browOut', 'eyeHei', 'lipHei', 'lipWid', 'lipGap', 'teeHei', 'mouUp', 'mouDw', 'mouAll', 'lip', 'apeaL', 'apeaU'};
dims  = [       1,         1,         1,       1,        1,        1,        1,       1,       1,        1,    24,     261,     126];
parts = {'upperR',  'upperR', 'upperR',    'lip',    'lip',    'all',    'mou',   'lip',   'lip',    'lip', 'lip',   'lip',   'lip'};
types = {   'dst',     'dst',     'dst',   'dst',    'dst',    'dst',    'dst',   'agl',   'agl',    'agl', 'shp',  'apea',  'apea'};

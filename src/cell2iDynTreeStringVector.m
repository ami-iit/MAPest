
% Copyright (C) 2018 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [ selectedJoints ] = cell2iDynTreeStringVector( array )
% CELL2IDYNTREESTRINGVECTOR transforms an iDynTree StringVector object into
% cella array.

selectedJoints = iDynTree.StringVector();
for i = 1 : length(array)
    selectedJoints.push_back(array{i});
end
assert(selectedJoints.size == length(array), 'Vector size mismatch');
end

function [ selectedJoints ] = cell2iDynTreeStringVector( array )
% CELL2IDYNTREESTRINGVECTOR transforms an iDynTree StringVector object into
% cella array.
%
% Author(s): Claudia Latella, 2017
% Dynamic Interaction Control, Istituto Italiano di Tecnologia

selectedJoints = iDynTree.StringVector();
for i = 1 : length(array)
     selectedJoints.push_back(array{i});
end 
assert(selectedJoints.size == length(array), 'Vector size mismatch');
end

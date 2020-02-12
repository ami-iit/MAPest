function [ matlabRange ] = range2matlab( iDynTreeRange )
% RANGE2MATLAB Convert an iDynTree.Range struct to a Matlab range.
%
% Author(s): Claudia Latella, 2017
% Dynamic Interaction Control, Istituto Italiano di Tecnologia


matlabRange = (iDynTreeRange.offset+1):(iDynTreeRange.offset+iDynTreeRange.size);
end


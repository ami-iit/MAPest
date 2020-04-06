
% Copyright (C) 2017 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [ matlabRange ] = range2matlab( iDynTreeRange )
% RANGE2MATLAB Convert an iDynTree.Range struct to a Matlab range.
%
% Author(s): Claudia Latella
% Dynamic Interaction Control, Istituto Italiano di Tecnologia


matlabRange = (iDynTreeRange.offset+1):(iDynTreeRange.offset+iDynTreeRange.size);
end


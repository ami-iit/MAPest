
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [missingIdx, flag] = checkingMissingValues(file,vectorToBeCompared, nrOfFrames, nrOfVariableRepetition, variableName)

missingIdx = [ ];
for nrOfFramesIdx = 1 : nrOfFrames
    % find the indices where the variable is missing
    if ~strcmp(file{vectorToBeCompared(nrOfFramesIdx)+nrOfVariableRepetition,1},variableName)
        missingIdx = [missingIdx,vectorToBeCompared(nrOfFramesIdx)+nrOfVariableRepetition];
        flag = true;
    end
end
end


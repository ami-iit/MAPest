
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function [ index, len ] = rangeOfDynamicVariable( berdy, varType, varID)
% RANGEOFDYNAMICVARIABLE given a type of variable and its label, returns its
% index in the vector d and its range.
%
% Author(s): Claudia Latella, Francesco Romano
% Dynamic Interaction Control, Istituto Italiano di Tecnologia


dynVariable = berdy.getDynamicVariablesOrdering();
index = -1;
len = 0;
for i = 1:size(dynVariable,2)
    currentInfo = dynVariable{i};
    if currentInfo.type == varType && strcmp(currentInfo.id, varID)
        range = currentInfo.range;
        index = range.offset + 1;
        len = range.size;
        break;
    end
end
end
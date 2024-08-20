
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

% Author(s): Claudia Latella
% Dynamic Interaction Control, Istituto Italiano di Tecnologia


function [indx] = valueFromName(VectorOfString, stringName)
for i = 1: length(VectorOfString)
    if strcmp(VectorOfString(i,:), stringName)
    indx = i;
    break;
    end
end
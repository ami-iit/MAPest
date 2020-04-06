
% Copyright (C) 2017 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

% Author(s): Claudia Latella
% Dynamic Interaction Control, Istituto Italiano di Tecnologia


function [indx] = valueFromName(VectorOfString, stringName)
for i = 1: length(VectorOfString)
    if strcmp(VectorOfString(i,:), stringName)
    indx = i;
    break;
    end
end
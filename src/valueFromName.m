
% Author(s): Claudia Latella, 2017
% Dynamic Interaction Control, Istituto Italiano di Tecnologia


function [indx] = valueFromName(VectorOfString, stringName)
for i = 1: length(VectorOfString)
    if strcmp(VectorOfString(i,:), stringName)
    indx = i;
    break;
    end
end
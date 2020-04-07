
% Copyright (C) 2017 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [ index, len ] = rangeOfSensorMeasurement( berdy, sensType, sensID)
%RANGEOFDYNAMICVARIABLE given a type of sensor and its label, returns its
% index in the vector y and its range.

sensorOrder = berdy.getSensorsOrdering();
index = -1;
len = 0;
for i = 1:size(sensorOrder,2)
    currentInfo = sensorOrder{i};
    if currentInfo.type == sensType && strcmp(currentInfo.id, sensID)
        range = currentInfo.range;
        index = range.offset + 1;
        len = range.size;
        break;
    end
end
end
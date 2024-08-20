
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function [ index, len ] = rangeOfSensorMeasurement( berdy, sensType, sensID)
%RANGEOFDYNAMICVARIABLE given a type of sensor and its label, returns its
% index in the vector y and its range.
%
% Author(s): Claudia Latella, Francesco Romano
% Dynamic Interaction Control, Istituto Italiano di Tecnologia


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
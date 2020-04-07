
% Copyright (C) 2017 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [y, Sigmay] = berdyMeasurementsWrapping(berdy, data)
% BERDYMEASUREMENTSWRAPPING orders the measurements in a format
% compatible with the BerdyHelper class.  It returns a vector of
% ordered measurements and its associated covariance matrix.

sensorOrder = berdy.getSensorsOrdering();

y = zeros(berdy.getNrOfSensorsMeasurements(),size(data(1).meas,2));
Sigmay = zeros(berdy.getNrOfSensorsMeasurements,berdy.getNrOfSensorsMeasurements);
for i = 1:size(sensorOrder,2)
    currentInfo = sensorOrder{i};
    found = false;
    for j = 1 : length(data)
        data_j = data(j);
        if (data_j.type == currentInfo.type && ...
            strcmp(data_j.id, currentInfo.id))
            found = true;
            matRange = range2matlab(currentInfo.range);
            y(matRange,:) = data_j.meas;
            Sigmay(matRange,matRange) = diag(data_j.var);
            break;
        end
    end
    if (found == false)
        error(strcat('Could not find sensor type', num2str(currentInfo.type),...
             ' id: ', currentInfo.id ));
    end
end
end
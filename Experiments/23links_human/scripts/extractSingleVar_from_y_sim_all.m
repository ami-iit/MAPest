
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

% -----------------------------------------------------------------------%
%  EXTERNAL FORCES
% -----------------------------------------------------------------------%
y_sim_fext.order = dVectorOrder;
y_sim_fext.meas  = cell(length(dVectorOrder),1);
for vectOrderIdx = 1 : length(dVectorOrder)
    range_fextMEAS = rangeOfSensorMeasurement(berdy, iDynTree.NET_EXT_WRENCH_SENSOR, dVectorOrder{vectOrderIdx}, opts.stackOfTaskMAP);
    y_sim_fext.meas{vectOrderIdx,1} = y_sim((range_fextMEAS:range_fextMEAS+5),:);
end

if opts.task1_SOT
    save(fullfile(bucket.pathToProcessedData_SOTtask1,'y_sim_fext.mat'),'y_sim_fext');
else
    save(fullfile(bucket.pathToProcessedData_SOTtask2,'y_sim_fext.mat'),'y_sim_fext');
end

if ~opts.task1_SOT
    % -----------------------------------------------------------------------%
    %  LIN ACCELERATION
    % -----------------------------------------------------------------------%
    nrOfLinAccelerometer = 17;
    y_sim_linAcc.order = cell(nrOfLinAccelerometer,1);
    y_sim_linAcc.meas = cell(nrOfLinAccelerometer,1);
    for accSensIdx = 1 : nrOfLinAccelerometer
        y_sim_linAcc.order{accSensIdx,1} = data(accSensIdx).id;
        range_linAccMEAS = rangeOfSensorMeasurement(berdy, iDynTree.ACCELEROMETER_SENSOR, data(accSensIdx).id, opts.stackOfTaskMAP);
        y_sim_linAcc.meas{accSensIdx,1} = y_sim((range_linAccMEAS:range_linAccMEAS+2),:);
    end
    save(fullfile(bucket.pathToProcessedData_SOTtask2,'y_sim_linAcc.mat'),'y_sim_linAcc');
    
    % -----------------------------------------------------------------------%
    %  JOINT ACCELERATION
    % -----------------------------------------------------------------------%
    y_sim_ddq.order = selectedJoints;
    y_sim_ddq.meas = cell(humanModel.getNrOfDOFs,1);
    for ddqIdx = 1 : humanModel.getNrOfDOFs
        range_ddqMEAS = rangeOfSensorMeasurement(berdy, iDynTree.DOF_ACCELERATION_SENSOR, selectedJoints{ddqIdx}, opts.stackOfTaskMAP);
        y_sim_ddq.meas{ddqIdx,1} = y_sim(range_ddqMEAS,:);
    end
    save(fullfile(bucket.pathToProcessedData_SOTtask2,'y_sim_ddq.mat'),'y_sim_ddq');
end

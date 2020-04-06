
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

% -----------------------------------------------------------------------%
%  EXTERNAL FORCES
% -----------------------------------------------------------------------%
% Extraction of the following variables
% - RightFoot
% - LeftFoot
% - RightHand
% - LeftHand
% Note that the other applied (external) forces are null!


% ---RightFoot
range_fextMEAS_rightFoot = rangeOfSensorMeasurement(berdy, iDynTree.NET_EXT_WRENCH_SENSOR, 'RightFoot');
y_sim(blockIdx).FextSim_RightFoot = y_sim(blockIdx).y_sim((range_fextMEAS_rightFoot:range_fextMEAS_rightFoot+5),:);

% ---LeftFoot
range_fextMEAS_leftFoot = rangeOfSensorMeasurement(berdy, iDynTree.NET_EXT_WRENCH_SENSOR, 'LeftFoot');
y_sim(blockIdx).FextSim_LeftFoot = y_sim(blockIdx).y_sim((range_fextMEAS_leftFoot:range_fextMEAS_leftFoot+5),:);

% ---RightHand
range_fextMEAS_rightHand = rangeOfSensorMeasurement(berdy, iDynTree.NET_EXT_WRENCH_SENSOR, 'RightHand');
y_sim(blockIdx).FextSim_RightHand = y_sim(blockIdx).y_sim((range_fextMEAS_rightHand:range_fextMEAS_rightHand+5),:);

% ---LeftHand
range_fextMEAS_leftHand = rangeOfSensorMeasurement(berdy, iDynTree.NET_EXT_WRENCH_SENSOR, 'LeftHand');
y_sim(blockIdx).FextSim_LeftHand = y_sim(blockIdx).y_sim((range_fextMEAS_leftHand:range_fextMEAS_leftHand+5),:);

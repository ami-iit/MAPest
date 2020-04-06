
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function [humanSensors] = addAccAngSensorInBerdySensors(humanSensors, name,parentLink, linkIndex, S_R_L, posSwrtL)
%ADDACCANGSENSORINBERDYSENSORS adds the angular accelerometer sensors to
%the iDynTree Berdy sensor

newAngAccSens = iDynTree.ThreeAxisAngularAccelerometerSensor;
newAngAccSens.setName(name);
newAngAccSens.setParentLink(parentLink);
newAngAccSens.setParentLinkIndex(linkIndex);

% Rotation
link_T_sensorRot = iDynTree.Rotation();
link_T_sensorRot.fromMatlab(S_R_L);

% Position
link_T_sensorPos = iDynTree.Position();
link_T_sensorPos.fromMatlab(posSwrtL); % in m

% iDynTreeTransform
link_T_sensor = iDynTree.Transform(link_T_sensorRot,link_T_sensorPos);

newAngAccSens.setLinkSensorTransform(link_T_sensor);
humanSensors.addSensor(newAngAccSens);
end

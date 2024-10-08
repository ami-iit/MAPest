
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function [suit] = computeSuitSensorPosition(suit, len)
% COMPUTESUITSENSORPOSITION computes the position of the sensors in the
% suit wrt the link frame. It returns its value in a new field of the same
% suit stucture. Notation: G = global, S = sensor; L = link.

% NOTE: Check/modify manually len value. You can decide to insert a fixed
% number of frames useful to capture all the movements performed during
% your own experiment.
%
% Author(s): Claudia Latella, Fraancesco Romano
% Dynamic Interaction Control, Istituto Italiano di Tecnologia

for sIdx = 1: suit.properties.nrOfSensors
    sensor = suit.sensors{sIdx};
    [link, ~] = linksFromName(suit.links, sensor.attachedLink);
    A = zeros(3*len,3);
    b = zeros(3*len,1);

    for i = 1 : len
        S1 = skewMatrix(link.meas.angularAcceleration(:,i));
        S2 = skewMatrix(link.meas.angularVelocity(:,i));

        G_R_L_mat = quat2Mat(link.meas.orientation(:,i));
        A(3*i-2:3*i,:) = (S1 + S2*S2) * G_R_L_mat;

        G_acc_S = sensor.meas.sensorFreeAcceleration(:,i);
        G_acc_L = link.meas.acceleration(:,i);

        b(3*i-2:3*i) = G_acc_S - G_acc_L;

        G_R_S_mat = quat2Mat(sensor.meas.sensorOrientation(:,i));
        S_R_L = G_R_S_mat' * G_R_L_mat;
        L_RPY_S(i,:) = mat2RPY(S_R_L'); %RPY in rad
    end
    % matrix system
    B_pos_SL = A\b;
    sensor.origin = B_pos_SL;
    suit.sensors{sIdx}.position = sensor.origin;
    suit.sensors{sIdx}.RPY = mean(L_RPY_S);

end
end

function [ S ] = skewMatrix(x)
%SKEWMATRIX computes the skew matrix given a vector x 3x1

S = [  0   -x(3)   x(2);
      x(3)   0    -x(1);
     -x(2)  x(1)    0  ];
end


% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function b_DotL = computeRateOfChangeOfCentroidalMomentumWRTbase(kinDynComputation, humanModel, state, baseVelocity, G_T_b)
%COMPUTERATEOFCHANGEOFCENTROIDALMOMENTUMWRTBASE computes the 6D rate of
% change of the centroidal momentum expressed w.r.t. the base.  Starting
% from the formula of the centroidal momentum expressed w.r.t. base, i.e., 
%
%                     b_L = (b_X_C * C_L)                           (1)
%
% the objective is to compute the derivative of (1), i.e.,
%
%                   b_DotL ~= (b_X_C * C_DotL)                      (2)
%           
% being:
% - C cetroidal frame
% - b base frame
% - b_X_C the adjoint 6x6 wrench transform
% - C_L is the centroidal momentum expressed w.r.t. C frame
% - C_DotL is the rate of change of the centroidal momentum expressed
%          w.r.t. C frame, such as C_DotL = m * (linAccCOM - g)
%   where:
%   - m is the model total mass
%   - linAccCOM is the linear CoM acceleration w.r.t. C;

q  = iDynTree.JointPosDoubleArray(kinDynComputation.model);
dq = iDynTree.JointDOFsDoubleArray(kinDynComputation.model);
base_vel = iDynTree.Twist();
gravity = iDynTree.Vector3();
gravityMatlab = [0; 0; -9.81];
gravity.fromMatlab(gravityMatlab);

% Centroidal frame with the orientation of the global frame
G_R_C = iDynTree.Rotation();
G_R_C.fromMatlab([ 1.0,  0.0,  0.0; ...
    0.0,  1.0,  0.0; ...
    0.0,  0.0,  1.0]);

samples = size(state.q ,2);
b_DotL = zeros(6,samples);
for i = 1 : samples
    q.fromMatlab(state.q(:,i));
    dq.fromMatlab(state.dq(:,i));
    base_vel.fromMatlab(baseVelocity(:,i));
    kinDynComputation.setRobotState(G_T_b{i,1},q,base_vel,dq,gravity);
    
    % Get the bias acceleration of the COM w.r.t. C frame
    biasAccCOM = kinDynComputation.getCenterOfMassBiasAcc(); % biasAccCOM(:,i) = kinDynComputation.getCenterOfMassBiasAcc().toMatlab();
    % Compute C_DotL
    C_DotL =  [humanModel.getTotalMass * (biasAccCOM.toMatlab() - gravityMatlab); ...
        zeros(3,1)]; %zeros(3,1) is the angular part. For now, its measurement is equal to zero.
    % Compute the transform b_T_C = b_T_G * G_T_C
    % 1) G_T_C
    G_pos_C = kinDynComputation.getCenterOfMassPosition();
    G_T_C = iDynTree.Transform(G_R_C, G_pos_C);
    % 2) b_T_G
    b_T_G = G_T_b{i,1}.inverse;
    b_T_C = b_T_G * G_T_C;
    % Compute b_DotL
    b_DotL(:,i) =  b_T_C.asAdjointTransformWrench.toMatlab() * C_DotL;
end

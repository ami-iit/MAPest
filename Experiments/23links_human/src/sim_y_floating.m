
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function y_simulated = sim_y_floating(berdy, human_state, traversal, baseAngVel, mu_dgiveny)
%SIMYFLOATING is useful (mandatoty) to compare the measurements in the y vector
% (i.e., the vector of the measurements) and the results of the MAP estimation in mu_dgiveny.
%
% Note: you cannot compare directly the results of
% the MAP (i.e., mu_dgiveny) with the measurements in the y vector but you
% have to pass through the sim_y_floating and only later to compare vectors
% y and y_simulated.
%
% Author(s): Claudia Latella
% Dynamic Interaction Control, Istituto Italiano di Tecnologia

% Set gravity
gravity = [0 0 -9.81];
grav  = iDynTree.Vector3();
grav.fromMatlab(gravity);

% Set matrices
berdyMatrices       = struct;
berdyMatrices.D     = iDynTree.MatrixDynSize();
berdyMatrices.b_D   = iDynTree.VectorDynSize();
berdyMatrices.Y     = iDynTree.MatrixDynSize();
berdyMatrices.b_Y   = iDynTree.VectorDynSize();

berdy.resizeAndZeroBerdyMatrices(berdyMatrices.D,...
    berdyMatrices.b_D,...
    berdyMatrices.Y,...
    berdyMatrices.b_Y);


q  = iDynTree.JointPosDoubleArray(berdy.model());
dq = iDynTree.JointDOFsDoubleArray(berdy.model());
currentBase = berdy.model().getLinkName(traversal.getBaseLink().getIndex());
baseIndex = berdy.model().getFrameIndex(currentBase);
base_angVel = iDynTree.Vector3();

for i = 1: length(human_state.q)
    
    q.fromMatlab(human_state.q(:,i));
    dq.fromMatlab(human_state.dq(:,i));
    base_angVel.fromMatlab(baseAngVel(:,i));
    
    berdy.updateKinematicsFromFloatingBase(q,dq,baseIndex,base_angVel);
    
    berdy.getBerdyMatrices(berdyMatrices.D,...
        berdyMatrices.b_D,...
        berdyMatrices.Y,...
        berdyMatrices.b_Y);
    
    Y_nonsparse = berdyMatrices.Y.toMatlab();
    
    Y   = sparse(Y_nonsparse);
    b_Y = berdyMatrices.b_Y.toMatlab();
    
    y_simulated(:,i) = Y * mu_dgiveny(:,i) + b_Y;
end
end

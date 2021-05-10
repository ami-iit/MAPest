function [forceplates_HF] = transformForceplatesWrenches (forceplates_SF, subjectParamsFromData)  
% TRANSFORMFORCEPLATEWRENCHES transforms external wrenches estimated from 
% forceplates into human frames
% Inputs:
% - forceplates_SF        : forceplate 1 and 2 wrenches in sensor frames;
% - subjectParamsFromData : for getting the ankle heights, i.e the origin 
%                           position of the reference frame of both feet
%                           wrt their projection on the plate
% Outputs:
% - forceplates_HF : human right foot external wrench (humanRightFootWrench)
%                    and human left foot external wrench (humanLeftFootWrench). 
%
% External wrenches are estimated by the forceplates in the frame of the 
% sensor system that is located at a known position. 
% For the human estimation we need to get from this wrenches but: 
% - multiplied by -1 (as the wrench applied on the human is exactly the 
%   opposite of the one excerted on the forceplate)
% - expressed in the frame of the human link in contact.

%% Preliminary note: 
% The force plate frame is located in the 3D middle of the plate

gravityZero = iDynTree.Vector3();
gravityZero.zero();

FPwrench_R = forceplates_SF.fp.interpolated_right';
FPwrench_L = forceplates_SF.fp.interpolated_left';

%% Transform FPwrench_R from forceplates frames into human frames
% We want: rightFoot_f_FPR starting from FPR_f_FPR
rightFoot_T_FPRrot = iDynTree.Rotation();
rightFoot_T_FPRrot.fromMatlab ([ 1.0,  0.0,  0.0; ...
                                 0.0, -1.0,  0.0; ...
                                 0.0,  0.0, -1.0]);
rightFoot_T_FPRpos = iDynTree.Position();
% Assumption on the foot position: the position of the foot is given by the
% mean of the CoP.
rightFoot_x = mean(forceplates_SF.CoP.interpolated.Right.CoPx) * 1e-3; % in [m]
rightFoot_y = mean(forceplates_SF.CoP.interpolated.Right.CoPy) * 1e-3; % in [m]
z_foot      = abs(subjectParamsFromData.pRightPivotFoot(3));
z_heightFP  = 0.05; % in [m]
rightFoot_z = z_heightFP/2 + z_foot; % in [m]
FPRSeenFromRightFoot = -[rightFoot_x; rightFoot_y ; rightFoot_z]; % in [m]
rightFoot_T_FPRpos.fromMatlab(FPRSeenFromRightFoot);

rightFoot_T_FPR = iDynTree.Transform(rightFoot_T_FPRrot, rightFoot_T_FPRpos);
forceplates_HF.humanRightFootWrench = ...
    -1 * (rightFoot_T_FPR.asAdjointTransformWrench().toMatlab()* ...
    FPwrench_R);

%% Transform FPwrench_L from forceplates frames into human frames
% We want: leftFoot_f_FPL starting from FPL_f_FPL
leftFoot_T_FPLrot = iDynTree.Rotation();
leftFoot_T_FPLrot.fromMatlab ([ -1.0, 0.0,  0.0; ...
                                 0.0, 1.0,  0.0; ...
                                 0.0, 0.0, -1.0]);
leftFoot_T_FPLpos = iDynTree.Position();
% Assumption on the foot position: the position of the foot is given by the
% mean of the CoP.
leftFoot_x = mean(forceplates_SF.CoP.interpolated.Left.CoPx) * 1e-3; % in [m]
leftFoot_y = mean(forceplates_SF.CoP.interpolated.Left.CoPy) * 1e-3; % in [m]
z_foot     = abs(subjectParamsFromData.pLeftPivotFoot(3));
z_heightFP = 0.05; % in [m]
leftFoot_z = z_heightFP/2 + z_foot; % in [m]
FPLSeenFromLeftFoot = [-leftFoot_x; leftFoot_y ; -leftFoot_z]; % in [m]
leftFoot_T_FPLpos.fromMatlab(FPLSeenFromLeftFoot);

leftFoot_T_FPL = iDynTree.Transform(leftFoot_T_FPLrot, leftFoot_T_FPLpos);
forceplates_HF.humanLeftFootWrench = ...
    -1 * (leftFoot_T_FPL.asAdjointTransformWrench().toMatlab()* ...
    FPwrench_L);
end

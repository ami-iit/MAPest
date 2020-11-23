
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.


%% 6D forces from the SPEXOR table
len = length(EXO.roundedTable.force);
EXO.exoForces.fT8_table_SPEXOR     = zeros(6,len);
EXO.exoForces.fPelvis_table_SPEXOR = zeros(6,len);
for lenIdx = 1 : len
    % T8
    EXO.exoForces.fT8_table_SPEXOR(1,lenIdx) = EXO.roundedTable.force(lenIdx) ...
        * sin(EXO.roundedTable.alpha(lenIdx)); % fx
    EXO.exoForces.fT8_table_SPEXOR(3,lenIdx) = EXO.roundedTable.force(lenIdx) ...
        * cos(EXO.roundedTable.alpha(lenIdx)); % fz
    
    % Pelvis
    EXO.exoForces.fPelvis_table_SPEXOR(1,lenIdx) = - EXO.exoForces.fT8_table_SPEXOR(1,lenIdx); % fx
    EXO.exoForces.fPelvis_table_SPEXOR(3,lenIdx) = - EXO.exoForces.fT8_table_SPEXOR(3,lenIdx); % fz
end
% no moments

%% Compute iDynTree transforms
% ================================ T8 =====================================
% ------------------------- from T8table to T8 ----------------------------
EXO.T8_R_T8table = [ 1.0,  0.0,  0.0; ...
    0.0,  -1.0,   0.0; ...
    0.0,   0.0,  -1.0];
EXO.tmp.exoT8distance = subjectParamsFromData.T8Box(1)/2;
EXO.tmp.T8exoSeenFromT8 = [-EXO.tmp.exoT8distance; 0; 0];

EXO.T8_T_T8tableRot = iDynTree.Rotation();
EXO.T8_T_T8tableRot.fromMatlab(EXO.T8_R_T8table);
EXO.T8_T_T8tablePos = iDynTree.Position();
EXO.T8_T_T8tablePos.fromMatlab(EXO.tmp.T8exoSeenFromT8);
EXO.T8_T_T8table = iDynTree.Transform(EXO.T8_T_T8tableRot, EXO.T8_T_T8tablePos);

% =============================== Pelvis ==================================
% ----------------------- from pelvisTable to pelvis ----------------------
EXO.pelvis_R_pelvisTable = [ 1.0,  0.0,  0.0; ...
    0.0,  -1.0,   0.0; ...
    0.0,   0.0,  -1.0];
EXO.tmp.exoPelvisDistance = subjectParamsFromData.pelvisBox(1)/2;
EXO.tmp.pelvisExoSeenFromPelvis = [-EXO.tmp.exoPelvisDistance; 0; 0];

EXO.pelvis_T_pelvisTableRot = iDynTree.Rotation();
EXO.pelvis_T_pelvisTableRot.fromMatlab(EXO.pelvis_R_pelvisTable);
EXO.pelvis_T_pelvisTablePos = iDynTree.Position();
EXO.pelvis_T_pelvisTablePos.fromMatlab(EXO.tmp.pelvisExoSeenFromPelvis);
EXO.pelvis_T_pelvisTable = iDynTree.Transform(EXO.pelvis_T_pelvisTableRot, EXO.pelvis_T_pelvisTablePos);

%% Transform exo table 6D forces into human frames
% Transform f_table from table frames to URDF frames
for lenIdx = 1 : len
    % T8
    EXO.transformedForces.fT8(:,lenIdx) = (EXO.T8_T_T8table.asAdjointTransformWrench().toMatlab() * ...
        EXO.exoForces.fT8_table_SPEXOR(:,lenIdx));
    % Pelvis
    EXO.transformedForces.fPelvis(:,lenIdx) = (EXO.pelvis_T_pelvisTable.asAdjointTransformWrench().toMatlab() * ...
        EXO.exoForces.fPelvis_table_SPEXOR(:,lenIdx));
end

%% Final format for packaging
EXOfext.T8 = EXO.transformedForces.fT8;
EXOfext.PELVIS = EXO.transformedForces.fPelvis;


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
    EXO.exoForces.fT8_table_SPEXOR(1,lenIdx) = - EXO.roundedTable.force(lenIdx) ...
        * sin(EXO.roundedTable.alpha(lenIdx)); % fx
    EXO.exoForces.fT8_table_SPEXOR(2,lenIdx) = - EXO.roundedTable.force(lenIdx) ...
        * cos(EXO.roundedTable.alpha(lenIdx)); % fy
    
    % Pelvis
    EXO.exoForces.fPelvis_table_SPEXOR(1,lenIdx) = EXO.exoForces.fT8_table_SPEXOR(1,lenIdx); % fx, hp: equal
    EXO.exoForces.fPelvis_table_SPEXOR(2,lenIdx) = EXO.exoForces.fT8_table_SPEXOR(2,lenIdx); % fy, hp: equal

%     % Right Upper Leg --> RUL
%     EXO.exoForces.fRUL_table_SPEXOR(1,lenIdx) = 1/2 * (EXO.exoForces.fT8_table_SPEXOR(1,lenIdx)); % fx, hp: equal
%     EXO.exoForces.fRUL_table_SPEXOR(2,lenIdx) = 1/2 * (EXO.exoForces.fT8_table_SPEXOR(2,lenIdx)); % fy, hp: equal
%     % Left Upper Leg --> LUL
%     EXO.exoForces.fLUL_table_SPEXOR(1,lenIdx) = 1/2 * (EXO.exoForces.fT8_table_SPEXOR(1,lenIdx)); % fx, hp: equal
%     EXO.exoForces.fLUL_table_SPEXOR(2,lenIdx) = 1/2 * (EXO.exoForces.fT8_table_SPEXOR(2,lenIdx)); % fy, hp: equal
end
% no moments

%% Maccepa axis
EXO.exoForces.fRUL = zeros(6,len);
EXO.exoForces.fLUL = zeros(6,len);
length_upper_maccepa = 0.20; % m, hp
length_lower_maccepa = 0.30; % m, hp
% hp: 1 == 28 beam

computeTauViaMaccepa;

% from the balance of the torques w.r.t. the maccepa axis
for lenIdx = 1 : len
    % Right Upper Leg --> RUL
    EXO.exoForces.fRUL(1,lenIdx) = (- EXO.maccepa.tau(1,lenIdx) - ...
        length_upper_maccepa*(EXO.exoForces.fPelvis_table_SPEXOR(1,lenIdx)/2))/length_lower_maccepa;
    % Left Upper Leg --> LUL
    EXO.exoForces.fLUL(1,lenIdx) = (- EXO.maccepa.tau(1,lenIdx) - ...
        length_upper_maccepa*(EXO.exoForces.fPelvis_table_SPEXOR(1,lenIdx)/2))/length_lower_maccepa;
end

%% Compute iDynTree transforms
% ================================ T8 =====================================
% ------------------------- from T8table to T8 ----------------------------
EXO.T8_R_T8table = [ 0.0,   1.0,   0.0; ...
                     0.0,   0.0,  -1.0; ...
                    -1.0,   0.0,   0.0];
EXO.tmp.exoT8distance = subjectParamsFromData.T8Box(1)/2;
EXO.tmp.T8exoSeenFromT8 = [-EXO.tmp.exoT8distance; 0; 0];

EXO.T8_T_T8tableRot = iDynTree.Rotation();
EXO.T8_T_T8tableRot.fromMatlab(EXO.T8_R_T8table);
EXO.T8_T_T8tablePos = iDynTree.Position();
EXO.T8_T_T8tablePos.fromMatlab(EXO.tmp.T8exoSeenFromT8);
EXO.T8_T_T8table = iDynTree.Transform(EXO.T8_T_T8tableRot, EXO.T8_T_T8tablePos);

% % % =============================== Pelvis ==================================
% % % ----------------------- from pelvisTable to pelvis ----------------------
% % EXO.pelvis_R_pelvisTable = [ 1.0,  0.0,  0.0; ...
% %     0.0,  -1.0,   0.0; ...
% %     0.0,   0.0,  -1.0];
% % EXO.tmp.exoPelvisDistance = subjectParamsFromData.pelvisBox(1)/2;
% % EXO.tmp.pelvisExoSeenFromPelvis = [-EXO.tmp.exoPelvisDistance; 0; 0];
% % 
% % EXO.pelvis_T_pelvisTableRot = iDynTree.Rotation();
% % EXO.pelvis_T_pelvisTableRot.fromMatlab(EXO.pelvis_R_pelvisTable);
% % EXO.pelvis_T_pelvisTablePos = iDynTree.Position();
% % EXO.pelvis_T_pelvisTablePos.fromMatlab(EXO.tmp.pelvisExoSeenFromPelvis);
% % EXO.pelvis_T_pelvisTable = iDynTree.Transform(EXO.pelvis_T_pelvisTableRot, EXO.pelvis_T_pelvisTablePos);


% ========================= Right Upper Leg (RUL) =========================
% --------------------------- from RULexo to RUL --------------------------
EXO.RUL_R_RULexo = [ 0.0,   1.0,   0.0; ...
                     0.0,   0.0,  -1.0; ...
                    -1.0,   0.0,   0.0];
EXO.tmp.exoRULdistance_radius = subjectParamsFromData.rightUpperLeg_x/2;
EXO.tmp.exoRULdistance_length = subjectParamsFromData.rightUpperLeg_z/6; % hp
EXO.tmp.RULexoSeenFromRUL = [0; -EXO.tmp.exoRULdistance_radius; EXO.tmp.exoRULdistance_length];

EXO.RUL_T_RULexoRot = iDynTree.Rotation();
EXO.RUL_T_RULexoRot.fromMatlab(EXO.RUL_R_RULexo);
EXO.RUL_T_RULexoPos = iDynTree.Position();
EXO.RUL_T_RULexoPos.fromMatlab(EXO.tmp.RULexoSeenFromRUL);
EXO.RUL_T_RULexo = iDynTree.Transform(EXO.RUL_T_RULexoRot, EXO.RUL_T_RULexoPos);

% ========================= Left Upper Leg (LUL) ==========================
% --------------------------- from LULexo to LUL --------------------------
EXO.LUL_R_LULexo = [ 0.0,   1.0,   0.0; ...
                     0.0,   0.0,  -1.0; ...
                    -1.0,   0.0,   0.0];
EXO.tmp.LULexoSeenFromLUL = [0; EXO.tmp.exoRULdistance_radius; EXO.tmp.exoRULdistance_length];

EXO.LUL_T_LULexoRot = iDynTree.Rotation();
EXO.LUL_T_LULexoRot.fromMatlab(EXO.LUL_R_LULexo);
EXO.LUL_T_LULexoPos = iDynTree.Position();
EXO.LUL_T_LULexoPos.fromMatlab(EXO.tmp.LULexoSeenFromLUL);
EXO.LUL_T_LULexo = iDynTree.Transform(EXO.LUL_T_LULexoRot, EXO.LUL_T_LULexoPos);

%% Transform exo table 6D forces into human frames
% Transform f_table from table frames to URDF frames
for lenIdx = 1 : len
    % T8
    EXO.transformedForces.fT8(:,lenIdx) = (EXO.T8_T_T8table.asAdjointTransformWrench().toMatlab() * ...
        EXO.exoForces.fT8_table_SPEXOR(:,lenIdx));
    % % %     % Pelvis
    % % %     EXO.transformedForces.fPelvis(:,lenIdx) = (EXO.pelvis_T_pelvisTable.asAdjointTransformWrench().toMatlab() * ...
    % % %         EXO.exoForces.fPelvis_table_SPEXOR(:,lenIdx));

    % RUL
    EXO.transformedForces.fRUL(:,lenIdx) = (EXO.RUL_T_RULexo.asAdjointTransformWrench().toMatlab() * ...
        EXO.exoForces.fRUL(:,lenIdx));
    % LUL
     EXO.transformedForces.fLUL(:,lenIdx) = (EXO.LUL_T_LULexo.asAdjointTransformWrench().toMatlab() * ...
        EXO.exoForces.fLUL(:,lenIdx));
end

%% Final format for packaging
EXOfext.T8 = EXO.transformedForces.fT8;
% EXOfext.PELVIS = -EXO.transformedForces.fPelvis;
EXOfext.RUL = EXO.transformedForces.fRUL;
EXOfext.LUL = EXO.transformedForces.fLUL;

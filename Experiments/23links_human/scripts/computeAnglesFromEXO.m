
%% Preliminaries
close all;

for sjIdx = 1 : size(selectedJoints,1)
    % Right shoulder
    if (strcmp(selectedJoints{sjIdx,1},'jRightShoulder_rotx'))
        jRshoRotx_idx = sjIdx;
    end
    if (strcmp(selectedJoints{sjIdx,1},'jRightShoulder_roty'))
        jRshoRoty_idx = sjIdx;
    end
    if (strcmp(selectedJoints{sjIdx,1},'jRightShoulder_rotz'))
        jRshoRotz_idx = sjIdx;
    end
    % Left Shoulder
    if (strcmp(selectedJoints{sjIdx,1},'jLeftShoulder_rotx'))
        jLshoRotx_idx = sjIdx;
    end
    if (strcmp(selectedJoints{sjIdx,1},'jLeftShoulder_roty'))
        jLshoRoty_idx = sjIdx;
    end
    if (strcmp(selectedJoints{sjIdx,1},'jLeftShoulder_rotz'))
        jLshoRotz_idx = sjIdx;
    end
    %     % C7shoulders
    %     if (strcmp(selectedJoints{sjIdx,1},'jRightC7Shoulder_rotx'))
    %         jRshoC7Rotx_idx = sjIdx;
    %     end
    %     if (strcmp(selectedJoints{sjIdx,1},'jLeftC7Shoulder_rotx'))
    %         jLshoC7Rotx_idx = sjIdx;
    %     end
end

%% Compute angles from EXO
for blockIdx = 1 : block.nrOfBlocks
    len = size(synchroKin(blockIdx).masterTime ,2);
    
    % -------Right shoulder
    % Original angles from Opensim IK (q) in deg
    qx_rightSho = synchroKin(blockIdx).q(jRshoRotx_idx,:) * 180/pi; %deg
    qy_rightSho = synchroKin(blockIdx).q(jRshoRoty_idx,:) * 180/pi; %deg
    qz_rightSho = synchroKin(blockIdx).q(jRshoRotz_idx,:) * 180/pi; %deg
    %     qx_rightC7Sho = synchroKin(blockIdx).q(jRshoC7Rotx_idx,:) * 180/pi; %deg
    
    % -------Left shoulder
    % Original angles from Opensim IK (q) in deg
    qx_leftSho = synchroKin(blockIdx).q(jLshoRotx_idx,:) * 180/pi; %deg
    qy_leftSho = synchroKin(blockIdx).q(jLshoRoty_idx,:) * 180/pi; %deg
    qz_leftSho = synchroKin(blockIdx).q(jLshoRotz_idx,:) * 180/pi; %deg
    %     qx_leftC7Sho = synchroKin(blockIdx).q(jLshoC7Rotx_idx,:) * 180/pi; %deg
    
    qFirst_rightSho = zeros(3,len);
    qFirst_leftSho = zeros(3,len);
    for i = 1 : len
        %-------Right shoulder
        % They are expressed in current frame (terna mobile) and the order of
        % consecutive rotations is: R_q = R_qx * R_qy * R_qz (from models)
        q_rightSho = [synchroKin(blockIdx).q(jRshoRotx_idx,i); ...
            synchroKin(blockIdx).q(jRshoRoty_idx,i); ...
            synchroKin(blockIdx).q(jRshoRotz_idx,i)];
        [R_qx_rightSho, R_qy_rightSho, R_qz_rightSho] = angle2rots(q_rightSho);
        R_q_rightSho = R_qx_rightSho * R_qy_rightSho * R_qz_rightSho;
        % Compute angles(qFirst) with the coordinates change
        qxFirst_rightSho = atan2(R_q_rightSho(3,2),sqrt(R_q_rightSho(1,2)^2 + R_q_rightSho(2,2)^2));
        qyFirst_rightSho = atan2(-R_q_rightSho(3,1),R_q_rightSho(3,3));
        qzFirst_rightSho = atan2(-R_q_rightSho(1,2),R_q_rightSho(2,2));
        qFirst_rightSho(:,i) = [qxFirst_rightSho; qyFirst_rightSho; qzFirst_rightSho] * 180/pi; %deg;
        
        %-------Left shoulder
        % They are expressed in current frame (terna mobile) and the order of
        % consecutive rotations is: R_q = R_qx * R_qy * R_qz (from models)
        q_leftSho = [synchroKin(blockIdx).q(jLshoRotx_idx,i); ...
            synchroKin(blockIdx).q(jLshoRoty_idx,i); ...
            synchroKin(blockIdx).q(jLshoRotz_idx,i)];
        [R_qx_leftSho, R_qy_leftSho, R_qz_leftSho] = angle2rots(q_leftSho);
        R_q_leftSho = R_qx_leftSho * R_qy_leftSho * R_qz_leftSho;
        % Compute angles(qFirst) with the coordinates change
        qxFirst_leftSho = atan2(R_q_leftSho(3,2),sqrt(R_q_leftSho(1,2)^2 + R_q_leftSho(2,2)^2));
        qyFirst_leftSho = atan2(-R_q_leftSho(3,1),R_q_leftSho(3,3));
        qzFirst_leftSho = atan2(-R_q_leftSho(1,2),R_q_leftSho(2,2));
        qFirst_leftSho(:,i) = [qxFirst_leftSho; qyFirst_leftSho; qzFirst_leftSho] * 180/pi; %deg;
    end
    
    %% Save CoC data in a struct
    CoC(blockIdx).block = block.labels(blockIdx);
    CoC(blockIdx).masterTime = synchroKin(blockIdx).masterTime;
    %-------Right shoulder
    CoC(blockIdx).Rsho_q =[qx_rightSho; qy_rightSho; qz_rightSho]; %deg
    CoC(blockIdx).Rsho_qFirst = qFirst_rightSho; %deg
    %-------Left shoulder
    CoC(blockIdx).Lsho_q =[qx_leftSho; qy_leftSho; qz_leftSho]; %deg
    CoC(blockIdx).Lsho_qFirst = qFirst_leftSho; %deg
end

%% Clear vars
clearvars jRshoRotx_idx jRshoRoty_idx jRshoRotz_idx jLshoRotx_idx jLshoRoty_idx jLshoRotz_idx ...
    qx_rightSho qy_rightSho qz_rightSho qx_leftSho qy_leftSho qz_leftSho ...
    qFirst_rightSho   qFirst_leftSho ...
    q_rightSho q_leftSho ...
    R_q_rightSho R_q_leftSho ...
    R_qx_rightSho R_qy_rightSho R_qz_rightSho ...
    R_qx_leftSho  R_qy_leftSho  R_qz_leftSho ...
    qxFirst_rightSho qyFirst_rightSho qzFirst_rightSho ...
    qxFirst_leftSho  qyFirst_leftSho  qzFirst_leftSho;

%% Utility
function [Rx, Ry, Rz] = angle2rots(x)
%ANGLE2ROTS computes the three rotation matrices given a vector x of angles
% 3x1 expressed in radians.
% It is required that the vector x is ordered as follow:
%    | angle of the rotation around x |
% x =| angle of the rotation around y |
%    | angle of the rotation around z |

Rx = [ 1     0          0    ;
    0 cos(x(1)) -sin(x(1));
    0 sin(x(1))  cos(x(1))];

Ry = [ cos(x(2)) 0 sin(x(2));
    0     1     0    ;
    -sin(x(2)) 0 cos(x(2))];

Rz = [ cos(x(3)) -sin(x(3)) 0;
    sin(x(3))  cos(x(3)) 0;
    0          0     1];
end

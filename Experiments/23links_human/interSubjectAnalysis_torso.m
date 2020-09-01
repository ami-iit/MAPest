
%% ================== TORSO ================================================
%% Table mean per area
%% L5S1
% ---rotx
tmp.range = 1;
singleJointsTau.torso.tableTorsoMean.L5S1_rotx  = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.L5S1_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_rotx.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.L5S1_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_rotx.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.L5S1_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L5S1_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L5S1_rotx(exoCheckIdx,2));
end
% ---roty
tmp.range = 2;
singleJointsTau.torso.tableTorsoMean.L5S1_roty = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_roty.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_roty.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L5S1_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L5S1_roty(exoCheckIdx,2));
end
%% L4L3
% ---rotx
tmp.range = 3;
singleJointsTau.torso.tableTorsoMean.L4L3_rotx = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_rotx.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_rotx.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L4L3_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L4L3_rotx(exoCheckIdx,2));
end
% ---roty
tmp.range = 4;
singleJointsTau.torso.tableTorsoMean.L4L3_roty = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_roty.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_roty.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L4L3_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L4L3_roty(exoCheckIdx,2));
end
%% L1T12
% ---rotx
tmp.range = 5;
singleJointsTau.torso.tableTorsoMean.L1T12_rotx = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_rotx.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_rotx.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L1T12_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L1T12_rotx(exoCheckIdx,2));
end
% ---roty
tmp.range = 6;
singleJointsTau.torso.tableTorsoMean.L1T12_roty  = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_roty.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_roty.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L1T12_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L1T12_roty(exoCheckIdx,2));
end
%% T9T8
% ---rotx
tmp.range = 7;
singleJointsTau.torso.tableTorsoMean.T9T8_rotx = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotx.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotx.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotx(exoCheckIdx,2));
end
% ---roty
tmp.range = 8;
singleJointsTau.torso.tableTorsoMean.T9T8_roty = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_roty.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_roty.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_roty(exoCheckIdx,2));
end
% ---rotz
tmp.range = 9;
singleJointsTau.torso.tableTorsoMean.T9T8_rotz = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotz.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotz.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotz.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotz.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotz(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotz(exoCheckIdx,2));
end
%% T1C7
% ---rotx
tmp.range = 10;
singleJointsTau.torso.tableTorsoMean.T1C7_rotx = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotx.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotx.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotx(exoCheckIdx,2));
end
% ---roty
tmp.range = 11;
singleJointsTau.torso.tableTorsoMean.T1C7_roty = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_roty.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_roty.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_roty(exoCheckIdx,2));
end
% ---rotz
tmp.range = 12;
singleJointsTau.torso.tableTorsoMean.T1C7_rotz = zeros(block.nrOfBlocks,3);
for blockIdx = 1 : block.nrOfBlocks
    tmp.cluster(blockIdx).clusterJointsNE = [];
    tmp.cluster(blockIdx).clusterJointsWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotz.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
    singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotz.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
    % mean of mean
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotz.torqueMeanNE);
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotz.torqueMeanWE);
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : block.nrOfBlocks
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotz(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotz(exoCheckIdx,2));
end

%% Bar plot single joints
fig = figure();
axes1 = axes('Parent',fig, ...
    'YGrid','on',...
    'XTickLabel',{'rot_x',...
    'rot_y',...
    'rot_x',...
    'rot_y',...
    'rot_x',...
    'rot_y',...
    'rot_x',...
    'rot_y',...
    'rot_z',...
    'rot_x',...
    'rot_y',...
    'rot_z'},...
    'XTick',[1.9 3.9 5.9 7.9 9.9 11.9 13.9 15.9 17.9 19.9 21.9 23.9],...
    'FontSize',20);
box(axes1,'off');
hold(axes1,'on');
% xtickangle(45);
grid on;

bar1 = bar([1.3 3.3 5.3 7.3 9.3 11.3 13.3 15.3 17.3 19.3 21.3 23.3],...
    [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(1,3) ...
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(1,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(1,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(1,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(1,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(1,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(1,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(1,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(1,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(1,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(1,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(1,3)], ...
    0.15,'FaceColor',benefit_color_green);
for barIdx = 1 : 12
    if bar1.YData(barIdx) < 0
        bar1.FaceColor = 'flat';
        bar1.CData(barIdx,:) = noBenefit_color_red;
        text_custom = text(bar1.XData(barIdx),bar1.YData(barIdx),'1', ...
            'HorizontalAlignment','center','VerticalAlignment','top');
        set(text_custom,'FontSize',14);
    else
        text_custom = text(bar1.XData(barIdx),bar1.YData(barIdx),'1', ...
            'HorizontalAlignment','center','VerticalAlignment','bottom');
        set(text_custom,'FontSize',14);
    end
end
hold on;
bar2 = bar([1.6 3.6 5.6 7.6 9.6 11.6 13.6 15.6 17.6 19.6 21.6 23.6],...
    [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(2,3) ...
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(2,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(2,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(2,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(2,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(2,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(2,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(2,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(2,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(2,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(2,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(2,3)], ...
    0.15,'FaceColor',benefit_color_green);
for barIdx = 1 : 12
    if bar2.YData(barIdx) < 0
        bar2.FaceColor = 'flat';
        bar2.CData(barIdx,:) = noBenefit_color_red;
        text_custom = text(bar2.XData(barIdx),bar2.YData(barIdx),'2', ...
            'HorizontalAlignment','center','VerticalAlignment','top');
        set(text_custom,'FontSize',14);
    else
        text_custom = text(bar2.XData(barIdx),bar2.YData(barIdx),'2', ...
            'HorizontalAlignment','center','VerticalAlignment','bottom');
        set(text_custom,'FontSize',14);
    end
end
hold on;
bar3 = bar([1.9 3.9 5.9 7.9 9.9 11.9 13.9 15.9 17.9 19.9 21.9 23.9],...
    [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(3,3) ...
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(3,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(3,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(3,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(3,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(3,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(3,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(3,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(3,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(3,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(3,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(3,3)], ...
    0.15,'FaceColor',benefit_color_green);
for barIdx = 1 : 12
    if bar3.YData(barIdx) < 0
        bar3.FaceColor = 'flat';
        bar3.CData(barIdx,:) = noBenefit_color_red;
        text_custom = text(bar3.XData(barIdx),bar3.YData(barIdx),'3', ...
            'HorizontalAlignment','center','VerticalAlignment','top');
        set(text_custom,'FontSize',14);
    else
        text_custom = text(bar3.XData(barIdx),bar3.YData(barIdx),'3', ...
            'HorizontalAlignment','center','VerticalAlignment','bottom');
        set(text_custom,'FontSize',14);
    end
end
hold on;
bar4 = bar([2.2 4.2 6.2 8.2 10.2 12.2 14.2 16.2 18.2 20.2 22.2 24.2], ...
    [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(4,3) ...
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(4,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(4,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(4,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(4,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(4,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(4,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(4,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(4,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(4,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(4,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(4,3)], ...
    0.15,'FaceColor',benefit_color_green);
for barIdx = 1 : 12
    if bar4.YData(barIdx) < 0
        bar4.FaceColor = 'flat';
        bar4.CData(barIdx,:) = noBenefit_color_red;
        text_custom = text(bar4.XData(barIdx),bar4.YData(barIdx),'4', ...
            'HorizontalAlignment','center','VerticalAlignment','top');
        set(text_custom,'FontSize',14);
    else
        text_custom = text(bar4.XData(barIdx),bar4.YData(barIdx),'4', ...
            'HorizontalAlignment','center','VerticalAlignment','bottom');
        set(text_custom,'FontSize',14);
    end
end
hold on;
bar5 = bar([2.5 4.5 6.5 8.5 10.5 12.5 14.5 16.5 18.5 20.5 22.5 24.5], ...
    [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(5,3) ...
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(5,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(5,3) ...
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(5,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(5,3) ...
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(5,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(5,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(5,3) ...
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(5,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(5,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(5,3) ...
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(5,3)], ...
    0.15,'FaceColor',benefit_color_green);
for barIdx = 1 : 12
    if bar5.YData(barIdx) < 0
        bar5.FaceColor = 'flat';
        bar5.CData(barIdx,:) = noBenefit_color_red;
        text_custom = text(bar5.XData(barIdx),bar5.YData(barIdx),'5', ...
            'HorizontalAlignment','center','VerticalAlignment','top');
        set(text_custom,'FontSize',14);
    else
        text_custom = text(bar5.XData(barIdx),bar5.YData(barIdx),'5', ...
            'HorizontalAlignment','center','VerticalAlignment','bottom');
        set(text_custom,'FontSize',14);
    end
end

% Legend and title
% Note: this legend is tuned on the bar plot
leg = legend([bar3, bar1],'benefit', 'no-benefit');
set(leg,'Interpreter','latex');
set(leg,'FontSize',25);
set(leg,  'NumColumns', 2);

title('Torso','FontSize',20);
ylabel(' $|{\bar\tau_{NE}}|-|{\bar\tau_{WE}}|$ [Nm]','HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',26,...
    'Interpreter','latex');
ylim([-12, 11.5]);
set(axes1, 'XLimSpec', 'Tight');
% axis tight;

%% Patch
yl = ylim;
xl = xlim;
% L5S1
xl_L5S1 = bar5.XData(2) + (bar1.XData(2) - bar5.XData(1))/2;
xBox = [xl(1), xl_L5S1, xl_L5S1, xl(1), xl(1)];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch1 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch1,'DisplayName','L5S1');
txt = 'L5S1';
text(xl_L5S1/2,-11,txt,'FontSize',25);
% L4L3
xl_L4L3 = bar5.XData(4) + (bar1.XData(2) - bar5.XData(1))/2;
xBox = [xl_L5S1, xl_L4L3, xl_L4L3, xl_L5S1, xl_L5S1];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch2 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch2,'DisplayName','L4L3');
txt = 'L4L3';
text(xl_L5S1+(xl_L4L3-xl_L5S1)/3,-11,txt,'FontSize',25);
% L1T12
xl_L1T12 = bar5.XData(6) + (bar1.XData(2) - bar5.XData(1))/2;
xBox = [xl_L4L3, xl_L1T12, xl_L1T12, xl_L4L3, xl_L4L3];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch3 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch3,'DisplayName','L1T12');
txt = 'L1T12';
text(xl_L4L3+(xl_L1T12-xl_L4L3)/3,-11,txt,'FontSize',25);
% T9T8
xl_T9T8 = bar5.XData(9) + (bar1.XData(2) - bar5.XData(1))/2;
xBox = [xl_L1T12, xl_T9T8, xl_T9T8, xl_L1T12, xl_L1T12];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch4 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch4,'DisplayName','T9T8');
txt = 'T9T8';
text(xl_L1T12+(xl_T9T8-xl_L1T12)/3,-11,txt,'FontSize',25);
% T1C7
xl_T1C7 = bar5.XData(12) + (bar1.XData(2) - bar5.XData(1))/2;
xBox = [xl_T9T8, xl_T1C7, xl_T1C7, xl_T9T8, xl_T9T8];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch5 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch5,'DisplayName','T1C7');
txt = 'T1C7';
text(xl_T9T8+(xl_T1C7-xl_T9T8)/3,-11,txt,'FontSize',25);


%% Save
tightfig();
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_torsoTauMean_bar'),fig,600);
end


%% ================== TORSO with head ================================================
% % % %% Table mean per area
% % % %% L5S1
% % % % ---rotx
% % % tmp.range = 1;
% % % singleJointsTau.torso.tableTorsoMean.L5S1_rotx  = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_rotx.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_rotx.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_rotx(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L5S1_rotx(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L5S1_rotx(exoCheckIdx,2));
% % % end
% % % % ---roty
% % % tmp.range = 2;
% % % singleJointsTau.torso.tableTorsoMean.L5S1_roty = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_roty.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L5S1_roty.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_roty(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L5S1_roty(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L5S1_roty(exoCheckIdx,2));
% % % end
% % % %% L4L3
% % % % ---rotx
% % % tmp.range = 3;
% % % singleJointsTau.torso.tableTorsoMean.L4L3_rotx = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_rotx.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_rotx.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_rotx(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L4L3_rotx(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L4L3_rotx(exoCheckIdx,2));
% % % end
% % % % ---roty
% % % tmp.range = 4;
% % % singleJointsTau.torso.tableTorsoMean.L4L3_roty = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_roty.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L4L3_roty.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_roty(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L4L3_roty(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L4L3_roty(exoCheckIdx,2));
% % % end
% % % %% L1T12
% % % % ---rotx
% % % tmp.range = 5;
% % % singleJointsTau.torso.tableTorsoMean.L1T12_rotx = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_rotx.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_rotx.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_rotx(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L1T12_rotx(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L1T12_rotx(exoCheckIdx,2));
% % % end
% % % % ---roty
% % % tmp.range = 6;
% % % singleJointsTau.torso.tableTorsoMean.L1T12_roty  = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_roty.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).L1T12_roty.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_roty(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L1T12_roty(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.L1T12_roty(exoCheckIdx,2));
% % % end
% % % %% T9T8
% % % % ---rotx
% % % tmp.range = 7;
% % % singleJointsTau.torso.tableTorsoMean.T9T8_rotx = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotx.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotx.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotx(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotx(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotx(exoCheckIdx,2));
% % % end
% % % % ---roty
% % % tmp.range = 8;
% % % singleJointsTau.torso.tableTorsoMean.T9T8_roty = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_roty.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_roty.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_roty(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T9T8_roty(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T9T8_roty(exoCheckIdx,2));
% % % end
% % % % ---rotz
% % % tmp.range = 9;
% % % singleJointsTau.torso.tableTorsoMean.T9T8_rotz = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotz.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotz.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotz(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotz.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotz(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T9T8_rotz.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotz(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotz(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotz(exoCheckIdx,2));
% % % end
% % % %% T1C7
% % % % ---rotx
% % % tmp.range = 10;
% % % singleJointsTau.torso.tableTorsoMean.T1C7_rotx = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotx.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotx.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotx(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotx(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotx(exoCheckIdx,2));
% % % end
% % % % ---roty
% % % tmp.range = 11;
% % % singleJointsTau.torso.tableTorsoMean.T1C7_roty = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_roty.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_roty.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_roty(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T1C7_roty(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T1C7_roty(exoCheckIdx,2));
% % % end
% % % % ---rotz
% % % tmp.range = 12;
% % % singleJointsTau.torso.tableTorsoMean.T1C7_rotz = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotz.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotz.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotz(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotz.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotz(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).T1C7_rotz.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotz(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotz(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotz(exoCheckIdx,2));
% % % end
% % % %% head
% % % % ---rotx
% % % tmp.range = 13;
% % % singleJointsTau.torso.tableTorsoMean.head_rotx = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).head_rotx.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).head_rotx.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.head_rotx(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).head_rotx.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.head_rotx(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).head_rotx.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.head_rotx(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.head_rotx(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.head_rotx(exoCheckIdx,2));
% % % end
% % % % ---roty
% % % tmp.range = 14;
% % % singleJointsTau.torso.tableTorsoMean.head_roty  = zeros(block.nrOfBlocks,3);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cluster(blockIdx).clusterJointsNE = [];
% % %     tmp.cluster(blockIdx).clusterJointsWE = [];
% % %     % Create vector for all the subjects divided in blocks
% % %     for subjIdx = 1 : nrOfSubject
% % %         tmp.cluster(blockIdx).clusterJointsNE = [tmp.cluster(blockIdx).clusterJointsNE; ...
% % %             intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
% % %         tmp.cluster(blockIdx).clusterJointsWE = [tmp.cluster(blockIdx).clusterJointsWE; ...
% % %             intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
% % %     end
% % %     % mean vector
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).head_roty.torqueMeanNE = mean(tmp.cluster(blockIdx).clusterJointsNE);
% % %     singleJointsTau.torso.jointsPerArea(blockIdx).head_roty.torqueMeanWE = mean(tmp.cluster(blockIdx).clusterJointsWE);
% % %     % mean of mean
% % %     singleJointsTau.torso.tableTorsoMean.head_roty(blockIdx,1) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).head_roty.torqueMeanNE);
% % %     singleJointsTau.torso.tableTorsoMean.head_roty(blockIdx,2) = mean(singleJointsTau.torso.jointsPerArea(blockIdx).head_roty.torqueMeanWE);
% % % end
% % % % Chech overall effort status due to exo presence
% % % for exoCheckIdx = 1 : block.nrOfBlocks
% % %     singleJointsTau.torso.tableTorsoMean.head_roty(exoCheckIdx,3) = ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.head_roty(exoCheckIdx,1)) - ...
% % %         abs(singleJointsTau.torso.tableTorsoMean.head_roty(exoCheckIdx,2));
% % % end
% % % 
% % % %% Mean from bar results
% % % % singleJointsTau.torso.tableTorsoMean.totalFromBarResults = zeros(block.nrOfBlocks,1);
% % % % for blockIdx = 1 : block.nrOfBlocks
% % % %     tmp.temp(blockIdx).resultsVect = [];
% % % %     tmp.temp(blockIdx).resultsVect  = [singleJointsTau.torso.tableTorsoMean.L5S1(blockIdx,3); ...
% % % %         singleJointsTau.torso.tableTorsoMean.L4L3(blockIdx,3); ...
% % % %         singleJointsTau.torso.tableTorsoMean.L1T12(blockIdx,3); ...
% % % %         singleJointsTau.torso.tableTorsoMean.T9T8(blockIdx,3); ...
% % % %         singleJointsTau.torso.tableTorsoMean.T1C7(blockIdx,3); ...
% % % %         singleJointsTau.torso.tableTorsoMean.head(blockIdx,3)];
% % % %     % mean vector
% % % %     singleJointsTau.torso.tableTorsoMean.totalFromBarResults(blockIdx,1) = mean(tmp.temp(blockIdx).resultsVect);
% % % % end
% % % 
% % % %% Bar plot single joints
% % % fig = figure();
% % % axes1 = axes('Parent',fig, ...
% % %     'YGrid','on',...
% % %     'XTickLabel',{'L5S1_x',...
% % %     'L5S1_y',...
% % %     'L4L3_x',...
% % %     'L4L3_y',...
% % %     'L1T12_x',...
% % %     'L1T12_y',...
% % %     'T9T8_x',...
% % %     'T9T8_y',...
% % %     'T9T8_z',...
% % %     'T1C7_x',...
% % %     'T1C7_y',...
% % %     'T1C7_z',...
% % %     'head_x',...
% % %     'head_y'},...
% % %     'XTick',[1.9 3.9 5.9 7.9 9.9 11.9 13.9 15.9 17.9 19.9 21.9 23.9 25.9 27.9],...
% % %     'FontSize',20);
% % % box(axes1,'off');
% % % hold(axes1,'on');
% % % % xtickangle(45);
% % % 
% % % bar1 = bar([1.3 3.3 5.3 7.3 9.3 11.3 13.3 15.3 17.3 19.3 21.3 23.3 25.3 27.3],...
% % %     [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_roty(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_rotx(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_roty(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_rotx(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_roty(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotx(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_roty(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotz(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotx(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_roty(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotz(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_rotx(1,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_roty(1,3)], ...
% % %     0.15,'FaceColor',benefit_color_green);
% % % for barIdx = 1 : 14
% % %     if bar1.YData(barIdx) < 0
% % %         bar1.FaceColor = 'flat';
% % %         bar1.CData(barIdx,:) = noBenefit_color_red;
% % %         text_custom = text(bar1.XData(barIdx),bar1.YData(barIdx),'1', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','top');
% % %         set(text_custom,'FontSize',14);
% % %     else
% % %         text_custom = text(bar1.XData(barIdx),bar1.YData(barIdx),'1', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','bottom');
% % %         set(text_custom,'FontSize',14);
% % %     end
% % % end
% % % hold on;
% % % bar2 = bar([1.6 3.6 5.6 7.6 9.6 11.6 13.6 15.6 17.6 19.6 21.6 23.6 25.6 27.6],...
% % %     [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_roty(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_rotx(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_roty(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_rotx(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_roty(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotx(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_roty(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotz(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotx(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_roty(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotz(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_rotx(2,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_roty(2,3)], ...
% % %     0.15,'FaceColor',benefit_color_green);
% % % for barIdx = 1 : 14
% % %     if bar2.YData(barIdx) < 0
% % %         bar2.FaceColor = 'flat';
% % %         bar2.CData(barIdx,:) = noBenefit_color_red;
% % %         text_custom = text(bar2.XData(barIdx),bar2.YData(barIdx),'2', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','top');
% % %         set(text_custom,'FontSize',14);
% % %     else
% % %         text_custom = text(bar2.XData(barIdx),bar2.YData(barIdx),'2', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','bottom');
% % %         set(text_custom,'FontSize',14);
% % %     end
% % % end
% % % hold on;
% % % bar3 = bar([1.9 3.9 5.9 7.9 9.9 11.9 13.9 15.9 17.9 19.9 21.9 23.9 25.9 27.9],...
% % %     [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_roty(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_rotx(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_roty(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_rotx(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_roty(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotx(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_roty(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotz(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotx(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_roty(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotz(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_rotx(3,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_roty(3,3)], ...
% % %     0.15,'FaceColor',benefit_color_green);
% % % for barIdx = 1 : 14
% % %     if bar3.YData(barIdx) < 0
% % %         bar3.FaceColor = 'flat';
% % %         bar3.CData(barIdx,:) = noBenefit_color_red;
% % %         text_custom = text(bar3.XData(barIdx),bar3.YData(barIdx),'3', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','top');
% % %         set(text_custom,'FontSize',14);
% % %     else
% % %         text_custom = text(bar3.XData(barIdx),bar3.YData(barIdx),'3', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','bottom');
% % %         set(text_custom,'FontSize',14);
% % %     end
% % % end
% % % hold on;
% % % bar4 = bar([2.2 4.2 6.2 8.2 10.2 12.2 14.2 16.2 18.2 20.2 22.2 24.2 26.2 28.2], ...
% % %     [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_roty(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_rotx(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_roty(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_rotx(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_roty(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotx(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_roty(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotz(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotx(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_roty(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotz(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_rotx(4,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_roty(4,3)], ...
% % %     0.15,'FaceColor',benefit_color_green);
% % % for barIdx = 1 : 14
% % %     if bar4.YData(barIdx) < 0
% % %         bar4.FaceColor = 'flat';
% % %         bar4.CData(barIdx,:) = noBenefit_color_red;
% % %         text_custom = text(bar4.XData(barIdx),bar4.YData(barIdx),'4', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','top');
% % %         set(text_custom,'FontSize',14);
% % %     else
% % %         text_custom = text(bar4.XData(barIdx),bar4.YData(barIdx),'4', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','bottom');
% % %         set(text_custom,'FontSize',14);
% % %     end
% % % end
% % % hold on;
% % % bar5 = bar([2.5 4.5 6.5 8.5 10.5 12.5 14.5 16.5 18.5 20.5 22.5 24.5 26.5 28.5], ...
% % %     [singleJointsTau.torso.tableTorsoMean.L5S1_rotx(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L5S1_roty(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_rotx(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L4L3_roty(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_rotx(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.L1T12_roty(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotx(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_roty(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T9T8_rotz(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotx(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_roty(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.T1C7_rotz(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_rotx(5,3) ...
% % %     singleJointsTau.torso.tableTorsoMean.head_roty(5,3)], ...
% % %     0.15,'FaceColor',benefit_color_green);
% % % for barIdx = 1 : 14
% % %     if bar5.YData(barIdx) < 0
% % %         bar5.FaceColor = 'flat';
% % %         bar5.CData(barIdx,:) = noBenefit_color_red;
% % %         text_custom = text(bar5.XData(barIdx),bar5.YData(barIdx),'5', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','top');
% % %         set(text_custom,'FontSize',14);
% % %     else
% % %         text_custom = text(bar5.XData(barIdx),bar5.YData(barIdx),'5', ...
% % %             'HorizontalAlignment','center','VerticalAlignment','bottom');
% % %         set(text_custom,'FontSize',14);
% % %     end
% % % end
% % % 
% % % % Legend and title
% % % % Note: this legend is tuned on the bar plot
% % % leg = legend([bar3, bar1],'benefit', 'no-benefit');
% % % set(leg,'Interpreter','latex');
% % % set(leg,'FontSize',25);
% % % set(leg,  'NumColumns', 2);
% % % 
% % % title('Torso','FontSize',20);
% % % ylabel(' $|{\bar\tau_{NE}}|-|{\bar\tau_{WE}}|$ [Nm]','HorizontalAlignment','center',...
% % %     'FontWeight','bold',...
% % %     'FontSize',26,...
% % %     'Interpreter','latex');
% % % ylim([-10, 12]);
% % % set(axes1, 'XLimSpec', 'Tight');
% % % % axis tight;
% % % 
% % % %% Patch
% % % yl = ylim;
% % % xl = xlim;
% % % % L5S1
% % % xl_L5S1 = bar5.XData(2) + (bar1.XData(2) - bar5.XData(1))/2;
% % % xBox = [xl(1), xl_L5S1, xl_L5S1, xl(1), xl(1)];
% % % yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
% % % patch1 = patch(xBox, yBox, 'black', 'FaceColor', 'green', 'FaceAlpha', 0.05);
% % % set(patch1,'DisplayName','L5S1');
% % % % L4L3
% % % xl_L4L3 = bar5.XData(4) + (bar1.XData(2) - bar5.XData(1))/2;
% % % xBox = [xl_L5S1, xl_L4L3, xl_L4L3, xl_L5S1, xl_L5S1];
% % % yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
% % % patch2 = patch(xBox, yBox, 'black', 'FaceColor', 'red', 'FaceAlpha', 0.05);
% % % set(patch2,'DisplayName','L4L3');
% % % % L1T12
% % % xl_L1T12 = bar5.XData(6) + (bar1.XData(2) - bar5.XData(1))/2;
% % % xBox = [xl_L4L3, xl_L1T12, xl_L1T12, xl_L4L3, xl_L4L3];
% % % yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
% % % patch3 = patch(xBox, yBox, 'black', 'FaceColor', 'blue', 'FaceAlpha', 0.05);
% % % set(patch3,'DisplayName','L1T12');
% % % % T9T8
% % % xl_T9T8 = bar5.XData(9) + (bar1.XData(2) - bar5.XData(1))/2;
% % % xBox = [xl_L1T12, xl_T9T8, xl_T9T8, xl_L1T12, xl_L1T12];
% % % yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
% % % patch4 = patch(xBox, yBox, 'black', 'FaceColor', 'yellow', 'FaceAlpha', 0.05);
% % % set(patch4,'DisplayName','T9T8');
% % % % T1C7
% % % xl_T1C7 = bar5.XData(12) + (bar1.XData(2) - bar5.XData(1))/2;
% % % xBox = [xl_T9T8, xl_T1C7, xl_T1C7, xl_T9T8, xl_T9T8];
% % % yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
% % % patch5 = patch(xBox, yBox, 'black', 'FaceColor', 'magenta', 'FaceAlpha', 0.05);
% % % set(patch5,'DisplayName','T1C7');
% % % % head
% % % xl_head = bar5.XData(14) + (bar1.XData(2) - bar5.XData(1))/2;
% % % xBox = [xl_T1C7, xl_head, xl_head, xl_T1C7, xl_T1C7];
% % % yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
% % % patch6 = patch(xBox, yBox, 'black', 'FaceColor', 'black', 'FaceAlpha', 0.05);
% % % set(patch6,'DisplayName','head');
% % % 
% % % %% Save
% % % tightfig();
% % % if saveON
% % %     save2pdf(fullfile(bucket.pathToPlots,'intersubj_torsoTauMean_bar'),fig,600);
% % % end
% % % 


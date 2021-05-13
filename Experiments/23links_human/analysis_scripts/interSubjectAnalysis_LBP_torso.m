
% Copyright (C) 2021 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% ========================================================================
%% =============================== HEAD ===================================
%% ========================================================================
%% Head
%% ---rotx
tmp.range = 13;
singleJointsTau.torso.tableTorsoMean.C1Head_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
% Create vector for all the subjects divided in blocks
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.C1Head_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.C1Head_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.C1Head_rotx(1,1) = mean(singleJointsTau.torso.jointsPerArea.C1Head_rotx.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.C1Head_rotx(1,2) = mean(singleJointsTau.torso.jointsPerArea.C1Head_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.C1Head_rotx(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.C1Head_rotx(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.C1Head_rotx(1,2));

%% ---roty
tmp.range = 14;
singleJointsTau.torso.tableTorsoMean.C1Head_roty = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
% Create vector for all the subjects divided in blocks
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.C1Head_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.C1Head_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.C1Head_roty(1,1) = mean(singleJointsTau.torso.jointsPerArea.C1Head_roty.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.C1Head_roty(1,2) = mean(singleJointsTau.torso.jointsPerArea.C1Head_roty.torqueMeanWE);
% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.C1Head_roty(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.C1Head_roty(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.C1Head_roty(1,2));

%% ========================================================================
%% =============================== L5S1 ===================================
%% ========================================================================
%% ---rotx
tmp.range = 1;
singleJointsTau.torso.tableTorsoMean.L5S1_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
% Create vector for all the subjects
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.L5S1_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.L5S1_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.L5S1_rotx(1,1) = mean(singleJointsTau.torso.jointsPerArea.L5S1_rotx.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.L5S1_rotx(1,2) = mean(singleJointsTau.torso.jointsPerArea.L5S1_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.L5S1_rotx(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.L5S1_rotx(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.L5S1_rotx(1,2));

% Plot mean
fig = figure('Name', 'jL5S1 rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
% NE
plot1 = plot(singleJointsTau.torso.jointsPerArea.L5S1_rotx.torqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
axis tight;
ax = gca;
ax.FontSize = 20;
hold on
% WE
plot2 = plot(singleJointsTau.torso.jointsPerArea.L5S1_rotx.torqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
hold on
% title(sprintf('Block %s', num2str(blockIdx)),'FontSize',22);
ylabel('$\bar\tau$ [Nm]','HorizontalAlignment','center',...
    'FontSize',30,'interpreter','latex');
xlabel('samples','FontSize',25);
grid on;
%legend
leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
set(leg,'Interpreter','latex','FontSize',25);
% axis tight
%     ylim([-1.8, 0.7]);
%     ylim([-1.8, 0.8]);
%     yticks([-1 0])
% align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_overallTauMean'),fig,600);
end

%% ---roty
tmp.range = 2;
singleJointsTau.torso.tableTorsoMean.L5S1_roty = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.L5S1_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.L5S1_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.L5S1_roty(1,1) = mean(singleJointsTau.torso.jointsPerArea.L5S1_roty.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.L5S1_roty(1,2) = mean(singleJointsTau.torso.jointsPerArea.L5S1_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.L5S1_roty(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.L5S1_roty(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.L5S1_roty(1,2));

% % % % Plot mean
% % % fig = figure('Name', 'jL5S1 roty','NumberTitle','off');
% % % axes1 = axes('Parent',fig,'FontSize',16);
% % % box(axes1,'on');
% % % hold(axes1,'on');
% % % grid on;
% % %
% % % % NE
% % % plot1 = plot(singleJointsTau.torso.jointsPerArea.L5S1_roty.torqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
% % % axis tight;
% % % ax = gca;
% % % ax.FontSize = 20;
% % % hold on
% % % % WE
% % % plot2 = plot(singleJointsTau.torso.jointsPerArea.L5S1_roty.torqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
% % % hold on
% % % %title(sprintf('Block %s', num2str),'FontSize',22);
% % % ylabel('$\bar\tau$ [Nm]','HorizontalAlignment','center',...
% % %     'FontSize',30,'interpreter','latex');
% % % xlabel('samples','FontSize',25);
% % %
% % % grid on;
% % % %legend
% % % leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
% % % set(leg,'Interpreter','latex','FontSize',25);
% % % % axis tight
% % % %     ylim([-1.8, 0.7]);
% % % %     ylim([-1.8, 0.8]);
% % % %     yticks([-1 0])
% % %
% % % % align_Ylabels(gcf)
% % % % subplotsqueeze(gcf, 1.12);
% % % tightfig();
% % % % save
% % % if saveON
% % %     save2pdf(fullfile(bucket.pathToPlots,'intersubj_overallTauMean'),fig,600);
% % % end

%% ========================================================================
%% =============================== L4L3 ===================================
%% ========================================================================
%% ---rotx
tmp.range = 3;
singleJointsTau.torso.tableTorsoMean.L4L3_rotx = zeros(1,3);

tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.L4L3_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.L4L3_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.L4L3_rotx(1,1) = mean(singleJointsTau.torso.jointsPerArea.L4L3_rotx.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.L4L3_rotx(1,2) = mean(singleJointsTau.torso.jointsPerArea.L4L3_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.L4L3_rotx(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.L4L3_rotx(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.L4L3_rotx(1,2));

%% ---roty
tmp.range = 4;
singleJointsTau.torso.tableTorsoMean.L4L3_roty = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.L4L3_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.L4L3_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.L4L3_roty(1,1) = mean(singleJointsTau.torso.jointsPerArea.L4L3_roty.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.L4L3_roty(1,2) = mean(singleJointsTau.torso.jointsPerArea.L4L3_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.L4L3_roty(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.L4L3_roty(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.L4L3_roty(1,2));

%% ========================================================================
%% ============================== L1T12 ===================================
%% ========================================================================
%% ---rotx
tmp.range = 5;
singleJointsTau.torso.tableTorsoMean.L1T12_rotx = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.L1T12_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.L1T12_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.L1T12_rotx(1,1) = mean(singleJointsTau.torso.jointsPerArea.L1T12_rotx.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.L1T12_rotx(1,2) = mean(singleJointsTau.torso.jointsPerArea.L1T12_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.L1T12_rotx(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.L1T12_rotx(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.L1T12_rotx(1,2));

%% ---roty
tmp.range = 6;
singleJointsTau.torso.tableTorsoMean.L1T12_roty  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.L1T12_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.L1T12_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.L1T12_roty(1,1) = mean(singleJointsTau.torso.jointsPerArea.L1T12_roty.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.L1T12_roty(1,2) = mean(singleJointsTau.torso.jointsPerArea.L1T12_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.L1T12_roty(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.L1T12_roty(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.L1T12_roty(1,2));

%% ========================================================================
%% =============================== T9T8 ===================================
%% ========================================================================
%% ---rotx
tmp.range = 7;
singleJointsTau.torso.tableTorsoMean.T9T8_rotx = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.T9T8_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.T9T8_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.T9T8_rotx(1,1) = mean(singleJointsTau.torso.jointsPerArea.T9T8_rotx.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.T9T8_rotx(1,2) = mean(singleJointsTau.torso.jointsPerArea.T9T8_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.T9T8_rotx(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotx(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotx(1,2));

%% ---roty
tmp.range = 8;
singleJointsTau.torso.tableTorsoMean.T9T8_roty = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.T9T8_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.T9T8_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.T9T8_roty(1,1) = mean(singleJointsTau.torso.jointsPerArea.T9T8_roty.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.T9T8_roty(1,2) = mean(singleJointsTau.torso.jointsPerArea.T9T8_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.T9T8_roty(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.T9T8_roty(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.T9T8_roty(1,2));

%% ---rotz
tmp.range = 9;
singleJointsTau.torso.tableTorsoMean.T9T8_rotz = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.T9T8_rotz.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.T9T8_rotz.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.T9T8_rotz(1,1) = mean(singleJointsTau.torso.jointsPerArea.T9T8_rotz.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.T9T8_rotz(1,2) = mean(singleJointsTau.torso.jointsPerArea.T9T8_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.T9T8_rotz(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotz(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotz(1,2));

%% ========================================================================
%% =============================== T1C7 ===================================
%% ========================================================================
%% ---rotx
tmp.range = 10;
singleJointsTau.torso.tableTorsoMean.T1C7_rotx = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.T1C7_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.T1C7_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.T1C7_rotx(1,1) = mean(singleJointsTau.torso.jointsPerArea.T1C7_rotx.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.T1C7_rotx(1,2) = mean(singleJointsTau.torso.jointsPerArea.T1C7_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.T1C7_rotx(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotx(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotx(1,2));

%% ---roty
tmp.range = 11;
singleJointsTau.torso.tableTorsoMean.T1C7_roty = zeros(1,3);

tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.T1C7_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.T1C7_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.torso.tableTorsoMean.T1C7_roty(1,1) = mean(singleJointsTau.torso.jointsPerArea.T1C7_roty.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.T1C7_roty(1,2) = mean(singleJointsTau.torso.jointsPerArea.T1C7_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.T1C7_roty(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.T1C7_roty(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.T1C7_roty(1,2));

%% ---rotz
tmp.range = 12;
singleJointsTau.torso.tableTorsoMean.T1C7_rotz = zeros(1,3);

tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
% Create vector for all the subjects divided in blocks
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.torso.jointsPerArea.T1C7_rotz.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.torso.jointsPerArea.T1C7_rotz.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.torso.tableTorsoMean.T1C7_rotz(1,1) = mean(singleJointsTau.torso.jointsPerArea.T1C7_rotz.torqueMeanNE);
singleJointsTau.torso.tableTorsoMean.T1C7_rotz(1,2) = mean(singleJointsTau.torso.jointsPerArea.T1C7_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.torso.tableTorsoMean.T1C7_rotz(1,3) = ...
    abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotz(1,1)) - ...
    abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotz(1,2));

%% ========================================================================
%% ============================= BAR PLOTS ================================
%% ========================================================================
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
    'rot_x',...
    'rot_y',...
    'rot_z',...
    'rot_x',...
    'rot_y',...
    'rot_z'},...
    'XTick',[0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8],...
    'FontSize',20);
box(axes1,'off');
hold(axes1,'on');
% xtickangle(45);
grid on;

bar1 = bar([0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8],...
    [singleJointsTau.torso.tableTorsoMean.C1Head_rotx(1,3) ...
    singleJointsTau.torso.tableTorsoMean.C1Head_roty(1,3) ...
    singleJointsTau.torso.tableTorsoMean.L5S1_rotx(1,3) ...
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
    0.6,'FaceColor',benefit_color_green);
for barIdx = 1 : 14
    if bar1.YData(barIdx) < 0
        bar1.FaceColor = 'flat';
        bar1.CData(barIdx,:) = noBenefit_color_red;
        %         text_custom = text(bar1.XData(barIdx),bar1.YData(barIdx),'1', ...
        %             'HorizontalAlignment','center','VerticalAlignment','top');
        %         set(text_custom,'FontSize',14);
    else
        bar1.CData(barIdx,:) = benefit_color_green;
        %         text_custom = text(bar1.XData(barIdx),bar1.YData(barIdx),'1', ...
        %             'HorizontalAlignment','center','VerticalAlignment','bottom');
        %         set(text_custom,'FontSize',14);
    end
end

% Legend and title
% Note: this legend is tuned on the bar plot
% leg = legend([bar3, bar1],'effort reduction', 'effort increase');
% set(leg,'Interpreter','latex');
% set(leg,'FontSize',25);
% set(leg,  'NumColumns', 2);

title('Head and torso','FontSize',20);
ylabel(' $|\bar {\bar{\tau}}^{t}_{NE}|-|\bar {\bar{\tau}}^{t}_{WE}|$ [Nm]','HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',30,...
    'Interpreter','latex');
ylim([-10, 10]);
set(axes1, 'XLimSpec', 'Tight');
% axis tight;

%% Patch
yl = ylim;
xl = xlim;
% C1Head
xl_C1Head = bar1.XData(2) + (bar1.XData(2) - bar1.XData(1))/2;
% xl_C1Head = bar5.XData(2) + (bar1.XData(2) - bar5.XData(1))/2;
xBox = [xl(1), xl_C1Head, xl_C1Head, xl(1), xl(1)];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch1 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch1,'DisplayName','C1Head');
txt = 'jC1Head';
text(xl_C1Head/2,-9,txt,'FontSize',25);
% L5S1
xl_L5S1 = bar1.XData(4) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl(1), xl_L5S1, xl_L5S1, xl_C1Head, xl_C1Head];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch1 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch1,'DisplayName','L5S1');
txt = 'jL5S1';
text(xl_C1Head+(xl_L5S1-xl_C1Head)/3,-9,txt,'FontSize',25);
% text(xl_L5S1/2,-11,txt,'FontSize',25);
% L4L3
xl_L4L3 = bar1.XData(6) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_L5S1, xl_L4L3, xl_L4L3, xl_L5S1, xl_L5S1];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch2 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch2,'DisplayName','L4L3');
txt = 'jL4L3';
text(xl_L5S1+(xl_L4L3-xl_L5S1)/3,-9,txt,'FontSize',25);
% L1T12
xl_L1T12 = bar1.XData(8) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_L4L3, xl_L1T12, xl_L1T12, xl_L4L3, xl_L4L3];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch3 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch3,'DisplayName','L1T12');
txt = 'jL1T12';
text(xl_L4L3+(xl_L1T12-xl_L4L3)/3,-9,txt,'FontSize',25);
% T9T8
xl_T9T8 = bar1.XData(11) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_L1T12, xl_T9T8, xl_T9T8, xl_L1T12, xl_L1T12];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch4 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch4,'DisplayName','T9T8');
txt = 'jT9T8';
text(xl_L1T12+(xl_T9T8-xl_L1T12)/3,-9,txt,'FontSize',25);
% T1C7
xl_T1C7 = bar1.XData(14) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_T9T8, xl_T1C7, xl_T1C7, xl_T9T8, xl_T9T8];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch5 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch5,'DisplayName','T1C7');
txt = 'jT1C7';
text(xl_T9T8+(xl_T1C7-xl_T9T8)/3,-9,txt,'FontSize',25);

%% Save
% tightfig();
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_headAndTorsoTauMean_bar'),fig,600);
end



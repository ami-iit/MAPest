%% ========================================================================
%% ============================ RIGHT LEG =================================
%% ========================================================================
%
%
%% ========================================================================
%% ================================= HIP ==================================
%% ========================================================================
%% ---rotx
tmp.range = 31;
singleJointsTau.rightLeg.tableRightLegMean.hip_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightLeg.jointsPerArea.hip_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightLeg.jointsPerArea.hip_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightLeg.tableRightLegMean.hip_rotx(1,1) = mean(singleJointsTau.rightLeg.jointsPerArea.hip_rotx.torqueMeanNE);
singleJointsTau.rightLeg.tableRightLegMean.hip_rotx(1,2) = mean(singleJointsTau.rightLeg.jointsPerArea.hip_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightLeg.tableRightLegMean.hip_rotx(1,3) = ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.hip_rotx(1,1)) - ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.hip_rotx(1,2));

%% ---roty
tmp.range = 32;
singleJointsTau.rightLeg.tableRightLegMean.hip_roty  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightLeg.jointsPerArea.hip_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightLeg.jointsPerArea.hip_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightLeg.tableRightLegMean.hip_roty(1,1) = mean(singleJointsTau.rightLeg.jointsPerArea.hip_roty.torqueMeanNE);
singleJointsTau.rightLeg.tableRightLegMean.hip_roty(1,2) = mean(singleJointsTau.rightLeg.jointsPerArea.hip_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightLeg.tableRightLegMean.hip_roty(1,3) = ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.hip_roty(1,1)) - ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.hip_roty(1,2));

%% ---rotz
tmp.range = 33;
singleJointsTau.rightLeg.tableRightLegMean.hip_rotz  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightLeg.jointsPerArea.hip_rotz.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightLeg.jointsPerArea.hip_rotz.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightLeg.tableRightLegMean.hip_rotz(1,1) = mean(singleJointsTau.rightLeg.jointsPerArea.hip_rotz.torqueMeanNE);
singleJointsTau.rightLeg.tableRightLegMean.hip_rotz(1,2) = mean(singleJointsTau.rightLeg.jointsPerArea.hip_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightLeg.tableRightLegMean.hip_rotz(1,3) = ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.hip_rotz(1,1)) - ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.hip_rotz(1,2));

%% ========================================================================
%% ================================= KNEE =================================
%% ========================================================================
%% ---roty
tmp.range = 34;
singleJointsTau.rightLeg.tableRightLegMean.knee_roty  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightLeg.jointsPerArea.knee_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightLeg.jointsPerArea.knee_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightLeg.tableRightLegMean.knee_roty(1,1) = mean(singleJointsTau.rightLeg.jointsPerArea.knee_roty.torqueMeanNE);
singleJointsTau.rightLeg.tableRightLegMean.knee_roty(1,2) = mean(singleJointsTau.rightLeg.jointsPerArea.knee_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightLeg.tableRightLegMean.knee_roty(1,3) = ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.knee_roty(1,1)) - ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.knee_roty(1,2));

%% ---rotz
tmp.range = 35;
singleJointsTau.rightLeg.tableRightLegMean.knee_rotz  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightLeg.jointsPerArea.knee_rotz.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightLeg.jointsPerArea.knee_rotz.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightLeg.tableRightLegMean.knee_rotz(1,1) = mean(singleJointsTau.rightLeg.jointsPerArea.knee_rotz.torqueMeanNE);
singleJointsTau.rightLeg.tableRightLegMean.knee_rotz(1,2) = mean(singleJointsTau.rightLeg.jointsPerArea.knee_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightLeg.tableRightLegMean.knee_rotz(1,3) = ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.knee_rotz(1,1)) - ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.knee_rotz(1,2));

%% ========================================================================
%% ================================= ANKLE ================================
%% ========================================================================
%% ---rotx
tmp.range = 36;
singleJointsTau.rightLeg.tableRightLegMean.ankle_rotx = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightLeg.jointsPerArea.ankle_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightLeg.jointsPerArea.ankle_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightLeg.tableRightLegMean.ankle_rotx(1,1) = mean(singleJointsTau.rightLeg.jointsPerArea.ankle_rotx.torqueMeanNE);
singleJointsTau.rightLeg.tableRightLegMean.ankle_rotx(1,2) = mean(singleJointsTau.rightLeg.jointsPerArea.ankle_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightLeg.tableRightLegMean.ankle_rotx(1,3) = ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.ankle_rotx(1,1)) - ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.ankle_rotx(1,2));

%% ---roty
tmp.range = 37;
singleJointsTau.rightLeg.tableRightLegMean.ankle_roty = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightLeg.jointsPerArea.ankle_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightLeg.jointsPerArea.ankle_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightLeg.tableRightLegMean.ankle_roty(1,1) = mean(singleJointsTau.rightLeg.jointsPerArea.ankle_roty.torqueMeanNE);
singleJointsTau.rightLeg.tableRightLegMean.ankle_roty(1,2) = mean(singleJointsTau.rightLeg.jointsPerArea.ankle_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightLeg.tableRightLegMean.ankle_roty(1,3) = ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.ankle_roty(1,1)) - ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.ankle_roty(1,2));

%% ---rotz
tmp.range = 38;
singleJointsTau.rightLeg.tableRightLegMean.ankle_rotz = zeros(1,3);
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
singleJointsTau.rightLeg.jointsPerArea.ankle_rotz.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightLeg.jointsPerArea.ankle_rotz.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightLeg.tableRightLegMean.ankle_rotz(1,1) = mean(singleJointsTau.rightLeg.jointsPerArea.ankle_rotz.torqueMeanNE);
singleJointsTau.rightLeg.tableRightLegMean.ankle_rotz(1,2) = mean(singleJointsTau.rightLeg.jointsPerArea.ankle_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightLeg.tableRightLegMean.ankle_rotz(1,3) = ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.ankle_rotz(1,1)) - ...
    abs(singleJointsTau.rightLeg.tableRightLegMean.ankle_rotz(1,2));


%% Bar plot single joints
fig = figure();
axes1 = axes('Parent',fig, ...
    'YGrid','on',...
    'XTickLabel',{'rot_x', ...
    'rot_x',...
    'rot_y',...
    'rot_z', ...
    'rot_y', ...
    'rot_z',...
    'rot_x',...
    'rot_z'},...
    'XTick',[0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6],...
    'FontSize',20);
box(axes1,'off');
hold(axes1,'on');
% xtickangle(45);
grid on;

bar1 = bar([0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6], ...
    [singleJointsTau.rightLeg.tableRightLegMean.hip_rotx(1,3) ...
    singleJointsTau.rightLeg.tableRightLegMean.hip_roty(1,3) ...
    singleJointsTau.rightLeg.tableRightLegMean.hip_rotz(1,3) ...
    singleJointsTau.rightLeg.tableRightLegMean.knee_roty(1,3) ...
    singleJointsTau.rightLeg.tableRightLegMean.knee_rotz(1,3) ...
    singleJointsTau.rightLeg.tableRightLegMean.ankle_rotx(1,3) ...
    singleJointsTau.rightLeg.tableRightLegMean.ankle_roty(1,3) ...
    singleJointsTau.rightLeg.tableRightLegMean.ankle_rotz(1,3)], ...
    0.6,'FaceColor',benefit_color_green);
for barIdx = 1 : 8
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
% set(leg,'FontSize',18);
% % set(leg,  'NumColumns', 2);

title('Right leg','FontSize',20);
ylabel(' $|\bar{\bar{\tau}}^{rl}_{NE}|-|\bar{\bar{\tau}}^{rl}_{WE}|$ [Nm]','HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',30,...
    'Interpreter','latex');
ylim([-10, 10]);
set(axes1, 'XLimSpec', 'Tight');
% axis tight;

%% Patch
yl = ylim;
xl = xlim;
% hip
xl_hip = bar1.XData(3) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl(1), xl_hip, xl_hip, xl(1), xl(1)];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch1 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch1,'DisplayName','C7shoulder');
txt = 'jHip';
text(xl_hip/2,-9,txt,'FontSize',25);
% knee
xl_knee = bar1.XData(5) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_hip, xl_knee, xl_knee, xl_hip, xl_hip];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch2 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch2,'DisplayName','shoulder');
txt = 'jKnee';
text(xl_hip+(xl_knee-xl_hip)/3,-9,txt,'FontSize',25);
% ankle
xl_ankle = bar1.XData(8) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_knee, xl_ankle, xl_ankle, xl_knee, xl_knee];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch4 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch4,'DisplayName','wrist');
txt = 'jAnkle';
text(xl_knee+(xl_ankle-xl_knee)/3,-9,txt,'FontSize',25);

%% Save
% tightfig();
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_rLegTauMean_bar'),fig,600);
end

%% ========================================================================
%% ============================ RIGHT LEG =================================
%% ========================================================================
%
%
%% ========================================================================
%% ================================= HIP ==================================
%% ========================================================================
%% ---rotx
tmp.range = 40;
singleJointsTau.leftLeg.tableLeftLegMean.hip_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftLeg.jointsPerArea.hip_rotx.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftLeg.jointsPerArea.hip_rotx.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftLeg.tableLeftLegMean.hip_rotx(1,1) = mean(singleJointsTau.leftLeg.jointsPerArea.hip_rotx.torqueMeanNE);
singleJointsTau.leftLeg.tableLeftLegMean.hip_rotx(1,2) = mean(singleJointsTau.leftLeg.jointsPerArea.hip_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftLeg.tableLeftLegMean.hip_rotx(1,3) = ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.hip_rotx(1,1)) - ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.hip_rotx(1,2));

%% ---roty
tmp.range = 41;
singleJointsTau.leftLeg.tableLeftLegMean.hip_roty  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftLeg.jointsPerArea.hip_roty.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftLeg.jointsPerArea.hip_roty.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftLeg.tableLeftLegMean.hip_roty(1,1) = mean(singleJointsTau.leftLeg.jointsPerArea.hip_roty.torqueMeanNE);
singleJointsTau.leftLeg.tableLeftLegMean.hip_roty(1,2) = mean(singleJointsTau.leftLeg.jointsPerArea.hip_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftLeg.tableLeftLegMean.hip_roty(1,3) = ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.hip_roty(1,1)) - ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.hip_roty(1,2));

%% ---rotz
tmp.range = 42;
singleJointsTau.leftLeg.tableLeftLegMean.hip_rotz  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftLeg.jointsPerArea.hip_rotz.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftLeg.jointsPerArea.hip_rotz.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftLeg.tableLeftLegMean.hip_rotz(1,1) = mean(singleJointsTau.leftLeg.jointsPerArea.hip_rotz.torqueMeanNE);
singleJointsTau.leftLeg.tableLeftLegMean.hip_rotz(1,2) = mean(singleJointsTau.leftLeg.jointsPerArea.hip_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftLeg.tableLeftLegMean.hip_rotz(1,3) = ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.hip_rotz(1,1)) - ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.hip_rotz(1,2));

%% ========================================================================
%% ================================= KNEE =================================
%% ========================================================================
%% ---roty
tmp.range = 43;
singleJointsTau.leftLeg.tableLeftLegMean.knee_roty  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftLeg.jointsPerArea.knee_roty.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftLeg.jointsPerArea.knee_roty.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftLeg.tableLeftLegMean.knee_roty(1,1) = mean(singleJointsTau.leftLeg.jointsPerArea.knee_roty.torqueMeanNE);
singleJointsTau.leftLeg.tableLeftLegMean.knee_roty(1,2) = mean(singleJointsTau.leftLeg.jointsPerArea.knee_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftLeg.tableLeftLegMean.knee_roty(1,3) = ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.knee_roty(1,1)) - ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.knee_roty(1,2));

%% ---rotz
tmp.range = 44;
singleJointsTau.leftLeg.tableLeftLegMean.knee_rotz  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftLeg.jointsPerArea.knee_rotz.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftLeg.jointsPerArea.knee_rotz.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftLeg.tableLeftLegMean.knee_rotz(1,1) = mean(singleJointsTau.leftLeg.jointsPerArea.knee_rotz.torqueMeanNE);
singleJointsTau.leftLeg.tableLeftLegMean.knee_rotz(1,2) = mean(singleJointsTau.leftLeg.jointsPerArea.knee_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftLeg.tableLeftLegMean.knee_rotz(1,3) = ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.knee_rotz(1,1)) - ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.knee_rotz(1,2));

%% ========================================================================
%% ================================= ANKLE ================================
%% ========================================================================
%% ---rotx
tmp.range = 45;
singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotx = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftLeg.jointsPerArea.ankle_rotx.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftLeg.jointsPerArea.ankle_rotx.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotx(1,1) = mean(singleJointsTau.leftLeg.jointsPerArea.ankle_rotx.torqueMeanNE);
singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotx(1,2) = mean(singleJointsTau.leftLeg.jointsPerArea.ankle_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotx(1,3) = ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotx(1,1)) - ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotx(1,2));

%% ---roty
tmp.range = 46;
singleJointsTau.leftLeg.tableLeftLegMean.ankle_roty = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftLeg.jointsPerArea.ankle_roty.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftLeg.jointsPerArea.ankle_roty.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftLeg.tableLeftLegMean.ankle_roty(1,1) = mean(singleJointsTau.leftLeg.jointsPerArea.ankle_roty.torqueMeanNE);
singleJointsTau.leftLeg.tableLeftLegMean.ankle_roty(1,2) = mean(singleJointsTau.leftLeg.jointsPerArea.ankle_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftLeg.tableLeftLegMean.ankle_roty(1,3) = ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.ankle_roty(1,1)) - ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.ankle_roty(1,2));

%% ---rotz
tmp.range = 47;
singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotz = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftLeg.jointsPerArea.ankle_rotz.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftLeg.jointsPerArea.ankle_rotz.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotz(1,1) = mean(singleJointsTau.leftLeg.jointsPerArea.ankle_rotz.torqueMeanNE);
singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotz(1,2) = mean(singleJointsTau.leftLeg.jointsPerArea.ankle_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotz(1,3) = ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotz(1,1)) - ...
    abs(singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotz(1,2));

%% Bar plot single joints
fig = figure();
axes1 = axes('Parent',fig, ...
    'YGrid','on',...
    'XTickLabel',{'rot_x', ...
    'rot_x',...
    'rot_y',...
    'rot_z', ...
    'rot_y', ...
    'rot_z',...
    'rot_x',...
    'rot_z'},...
    'XTick',[0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6],...
    'FontSize',20);
box(axes1,'off');
hold(axes1,'on');
% xtickangle(45);
grid on;

bar1 = bar([0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6], ...
    [singleJointsTau.leftLeg.tableLeftLegMean.hip_rotx(1,3) ...
    singleJointsTau.leftLeg.tableLeftLegMean.hip_roty(1,3) ...
    singleJointsTau.leftLeg.tableLeftLegMean.hip_rotz(1,3) ...
    singleJointsTau.leftLeg.tableLeftLegMean.knee_roty(1,3) ...
    singleJointsTau.leftLeg.tableLeftLegMean.knee_rotz(1,3) ...
    singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotx(1,3) ...
    singleJointsTau.leftLeg.tableLeftLegMean.ankle_roty(1,3) ...
    singleJointsTau.leftLeg.tableLeftLegMean.ankle_rotz(1,3)], ...
    0.6,'FaceColor',benefit_color_green);
for barIdx = 1 : 8
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
% set(leg,'FontSize',18);
% % set(leg,  'NumColumns', 2);

title('Left leg','FontSize',20);
ylabel(' $|\bar{\bar{\tau}}^{rl}_{NE}|-|\bar{\bar{\tau}}^{rl}_{WE}|$ [Nm]','HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',30,...
    'Interpreter','latex');
ylim([-10, 10]);
set(axes1, 'XLimSpec', 'Tight');
% axis tight;

%% Patch
yl = ylim;
xl = xlim;
% hip
xl_hip = bar1.XData(3) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl(1), xl_hip, xl_hip, xl(1), xl(1)];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch1 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch1,'DisplayName','C7shoulder');
txt = 'jHip';
text(xl_hip/2,-9,txt,'FontSize',25);
% knee
xl_knee = bar1.XData(5) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_hip, xl_knee, xl_knee, xl_hip, xl_hip];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch2 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch2,'DisplayName','shoulder');
txt = 'jKnee';
text(xl_hip+(xl_knee-xl_hip)/3,-9,txt,'FontSize',25);
% ankle
xl_ankle = bar1.XData(8) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_knee, xl_ankle, xl_ankle, xl_knee, xl_knee];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch4 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch4,'DisplayName','wrist');
txt = 'jAnkle';
text(xl_knee+(xl_ankle-xl_knee)/3,-9,txt,'FontSize',25);

%% Save
% tightfig();
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_lLegTauMean_bar'),fig,600);
end
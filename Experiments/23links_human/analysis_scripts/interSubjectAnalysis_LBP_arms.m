%% ========================================================================
%% ============================ RIGHT ARM =================================
%% ========================================================================
%
%
%% ========================================================================
%% ============================ C7shoulder ================================
%% ========================================================================
%% ---rotx
tmp.range = 15;
singleJointsTau.rightArm.tableRightArmMean.C7shoulder_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightArm.jointsPerArea.C7shoulder_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightArm.jointsPerArea.C7shoulder_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightArm.tableRightArmMean.C7shoulder_rotx(1,1) = mean(singleJointsTau.rightArm.jointsPerArea.C7shoulder_rotx.torqueMeanNE);
singleJointsTau.rightArm.tableRightArmMean.C7shoulder_rotx(1,2) = mean(singleJointsTau.rightArm.jointsPerArea.C7shoulder_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightArm.tableRightArmMean.C7shoulder_rotx(1,3) = ...
    abs(singleJointsTau.rightArm.tableRightArmMean.C7shoulder_rotx(1,1)) - ...
    abs(singleJointsTau.rightArm.tableRightArmMean.C7shoulder_rotx(1,2));

%% ========================================================================
%% ============================= shoulder =================================
%% ========================================================================
%% ---rotx
tmp.range = 16;
singleJointsTau.rightArm.tableRightArmMean.shoulder_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightArm.jointsPerArea.shoulder_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightArm.jointsPerArea.shoulder_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightArm.tableRightArmMean.shoulder_rotx(1,1) = mean(singleJointsTau.rightArm.jointsPerArea.shoulder_rotx.torqueMeanNE);
singleJointsTau.rightArm.tableRightArmMean.shoulder_rotx(1,2) = mean(singleJointsTau.rightArm.jointsPerArea.shoulder_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightArm.tableRightArmMean.shoulder_rotx(1,3) = ...
    abs(singleJointsTau.rightArm.tableRightArmMean.shoulder_rotx(1,1)) - ...
    abs(singleJointsTau.rightArm.tableRightArmMean.shoulder_rotx(1,2));

%% ---roty
tmp.range = 17;
singleJointsTau.rightArm.tableRightArmMean.shoulder_roty  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightArm.jointsPerArea.shoulder_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightArm.jointsPerArea.shoulder_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightArm.tableRightArmMean.shoulder_roty(1,1) = mean(singleJointsTau.rightArm.jointsPerArea.shoulder_roty.torqueMeanNE);
singleJointsTau.rightArm.tableRightArmMean.shoulder_roty(1,2) = mean(singleJointsTau.rightArm.jointsPerArea.shoulder_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightArm.tableRightArmMean.shoulder_roty(1,3) = ...
    abs(singleJointsTau.rightArm.tableRightArmMean.shoulder_roty(1,1)) - ...
    abs(singleJointsTau.rightArm.tableRightArmMean.shoulder_roty(1,2));

%% ---rotz
tmp.range = 18;
singleJointsTau.rightArm.tableRightArmMean.shoulder_rotz  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightArm.jointsPerArea.shoulder_rotz.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightArm.jointsPerArea.shoulder_rotz.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightArm.tableRightArmMean.shoulder_rotz(1,1) = mean(singleJointsTau.rightArm.jointsPerArea.shoulder_rotz.torqueMeanNE);
singleJointsTau.rightArm.tableRightArmMean.shoulder_rotz(1,2) = mean(singleJointsTau.rightArm.jointsPerArea.shoulder_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightArm.tableRightArmMean.shoulder_rotz(1,3) = ...
    abs(singleJointsTau.rightArm.tableRightArmMean.shoulder_rotz(1,1)) - ...
    abs(singleJointsTau.rightArm.tableRightArmMean.shoulder_rotz(1,2));

%% ========================================================================
%% =============================== ELBOW ==================================
%% ========================================================================
% ---roty
tmp.range = 19;
singleJointsTau.rightArm.tableRightArmMean.elbow_roty  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightArm.jointsPerArea.elbow_roty.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightArm.jointsPerArea.elbow_roty.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightArm.tableRightArmMean.elbow_roty(1,1) = mean(singleJointsTau.rightArm.jointsPerArea.elbow_roty.torqueMeanNE);
singleJointsTau.rightArm.tableRightArmMean.elbow_roty(1,2) = mean(singleJointsTau.rightArm.jointsPerArea.elbow_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightArm.tableRightArmMean.elbow_roty(1,3) = ...
    abs(singleJointsTau.rightArm.tableRightArmMean.elbow_roty(1,1)) - ...
    abs(singleJointsTau.rightArm.tableRightArmMean.elbow_roty(1,2));

%% ---rotz
tmp.range = 20;
singleJointsTau.rightArm.tableRightArmMean.elbow_rotz  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightArm.jointsPerArea.elbow_rotz.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightArm.jointsPerArea.elbow_rotz.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightArm.tableRightArmMean.elbow_rotz(1,1) = mean(singleJointsTau.rightArm.jointsPerArea.elbow_rotz.torqueMeanNE);
singleJointsTau.rightArm.tableRightArmMean.elbow_rotz(1,2) = mean(singleJointsTau.rightArm.jointsPerArea.elbow_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightArm.tableRightArmMean.elbow_rotz(1,3) = ...
    abs(singleJointsTau.rightArm.tableRightArmMean.elbow_rotz(1,1)) - ...
    abs(singleJointsTau.rightArm.tableRightArmMean.elbow_rotz(1,2));

%% ========================================================================
%% =============================== WRIST ==================================
%% ========================================================================
%% ---rotx
tmp.range = 21;
singleJointsTau.rightArm.tableRightArmMean.wrist_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightArm.jointsPerArea.wrist_rotx.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightArm.jointsPerArea.wrist_rotx.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightArm.tableRightArmMean.wrist_rotx(1,1) = mean(singleJointsTau.rightArm.jointsPerArea.wrist_rotx.torqueMeanNE);
singleJointsTau.rightArm.tableRightArmMean.wrist_rotx(1,2) = mean(singleJointsTau.rightArm.jointsPerArea.wrist_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightArm.tableRightArmMean.wrist_rotx(1,3) = ...
    abs(singleJointsTau.rightArm.tableRightArmMean.wrist_rotx(1,1)) - ...
    abs(singleJointsTau.rightArm.tableRightArmMean.wrist_rotx(1,2));

%% ---rotz
tmp.range = 22;
singleJointsTau.rightArm.tableRightArmMean.wrist_rotz  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.rightArm.jointsPerArea.wrist_rotz.torqueMeanNE = mean(abs(tmp.cluster.clusterJointsNE));
singleJointsTau.rightArm.jointsPerArea.wrist_rotz.torqueMeanWE = mean(abs(tmp.cluster.clusterJointsWE));
% mean of mean
singleJointsTau.rightArm.tableRightArmMean.wrist_rotz(1,1) = mean(singleJointsTau.rightArm.jointsPerArea.wrist_rotz.torqueMeanNE);
singleJointsTau.rightArm.tableRightArmMean.wrist_rotz(1,2) = mean(singleJointsTau.rightArm.jointsPerArea.wrist_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.rightArm.tableRightArmMean.wrist_rotz(1,3) = ...
    abs(singleJointsTau.rightArm.tableRightArmMean.wrist_rotz(1,1)) - ...
    abs(singleJointsTau.rightArm.tableRightArmMean.wrist_rotz(1,2));

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
    [singleJointsTau.rightArm.tableRightArmMean.C7shoulder_rotx(1,3) ...
    singleJointsTau.rightArm.tableRightArmMean.shoulder_rotx(1,3) ...
    singleJointsTau.rightArm.tableRightArmMean.shoulder_roty(1,3) ...
    singleJointsTau.rightArm.tableRightArmMean.shoulder_rotz(1,3) ...
    singleJointsTau.rightArm.tableRightArmMean.elbow_roty(1,3) ...
    singleJointsTau.rightArm.tableRightArmMean.elbow_rotz(1,3) ...
    singleJointsTau.rightArm.tableRightArmMean.wrist_rotx(1,3) ...
    singleJointsTau.rightArm.tableRightArmMean.wrist_rotz(1,3)], ...
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
% set(leg,'FontSize',25);
% set(leg,  'NumColumns', 2);

title('Right arm','FontSize',20);
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
% C7shoulder
xl_C7shoulder = bar1.XData(1) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl(1), xl_C7shoulder, xl_C7shoulder, xl(1), xl(1)];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch1 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch1,'DisplayName','C7shoulder');
txt = 'jC7sho';
text(xl_C7shoulder/2,-9,txt,'FontSize',25);
% shoulder
xl_shoulder = bar1.XData(4) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_C7shoulder, xl_shoulder, xl_shoulder, xl_C7shoulder, xl_C7shoulder];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch2 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch2,'DisplayName','shoulder');
txt = 'jShoulder';
text(xl_C7shoulder+(xl_shoulder-xl_C7shoulder)/3,-9,txt,'FontSize',25);
% elbow
xl_elbow = bar1.XData(6) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_shoulder, xl_elbow, xl_elbow, xl_shoulder, xl_shoulder];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch3 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch3,'DisplayName','elbow');
txt = 'jElbow';
text(xl_shoulder+(xl_elbow-xl_shoulder)/3,-9,txt,'FontSize',25);
% wrist
xl_wrist = bar1.XData(8) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_elbow, xl_wrist, xl_wrist, xl_elbow, xl_elbow];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch4 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch4,'DisplayName','wrist');
txt = 'jWrist';
text(xl_elbow+(xl_wrist-xl_elbow)/3,-9,txt,'FontSize',25);

%% Save
% tightfig();
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_rArmTauMean_bar'),fig,600);
end


%% ========================================================================
%% ============================ LEFT ARM =================================
%% ========================================================================
%
%
%% ========================================================================
%% ============================ C7shoulder ================================
%% ========================================================================
%% ---rotx
tmp.range = 23;
singleJointsTau.leftArm.tableLeftArmMean.C7shoulder_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftArm.jointsPerArea.C7shoulder_rotx.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftArm.jointsPerArea.C7shoulder_rotx.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftArm.tableLeftArmMean.C7shoulder_rotx(1,1) = mean(singleJointsTau.leftArm.jointsPerArea.C7shoulder_rotx.torqueMeanNE);
singleJointsTau.leftArm.tableLeftArmMean.C7shoulder_rotx(1,2) = mean(singleJointsTau.leftArm.jointsPerArea.C7shoulder_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftArm.tableLeftArmMean.C7shoulder_rotx(1,3) = ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.C7shoulder_rotx(1,1)) - ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.C7shoulder_rotx(1,2));

%% ========================================================================
%% ============================= shoulder =================================
%% ========================================================================
%% ---rotx
tmp.range = 24;
singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftArm.jointsPerArea.shoulder_rotx.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftArm.jointsPerArea.shoulder_rotx.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotx(1,1) = mean(singleJointsTau.leftArm.jointsPerArea.shoulder_rotx.torqueMeanNE);
singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotx(1,2) = mean(singleJointsTau.leftArm.jointsPerArea.shoulder_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotx(1,3) = ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotx(1,1)) - ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotx(1,2));

%% ---roty
tmp.range = 25;
singleJointsTau.leftArm.tableLeftArmMean.shoulder_roty  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftArm.jointsPerArea.shoulder_roty.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftArm.jointsPerArea.shoulder_roty.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftArm.tableLeftArmMean.shoulder_roty(1,1) = mean(singleJointsTau.leftArm.jointsPerArea.shoulder_roty.torqueMeanNE);
singleJointsTau.leftArm.tableLeftArmMean.shoulder_roty(1,2) = mean(singleJointsTau.leftArm.jointsPerArea.shoulder_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftArm.tableLeftArmMean.shoulder_roty(1,3) = ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.shoulder_roty(1,1)) - ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.shoulder_roty(1,2));

%% ---rotz
tmp.range = 26;
singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotz  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftArm.jointsPerArea.shoulder_rotz.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftArm.jointsPerArea.shoulder_rotz.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotz(1,1) = mean(singleJointsTau.leftArm.jointsPerArea.shoulder_rotz.torqueMeanNE);
singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotz(1,2) = mean(singleJointsTau.leftArm.jointsPerArea.shoulder_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotz(1,3) = ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotz(1,1)) - ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotz(1,2));

%% ========================================================================
%% =============================== ELBOW ==================================
%% ========================================================================
%% ---roty
tmp.range = 27;
singleJointsTau.leftArm.tableLeftArmMean.elbow_roty  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftArm.jointsPerArea.elbow_roty.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftArm.jointsPerArea.elbow_roty.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftArm.tableLeftArmMean.elbow_roty(1,1) = mean(singleJointsTau.leftArm.jointsPerArea.elbow_roty.torqueMeanNE);
singleJointsTau.leftArm.tableLeftArmMean.elbow_roty(1,2) = mean(singleJointsTau.leftArm.jointsPerArea.elbow_roty.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftArm.tableLeftArmMean.elbow_roty(1,3) = ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.elbow_roty(1,1)) - ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.elbow_roty(1,2));

%% ---rotz
tmp.range = 28;
singleJointsTau.leftArm.tableLeftArmMean.elbow_rotz  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftArm.jointsPerArea.elbow_rotz.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftArm.jointsPerArea.elbow_rotz.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftArm.tableLeftArmMean.elbow_rotz(1,1) = mean(singleJointsTau.leftArm.jointsPerArea.elbow_rotz.torqueMeanNE);
singleJointsTau.leftArm.tableLeftArmMean.elbow_rotz(1,2) = mean(singleJointsTau.leftArm.jointsPerArea.elbow_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftArm.tableLeftArmMean.elbow_rotz(1,3) = ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.elbow_rotz(1,1)) - ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.elbow_rotz(1,2));

%% ========================================================================
%% =============================== WRIST ==================================
%% ========================================================================
%% ---rotx
tmp.range = 29;
singleJointsTau.leftArm.tableLeftArmMean.wrist_rotx  = zeros(1,3);
tmp.cluster.clusterJointsNE = [];
tmp.cluster.clusterJointsWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.cluster.clusterJointsNE = [tmp.cluster.clusterJointsNE; ...
        intraSubj(subjIdx).NE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormNE)];
    tmp.cluster.clusterJointsWE = [tmp.cluster.clusterJointsWE; ...
        intraSubj(subjIdx).WE.estimatedVariables.tau.values(tmp.range,1:interSubj.lenghtOfIntersubjNormWE)];
end
% mean vector
singleJointsTau.leftArm.jointsPerArea.wrist_rotx.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftArm.jointsPerArea.wrist_rotx.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftArm.tableLeftArmMean.wrist_rotx(1,1) = mean(singleJointsTau.leftArm.jointsPerArea.wrist_rotx.torqueMeanNE);
singleJointsTau.leftArm.tableLeftArmMean.wrist_rotx(1,2) = mean(singleJointsTau.leftArm.jointsPerArea.wrist_rotx.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftArm.tableLeftArmMean.wrist_rotx(1,3) = ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.wrist_rotx(1,1)) - ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.wrist_rotx(1,2));

%% ---rotz
tmp.range = 30;
singleJointsTau.leftArm.tableLeftArmMean.wrist_rotz  = zeros(1,3);
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
singleJointsTau.leftArm.jointsPerArea.wrist_rotz.torqueMeanNE = mean(tmp.cluster.clusterJointsNE);
singleJointsTau.leftArm.jointsPerArea.wrist_rotz.torqueMeanWE = mean(tmp.cluster.clusterJointsWE);
% mean of mean
singleJointsTau.leftArm.tableLeftArmMean.wrist_rotz(1,1) = mean(singleJointsTau.leftArm.jointsPerArea.wrist_rotz.torqueMeanNE);
singleJointsTau.leftArm.tableLeftArmMean.wrist_rotz(1,2) = mean(singleJointsTau.leftArm.jointsPerArea.wrist_rotz.torqueMeanWE);

% Chech overall effort status due to exo presence
singleJointsTau.leftArm.tableLeftArmMean.wrist_rotz(1,3) = ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.wrist_rotz(1,1)) - ...
    abs(singleJointsTau.leftArm.tableLeftArmMean.wrist_rotz(1,2));

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
    [singleJointsTau.leftArm.tableLeftArmMean.C7shoulder_rotx(1,3) ...
    singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotx(1,3) ...
    singleJointsTau.leftArm.tableLeftArmMean.shoulder_roty(1,3) ...
    singleJointsTau.leftArm.tableLeftArmMean.shoulder_rotz(1,3) ...
    singleJointsTau.leftArm.tableLeftArmMean.elbow_roty(1,3) ...
    singleJointsTau.leftArm.tableLeftArmMean.elbow_rotz(1,3) ...
    singleJointsTau.leftArm.tableLeftArmMean.wrist_rotx(1,3) ...
    singleJointsTau.leftArm.tableLeftArmMean.wrist_rotz(1,3)], ...
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
% set(leg,'FontSize',25);
% set(leg,  'NumColumns', 2);

title('Left arm','FontSize',20);
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
% C7shoulder
xl_C7shoulder = bar1.XData(1) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl(1), xl_C7shoulder, xl_C7shoulder, xl(1), xl(1)];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch1 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch1,'DisplayName','C7shoulder');
txt = 'jC7sho';
text(xl_C7shoulder/2,-9,txt,'FontSize',25);
% shoulder
xl_shoulder = bar1.XData(4) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_C7shoulder, xl_shoulder, xl_shoulder, xl_C7shoulder, xl_C7shoulder];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch2 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch2,'DisplayName','shoulder');
txt = 'jShoulder';
text(xl_C7shoulder+(xl_shoulder-xl_C7shoulder)/3,-9,txt,'FontSize',25);
% elbow
xl_elbow = bar1.XData(6) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_shoulder, xl_elbow, xl_elbow, xl_shoulder, xl_shoulder];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch3 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch3,'DisplayName','elbow');
txt = 'jElbow';
text(xl_shoulder+(xl_elbow-xl_shoulder)/3,-9,txt,'FontSize',25);
% wrist
xl_wrist = bar1.XData(8) + (bar1.XData(2) - bar1.XData(1))/2;
xBox = [xl_elbow, xl_wrist, xl_wrist, xl_elbow, xl_elbow];
yBox = [yl(1), yl(1), yl(2), yl(2), yl(1)];
patch4 = patch(xBox, yBox, 'black', 'FaceColor', 'white', 'FaceAlpha', 0.05);
% set(patch4,'DisplayName','wrist');
txt = 'jWrist';
text(xl_elbow+(xl_wrist-xl_elbow)/3,-9,txt,'FontSize',25);

%% Save
% tightfig();
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_lArmTauMean_bar'),fig,600);
end
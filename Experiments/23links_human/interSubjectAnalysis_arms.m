
%% ================== RIGHT ARM ============================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.rightArm_range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.rightArm_range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    interSubj(blockIdx).rightArmTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).rightArmTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'Intersubject right arm tau mean','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).rightArmTorqueMeanNE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).rightArmTorqueMeanNE) == 1);
        interSubj(blockIdx).rightArmTorqueMeanNE(:,nanVal) = (interSubj(blockIdx).rightArmTorqueMeanNE(:,nanVal-1)+ ...
            interSubj(blockIdx).rightArmTorqueMeanNE(:,nanVal+1))/2;
    end
    plot1 = plot(interSubj(blockIdx).rightArmTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).rightArmTorqueMeanWE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).rightArmTorqueMeanWE) == 1);
        interSubj(blockIdx).rightArmTorqueMeanWE(:,nanVal) = (interSubj(blockIdx).rightArmTorqueMeanWE(:,nanVal-1)+ ...
            interSubj(blockIdx).rightArmTorqueMeanWE(:,nanVal+1))/2;
    end
    plot2 = plot(interSubj(blockIdx).rightArmTorqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',22);
    ylabel('${\bar\tau}_{rarm}$','HorizontalAlignment','center',...
    'FontSize',40,'interpreter','latex');
    if blockIdx == 5
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    ylim([-5, 0.5]);
end
% align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_rarmTauMean'),fig,600);
end

% -------------------------------------------------------------------------
% --------------------- Analyis on single joints --------------------------
% -------------------------------------------------------------------------
range_jointIdx = [15:22];
tmp.diffValueOfTorquesMean = zeros(block.nrOfBlocks,length(range_jointIdx));
for jointIdx = 1 : length(range_jointIdx)
    for blockIdx = 1 : block.nrOfBlocks
        tmp.interSubj(blockIdx).torqueListNE_singleJoint = [];
        tmp.interSubj(blockIdx).torqueListWE_singleJoint = [];
        % Create vector for all the subjects divided in blocks
        for subjIdx = 1 : nrOfSubject
            tmp.interSubj(blockIdx).torqueListNE_singleJoint  = [tmp.interSubj(blockIdx).torqueListNE_singleJoint; ...
                intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(range_jointIdx(jointIdx),1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
            tmp.interSubj(blockIdx).torqueListWE_singleJoint  = [tmp.interSubj(blockIdx).torqueListWE_singleJoint; ...
                intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(range_jointIdx(jointIdx),1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
        end
        % mean vector
        tmp.interSubj(blockIdx).sigleJointTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE_singleJoint);
        tmp.interSubj(blockIdx).sigleJointTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE_singleJoint);
        % NE
        % check if isnan
        if ~isempty(find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE) == 1))
            nanVal = find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE) == 1);
            tmp.interSubj(blockIdx).sigleJointTorqueMeanNE(:,nanVal) = (tmp.interSubj(blockIdx).sigleJointTorqueMeanNE(:,nanVal-1)+ ...
                tmp.interSubj(blockIdx).sigleJointTorqueMeanNE(:,nanVal+1))/2;
        end
        % WE
        % check if isnan
        if ~isempty(find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE) == 1))
            nanVal = find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE) == 1);
            tmp.interSubj(blockIdx).sigleJointTorqueMeanWE(:,nanVal) = (tmp.interSubj(blockIdx).sigleJointTorqueMeanWE(:,nanVal-1)+ ...
                tmp.interSubj(blockIdx).sigleJointTorqueMeanWE(:,nanVal+1))/2;
        end
        % Value in [Nm] of the torque mean NE vs. WE
        tmp.diffValueOfTorquesMean(blockIdx, jointIdx) = ...
            max(abs(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE)),abs(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE))) - ...
            min(abs(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE)),abs(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE)));
    end
%     % Plot
%     fig = figure('Name', 'single joint right arm tau mean','NumberTitle','off');
%     axes1 = axes('Parent',fig,'FontSize',16);
%     box(axes1,'on');
%     hold(axes1,'on');
%     grid on;
%     for blockIdx = 1 : block.nrOfBlocks
%         subplot (5,1,blockIdx)
%         % NE
%         % check if isnan
%         if ~isempty(find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE) == 1))
%             nanVal = find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE) == 1);
%             tmp.interSubj(blockIdx).sigleJointTorqueMeanNE(:,nanVal) = (tmp.interSubj(blockIdx).sigleJointTorqueMeanNE(:,nanVal-1)+ ...
%                 tmp.interSubj(blockIdx).sigleJointTorqueMeanNE(:,nanVal+1))/2;
%         end
%         plot1 = plot(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
%         hold on;
%         yline(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE),'color',orangeAnDycolor,'lineWidth',2);
%         axis tight;
%         ax = gca;
%         ax.FontSize = 20;
%         hold on
%         % WE
%         % check if isnan
%         if ~isempty(find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE) == 1))
%             nanVal = find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE) == 1);
%             tmp.interSubj(blockIdx).sigleJointTorqueMeanWE(:,nanVal) = (tmp.interSubj(blockIdx).sigleJointTorqueMeanWE(:,nanVal-1)+ ...
%                 tmp.interSubj(blockIdx).sigleJointTorqueMeanWE(:,nanVal+1))/2;
%         end
%         plot2 = plot(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
%         hold on;
%         yline(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE),'color',greenAnDycolor,'lineWidth',2);
%         title(sprintf('Block %s, %s', num2str(blockIdx), selectedJoints.selectedJoints{tmp.rightArm_range_jointIdx(rarmIdx)}),'FontSize',22);
%         ylabel('${\bar\tau}$','HorizontalAlignment','center',...
%             'FontSize',40,'interpreter','latex');
%         if blockIdx == 5
%             xlabel('samples','FontSize',25);
%         end
%         grid on;
%         %legend
%         leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
%         set(leg,'Interpreter','latex','FontSize',25);
%         axis tight;
%    end
    % % %     % % % align_Ylabels(gcf)
    % % %     % % % subplotsqueeze(gcf, 1.12);
    % % %     % % tightfig();
    % % %     % % % save
    % % %     % % if saveON
    % % %     % %     save2pdf(fullfile(bucket.pathToPlots,'intersubj_torsoTauMean'),fig,600);
    % % %     % % end
end
singleJointsTau.arm.allValues_rarm = tmp.diffValueOfTorquesMean;
% Cluster in joints
singleJointsTau.rarm.jointsvalueOfTorqueMean.rshoulder = zeros(5,1);
singleJointsTau.rarm.jointsvalueOfTorqueMean.relbow    = zeros(5,1);
singleJointsTau.rarm.jointsvalueOfTorqueMean.rwrist    = zeros(5,1);
for k = 1 : block.nrOfBlocks
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rshoulder(k,1) = mean(singleJointsTau.arm.allValues_rarm(k,1:4));
    singleJointsTau.rarm.jointsvalueOfTorqueMean.relbow(k,1)    = mean(singleJointsTau.arm.allValues_rarm(k,5:6));
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rwrist(k,1)    = mean(singleJointsTau.arm.allValues_rarm(k,7:8));
end

%% ================== LEFT ARM =============================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.leftArm_range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.leftArm_range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    interSubj(blockIdx).leftArmTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).leftArmTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'Intersubject left arm tau mean','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).leftArmTorqueMeanNE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).leftArmTorqueMeanNE) == 1);
        interSubj(blockIdx).leftArmTorqueMeanNE(:,nanVal) = (interSubj(blockIdx).leftArmTorqueMeanNE(:,nanVal-1)+ ...
            interSubj(blockIdx).leftArmTorqueMeanNE(:,nanVal+1))/2;
    end
    plot1 = plot(interSubj(blockIdx).leftArmTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).leftArmTorqueMeanWE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).leftArmTorqueMeanWE) == 1);
        interSubj(blockIdx).leftArmTorqueMeanWE(:,nanVal) = (interSubj(blockIdx).leftArmTorqueMeanWE(:,nanVal-1)+ ...
            interSubj(blockIdx).leftArmTorqueMeanWE(:,nanVal+1))/2;
    end
    plot2 = plot(interSubj(blockIdx).leftArmTorqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',22);
    ylabel('${\bar\tau}_{larm}$','HorizontalAlignment','center',...
    'FontSize',40,'interpreter','latex');
    if blockIdx == 5
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    ylim([-1.4, 1.4]);
end
% align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_larmTauMean'),fig,600);
end

% -------------------------------------------------------------------------
% --------------------- Analyis on single joints --------------------------
% -------------------------------------------------------------------------
range_jointIdx = [23:30];
tmp.diffValueOfTorquesMean = zeros(block.nrOfBlocks,length(range_jointIdx));
for jointIdx = 1 : length(range_jointIdx)
    for blockIdx = 1 : block.nrOfBlocks
        tmp.interSubj(blockIdx).torqueListNE_singleJoint = [];
        tmp.interSubj(blockIdx).torqueListWE_singleJoint = [];
        % Create vector for all the subjects divided in blocks
        for subjIdx = 1 : nrOfSubject
            tmp.interSubj(blockIdx).torqueListNE_singleJoint  = [tmp.interSubj(blockIdx).torqueListNE_singleJoint; ...
                intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(range_jointIdx(jointIdx),1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
            tmp.interSubj(blockIdx).torqueListWE_singleJoint  = [tmp.interSubj(blockIdx).torqueListWE_singleJoint; ...
                intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(range_jointIdx(jointIdx),1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
        end
        % mean vector
        tmp.interSubj(blockIdx).sigleJointTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE_singleJoint);
        tmp.interSubj(blockIdx).sigleJointTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE_singleJoint);
        % NE
        % check if isnan
        if ~isempty(find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE) == 1))
            nanVal = find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE) == 1);
            tmp.interSubj(blockIdx).sigleJointTorqueMeanNE(:,nanVal) = (tmp.interSubj(blockIdx).sigleJointTorqueMeanNE(:,nanVal-1)+ ...
                tmp.interSubj(blockIdx).sigleJointTorqueMeanNE(:,nanVal+1))/2;
        end
        % WE
        % check if isnan
        if ~isempty(find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE) == 1))
            nanVal = find(isnan(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE) == 1);
            tmp.interSubj(blockIdx).sigleJointTorqueMeanWE(:,nanVal) = (tmp.interSubj(blockIdx).sigleJointTorqueMeanWE(:,nanVal-1)+ ...
                tmp.interSubj(blockIdx).sigleJointTorqueMeanWE(:,nanVal+1))/2;
        end
        % Value in [Nm] of the torque mean NE vs. WE
        tmp.diffValueOfTorquesMean(blockIdx, jointIdx) = ...
            max(abs(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE)),abs(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE))) - ...
            min(abs(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanNE)),abs(mean(tmp.interSubj(blockIdx).sigleJointTorqueMeanWE)));
    end
end
singleJointsTau.arm.allValues_larm = tmp.diffValueOfTorquesMean;
% Cluster in joints
singleJointsTau.larm.jointsvalueOfTorqueMean.lshoulder = zeros(5,1);
singleJointsTau.larm.jointsvalueOfTorqueMean.lelbow    = zeros(5,1);
singleJointsTau.larm.jointsvalueOfTorqueMean.lwrist    = zeros(5,1);
for k = 1 : block.nrOfBlocks
    singleJointsTau.larm.jointsvalueOfTorqueMean.lshoulder(k,1) = mean(singleJointsTau.arm.allValues_larm(k,1:4));
    singleJointsTau.larm.jointsvalueOfTorqueMean.lelbow(k,1)    = mean(singleJointsTau.arm.allValues_larm(k,5:6));
    singleJointsTau.larm.jointsvalueOfTorqueMean.lwrist(k,1)    = mean(singleJointsTau.arm.allValues_larm(k,7:8));
end

%% Bar plot
fig = figure();
axes1 = axes('Parent',fig, ...
    'YGrid','on',...
    'XTickLabel',{'lShoulder',...
    'lElbow',...
    'lWrist', ...
    'rShoulder',...
    'rElbow',...
    'rWrist'},...
    'XTick',[1.9 3.9 5.9 7.9 9.9 11.9],...
    'FontSize',20);
box(axes1,'off');
hold(axes1,'on')

bar1 = bar([1.3, 3.3, 5.3, 7.3, 9.3, 11.3], ...
    [singleJointsTau.larm.jointsvalueOfTorqueMean.lshoulder(1) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lelbow(1) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lwrist(1) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rshoulder(1) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.relbow(1) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rwrist(1)], ...
    0.15,'FaceColor',block1_color);
hold on;

bar2 = bar([1.6, 3.6, 5.6, 7.6, 9.6, 11.6], ...
    [singleJointsTau.larm.jointsvalueOfTorqueMean.lshoulder(2) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lelbow(2) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lwrist(2) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rshoulder(2) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.relbow(2) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rwrist(2)], ...
    0.15,'FaceColor',block2_color);

bar3 = bar([1.9, 3.9, 5.9, 7.9, 9.9, 11.9], ...
    [singleJointsTau.larm.jointsvalueOfTorqueMean.lshoulder(3) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lelbow(3) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lwrist(3) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rshoulder(3) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.relbow(3) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rwrist(3)], ...
    0.15,'FaceColor',block3_color);
hold on;
bar4 = bar([2.2, 4.2, 6.2, 8.2, 10.2, 12.2], ...
    [singleJointsTau.larm.jointsvalueOfTorqueMean.lshoulder(4) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lelbow(4) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lwrist(4) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rshoulder(4) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.relbow(4) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rwrist(4)], ...
    0.15,'FaceColor',block4_color);
hold on;
bar5 = bar([2.5, 4.5, 6.5, 8.5, 10.5, 12.5], ...
    [singleJointsTau.larm.jointsvalueOfTorqueMean.lshoulder(5) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lelbow(5) ...
    singleJointsTau.larm.jointsvalueOfTorqueMean.lwrist(5) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rshoulder(5) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.relbow(5) ...
    singleJointsTau.rarm.jointsvalueOfTorqueMean.rwrist(5)], ...
    0.15,'FaceColor',block5_color);
   
leg = legend('block1','block2','block3','block4','block5','Location','northeast');
set(leg,'Interpreter','latex');
set(leg,'FontSize',18);                
ylabel('${\bar\tau}$ [Nm]','HorizontalAlignment','center',...
       'FontWeight','bold',...
       'FontSize',26,...
       'Interpreter','latex');
ylim([0,8])
% title('x');
set(axes1, 'XLimSpec', 'Tight');
tightfig();

% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_armsTauMean_singleJoints'),fig,600);
end

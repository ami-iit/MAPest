
%% ================== RIGHT LEG ============================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.rightLeg_range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.rightLeg_range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    interSubj(blockIdx).rightLegTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).rightLegTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'Intersubject right leg tau mean','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).rightLegTorqueMeanNE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).rightLegTorqueMeanNE) == 1);
        interSubj(blockIdx).rightLegTorqueMeanNE(:,nanVal) = (interSubj(blockIdx).rightLegTorqueMeanNE(:,nanVal-1)+ ...
            interSubj(blockIdx).rightLegTorqueMeanNE(:,nanVal+1))/2;
    end
    plot1 = plot(interSubj(blockIdx).rightLegTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).rightLegTorqueMeanWE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).rightLegTorqueMeanWE) == 1);
        interSubj(blockIdx).rightLegTorqueMeanWE(:,nanVal) = (interSubj(blockIdx).rightLegTorqueMeanWE(:,nanVal-1)+ ...
            interSubj(blockIdx).rightLegTorqueMeanWE(:,nanVal+1))/2;
    end
    plot2 = plot(interSubj(blockIdx).rightLegTorqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',22);
    ylabel('${\bar\tau}_{rleg}$','HorizontalAlignment','center',...
    'FontSize',40,'interpreter','latex');
    if blockIdx == 5
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    ylim([-0.5, 10.5]);
end
% align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_rlegTauMean'),fig,600);
end

% -------------------------------------------------------------------------
% --------------------- Analyis on single joints --------------------------
% -------------------------------------------------------------------------
range_jointIdx = [31:39];
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
singleJointsTau.leg.allValues_rleg = tmp.diffValueOfTorquesMean;
% Cluster in joints
singleJointsTau.rleg.jointsvalueOfTorqueMean.rhip   = zeros(5,1);
singleJointsTau.rleg.jointsvalueOfTorqueMean.rknee  = zeros(5,1);
singleJointsTau.rleg.jointsvalueOfTorqueMean.rankle = zeros(5,1);
for k = 1 : block.nrOfBlocks
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rhip(k,1)   = mean(singleJointsTau.leg.allValues_rleg(k,1:3));
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rknee(k,1)  = mean(singleJointsTau.leg.allValues_rleg(k,4:5));
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rankle(k,1) = mean(singleJointsTau.leg.allValues_rleg(k,6:7));
end

%% ================== LEFT LEG =============================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.leftLeg_range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.leftLeg_range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    interSubj(blockIdx).leftLegTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).leftLegTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'Intersubject left leg tau mean','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).leftLegTorqueMeanNE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).leftLegTorqueMeanNE) == 1);
        interSubj(blockIdx).leftLegTorqueMeanNE(:,nanVal) = (interSubj(blockIdx).leftLegTorqueMeanNE(:,nanVal-1)+ ...
            interSubj(blockIdx).leftLegTorqueMeanNE(:,nanVal+1))/2;
    end
    plot1 = plot(interSubj(blockIdx).leftLegTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).leftLegTorqueMeanWE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).leftLegTorqueMeanWE) == 1);
        interSubj(blockIdx).leftLegTorqueMeanWE(:,nanVal) = (interSubj(blockIdx).leftLegTorqueMeanWE(:,nanVal-1)+ ...
            interSubj(blockIdx).leftLegTorqueMeanWE(:,nanVal+1))/2;
    end
    plot2 = plot(interSubj(blockIdx).leftLegTorqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',22);
    ylabel('${\bar\tau}_{lleg}$','HorizontalAlignment','center',...
    'FontSize',40,'interpreter','latex');
    if blockIdx == 5
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    ylim([-1.5, 7.5]);
end
% align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_llegTauMean'),fig,600);
end

% -------------------------------------------------------------------------
% --------------------- Analyis on single joints --------------------------
% -------------------------------------------------------------------------
range_jointIdx = [40:48];
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
singleJointsTau.leg.allValues_lleg = tmp.diffValueOfTorquesMean;
% Cluster in joints
singleJointsTau.lleg.jointsvalueOfTorqueMean.lhip   = zeros(5,1);
singleJointsTau.lleg.jointsvalueOfTorqueMean.lknee  = zeros(5,1);
singleJointsTau.lleg.jointsvalueOfTorqueMean.lankle = zeros(5,1);
for k = 1 : block.nrOfBlocks
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lhip(k,1)   = mean(singleJointsTau.leg.allValues_lleg(k,1:3));
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lknee(k,1)  = mean(singleJointsTau.leg.allValues_lleg(k,4:5));
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lankle(k,1) = mean(singleJointsTau.leg.allValues_lleg(k,6:7));
end

%% Bar plot
fig = figure();
axes1 = axes('Parent',fig, ...
    'YGrid','on',...
    'XTickLabel',{'lHip',...
    'lKnee',...
    'lAnkle', ...
    'rHip',...
    'rKnee',...
    'rAnkle'},...
    'XTick',[1.9 3.9 5.9 7.9 9.9 11.9],...
    'FontSize',20);
box(axes1,'off');
hold(axes1,'on')

bar1 = bar([1.3, 3.3, 5.3, 7.3, 9.3, 11.3], ...
    [singleJointsTau.lleg.jointsvalueOfTorqueMean.lhip(1) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lknee(1) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lankle(1) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rhip(1) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rknee(1) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rankle(1)], ...
    0.15,'FaceColor',block1_color);
hold on;

bar2 = bar([1.6, 3.6, 5.6, 7.6, 9.6, 11.6], ...
    [singleJointsTau.lleg.jointsvalueOfTorqueMean.lhip(2) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lknee(2) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lankle(2) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rhip(2) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rknee(2) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rankle(2)], ...
    0.15,'FaceColor',block2_color);

bar3 = bar([1.9, 3.9, 5.9, 7.9, 9.9, 11.9], ...
    [singleJointsTau.lleg.jointsvalueOfTorqueMean.lhip(3) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lknee(3) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lankle(3) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rhip(3) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rknee(3) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rankle(3)], ...
    0.15,'FaceColor',block3_color);
hold on;
bar4 = bar([2.2, 4.2, 6.2, 8.2, 10.2, 12.2], ...
    [singleJointsTau.lleg.jointsvalueOfTorqueMean.lhip(4) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lknee(4) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lankle(4) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rhip(4) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rknee(4) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rankle(4)], ...
    0.15,'FaceColor',block4_color);
hold on;
bar5 = bar([2.5, 4.5, 6.5, 8.5, 10.5, 12.5], ...
    [singleJointsTau.lleg.jointsvalueOfTorqueMean.lhip(5) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lknee(5) ...
    singleJointsTau.lleg.jointsvalueOfTorqueMean.lankle(5) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rhip(5) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rknee(5) ...
    singleJointsTau.rleg.jointsvalueOfTorqueMean.rankle(5)], ...
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
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_legsTauMean_singleJoints'),fig,600);
end

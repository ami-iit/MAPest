
%% ================== TORSO ================================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.torso_range,1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.torso_range,1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
    % mean vector
    interSubj(blockIdx).torsoTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).torsoTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'Intersubject torso tau mean','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).torsoTorqueMeanNE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).torsoTorqueMeanNE) == 1);
        interSubj(blockIdx).torsoTorqueMeanNE(:,nanVal) = (interSubj(blockIdx).torsoTorqueMeanNE(:,nanVal-1)+ ...
            interSubj(blockIdx).torsoTorqueMeanNE(:,nanVal+1))/2;
    end
    plot1 = plot(interSubj(blockIdx).torsoTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    % check if isnan
    if ~isempty(find(isnan(interSubj(blockIdx).torsoTorqueMeanWE) == 1))
        nanVal = find(isnan(interSubj(blockIdx).torsoTorqueMeanWE) == 1);
        interSubj(blockIdx).torsoTorqueMeanWE(:,nanVal) = (interSubj(blockIdx).torsoTorqueMeanWE(:,nanVal-1)+ ...
            interSubj(blockIdx).torsoTorqueMeanWE(:,nanVal+1))/2;
    end
    plot2 = plot(interSubj(blockIdx).torsoTorqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',22);
    ylabel('${\bar\tau}_{torso}$','HorizontalAlignment','center',...
    'FontSize',40,'interpreter','latex');
    if blockIdx == 5
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    ylim([-12.5, 0.5]);
end
% align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_torsoTauMean'),fig,600);
end

% -------------------------------------------------------------------------
% --------------------- Analyis on single joints --------------------------
% -------------------------------------------------------------------------
range_jointIdx = [1:14];
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
singleJointsTau.torso.allValues = tmp.diffValueOfTorquesMean;
% Cluster in joints
singleJointsTau.torso.jointsvalueOfTorqueMean.L5S1  = zeros(5,1);
singleJointsTau.torso.jointsvalueOfTorqueMean.L4L3  = zeros(5,1);
singleJointsTau.torso.jointsvalueOfTorqueMean.L1T12 = zeros(5,1);
singleJointsTau.torso.jointsvalueOfTorqueMean.T9T8  = zeros(5,1);
singleJointsTau.torso.jointsvalueOfTorqueMean.T1C7  = zeros(5,1);
singleJointsTau.torso.jointsvalueOfTorqueMean.head  = zeros(5,1);
for k = 1 : block.nrOfBlocks
    singleJointsTau.torso.jointsvalueOfTorqueMean.L5S1(k,1)  = mean(singleJointsTau.torso.allValues(k,1:2));
    singleJointsTau.torso.jointsvalueOfTorqueMean.L4L3(k,1)  = mean(singleJointsTau.torso.allValues(k,3:4));
    singleJointsTau.torso.jointsvalueOfTorqueMean.L1T12(k,1) = mean(singleJointsTau.torso.allValues(k,5:6));
    singleJointsTau.torso.jointsvalueOfTorqueMean.T9T8(k,1)  = mean(singleJointsTau.torso.allValues(k,7:9));
    singleJointsTau.torso.jointsvalueOfTorqueMean.T1C7(k,1)  = mean(singleJointsTau.torso.allValues(k,10:12));
    singleJointsTau.torso.jointsvalueOfTorqueMean.head(k,1)  = mean(singleJointsTau.torso.allValues(k,13:14));
end

%% Bar plot
fig = figure();
axes1 = axes('Parent',fig, ...
    'YGrid','on',...
    'XTickLabel',{'L5S1',...
    'L4L3',...
    'L1T12',...
    'T9T8',...
    'T1C7',...
    'head'},...
    'XTick',[1.9 3.9 5.9 7.9 9.9 11.9],...
    'FontSize',20);
box(axes1,'off');
hold(axes1,'on')

bar1 = bar([1.3, 3.3, 5.3, 7.3, 9.3, 11.3], ...
    [singleJointsTau.torso.jointsvalueOfTorqueMean.L5S1(1) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L4L3(1) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L1T12(1) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T9T8(1) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T1C7(1) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.head(1)], ...
    0.15,'FaceColor',block1_color);
hold on;

bar2 = bar([1.6, 3.6, 5.6, 7.6, 9.6, 11.6], ...
    [singleJointsTau.torso.jointsvalueOfTorqueMean.L5S1(2) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L4L3(2) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L1T12(2) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T9T8(2) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T1C7(2) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.head(2)], ...
    0.15,'FaceColor',block2_color);

bar3 = bar([1.9, 3.9, 5.9, 7.9, 9.9, 11.9], ...
    [singleJointsTau.torso.jointsvalueOfTorqueMean.L5S1(3) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L4L3(3) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L1T12(3) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T9T8(3) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T1C7(3) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.head(3)], ...
    0.15,'FaceColor',block3_color);
hold on;
bar4 = bar([2.2, 4.2, 6.2, 8.2, 10.2, 12.2], ...
    [singleJointsTau.torso.jointsvalueOfTorqueMean.L5S1(4) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L4L3(4) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L1T12(4) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T9T8(4) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T1C7(4) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.head(4)], ...
    0.15,'FaceColor',block4_color);
hold on;
bar5 = bar([2.5, 4.5, 6.5, 8.5, 10.5, 12.5], ...
    [singleJointsTau.torso.jointsvalueOfTorqueMean.L5S1(5) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L4L3(5) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.L1T12(5) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T9T8(5) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.T1C7(5) ...
    singleJointsTau.torso.jointsvalueOfTorqueMean.head(5)], ...
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
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_torsoTauMean_singleJoints'),fig,600);
end

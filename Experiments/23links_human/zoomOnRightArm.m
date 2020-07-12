
%% Single joint right arm analysis
tmp.rightArm_range_jointIdx = [15,16,17,18,19,20,21,22];
tmp.diffValueOfTorquesMean = zeros(block.nrOfBlocks,length(tmp.rightArm_range_jointIdx));
for rarmIdx = 1 : length(tmp.rightArm_range_jointIdx)
    for blockIdx = 1 : block.nrOfBlocks
        tmp.interSubj(blockIdx).torqueListNE_singleJoint = [];
        tmp.interSubj(blockIdx).torqueListWE_singleJoint = [];
        %         tmp.interSubj(blockIdx).diffValueOfTorquesMean = [];
        % Create vector for all the subjects divided in blocks
        for subjIdx = 1 : nrOfSubject
            tmp.interSubj(blockIdx).torqueListNE_singleJoint  = [tmp.interSubj(blockIdx).torqueListNE_singleJoint; ...
                intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.rightArm_range_jointIdx(rarmIdx),1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
            tmp.interSubj(blockIdx).torqueListWE_singleJoint  = [tmp.interSubj(blockIdx).torqueListWE_singleJoint; ...
                intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.rightArm_range_jointIdx(rarmIdx),1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
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
        tmp.diffValueOfTorquesMean(blockIdx, rarmIdx) = ...
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



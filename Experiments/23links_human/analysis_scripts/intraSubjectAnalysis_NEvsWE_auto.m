
% Copyright (C) 2021 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% Preliminaries

close all;

% NE color
orangeAnDycolor = [0.952941176470588   0.592156862745098   0.172549019607843];
% WE color
greenAnDycolor  = [0.282352941176471   0.486274509803922   0.427450980392157];

subjectInfo_bio;
subjects = 21;
for subjIdx = 1 : length(subjects)
    subjectID = subjects(subjIdx);
    
    fprintf('SUBJECT_%03d\n',subjectID);
    bucket.datasetRoot          = fullfile(pwd, 'dataLBP_SPEXOR');
    bucket.pathToSubject        = fullfile(bucket.datasetRoot, sprintf('S%03d',subjectID));
    bucket.pathToSubjectRawData = fullfile(bucket.pathToSubject,'data');
    
    mass = subjectInfo_weight(subjIdx); % in kg
    height = subjectInfo_height(subjIdx); % in m
    %     loadWeight = subjectInfo_load(subjIdx); % in kg
    
    % New plot label for motion tasks
    motionTasksPlotLabel     = {'free'};
    motionTasksPlotLabel_exo = {'FREE_EXO'};
    for taskIdx = 1 : length(motionTasksPlotLabel)
        %% Extraction data squat
        % NE
        bucket.pathToTask   = fullfile(bucket.pathToSubjectRawData, motionTasksPlotLabel{1});
        bucket.pathToProcessedData   = fullfile(bucket.pathToTask,'processed');
        estimatedVariables_squat     = load(fullfile(bucket.pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
        synchrokin_squat             = load(fullfile(bucket.pathToProcessedData,'synchrokin.mat'));
        
        % WE
        bucket.pathToTask   = fullfile(bucket.pathToSubjectRawData,motionTasksPlotLabel_exo{1});
        bucket.pathToProcessedData  = fullfile(bucket.pathToTask,'processed');
        estimatedVariables_squatEXO = load(fullfile(bucket.pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
        synchrokin_squatEXO         = load(fullfile(bucket.pathToProcessedData,'synchrokin.mat'));
        
        selectedJoints           = load(fullfile(bucket.pathToProcessedData,'selectedJoints.mat'));
        
        %% ========================================================================
        %% ========================================================================
        %% [rotx] --> RightC7Shoulder, LeftC7Shoulder
        %% ========================================================================
        %% ========================================================================
        joints = {'RightC7Shoulder', 'LeftC7Shoulder'};
        joints_rotx = {'jRightC7Shoulder_rotx', 'jLeftC7Shoulder_rotx'};
        
        for jointsIdx = 1 : length(joints)
            fig = figure('Name', sprintf('intra-subject %s',joints{jointsIdx}),'NumberTitle','off');
            axes1 = axes('Parent',fig,'FontSize',16);
            box(axes1,'on');
            hold(axes1,'on');
            grid on;
            
            %% ----------- rotx
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_rotx{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,1,1) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{x}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,1,2) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{x}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3,plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            % subplot (3,1,3) %-------------exo forces w.r.t. T8 link
            % plot5 = plot(EXOfext.T8(1,:),'k','lineWidth',2);
            % axis tight;
            % ax = gca;
            % ax.FontSize = 15;
            % hold on
            % xlabel('samples','FontSize',25);
            % ylabel('$f^{EXO,T8}_x$','HorizontalAlignment','center',...
            %     'FontSize',40,'interpreter','latex');
            grid on;
        end
        
        %% ========================================================================
        %% ========================================================================
        %% [roty] --> RightBallFoot, LeftBallFoot
        %% ========================================================================
        %% ========================================================================
        joints = {'RightBallFoot', 'LeftBallFoot'};
        joints_roty = {'jRightBallFoot_roty', 'jLeftBallFoot_roty'};
        
        for jointsIdx = 1 : length(joints)
            fig = figure('Name', sprintf('intra-subject %s',joints{jointsIdx}),'NumberTitle','off');
            axes1 = axes('Parent',fig,'FontSize',16);
            box(axes1,'on');
            hold(axes1,'on');
            grid on;
            
            %% ----------- roty
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_roty{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,1,1) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{y}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,1,2) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{y}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3,plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            % subplot (3,1,3) %-------------exo forces w.r.t. T8 link
            % plot5 = plot(EXOfext.T8(1,:),'k','lineWidth',2);
            % axis tight;
            % ax = gca;
            % ax.FontSize = 15;
            % hold on
            % xlabel('samples','FontSize',25);
            % ylabel('$f^{EXO,T8}_x$','HorizontalAlignment','center',...
            %     'FontSize',40,'interpreter','latex');
            grid on;
        end
        
        %% ========================================================================
        %% ========================================================================
        %% [rotx, roty] --> L5S1, L4L3, L1T12, C1Head
        %% ========================================================================
        %% ========================================================================
        joints = {'L5S1', 'L4L3','L1T12', 'C1Head'};
        joints_rotx = {'jL5S1_rotx', 'jL4L3_rotx','jL1T12_rotx', 'jC1Head_rotx'};
        joints_roty = {'jL5S1_roty', 'jL4L3_roty','jL1T12_roty', 'jC1Head_roty'};
        
        for jointsIdx = 1 : length(joints)
            fig = figure('Name', sprintf('intra-subject %s',joints{jointsIdx}),'NumberTitle','off');
            axes1 = axes('Parent',fig,'FontSize',16);
            box(axes1,'on');
            hold(axes1,'on');
            grid on;
            
            %% ----------- rotx
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_rotx{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,2,1) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{x}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,2,3) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{x}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3,plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            % subplot (3,1,3) %-------------exo forces w.r.t. T8 link
            % plot5 = plot(EXOfext.T8(1,:),'k','lineWidth',2);
            % axis tight;
            % ax = gca;
            % ax.FontSize = 15;
            % hold on
            % xlabel('samples','FontSize',25);
            % ylabel('$f^{EXO,T8}_x$','HorizontalAlignment','center',...
            %     'FontSize',40,'interpreter','latex');
            grid on;
            
            %% ----------- roty
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_roty{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,2,2) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{y}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,2,4) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{y}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3, plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            grid on;
        end
        
        
        %% ========================================================================
        %% ========================================================================
        %% [roty, rotz] --> RightElbow, RightKnee, LeftElbow, LeftKnee
        %% ========================================================================
        %% ========================================================================
        joints = {'RightElbow', 'RightKnee','LeftElbow', 'LeftKnee'};
        joints_roty = {'jRightElbow_roty', 'jRightKnee_roty','jLeftElbow_roty', 'jLeftKnee_roty'};
        joints_rotz = {'jRightElbow_rotz', 'jRightKnee_rotz','jLeftElbow_rotz', 'jLeftKnee_rotz'};
        
        for jointsIdx = 1 : length(joints)
            
            fig = figure('Name', sprintf('intra-subject %s',joints{jointsIdx}),'NumberTitle','off');
            axes1 = axes('Parent',fig,'FontSize',16);
            box(axes1,'on');
            hold(axes1,'on');
            grid on;
            
            %% ----------- roty
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_roty{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,2,1) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{y}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,2,3) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{y}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3, plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            grid on;
            
            %% ----------- rotz
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_rotz{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,2,2) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{z}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,2,4) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{z}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3,plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            % subplot (3,1,3) %-------------exo forces w.r.t. T8 link
            % plot5 = plot(EXOfext.T8(1,:),'k','lineWidth',2);
            % axis tight;
            % ax = gca;
            % ax.FontSize = 15;
            % hold on
            % xlabel('samples','FontSize',25);
            % ylabel('$f^{EXO,T8}_x$','HorizontalAlignment','center',...
            %     'FontSize',40,'interpreter','latex');
            grid on;
        end
        
        %% ========================================================================
        %% ========================================================================
        %% [rotx, rotz] --> RightWrist, LeftWrist
        %% ========================================================================
        %% ========================================================================
        joints = {'RightWrist', 'LeftWrist'};
        joints_rotx = {'jRightWrist_rotx', 'jLeftWrist_rotx'};
        joints_rotz = {'jRightElbow_rotz', 'jLeftWrist_rotz'};
        
        for jointsIdx = 1 : length(joints)
            
            fig = figure('Name', sprintf('intra-subject %s',joints{jointsIdx}),'NumberTitle','off');
            axes1 = axes('Parent',fig,'FontSize',16);
            box(axes1,'on');
            hold(axes1,'on');
            grid on;
            
            %% ----------- rotx
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_rotx{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,2,1) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{x}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,2,3) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{x}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3, plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            grid on;
            
            %% ----------- rotz
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_rotz{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,2,2) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{z}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,2,4) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{z}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3,plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            % subplot (3,1,3) %-------------exo forces w.r.t. T8 link
            % plot5 = plot(EXOfext.T8(1,:),'k','lineWidth',2);
            % axis tight;
            % ax = gca;
            % ax.FontSize = 15;
            % hold on
            % xlabel('samples','FontSize',25);
            % ylabel('$f^{EXO,T8}_x$','HorizontalAlignment','center',...
            %     'FontSize',40,'interpreter','latex');
            grid on;
        end
        
        %% ========================================================================
        %% ========================================================================
        %% [roty, rotz] --> T9T8, T1C7, L1T12, RightShoulder, LeftShoulder,
        %                   RightHip, LeftHip, RightAnkle, LeftAnkle
        %% ========================================================================
        %% ========================================================================
        joints = {'T9T8', 'T1C7', 'L1T12','RightShoulder','LeftShoulder', ...
            'RightHip', 'LeftHip', 'RightAnkle', 'LeftAnkle'};
        joints_rotx = { 'jT9T8_rotx', 'jT1C7_rotx', 'jL1T12_rotx','jRightShoulder_rotx','jLeftShoulder_rotx', ...
            'jRightHip_rotx', 'jLeftHip_rotx', 'jRightAnkle_rotx', 'jLeftAnkle_rotx'};
        joints_roty = { 'jT9T8_roty', 'jT1C7_roty', 'jL1T12_roty','jRightShoulder_roty','jLeftShoulder_roty', ...
            'jRightHip_roty', 'jLeftHip_roty', 'jRightAnkle_roty', 'jLeftAnkle_roty'};
        joints_rotz = { 'jT9T8_rotz', 'jT1C7_rotz', 'jL1T12_rotz','jRightShoulder_rotz','jLeftShoulder_rotz', ...
            'jRightHip_rotz', 'jLeftHip_rotz', 'jRightAnkle_rotz', 'jLeftAnkle_rotz'};
        
        
        for jointsIdx = 1 : length(joints)
            
            fig = figure('Name', sprintf('intra-subject %s',joints{jointsIdx}),'NumberTitle','off');
            axes1 = axes('Parent',fig,'FontSize',16);
            box(axes1,'on');
            hold(axes1,'on');
            grid on;
            
            %% ----------- rotx
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_rotx{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,3,1) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{x}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,3,4) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{x}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3, plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            grid on;
            
            %% ----------- roty
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_roty{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,3,2) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{y}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,3,5) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{y}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3, plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            grid on;
            
            %% ----------- rotz
            for jIdx = 1 : length(selectedJoints.selectedJoints)
                if strcmp(selectedJoints.selectedJoints{jIdx}, joints_rotz{jointsIdx})
                    jointIndex = jIdx;
                end
            end
            subplot (2,3,3) %-------------squat
            % NE
            plot1 = plot((estimatedVariables_squat.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot2 = plot((estimatedVariables_squatEXO.estimatedVariables.tau.values(jointIndex,:)), ...
                'color',greenAnDycolor,'lineWidth',4);
            hold on
            title(sprintf('Subj %03d, Task  < %s >, %s', subjectID,'squat',joints{jointsIdx}),'FontSize',22);
            ylabel('$\tau_{z}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot1,plot2],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            subplot (2,3,6) %-------------squat kinematics
            % NE
            plot3 = plot((synchrokin_squat.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',orangeAnDycolor,'lineWidth',4);
            axis tight;
            ax = gca;
            ax.FontSize = 15;
            hold on
            % WE
            plot4 = plot((synchrokin_squatEXO.synchroKin.q(jointIndex,:)*180/pi), ...
                'color',greenAnDycolor,'lineWidth',4);
            xlabel('samples','FontSize',25);
            ylabel('$q_{z}$','HorizontalAlignment','center',...
                'FontSize',40,'interpreter','latex');
            grid on;
            %legend
            leg = legend([plot3,plot4],{'NE', 'WE'},'Location','northeast');
            set(leg,'Interpreter','latex','FontSize',25);
            
            % subplot (3,1,3) %-------------exo forces w.r.t. T8 link
            % plot5 = plot(EXOfext.T8(1,:),'k','lineWidth',2);
            % axis tight;
            % ax = gca;
            % ax.FontSize = 15;
            % hold on
            % xlabel('samples','FontSize',25);
            % ylabel('$f^{EXO,T8}_x$','HorizontalAlignment','center',...
            %     'FontSize',40,'interpreter','latex');
            grid on;
        end
    end
end

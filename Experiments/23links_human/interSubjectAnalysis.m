% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% Preliminaries
close all;

% Subjects
tmp.subjects = {'subj01'; ...
    'subj02'; ...
    'subj03'; ...
    'subj04'; ...
    'subj05'; ...
    'subj06'; ...
    'subj07'; ...
    'subj08'; ...
    'subj09'; ...
    'subj10'; ...
    'subj11'; ...
    'subj12'};

% Blocks
block.labels = {'block1'; ...
    'block2'; ...
    'block3'; ...
    'block4'; ...
    'block5'};
block.nrOfBlocks = size(block.labels,1);

% NE color
orangeAnDycolor = [0.952941176470588   0.592156862745098   0.172549019607843];
% WE color
greenAnDycolor  = [0.282352941176471   0.486274509803922   0.427450980392157];

%% Extraction data
subjectID = [1,2];% subjectID = [1,3,5,7,9,11];
nrOfSubject = length(subjectID);
taskID = [0,1];

for subjIdx = 1 : nrOfSubject
    intraSubj(subjIdx).subjects = tmp.subjects(subjIdx);
    pathToSubject = fullfile(bucket.datasetRoot, sprintf('S%02d',subjectID(subjIdx)));
    
    if floor(subjIdx/2) == subjIdx/2 %GROUP 2 --> subjectID = [2,4,6,8,10,12];
        % 0 --> NE
        pathToTask = fullfile(pathToSubject,sprintf('task%d',taskID(1)));
        pathToProcessedData = fullfile(pathToTask,'processed');
        intraSubj(subjIdx).NE = load(fullfile(pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
        % 1 --> WE
        pathToTask = fullfile(pathToSubject,sprintf('task%d',taskID(2)));
        pathToProcessedData = fullfile(pathToTask,'processed');
        intraSubj(subjIdx).WE = load(fullfile(pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
    else %GROUP 1--> subjectID = [1,3,5,7,9,11]
        % 1 --> NE
        pathToTask = fullfile(pathToSubject,sprintf('task%d',taskID(2)));
        pathToProcessedData = fullfile(pathToTask,'processed');
        intraSubj(subjIdx).NE = load(fullfile(pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
        % 0 --> WE
        pathToTask = fullfile(pathToSubject,sprintf('task%d',taskID(1)));
        pathToProcessedData = fullfile(pathToTask,'processed');
        intraSubj(subjIdx).WE = load(fullfile(pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
    end
end 

%% ========================================================================
%%                    OVERALL WHOLE-BODY EFFECT
%% ========================================================================
% -------- Intra-subject overall torque norm
for subjIdx = 1 : nrOfSubject
    for blockIdx = 1 : block.nrOfBlocks
        intraSubj(subjIdx).torqueNormNE(blockIdx).block = block.labels(blockIdx);
        intraSubj(subjIdx).torqueNormWE(blockIdx).block = block.labels(blockIdx);
        lenNE = length(intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values);
        lenWE = length(intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values);
        for i = 1 : lenNE
            intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm(1,i) = ...
                norm(intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(:,i));
        end
        for i = 1 : lenWE
            intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm(1,i) = ...
                norm(intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(:,i));
        end
    end
end

% -------- Inter-subject overall torque norm
% Create vector for all the subjects divided in blocks
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).overallTorqueListNE = [];
    tmp.interSubj(blockIdx).overallTorqueListWE = [];
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).overallTorqueListNE  = [tmp.interSubj(blockIdx).overallTorqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values];
        tmp.interSubj(blockIdx).overallTorqueListWE  = [tmp.interSubj(blockIdx).overallTorqueListWE; ... 
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values];
    end
end

% Overall torque norm
for blockIdx = 1 : block.nrOfBlocks
    interSubj(blockIdx).block = block.labels(blockIdx);
    lenNE = length(tmp.interSubj(blockIdx).overallTorqueListNE);
    lenWE = length(tmp.interSubj(blockIdx).overallTorqueListWE);
     for i = 1 : lenNE
         interSubj(blockIdx).torqueNormNE(1,i) = norm(tmp.interSubj(blockIdx).overallTorqueListNE(:,i));
     end
     for i = 1 : lenWE
         interSubj(blockIdx).torqueNormWE(1,i) = norm(tmp.interSubj(blockIdx).overallTorqueListWE(:,i));
     end
end
fig = figure('Name', 'Intersubject whole-body effect NE vs WE','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    plot1 = plot(interSubj(blockIdx).torqueNormNE,'color',orangeAnDycolor,'lineWidth',1.5);
    hold on
    % WE
    plot2 = plot(interSubj(blockIdx).torqueNormWE,'color',greenAnDycolor,'lineWidth',1.5);
    hold on
    title(sprintf('overall norm, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
    ylabel('\tau norm');
    if blockIdx == 5
        xlabel('samples');
    end
    set(gca,'FontSize',15)
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex');
    axis tight
end

%% Body areas
tmp.torso_range    = (1:14);
tmp.rightArm_range = (15:22);
tmp.leftArm_range  = (23:30);
tmp.rightLeg_range = (31:39);
tmp.leftLeg_range  = (40:48);

% ================== TORSO ================================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.torso_range,:)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.torso_range,:)];
    end
    % mean vector
    interSubj(blockIdx).torsoTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).torsoTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'torso mean torque NE vs WE','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    plot1 = plot(interSubj(blockIdx).torsoTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',1.5);
    hold on
    % WE
    plot2 = plot(interSubj(blockIdx).torsoTorqueMeanWE,'color',greenAnDycolor,'lineWidth',1.5);
    hold on
    title(sprintf('Torso mean torque, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
    ylabel('\tau norm');
    if blockIdx == 5
        xlabel('samples');
    end
    set(gca,'FontSize',15)
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex');
    axis tight
end

% ================== RIGHT ARM ============================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.rightArm_range,:)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.rightArm_range,:)];
    end
    % mean vector
    interSubj(blockIdx).rightArmTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).rightArmTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'right arm mean torque NE vs WE','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    plot1 = plot(interSubj(blockIdx).rightArmTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',1.5);
    hold on
    % WE
    plot2 = plot(interSubj(blockIdx).rightArmTorqueMeanWE,'color',greenAnDycolor,'lineWidth',1.5);
    hold on
    title(sprintf('Right arm mean torque, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
    ylabel('\tau norm');
    if blockIdx == 5
        xlabel('samples');
    end
    set(gca,'FontSize',15)
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex');
    axis tight
end

% ================== LEFT ARM =============================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.leftArm_range,:)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.leftArm_range,:)];
    end
    % mean vector
    interSubj(blockIdx).leftArmTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).leftArmTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'left arm mean torque NE vs WE','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    plot1 = plot(interSubj(blockIdx).leftArmTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',1.5);
    hold on
    % WE
    plot2 = plot(interSubj(blockIdx).leftArmTorqueMeanWE,'color',greenAnDycolor,'lineWidth',1.5);
    hold on
    title(sprintf('Left arm mean torque, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
    ylabel('\tau norm');
    if blockIdx == 5
        xlabel('samples');
    end
    set(gca,'FontSize',15)
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex');
    axis tight
end

% ================== RIGHT LEG ============================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.rightLeg_range,:)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.rightLeg_range,:)];
    end
    % mean vector
    interSubj(blockIdx).rightLegTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).rightLegTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'right leg mean torque NE vs WE','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    plot1 = plot(interSubj(blockIdx).rightLegTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',1.5);
    hold on
    % WE
    plot2 = plot(interSubj(blockIdx).rightLegTorqueMeanWE,'color',greenAnDycolor,'lineWidth',1.5);
    hold on
    title(sprintf('Right leg mean torque, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
    ylabel('\tau norm');
    if blockIdx == 5
        xlabel('samples');
    end
    set(gca,'FontSize',15)
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex');
    axis tight
end

% ================== LEFT LEG =============================================
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).torqueListNE = [];
    tmp.interSubj(blockIdx).torqueListWE = [];
    % Create vector for all the subjects divided in blocks
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).torqueListNE  = [tmp.interSubj(blockIdx).torqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(tmp.leftLeg_range,:)];
        tmp.interSubj(blockIdx).torqueListWE  = [tmp.interSubj(blockIdx).torqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(tmp.leftLeg_range,:)];
    end
    % mean vector
    interSubj(blockIdx).leftLegTorqueMeanNE = mean(tmp.interSubj(blockIdx).torqueListNE);
    interSubj(blockIdx).leftLegTorqueMeanWE = mean(tmp.interSubj(blockIdx).torqueListWE);
end
fig = figure('Name', 'left leg mean torque NE vs WE','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    plot1 = plot(interSubj(blockIdx).leftLegTorqueMeanNE,'color',orangeAnDycolor,'lineWidth',1.5);
    hold on
    % WE
    plot2 = plot(interSubj(blockIdx).leftLegTorqueMeanWE,'color',greenAnDycolor,'lineWidth',1.5);
    hold on
    title(sprintf('Left leg mean torque, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
    ylabel('\tau norm');
    if blockIdx == 5
        xlabel('samples');
    end
    set(gca,'FontSize',15)
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex');
    axis tight
end

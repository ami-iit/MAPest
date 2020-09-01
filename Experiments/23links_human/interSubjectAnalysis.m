% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% Preliminaries
close all;
clc; clear all;
% Root folder of the dataset
bucket = struct;
bucket.datasetRoot = fullfile(pwd, 'dataJSI');

addpath(genpath('../../external'));

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
% Effect colors
benefit_color_green = [0.4660 0.6740 0.1880];
noBenefit_color_red = [1 0 0];
% Plot folder
bucket.pathToPlots = fullfile(bucket.datasetRoot,'/plots');
if ~exist(bucket.pathToPlots)
    mkdir (bucket.pathToPlots)
end
saveON = false;

%% Extraction data
subjectID = [1,2,3,4,5,6,7,8,9,10,11,12];
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
        intraSubj(subjIdx).NE_errRel = load(fullfile(pathToProcessedData,'covarianceTuning.mat'));
        % 1 --> WE
        pathToTask = fullfile(pathToSubject,sprintf('task%d',taskID(2)));
        pathToProcessedData = fullfile(pathToTask,'processed');
        intraSubj(subjIdx).WE = load(fullfile(pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
        intraSubj(subjIdx).WE_errRel = load(fullfile(pathToProcessedData,'covarianceTuning.mat'));
    else %GROUP 1--> subjectID = [1,3,5,7,9,11]
        % 1 --> NE
        pathToTask = fullfile(pathToSubject,sprintf('task%d',taskID(2)));
        pathToProcessedData = fullfile(pathToTask,'processed');
        intraSubj(subjIdx).NE = load(fullfile(pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
        intraSubj(subjIdx).NE_errRel = load(fullfile(pathToProcessedData,'covarianceTuning.mat'));
        % 0 --> WE
        pathToTask = fullfile(pathToSubject,sprintf('task%d',taskID(1)));
        pathToProcessedData = fullfile(pathToTask,'processed');
        intraSubj(subjIdx).WE = load(fullfile(pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
        intraSubj(subjIdx).WE_errRel = load(fullfile(pathToProcessedData,'covarianceTuning.mat'));
    end
end
selectedJoints = load(fullfile(pathToProcessedData,'selectedJoints.mat'));

%% ========================================================================
%%                    COVARIANCE TUNING CHOICE
%% ========================================================================
% Create the vector for the choice of the trustfull power --> n = 4
tmp.trustfullPower_NE = [];
tmp.trustfullPower_WE = [];
for subjIdx = 1 : nrOfSubject
    tmp.trustfullPower_NE = [tmp.trustfullPower_NE, intraSubj(subjIdx).NE_errRel.covarianceTuning.chosenSelectedValue];
    tmp.trustfullPower_WE = [tmp.trustfullPower_WE, intraSubj(subjIdx).WE_errRel.covarianceTuning.chosenSelectedValue];
end

% Collect the percentage for the relative error |meas - estim|/|meas|
tmp.relErrPercentage_NE = [];
tmp.relErrPercentage_WE = [];
for subjIdx = 1 : nrOfSubject
    tmp.relErrPercentage_NE = [tmp.relErrPercentage_NE, intraSubj(subjIdx).NE_errRel.covarianceTuning.relError_percentage];
    tmp.relErrPercentage_WE = [tmp.relErrPercentage_WE, intraSubj(subjIdx).WE_errRel.covarianceTuning.relError_percentage];
end
relErrPercentage_NE_mean = mean(tmp.relErrPercentage_NE);
relErrPercentage_WE_mean = mean(tmp.relErrPercentage_WE);

%% Check if NaN in loaded raw data
for subjIdx = 1 : nrOfSubject
    for blockIdx = 1 : block.nrOfBlocks
        for i = 1 : length(selectedJoints.selectedJoints)
            % NE
            if ~isempty(find(isnan(intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(i,:)) == 1))
                nanVal = find(isnan(intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(i,:)) == 1);
                intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(i,nanVal) = ...
                    (intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(i,nanVal-1)+ ...
                    intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(i,nanVal+1))/2;
            end
            % WE
            if ~isempty(find(isnan(intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(i,:)) == 1))
                nanVal = find(isnan(intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(i,:)) == 1);
                intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(i,nanVal) = ...
                    (intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(i,nanVal-1)+ ...
                    intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(i,nanVal+1))/2;
            end
        end
    end
end

%% ========================================================================
%%                    OVERALL NORM WHOLE-BODY EFFECT
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
% Uniform the range of signals per block
for blockIdx = 1 : block.nrOfBlocks
    interSubj(blockIdx).block = block.labels(blockIdx);
    tmp.interSubj(blockIdx).rangeNE = [];
    tmp.interSubj(blockIdx).rangeWE = [];
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).rangeNE = [tmp.interSubj(blockIdx).rangeNE; ...
            size(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm,2)];
        tmp.interSubj(blockIdx).rangeWE = [tmp.interSubj(blockIdx).rangeWE; ...
            size(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm,2)];
    end
    interSubj(blockIdx).lenghtOfIntersubjNormNE = min(tmp.interSubj(blockIdx).rangeNE);
    interSubj(blockIdx).lenghtOfIntersubjNormWE = min(tmp.interSubj(blockIdx).rangeWE);
end

% Create vector for all the subjects divided in blocks
for blockIdx = 1 : block.nrOfBlocks
    tmp.interSubj(blockIdx).overallTorqueListNE = [];
    tmp.interSubj(blockIdx).overallTorqueListWE = [];
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj(blockIdx).overallTorqueListNE  = [tmp.interSubj(blockIdx).overallTorqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(:, 1:interSubj(blockIdx).lenghtOfIntersubjNormNE)];
        tmp.interSubj(blockIdx).overallTorqueListWE  = [tmp.interSubj(blockIdx).overallTorqueListWE; ... 
            intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(:, 1:interSubj(blockIdx).lenghtOfIntersubjNormWE)];
    end
end

% Overall torque norm
for blockIdx = 1 : block.nrOfBlocks
    lenNE = interSubj(blockIdx).lenghtOfIntersubjNormNE;
    lenWE = interSubj(blockIdx).lenghtOfIntersubjNormWE;
     for i = 1 : lenNE
         interSubj(blockIdx).torqueNormNE(1,i) = norm(tmp.interSubj(blockIdx).overallTorqueListNE(:,i));
     end
     for i = 1 : lenWE
         interSubj(blockIdx).torqueNormWE(1,i) = norm(tmp.interSubj(blockIdx).overallTorqueListWE(:,i));
     end
end

% Overall torque norm difference
% % % Find the minimum length for the difference
% % for blockIdx = 1 : block.nrOfBlocks
% %     interSubj(blockIdx).lenghtOfIntersubjDiff = min(interSubj(blockIdx).lenghtOfIntersubjNormNE, ....
% %         interSubj(blockIdx).lenghtOfIntersubjNormWE); 
% % end
% % % Cut signals with new length
% % for blockIdx = 1 : block.nrOfBlocks
% %     tmp.interSubj(blockIdx).overallTorqueListNE_cut = tmp.interSubj(blockIdx).overallTorqueListNE(:,1:interSubj(blockIdx).lenghtOfIntersubjDiff);
% %     tmp.interSubj(blockIdx).overallTorqueListWE_cut = tmp.interSubj(blockIdx).overallTorqueListWE(:,1:interSubj(blockIdx).lenghtOfIntersubjDiff);
% % end
% % 
% % % Difference: (tau_NE - tau_WE)
% % for blockIdx = 1 : block.nrOfBlocks
% %         tmp.interSubj(blockIdx).tauDiff = tmp.interSubj(blockIdx).overallTorqueListNE_cut - tmp.interSubj(blockIdx).overallTorqueListWE_cut;
% % end
% % % Norm of the difference |tau_NE - tau_WE|
% % for blockIdx = 1 : block.nrOfBlocks
% %     for lenIdx = 1 : interSubj(blockIdx).lenghtOfIntersubjDiff
% %         tmp.interSubj(blockIdx).tauNormDiff(1,lenIdx) = norm(tmp.interSubj(blockIdx).tauDiff(:,lenIdx));
% %     end
% % end
% % % Norm of |tau_NE|
% % for blockIdx = 1 : block.nrOfBlocks
% %     for lenIdx = 1 : interSubj(blockIdx).lenghtOfIntersubjDiff
% %         tmp.interSubj(blockIdx).normTau_NE(1,lenIdx) = norm(tmp.interSubj(blockIdx).overallTorqueListNE_cut(:,lenIdx));
% %     end
% % end
% % % Relative error: |tau_NE - tau_WE|/|tau_NE|
% % for blockIdx = 1 : block.nrOfBlocks
% %     for lenIdx = 1 : interSubj(blockIdx).lenghtOfIntersubjDiff
% %         interSubj(blockIdx).relTauError(1,lenIdx) = (tmp.interSubj(blockIdx).tauNormDiff(1,lenIdx)/tmp.interSubj(blockIdx).normTau_NE(1,lenIdx));
% %     end
% % end

% Plot norm
fig = figure('Name', 'Intersubject overall tau norm','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    plot1 = plot(interSubj(blockIdx).torqueNormNE,'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot(interSubj(blockIdx).torqueNormWE,'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',22);
    ylabel('$|\tau|$','HorizontalAlignment','center',...
    'FontSize',40,'interpreter','latex');
    if blockIdx == 5
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_overallTauNorm_s'),fig,600);
end

% -------- Inter-subject overall torque mean
for blockIdx = 1 : block.nrOfBlocks
    interSubj(blockIdx).torqueMeanNE = mean(tmp.interSubj(blockIdx).overallTorqueListNE);
    interSubj(blockIdx).torqueMeanWE = mean(tmp.interSubj(blockIdx).overallTorqueListWE);
end

% Plot mean
fig = figure('Name', 'Intersubject overall tau mean','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    plot1 = plot(interSubj(blockIdx).torqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot(interSubj(blockIdx).torqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',22);
    ylabel('$\bar\tau$ [Nm]','HorizontalAlignment','center',...
    'FontSize',30,'interpreter','latex');
    if blockIdx == 5
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([-1.8, 0.7]);
    ylim([-1.8, 0.8]);
    yticks([-1 0])
end
% align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_overallTauMean'),fig,600);
end

%% ========================================================================
%%                 BODY EFFECT DIVIDED PER AREAS
%% ========================================================================
% Torso
tmp.torso_range  = [1:12]; %no 13,14, head joints
interSubjectAnalysis_torso;
% Arms
tmp.rightArm_range = [15:22];
tmp.leftArm_range  = [23:30];
interSubjectAnalysis_arms;
% Legs
tmp.rightLeg_range = [31:38]; %no 39, rightBallFoot joint
tmp.leftLeg_range  = [40:47]; %no 48, leftBallFoot joint
interSubjectAnalysis_legs;


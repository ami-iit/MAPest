
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
addpath(genpath('analysis_scripts'));

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
%%                         INTRA-SUBJECT COMPUTATIONS
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
% Normalization
for subjIdx = 1 : nrOfSubject
    for blockIdx = 1 : block.nrOfBlocks
        % ---- normalized norm NE
        intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm_normalized = ...
            (intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm - ...
            min(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm))/ ...
            (max(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm) - ...
            min(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm));
        % ---- normalized norm WE
        intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm_normalized = ...
            (intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm - ...
            min(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm))/ ...
            (max(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm) - ...
            min(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm));
    end
end

% -------- Intra-subject overall torque MEAN
for subjIdx = 1 : nrOfSubject
    for blockIdx = 1 : block.nrOfBlocks
        lenNE = length(intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values);
        lenWE = length(intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values);
        for i = 1 : lenNE
            intraSubj(subjIdx).torqueMeanNE(blockIdx).torqueMean(1,i) = ...
                mean(intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(:,i));
        end
        for i = 1 : lenWE
            intraSubj(subjIdx).torqueMeanWE(blockIdx).torqueMean(1,i) = ...
                mean(intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(:,i));
        end
    end
end
% Normalization
for subjIdx = 1 : nrOfSubject
    for blockIdx = 1 : block.nrOfBlocks
        % ---- normalized mean NE
        intraSubj(subjIdx).torqueMeanNE(blockIdx).torqueMean_normalized = ...
            (intraSubj(subjIdx).torqueMeanNE(blockIdx).torqueMean - ...
            min(intraSubj(subjIdx).torqueMeanNE(blockIdx).torqueMean))/ ...
            (max(intraSubj(subjIdx).torqueMeanNE(blockIdx).torqueMean) - ...
            min(intraSubj(subjIdx).torqueMeanNE(blockIdx).torqueMean));
        % ---- normalized mean WE
        intraSubj(subjIdx).torqueMeanWE(blockIdx).torqueMean_normalized = ...
            (intraSubj(subjIdx).torqueMeanWE(blockIdx).torqueMean - ...
            min(intraSubj(subjIdx).torqueMeanWE(blockIdx).torqueMean))/ ...
            (max(intraSubj(subjIdx).torqueMeanWE(blockIdx).torqueMean) - ...
            min(intraSubj(subjIdx).torqueMeanWE(blockIdx).torqueMean));
    end
end

%% ========================================================================
%%                         WHOLE-BODY NORM
%% ========================================================================
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

% -------- Inter-subject overall torque norm
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

%% Plot norm
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
    ylabel('$||\tau||$','HorizontalAlignment','center',...
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

%% Stats and boxplot norm
stats_tauNorm_wb_anova2;

%% ========================================================================
%%                         WHOLE-BODY MEAN
%% ========================================================================
% -------- Inter-subject overall torque mean
meanMeanTorques = zeros(block.nrOfBlocks,2);
for blockIdx = 1 : block.nrOfBlocks
    % NE
    interSubj(blockIdx).torqueMeanNE = mean(tmp.interSubj(blockIdx).overallTorqueListNE);
    meanMeanTorques(blockIdx,1) = mean(interSubj(blockIdx).torqueMeanNE);
    % WE
    interSubj(blockIdx).torqueMeanWE = mean(tmp.interSubj(blockIdx).overallTorqueListWE);
        meanMeanTorques(blockIdx,2) = mean(interSubj(blockIdx).torqueMeanWE);
end


%% Plot mean
fig = figure('Name', 'Intersubje overall tau mean','NumberTitle','off');
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
    ax.FontSize = 27;
    hold on
    % WE
    plot2 = plot(interSubj(blockIdx).torqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',23);
    ylabel('$\bar\tau^{wb}$ [Nm]','HorizontalAlignment','center',...
        'FontSize',30,'interpreter','latex');
    if blockIdx == 5
        xlabel('samples','FontSize',30);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',33);
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

%% Plot mean abs
% % % fig = figure('Name', 'Intersubje overall tau mean','NumberTitle','off');
% % % axes1 = axes('Parent',fig,'FontSize',16);
% % % box(axes1,'on');
% % % hold(axes1,'on');
% % % grid on;
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     subplot (5,1,blockIdx)
% % %     % NE
% % %     plot1 = plot(abs(interSubj(blockIdx).torqueMeanNE),'color',orangeAnDycolor,'lineWidth',4);
% % %     axis tight;
% % %     ax = gca;
% % %     ax.FontSize = 27;
% % %     hold on
% % %     % WE
% % %     plot2 = plot(abs(interSubj(blockIdx).torqueMeanWE),'color',greenAnDycolor,'lineWidth',4);
% % %     hold on
% % %     title(sprintf('Block %s', num2str(blockIdx)),'FontSize',23);
% % %     ylabel('$|\bar\tau^{wb}|$ [Nm]','HorizontalAlignment','center',...
% % %         'FontSize',35,'interpreter','latex');
% % %     if blockIdx == 5
% % %         xlabel('samples','FontSize',30);
% % %     end
% % %     grid on;
% % %     %legend
% % %     leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
% % %     set(leg,'Interpreter','latex','FontSize',33);
% % %     % axis tight
% % %     %     ylim([-1.8, 0.7]);
% % %     ylim([-0.3, 2]);
% % %     yticks([-1 0 1])
% % % end
% % % % align_Ylabels(gcf)
% % % % subplotsqueeze(gcf, 1.12);
% % % tightfig();
% % % % save
% % % if saveON
% % %     save2pdf(fullfile(bucket.pathToPlots,'intersubj_overallTauMean'),fig,600);
% % % end

%% Plot normalized mean abs
fig = figure('Name', 'Intersubje overall tau normalized mean','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;
for blockIdx = 1 : block.nrOfBlocks
    subplot (5,1,blockIdx)
    % NE
    NE_vect = abs(interSubj(blockIdx).torqueMeanNE);
    NE_vect_min = min(NE_vect);
    NE_vect_max = max(NE_vect);
    plot1 = plot((NE_vect-NE_vect_min)/(NE_vect_max-NE_vect_min),'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 27;
    hold on
    % WE
    WE_vect = abs(interSubj(blockIdx).torqueMeanWE);
    WE_vect_min = min(WE_vect);
    WE_vect_max = max(WE_vect);
    plot2 = plot((WE_vect-WE_vect_min)/(WE_vect_max-WE_vect_min),'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',23);
    ylabel('$|\bar\tau^{wb}|$ [Nm]','HorizontalAlignment','center',...
        'FontSize',35,'interpreter','latex');
    if blockIdx == 5
        xlabel('samples','FontSize',30);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',33);
    % axis tight
    %     ylim([-1.8, 0.7]);
    ylim([-0.3, 2]);
    yticks([0 1])
end
% align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_overallTauNormalizedMean'),fig,600);
end

%% Bar plot single joints
fig = figure();
axes1 = axes('Parent',fig, ...
    'YGrid','on',...
    'XTickLabel',{'Block1',...
    'Block2',...
    'Block3',...
    'Block4',...
    'Block5'},...
    'XTick',[1 2 3 4 5],...
    'FontSize',20);
box(axes1,'off');
hold(axes1,'on');
grid on;

bar1 = bar([1 2 3 4 5],...
    [meanMeanTorques(1,1) ...
    meanMeanTorques(2,1) ...
    meanMeanTorques(3,1) ...
    meanMeanTorques(4,1) ...
    meanMeanTorques(5,1)], ...
    0.30,'FaceColor',orangeAnDycolor);
hold on;
bar2 = bar([1.3 2.3 3.3 4.3 5.3],...
    [meanMeanTorques(1,2) ...
    meanMeanTorques(2,2) ...
    meanMeanTorques(3,2) ...
    meanMeanTorques(4,2) ...
    meanMeanTorques(5,2)], ...
    0.30,'FaceColor',greenAnDycolor);

% Legend and title
% Note: this legend is tuned on the bar plot
% leg = legend([bar1, bar2],'effort reduction', 'effort increase');
% set(leg,'Interpreter','latex');
% set(leg,'FontSize',25);
% set(leg,  'NumColumns', 2);

title('Head and torso','FontSize',20);
ylabel(' $\bar {\bar{\tau}}$ [Nm]','HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FontSize',30,...
    'Interpreter','latex');
set(axes1, 'XLimSpec', 'Tight');
% axis tight;

% % align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
% tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'meanOfNormalizedNormOfTorques'),fig,600);
end

%% Computation (|barBarTau_NE| - |barBarTau_WE|)/|barBarTau_NE|
wholeBodyExo.values = zeros(5,3);
for blockIdx = 1 : block.nrOfBlocks
    wholeBodyExo.values(blockIdx,1) = mean(interSubj(blockIdx).torqueMeanNE);
    wholeBodyExo.values(blockIdx,2) = mean(interSubj(blockIdx).torqueMeanWE);
    wholeBodyExo.values(blockIdx,3) = (abs(wholeBodyExo.values(blockIdx,1)) - ...
        abs(wholeBodyExo.values(blockIdx,2)))/abs(wholeBodyExo.values(blockIdx,1));
end

%% ========================================================================
%%                              AREAS MEAN
%% ========================================================================
% Torso
tmp.torso_range  = [1:14];
interSubjectAnalysis_torso;
% Arms
tmp.rightArm_range = [15:22];
tmp.leftArm_range  = [23:30];
interSubjectAnalysis_arms;
% Legs
tmp.rightLeg_range = [31:38]; %no 39, rightBallFoot joint
tmp.leftLeg_range  = [40:47]; %no 48, leftBallFoot joint
interSubjectAnalysis_legs;

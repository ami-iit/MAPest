
% Copyright (C) 2021 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% Preliminaries
close all;
clc; clear all;

% Root folder of the dataset
bucket = struct;
bucket.datasetRoot = fullfile(pwd, 'dataLBP_SPEXOR');

addpath(genpath('../../external'));
addpath(genpath('analysis_scripts'));

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

tmp.subjects = [21; 23]; %[21; 23; 26; 27];
nrOfSubject = length(tmp.subjects);

for subjIdx = 1 : nrOfSubject
    intraSubj(subjIdx).subjects = tmp.subjects(subjIdx);
    subjectID = tmp.subjects(subjIdx);
    if subjectID == 21
        mass = 90; % in kg
        height = 1.80; % in m
    end
    if subjectID == 23
        mass = 64; % in kg
        height = 1.63; % in m
    end
    if subjectID == 26
        mass = 65; % in kg
        height = 1.63; % in m
    end
    if subjectID == 27
        mass = 54; % in kg
        height = 1.66; % in m
    end
    fprintf('SUBJECT_%03d\n',subjectID);
    bucket.pathToSubject = fullfile(bucket.datasetRoot, sprintf('S%03d',subjectID));
    bucket.pathToSubjectRawData = fullfile(bucket.pathToSubject,'data');
   
    % New plot label for motion tasks
    motionTasksPlotLabel     = {'squat'};
    motionTasksPlotLabel_exo = {'squat_EXO'};
    
    %% Extraction data squat
    % NE
    bucket.pathToTask                = fullfile(bucket.pathToSubjectRawData,'squat');
    bucket.pathToProcessedData       = fullfile(bucket.pathToTask,'processed');
    intraSubj(subjIdx).NE            = load(fullfile(bucket.pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
    intraSubj(subjIdx).NE_errRel     = load(fullfile(bucket.pathToSubject,'covarianceTuning.mat'));
    intraSubj(subjIdx).NE_synchrokin = load(fullfile(bucket.pathToProcessedData,'synchrokin.mat'));
    % WE
    bucket.pathToTask                = fullfile(bucket.pathToSubjectRawData,'squat_EXO');
    bucket.pathToProcessedData       = fullfile(bucket.pathToTask,'processed');
    intraSubj(subjIdx).WE            = load(fullfile(bucket.pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
    intraSubj(subjIdx).WE_errRel     = load(fullfile(bucket.pathToSubject,'covarianceTuning.mat'));
    intraSubj(subjIdx).WE_synchrokin = load(fullfile(bucket.pathToProcessedData,'synchrokin.mat'));
    
    selectedJoints           = load(fullfile(bucket.pathToProcessedData,'selectedJoints.mat'));   
end

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
    for i = 1 : length(selectedJoints.selectedJoints)
        % NE
        if ~isempty(find(isnan(intraSubj(subjIdx).NE.estimatedVariables.tau.values(i,:)) == 1))
            nanVal = find(isnan(intraSubj(subjIdx).NE.estimatedVariables.tau.values(i,:)) == 1);
            intraSubj(subjIdx).NE.estimatedVariables.tau.values(i,nanVal) = ...
                (intraSubj(subjIdx).NE.estimatedVariables.tau.values(i,nanVal-1)+ ...
                intraSubj(subjIdx).NE.estimatedVariables.tau.values(i,nanVal+1))/2;
        end
        % WE
        if ~isempty(find(isnan(intraSubj(subjIdx).WE.estimatedVariables.tau.values(i,:)) == 1))
            nanVal = find(isnan(intraSubj(subjIdx).WE.estimatedVariables.tau.values(i,:)) == 1);
            intraSubj(subjIdx).WE.estimatedVariables.tau.values(i,nanVal) = ...
                (intraSubj(subjIdx).WE.estimatedVariables.tau.values(i,nanVal-1)+ ...
                intraSubj(subjIdx).WE.estimatedVariables.tau.values(i,nanVal+1))/2;
        end
    end
end

%% ========================================================================
%%                         INTRA-SUBJECT COMPUTATIONS
%% ========================================================================
% -------- Intra-subject overall torque norm
for subjIdx = 1 : nrOfSubject
    lenNE = length(intraSubj(subjIdx).NE.estimatedVariables.tau.values);
    lenWE = length(intraSubj(subjIdx).WE.estimatedVariables.tau.values);
    for i = 1 : lenNE
        intraSubj(subjIdx).torqueNormNE.torqueNorm(1,i) = ...
            norm(intraSubj(subjIdx).NE.estimatedVariables.tau.values(:,i));
    end
    for i = 1 : lenWE
        intraSubj(subjIdx).torqueNormWE.torqueNorm(1,i) = ...
            norm(intraSubj(subjIdx).WE.estimatedVariables.tau.values(:,i));
    end
end
% Normalization
for subjIdx = 1 : nrOfSubject
    % ---- normalized norm NE
    intraSubj(subjIdx).torqueNormNE.torqueNorm_normalized = ...
        (intraSubj(subjIdx).torqueNormNE.torqueNorm - ...
        min(intraSubj(subjIdx).torqueNormNE.torqueNorm))/ ...
        (max(intraSubj(subjIdx).torqueNormNE.torqueNorm) - ...
        min(intraSubj(subjIdx).torqueNormNE.torqueNorm));
    % ---- normalized norm WE
    intraSubj(subjIdx).torqueNormWE.torqueNorm_normalized = ...
        (intraSubj(subjIdx).torqueNormWE.torqueNorm - ...
        min(intraSubj(subjIdx).torqueNormWE.torqueNorm))/ ...
        (max(intraSubj(subjIdx).torqueNormWE.torqueNorm) - ...
        min(intraSubj(subjIdx).torqueNormWE.torqueNorm));
    
end

% -------- Intra-subject overall torque MEAN
for subjIdx = 1 : nrOfSubject
    lenNE = length(intraSubj(subjIdx).NE.estimatedVariables.tau.values);
    lenWE = length(intraSubj(subjIdx).WE.estimatedVariables.tau.values);
    for i = 1 : lenNE
        intraSubj(subjIdx).torqueMeanNE.torqueMean(1,i) = ...
            mean(intraSubj(subjIdx).NE.estimatedVariables.tau.values(:,i));
    end
    for i = 1 : lenWE
        intraSubj(subjIdx).torqueMeanWE.torqueMean(1,i) = ...
            mean(intraSubj(subjIdx).WE.estimatedVariables.tau.values(:,i));
    end
end
% Normalization
for subjIdx = 1 : nrOfSubject
    % ---- normalized mean NE
    intraSubj(subjIdx).torqueMeanNE.torqueMean_normalized = ...
        (intraSubj(subjIdx).torqueMeanNE.torqueMean - ...
        min(intraSubj(subjIdx).torqueMeanNE.torqueMean))/ ...
        (max(intraSubj(subjIdx).torqueMeanNE.torqueMean) - ...
        min(intraSubj(subjIdx).torqueMeanNE.torqueMean));
    % ---- normalized mean WE
    intraSubj(subjIdx).torqueMeanWE.torqueMean_normalized = ...
        (intraSubj(subjIdx).torqueMeanWE.torqueMean - ...
        min(intraSubj(subjIdx).torqueMeanWE.torqueMean))/ ...
        (max(intraSubj(subjIdx).torqueMeanWE.torqueMean) - ...
        min(intraSubj(subjIdx).torqueMeanWE.torqueMean));
end

%% ========================================================================
%%                         WHOLE-BODY NORM
%% ========================================================================
% -------- Inter-subject overall torque norm
% Uniform the range of signals per block
tmp.interSubj.rangeNE = [];
tmp.interSubj.rangeWE = [];
for subjIdx = 1 : nrOfSubject
    tmp.interSubj.rangeNE = [tmp.interSubj.rangeNE; ...
        size(intraSubj(subjIdx).torqueNormNE.torqueNorm,2)];
    tmp.interSubj.rangeWE = [tmp.interSubj.rangeWE; ...
        size(intraSubj(subjIdx).torqueNormWE.torqueNorm,2)];
end
interSubj.lenghtOfIntersubjNormNE = min(tmp.interSubj.rangeNE);
interSubj.lenghtOfIntersubjNormWE = min(tmp.interSubj.rangeWE);

% Create vector for all the subjects divided in blocks
    tmp.interSubj.overallTorqueListNE = [];
    tmp.interSubj.overallTorqueListWE = [];
    for subjIdx = 1 : nrOfSubject
        tmp.interSubj.overallTorqueListNE  = [tmp.interSubj.overallTorqueListNE; ...
            intraSubj(subjIdx).NE.estimatedVariables.tau.values(:, 1:interSubj.lenghtOfIntersubjNormNE)];
        tmp.interSubj.overallTorqueListWE  = [tmp.interSubj.overallTorqueListWE; ...
            intraSubj(subjIdx).WE.estimatedVariables.tau.values(:, 1:interSubj.lenghtOfIntersubjNormWE)];
    end

% -------- Inter-subject overall torque norm
lenNE = interSubj.lenghtOfIntersubjNormNE;
lenWE = interSubj.lenghtOfIntersubjNormWE;
for i = 1 : lenNE
    interSubj.torqueNormNE(1,i) = norm(tmp.interSubj.overallTorqueListNE(:,i));
end
for i = 1 : lenWE
    interSubj.torqueNormWE(1,i) = norm(tmp.interSubj.overallTorqueListWE(:,i));
end

%% Plot norm
fig = figure('Name', 'Intersubject overall tau norm','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

% NE
plot1 = plot(interSubj.torqueNormNE,'color',orangeAnDycolor,'lineWidth',4);
axis tight;
ax = gca;
ax.FontSize = 20;
hold on
% WE
plot2 = plot(interSubj.torqueNormWE,'color',greenAnDycolor,'lineWidth',4);
hold on
% title(sprintf('Block %s', num2str(blockIdx)),'FontSize',22);
ylabel('$||\tau||$','HorizontalAlignment','center',...
    'FontSize',40,'interpreter','latex');
xlabel('samples','FontSize',25);

grid on;
%legend
leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
set(leg,'Interpreter','latex','FontSize',25);
% axis tight
ylim([40,400]);

tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_overallTauNorm_s'),fig,600);
end

%% Stats and boxplot norm
% stats_tauNorm_wb_anova2;

%% ========================================================================
%%                         WHOLE-BODY MEAN
%% ========================================================================
% -------- Inter-subject overall torque mean
meanMeanTorques = zeros(1,2);
% NE
interSubj.torqueMeanNE = mean(tmp.interSubj.overallTorqueListNE);
meanMeanTorques(1,1) = mean(interSubj.torqueMeanNE);
% WE
interSubj.torqueMeanWE = mean(tmp.interSubj.overallTorqueListWE);
meanMeanTorques(1,2) = mean(interSubj.torqueMeanWE);

%% Plot mean
fig = figure('Name', 'Intersubje overall tau mean','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

% NE
plot1 = plot(interSubj.torqueMeanNE,'color',orangeAnDycolor,'lineWidth',4);
axis tight;
ax = gca;
ax.FontSize = 27;
hold on
% WE
plot2 = plot(interSubj.torqueMeanWE,'color',greenAnDycolor,'lineWidth',4);
hold on
%     title(sprintf('Block %s', num2str(blockIdx)),'FontSize',23);
ylabel('$\bar\tau^{wb}$ [Nm]','HorizontalAlignment','center',...
    'FontSize',30,'interpreter','latex');
xlabel('samples','FontSize',30);
grid on;
%legend
leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
set(leg,'Interpreter','latex','FontSize',33);
% axis tight
%     ylim([-1.8, 0.7]);
ylim([-1.8, 0.8]);
yticks([-1 0])

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
% % %     ylabel('|τ¯wb| [Nm]','HorizontalAlignment','center',...
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

% NE
NE_vect = abs(interSubj.torqueMeanNE);
NE_vect_min = min(NE_vect);
NE_vect_max = max(NE_vect);
plot1 = plot((NE_vect-NE_vect_min)/(NE_vect_max-NE_vect_min),'color',orangeAnDycolor,'lineWidth',4);
axis tight;
ax = gca;
ax.FontSize = 27;
hold on
% WE
WE_vect = abs(interSubj.torqueMeanWE);
WE_vect_min = min(WE_vect);
WE_vect_max = max(WE_vect);
plot2 = plot((WE_vect-WE_vect_min)/(WE_vect_max-WE_vect_min),'color',greenAnDycolor,'lineWidth',4);
hold on
%     title(sprintf('Block %s', num2str(blockIdx)),'FontSize',23);
ylabel('$|\bar\tau^{wb}|$ [Nm]','HorizontalAlignment','center',...
    'FontSize',35,'interpreter','latex');

xlabel('samples','FontSize',30);

grid on;
%legend
leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
set(leg,'Interpreter','latex','FontSize',33);
% axis tight
%     ylim([-1.8, 0.7]);
ylim([-0.3, 2]);
yticks([0 1])
% align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intersubj_overallTauNormalizedMean'),fig,600);
end

%% Bar plot single joints
% % % fig = figure();
% % % axes1 = axes('Parent',fig, ...
% % %     'YGrid','on',...
% % %     'XTickLabel',{'Block1',...
% % %     'Block2',...
% % %     'Block3',...
% % %     'Block4',...
% % %     'Block5'},...
% % %     'XTick',[1 2 3 4 5],...
% % %     'FontSize',20);
% % % box(axes1,'off');
% % % hold(axes1,'on');
% % % grid on;
% % % 
% % % bar1 = bar([1 2 3 4 5],...
% % %     [meanMeanTorques(1,1) ...
% % %     meanMeanTorques(2,1) ...
% % %     meanMeanTorques(3,1) ...
% % %     meanMeanTorques(4,1) ...
% % %     meanMeanTorques(5,1)], ...
% % %     0.30,'FaceColor',orangeAnDycolor);
% % % hold on;
% % % bar2 = bar([1.3 2.3 3.3 4.3 5.3],...
% % %     [meanMeanTorques(1,2) ...
% % %     meanMeanTorques(2,2) ...
% % %     meanMeanTorques(3,2) ...
% % %     meanMeanTorques(4,2) ...
% % %     meanMeanTorques(5,2)], ...
% % %     0.30,'FaceColor',greenAnDycolor);
% % % 
% % % % Legend and title
% % % % Note: this legend is tuned on the bar plot
% % % % leg = legend([bar1, bar2],'effort reduction', 'effort increase');
% % % % set(leg,'Interpreter','latex');
% % % % set(leg,'FontSize',25);
% % % % set(leg,  'NumColumns', 2);
% % % 
% % % title('Head and torso','FontSize',20);
% % % ylabel(' $\bar {\bar{\tau}}$ [Nm]','HorizontalAlignment','center',...
% % %     'FontWeight','bold',...
% % %     'FontSize',30,...
% % %     'Interpreter','latex');
% % % set(axes1, 'XLimSpec', 'Tight');
% % % % axis tight;
% % % 
% % % % % align_Ylabels(gcf)
% % % % subplotsqueeze(gcf, 1.12);
% % % % tightfig();
% % % % save
% % % if saveON
% % %     save2pdf(fullfile(bucket.pathToPlots,'meanOfNormalizedNormOfTorques'),fig,600);
% % % end

%% Computation (|barBarTau_NE| - |barBarTau_WE|)/|barBarTau_NE|
wholeBodyExo.values = zeros(1,3);
wholeBodyExo.values(1,1) = mean(interSubj.torqueMeanNE);
wholeBodyExo.values(1,2) = mean(interSubj.torqueMeanWE);
wholeBodyExo.values(1,3) = (abs(wholeBodyExo.values(1,1)) - ...
    abs(wholeBodyExo.values(1,2)))/abs(wholeBodyExo.values(1,1));

%% ========================================================================
%%                              AREAS MEAN
%% ========================================================================
% Torso
tmp.torso_range  = [1:14];
interSubjectAnalysis_LBP_torso;
% Arms
tmp.rightArm_range = [15:22];
tmp.leftArm_range  = [23:30];
interSubjectAnalysis_LBP_arms;
% Legs
tmp.rightLeg_range = [31:38]; %no 39, rightBallFoot joint
tmp.leftLeg_range  = [40:47]; %no 48, leftBallFoot joint
interSubjectAnalysis_LBP_legs;

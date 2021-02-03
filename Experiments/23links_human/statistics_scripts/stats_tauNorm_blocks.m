% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% Preliminaries
close all;
clc;
% Root folder of the dataset
bucket = struct;
bucket.datasetRoot = fullfile(pwd, 'dataJSI');

addpath(genpath('../../external'));
addpath(genpath('statistics_scripts'));

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
selectedJoints = load(fullfile(pathToProcessedData,'selectedJoints.mat'));

% Check if NaN in loaded raw data
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
% Intra-subject whole-body torque norm
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

%% Statistics
% ANOVA2 computation
% Computation two-way analysis of variance (ANOVA) with balanced designs.
% - columns --> conditions (NE or WE), nrOfGroups = 2
% - rows    --> block (per subject) --> block.nrOfBlocks*nrOfSubject
stats_vect = [];
tmp.tmp_vect = [];
for blockIdx = 1 : block.nrOfBlocks
    for subjIdx = 1 : nrOfSubject
        % NE
        tmp.tmp_vect(subjIdx,1) = ...
            mean(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm_normalized);
        % WE
        tmp.tmp_vect(subjIdx,2) = ...
            mean(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm_normalized);
    end
    stats_vect = [stats_vect; tmp.tmp_vect];
end
repetitions = block.nrOfBlocks;
[~,~,stats_anova2] = anova2(stats_vect,repetitions);
c = multcompare(stats_anova2);

%% ----- Box plot
% ============================= single block ==============================
fig = figure('Name', 'anova2 - mean of the tau norm','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
for blockIdx = 1 : block.nrOfBlocks
    sub1 = subplot(1,block.nrOfBlocks+1,blockIdx);
    tmp.range = nrOfSubject*(blockIdx-1)+1 : nrOfSubject*blockIdx;
    box1 = boxplot(stats_vect(tmp.range,:));
    set(box1, 'Linewidth', 2.5);
    h = findobj(gca,'Tag','Box');
    % Group 1
    patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
    % Group 2
    patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);

    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',20);
    if blockIdx == 1
        ylabel('Normalized $|\tau^{wb}|$ mean', 'HorizontalAlignment','center',...
            'FontSize',25,'interpreter','latex');
    else
        set(gca,'YTickLabel',[]);
    end
    %     xlabel('Conditions','HorizontalAlignment','center',...
    %             'FontSize',25,'interpreter','latex');
    set(sub1,'TickLabelInterpreter','none','XTick',[1 2],...
        'XTickLabel',{'WE','NE'});
    ax=gca;
    ax.XAxis.FontSize = 20;
    ylim([0 1]);
    grid on;
end

% =============================== anova2 ==================================
% Box plot of the observations for each group in y. Box plots provide a
% visual comparison of the group location parameters.  On each box, the
% central mark is the median (2nd quantile, q2) and the edges of the box
% are the 25th and 75th percentiles (1st and 3rd quantiles, q1 and q3,
% respectively). The whiskers extend to the most extreme data points that
% are not considered outliers. The outliers are plotted individually using
% the '+' symbol. The extremes of the whiskers correspond to
%           q3 + 1.5 × (q3 – q1) and q1 – 1.5 × (q3 – q1).
% Box plots include notches for the comparison of the median values.
% Two medians are significantly different at the 5% significance level if
% their intervals, represented by notches, do not overlap. This test is
% different from the F-test that ANOVA performs; however, large differences
% in the center lines of the boxes correspond to a large F-statistic value
% and correspondingly a small p-value. The extremes of the notches correspond
% to q2 – 1.57(q3 – q1)/sqrt(n) and q2 + 1.57(q3 – q1)/sqrt(n), where n is
% the number of observations without any NaN values.
sub2 = subplot(1,6,6);
box1 = boxplot(stats_vect);
set(box1, 'Linewidth', 2.5);
h = findobj(gca,'Tag','Box');
% Group 1
patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
% Group 2
patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);

% ----- Statistical significance among pair of groups
% Add stars and lines highlighting significant differences between pairs of groups.
% Stars are drawn according to:
%   * represents p<=0.05
%  ** represents p<=1E-2
% *** represents p<=1E-3
H = sigstar({[1,2]},[c(1,6)]);
title('Total','FontSize',20);
% % %     ylabel('Normalized $\tau_{NORM}$ mean', 'HorizontalAlignment','center',...
% % %         'FontSize',25,'interpreter','latex');
% % % % xlabel('Factor: subjects ','HorizontalAlignment','center',...
% % % %     'FontSize',25,'interpreter','latex');

set(sub2,'TickLabelInterpreter','none','XTick',[1 2],...
    'XTickLabel',{'WE','NE'});
ax=gca;
ax.XAxis.FontSize = 20;
ylim([0 1]);
grid on;

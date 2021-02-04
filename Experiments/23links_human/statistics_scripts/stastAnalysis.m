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

%% Statistics
disp('-------------------------------------------------------------------');
disp('[Start] All-joint torques statistics..');
% Computation of all joints norm
stats_tauNorm_blocks_allJoints;
disp('[End] All-joint torques statistics.');
disp('-------------------------------------------------------------------');
disp('-------------------------------------------------------------------');
disp('-------------------------------------------------------------------');
disp('[Start] Joint-area torques statistics..');
% Computation of all joints norm
stats_tauNorm_blocks_areas;
disp('[End] Joint-area torques statistics.');


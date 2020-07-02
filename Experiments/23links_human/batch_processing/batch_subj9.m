
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

tic;
clc; close all; clear all;

rng(1); % Force the casual generator to be const
format long;

%% Add src to the path
addpath(genpath('src'));
addpath(genpath('../../src'));
addpath(genpath('../../external'));
addpath(genpath('scripts'));
addpath(genpath('batch_processing'));

subjectID = 9;
task = [0,1];
% Legend: O WE, 1 NE

for taskIdx = 1 : length(task)
    taskID = task(taskIdx);
    
    % WE
    if taskID == 0
        if ~exist(fullfile(pwd,sprintf(('/dataJSI/S%02d/Task%d/processed/processed_SOTtask2/y_sim_ddq.mat'),subjectID,taskID)), 'file')
            opts.EXO = true;
            if opts.EXO
                opts.EXO_torqueLevelAnalysis = false;
                opts.EXO_forceLevelAnalysis  = false;
                opts.EXO_insideMAP           = true;
            end
            configureAndRunMAPest;
        end
    end
    
    % NE
    if taskID == 1
        if ~exist(fullfile(pwd,sprintf(('/dataJSI/S%02d/Task%d/processed/processed_SOTtask2/y_sim_ddq.mat'),subjectID,taskID)), 'file')
            clearvars -except subjectID taskID
            opts.EXO = false;
            configureAndRunMAPest;
        end
    end
end

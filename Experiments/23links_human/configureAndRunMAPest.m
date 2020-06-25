
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.


clc; close all; clear all;

rng(1); % Force the casual generator to be const
format long;

%% Add src to the path
addpath(genpath('src'));
addpath(genpath('../../src'));
addpath(genpath('../../external'));
addpath(genpath('scripts'));

%% Set Java path needed by OSIM - SCREWS MATLAB CURRENT CONFIGURATION
%       UNCONMMENT ONLY IF YOU KNOW WHAT YOU ARE DOING
%  Routine left here just for Legacy, not to be used since it erases the
%  current path. 

setupJAVAPath();

%% Preliminaries
% Create a structure 'bucket' where storing different stuff generating by
% running the code
bucket = struct;

%% Configure
% Root folder of the dataset
bucket.datasetRoot = fullfile(pwd, 'dataJSI');

% Subject and task to be processed
subjectID = 1;
taskID = 0;

% EXO option
opts.EXO = true;
if opts.EXO
    opts.EXO_torqueLevelAnalysis = false;
    opts.EXO_forceLevelAnalysis  = false;
    opts.EXO_insideMAP           = true;
end

% Option for C7 joints as follows:
% - fixed in the URDF model  (i.e., opts.noC7joints = true)
% - locked on the Osim model (i.e., opts.noC7joints = true)
opts.noC7joints = false;

% ID comparisons for MAP benchmarking
opts.MAPbenchmarking = false;
if opts.MAPbenchmarking
    opts.iDynID_kinDynClass = false;
    opts.iDynID_estimClass  = false;
%     opts.OsimID             = false;
end

%% Plots
opts.plots = false;
opts.finalPlot_standalone = false;

if opts.plots
    addpath(genpath('plots_scripts'));
    % ----------------------------------
    % Plots for the standalone analysis. No comparison for the same subject
    % with and without exo
    if opts.finalPlot_standalone
        finalPlot_standalone;
    end
    % ----------------------------------
    % Force-level analysis plots
    if opts.EXO_forceLevelAnalysis
        EXOvsNOEXO_plots_forcelevel;
    end
    % ----------------------------------
    % EXO inside MAP analysis plots
    if opts.EXO_insideMAP
        EXOvsNOEXO_plots_insideMAP;
    end
end

%% Tuning covariance
disp(' ');
disp('======================= COVARIANCE TUNING ==========================');
opts.tuneCovarianceTest = true;

covTun.rangePowerForPolarizedTuning = [1, 2, 3, 4];
for powerIdx = 1 : length(covTun.rangePowerForPolarizedTuning)
    fprintf('[Start] Covariance tuning SUBJECT_%02d, TRIAL_%02d. Test with power %01d\n',subjectID,taskID, powerIdx);
    covarianceSelectedValue = covTun.rangePowerForPolarizedTuning(powerIdx);
    config;
    % Save
    if opts.tuneCovarianceTest
        bucket.pathToCovarianceTuningData   = fullfile(bucket.pathToTask,'covarianceTuning');
        if ~exist(bucket.pathToCovarianceTuningData)
            mkdir(bucket.pathToCovarianceTuningData)
        end
        % Move folders
        path_destination  = bucket.pathToCovarianceTuningData;
        path_source_task1 = bucket.pathToProcessedData_SOTtask1;
        movefile(path_source_task1,path_destination);
        path_source_task2 = bucket.pathToProcessedData_SOTtask2;
        movefile(path_source_task2,path_destination);
        % Rename folders by adding the power
        oldFolder_SOTtask1 = fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask1');
        newFolder_SOTtask1 = fullfile(bucket.pathToCovarianceTuningData,sprintf('processed_SOTtask1_power%d', priors.absPowerValue));
        mkdir(oldFolder_SOTtask1);
        movefile(oldFolder_SOTtask1,newFolder_SOTtask1);
        oldFolder_SOTtask2 = fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2');
        newFolder_SOTtask2 = fullfile(bucket.pathToCovarianceTuningData,sprintf('processed_SOTtask2_power%d', priors.absPowerValue));
        mkdir(oldFolder_SOTtask2);
        movefile(oldFolder_SOTtask2,newFolder_SOTtask2);
    end
end
% Define chosen covarianceChosenSelectedValue
tuningCovariance_measVSestim;
covarianceSelectedValue = covarianceTuning.chosenSelectedValue;

% Remove file/folders related to the covariance tuning analysis
clearvars covTun;
rmdir(bucket.pathToCovarianceTuningData);

opts.tuneCovarianceTest = false;
fprintf('[End] Covariance tuning SUBJECT_%02d, TRIAL_%02d\n',subjectID,taskID);

%% Launch the analysis script
clearvars -except bucket opts subjectID taskID covarianceSelectedValue powerIdx;

disp(' ');
disp('===================== FLOATING-BASE ANALYSIS ========================');
fprintf('[Start] Analysis SUBJECT_%02d, TRIAL_%02d\n',subjectID,taskID);
fprintf('[Info] Trusted covariance Sigma_trusted = 1e-%01d\n',covarianceSelectedValue);
fprintf('[Info] Trusted covariance Sigma_notrusted = 1e%01d\n',covarianceSelectedValue);
config;
fprintf('[End] Analysis SUBJECT_%02d, TRIAL_%02d\n',subjectID,taskID);
disp('===================================================================');


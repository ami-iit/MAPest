
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%--------------------------------------------------------------------------
% LBP_SPEXOR_experiments subject batch
%--------------------------------------------------------------------------

% tic;
clc; close all; clear all;

rng(1); % Force the casual generator to be const
format long;

% Add folders to the path
addpath(genpath('src'));
addpath(genpath('../../src'));
addpath(genpath('../../external'));
addpath(genpath('scripts'));
addpath(genpath('batch_processing'));

% Set Java path needed by OSIM - SCREWS MATLAB CURRENT CONFIGURATION
setupJAVAPath();

% Subject info
subjectInfo_bio; 
% script generating
% - a column vector for the mass of the subjects
% - a column vector for the height of the subjects
% - a column vector for the weight of the external load
subjectID = 26;
mass = subjectInfo_weight(3); % in kg
height = subjectInfo_height(3); % in m
loadWeight = subjectInfo_load(3); % in kg

% Create a structure 'bucket' where storing different stuff generating by
% running the code
bucket = struct;

% Root folder of the dataset
bucket.datasetRoot = fullfile(pwd, 'dataLBP_SPEXOR');
bucket.pathToSubject = fullfile(bucket.datasetRoot, sprintf('S%03d',subjectID));
bucket.pathToSubjectRawData = fullfile(bucket.pathToSubject,'data');

%% Options
% Option for C7 joints as follows:
% - fixed in the URDF model  (i.e., opts.noC7joints = true)
% - locked on the Osim model (i.e., opts.noC7joints = true)
opts.noC7joints = false;
% Option for computing the estimated Sigma
opts.Sigma_dgiveny = false;

% Define the template to be used
if opts.noC7joints
    addpath(genpath('templatesNoC7'));
    rmpath('templates'); %if exists
    disp('[Warning]: The following analysis will be done with C7joints locked/fixed in the models!');
else
    addpath(genpath('templates'));
    rmpath('templatesNoC7'); %if exists
end

%% Launch MAPest
configureAndRunMAPest;
% toc;

% % NE
% if ~exist(fullfile(pwd,sprintf(('/dataJSI/S%02d/Task%d/processed/processed_SOTtask2/y_sim_ddq.mat'),subjectID,taskID)), 'file')
%     opts.EXO = false;
%     configureAndRunMAPest;
% end
% 
% % WE
% if ~exist(fullfile(pwd,sprintf(('/dataJSI/S%02d/Task%d/processed/processed_SOTtask2/y_sim_ddq.mat'),subjectID,taskID)), 'file')
%     clearvars -except subjectID taskID
%     opts.EXO = true;
%     if opts.EXO
%         opts.EXO_torqueLevelAnalysis = false;
%         opts.EXO_forceLevelAnalysis  = false;
%         opts.EXO_insideMAP           = true;
%     end
%     configureAndRunMAPest;
% end

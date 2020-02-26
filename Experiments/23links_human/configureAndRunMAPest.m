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
taskID = 1;

disp(' ');
disp('===================== FLOATING-BASE ANALYSIS ========================');
fprintf('[Start] Analysis SUBJECT_%02d, TRIAL_%02d\n',subjectID,taskID);

% EXO option
opts.EXO = true;
if opts.EXO
    opts.EXO_torqueLevelAnalysis = false;
    opts.EXO_forceLevelAnalysis  = false;
    opts.EXO_insideMAP           = false;
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

%% Covariances setting
priors = struct;
priors.acc_IMU     = 1e-3 * ones(3,1);                      %[m^2/s^2]   , from datasheet
% priors.gyro_IMU    = xxxxxx * ones(3,1);                  %[rad^2/s^2] , from datasheet
priors.angAcc      = 1e-3 * ones(3,1); %test
priors.ddq         = 6.66e-6;                               %[rad^2/s^4] , from worst case covariance
priors.foot_fext   = 1e-6 * [59; 59; 36; 2.25; 2.25; 0.56]; %[N^2,(Nm)^2]
priors.noSens_fext = 1e-6 * ones(6,1);

bucket.Sigmad = 1e6;
% low reliability on the estimation (i.e., no prior info on the model regularization term d)
bucket.SigmaD = 1e-4;
% high reliability on the model constraints

if opts.EXO
    if opts.EXO_insideMAP
        priors.exo_fext   = 1e0 * ones(6,1); %[N^2,(Nm)^2]
    end
end
% covariances for SOT in Task1
priors.fext_hands = 1e3 * ones(6,1);
priors.properDotL = 1e-4 * ones(6,1);

%% Run MAPest stack of tasks (SOT)
% =========================================================================
%  RUN TASK1
disp('=====================================================================');
disp('=====================================================================');
disp('[Start] Run SOT Task1..');
opts.task1_SOT = true;
opts.stackOfTaskMAP = true; % argument value for berdy functions for Task1
main;
disp('[End] Run SOT Task1');

% =========================================================================
%  RUN TASK2
disp('=====================================================================');
disp('=====================================================================');
disp('[Start] Run SOT Task2..');
opts.task1_SOT = false;
opts.stackOfTaskMAP = false; % argument value for berdy functions for Task2
main;
disp('[End] Run SOT Task2');

fprintf('[End] Analysis SUBJECT_%02d, TRIAL_%02d\n',subjectID,taskID);

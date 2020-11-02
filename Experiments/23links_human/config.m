
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%--------------------------------------------------------------------------
% LBP_SPEXOR_experiments config
%--------------------------------------------------------------------------

%% Covariances setting
% Settings
priors = struct;
priors.absPowerValue = 3; %covarianceSelectedValue; --- >TBC
priors.trusted     = str2double(strcat('1e-',num2str(priors.absPowerValue))); %magnitude for trusted values
priors.no_trusted  = str2double(strcat('1e' ,num2str(priors.absPowerValue))); %magnitude for non trusted values

priors.acc_IMU     = priors.trusted * ones(3,1); %[m^2/s^2]
% priors.gyro_IMU    = xxxxxx * ones(3,1); %[rad^2/s^2]
priors.angAcc      = priors.trusted * ones(3,1);
priors.ddq         = priors.trusted; %[rad^2/s^4]
priors.foot_fext   = priors.trusted * ones(6,1); %[N^2,(Nm)^2]
priors.noSens_fext = priors.trusted * ones(6,1); %[N^2,(Nm)^2]

bucket.Sigmad = priors.no_trusted; % low reliability on the estimation (i.e., no prior info on the model regularization term d)
bucket.SigmaD = priors.trusted;    % high reliability on the model constraints

if opts.EXO
    if opts.EXO_insideMAP
         priors.exo_fext   = priors.trusted * ones(6,1); %[N^2,(Nm)^2]
    end
end
% covariances for SOT in Task1
priors.fext_hands = priors.no_trusted * ones(6,1); %[N^2,(Nm)^2]
priors.b_dh       = priors.trusted * ones(6,1);

%% Run MAPest stack of tasks (SOT)
% =========================================================================
%  RUN TASK1
disp('=====================================================================');
disp('=====================================================================');
disp('[Start] Run SOT Task1...');
opts.task1_SOT = true;
opts.stackOfTaskMAP = true; % argument value for berdy functions for Task1
main;
disp('[End] Run SOT Task1.');

% =========================================================================
%  RUN TASK2
disp('=====================================================================');
disp('=====================================================================');
disp('[Start] Run SOT Task2...');
opts.task1_SOT = false;
opts.stackOfTaskMAP = false; % argument value for berdy functions for Task2
main;
disp('[End] Run SOT Task2.');

%% Post computation analysis and plots
% disp('-------------------------------------------------------------------');
% disp('[Start] Compute RMSE in measured Vs. estimated variables...');
% computeRMSE;
% disp('[End] Compute RMSE in measured Vs. estimated variables.');
% %
% disp('-------------------------------------------------------------------');
% disp('[Start] Compute error norm for measured Vs. estimated variables...');
% computeNorm;
% disp('[End] Compute error norm for measured Vs. estimated variables.');
% disp('-------------------------------------------------------------------');
%
%SOT_plots;

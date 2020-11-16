
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%--------------------------------------------------------------------------
% LBP_SPEXOR_experiments configureAndRunMAPest
%--------------------------------------------------------------------------

%% Tasks
% List of tasks
listOfTasks = {'free'; 'FREE_EXO'; ...
    'FreeDeep'; 'freeDeep_EXO'; ...
    'freeROT'; 'FreeROT_EXO'; ...
    'ROM'; ...
    'Squat'; 'Squat_EXO'; ...
    'SquatROT'; 'SquatROT_EXO'; ...
    'Stoop'; 'Stoop_EXO'; ...
    'StoopROT'; 'StoopROT_EXO'; ...
    };

for tasksIdx = 1 %: length(listOfTasks) --- >TBC
    bucket.pathToTask   = fullfile(bucket.pathToSubjectRawData,listOfTasks{tasksIdx});
    bucket.pathToProcessedData   = fullfile(bucket.pathToTask,'processed');
    if contains(listOfTasks{tasksIdx}, 'EXO')
        opts.EXO = true;
        opts.EXO_insideMAP = true;
    else
        opts.EXO = false;
        opts.EXO_insideMAP = false;
    end

    % Tuning covariance only in the free task
    if tasksIdx == 1
        opts.tuneCovarianceTest = true;
        if ~exist(fullfile(bucket.pathToSubject, '/covarianceTuning'))
            disp(' ');
            disp('======================= COVARIANCE TUNING ==========================');
            covTun.rangePowerForPolarizedTuning = [1, 2, 3, 4];
            for powerIdx = 1 : length(covTun.rangePowerForPolarizedTuning)
                disp('=====================================================================');
                fprintf('[Start] Covariance tuning SUBJECT_%03d, %s\n Test with power %01d\n',subjectID,listOfTasks{tasksIdx}, powerIdx);
                covarianceSelectedValue = covTun.rangePowerForPolarizedTuning(powerIdx);
                config;
                % Save
                if opts.tuneCovarianceTest
                    bucket.pathToCovarianceTuningData   = fullfile(bucket.pathToSubject,'covarianceTuning');
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
            % rmdir(bucket.pathToCovarianceTuningData);
        else
            load(fullfile(bucket.pathToSubject, '/covarianceTuning.mat'))
            covarianceSelectedValue = covarianceTuning.chosenSelectedValue;
            opts.tuneCovarianceTest = false;
        end
    else
        load(fullfile(bucket.pathToSubject, '/covarianceTuning.mat'))
        covarianceSelectedValue = covarianceTuning.chosenSelectedValue;
        opts.tuneCovarianceTest = false;
    end

    %% Run config file
    disp(' ');
    disp('===================== FLOATING-BASE ANALYSIS ========================');
    fprintf('[Start] Analysis SUBJECT_%03d, %s\n',subjectID,listOfTasks{tasksIdx});
    fprintf('[Info] Trusted covariance Sigma_trusted = 1e-%01d\n',covarianceSelectedValue);
    fprintf('[Info] Trusted covariance Sigma_notrusted = 1e%01d\n',covarianceSelectedValue);
    config;
    fprintf('[End] Analysis SUBJECT_%03d, %s\n',subjectID,listOfTasks{tasksIdx});
    disp('===================================================================');
end

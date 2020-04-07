
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

% delete .mat file in processed_fixed (i.e., fixed folder)
delete(fullfile(bucket.pathToTask,'processed_fixed/estimation.mat'));
delete(fullfile(bucket.pathToTask,'processed_fixed/estimatedVariables.mat'));
delete(fullfile(bucket.pathToTask,'processed_fixed/y_sim.mat'));
delete(fullfile(bucket.pathToTask,'processed_fixed/y_sim_fext.mat'));
delete(fullfile(bucket.pathToTask,'processed_fixed/fixedBaseRange.mat'));

% delete .mat file in processed (i.e., floating folder)
delete(fullfile(bucket.pathToProcessedData,'estimation.mat'));
delete(fullfile(bucket.pathToProcessedData,'estimatedVariables.mat'));
delete(fullfile(bucket.pathToProcessedData,'y_sim.mat'));
delete(fullfile(bucket.pathToProcessedData,'y_sim_fext.mat'));
delete(fullfile(bucket.pathToProcessedData,'RMSE_measVSestim.mat'));
delete(fullfile(bucket.pathToProcessedData,'errorVal_measVSestim.mat'));
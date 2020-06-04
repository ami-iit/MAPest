
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%                     MEASUREMENTS vs. ESTIMATIONS
%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%% Linear acceleration
% RMSE
nrOfLinAccelerometer = length(y_sim_linAcc(1).order);
for blockIdx = blockID
    for linAccIdx = 1  : nrOfLinAccelerometer
        RMSE(blockIdx).linAcc(linAccIdx).label = y_sim_linAcc(1).order(linAccIdx);
        RMSE(blockIdx).linAcc(linAccIdx).meas  = zeros(3,1);
        for i = 1 : 3
            vect_meas  = data(blockIdx).data(linAccIdx).meas(i,:);
            vect_estim = y_sim_linAcc(blockIdx).meas{linAccIdx,1}(i,:);
            RMSE(blockIdx).linAcc(linAccIdx).meas(i) = sqrt(mean((vect_meas - vect_estim).^2));
        end
    end
end

%%  Angular acceleration acceleration
% TODO

%% External force
% Define range in data (only for block 1) for forces
tmp.fextIndex = [];
for fextInDataIdx = 1 : length(data(1).data)
    if data(1).data(fextInDataIdx).type == 1002
        tmp.fextIndex = [tmp.fextIndex; fextInDataIdx];
        continue;
    end
end
% RMSE
for blockIdx = blockID
    for vectOrderIdx = 1 : length(dVectorOrder)
        RMSE(blockIdx).fext(vectOrderIdx).label = dVectorOrder(vectOrderIdx);
        RMSE(blockIdx).fext(vectOrderIdx).meas  = zeros(3,1);
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            for i = 1 : 3
                vect_meas  = data(blockIdx).data(dataFextIdx).meas(i,:);
                vect_estim = y_sim_fext(blockIdx).meas{vectOrderIdx,1}(1,:);
                RMSE(blockIdx).fext(vectOrderIdx).meas(i) = sqrt(mean((vect_meas - vect_estim).^2));
            end
        end
    end
end

%% External moment
% RMSE
for blockIdx = blockID
    for vectOrderIdx = 1 : length(dVectorOrder)
        RMSE(blockIdx).mext(vectOrderIdx).label = dVectorOrder(vectOrderIdx);
        RMSE(blockIdx).mext(vectOrderIdx).meas  = zeros(3,1);
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            for i = 1 : 3
                vect_meas  = data(blockIdx).data(dataFextIdx).meas(i+3,:);
                vect_estim = y_sim_fext(blockIdx).meas{vectOrderIdx,1}(i+3,:);
                RMSE(blockIdx).mext(vectOrderIdx).meas(i) = sqrt(mean((vect_meas - vect_estim).^2));
            end
        end
    end
end

%% Save RMSE
save(fullfile(bucket.pathToProcessedData_SOTtask2,'RMSE.mat'),'RMSE');


%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%                     MEASUREMENTS vs. ESTIMATIONS
%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%% Linear acceleration
% RMSE
nrOfLinAccelerometer = length(y_sim_linAcc(1).order);
for blockIdx = 1 : block.nrOfBlocks
    for linAccIdx = 1  : nrOfLinAccelerometer
        RMSE(blockIdx).linAcc(linAccIdx).label = y_sim_linAcc(1).order(linAccIdx);
        RMSE(blockIdx).linAcc(linAccIdx).meas  = zeros(3,1);
        for i = 1 : 3
            RMSE(blockIdx).linAcc(linAccIdx).meas(i) = sqrt(mean(data(blockIdx).data(linAccIdx).meas(i,:) - ...
                y_sim_linAcc(blockIdx).meas{linAccIdx,1}(i,:)).^2);
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
for blockIdx = 1 : block.nrOfBlocks
    for vectOrderIdx = 1 : length(dVectorOrder)
        RMSE(blockIdx).fext(vectOrderIdx).label = dVectorOrder(vectOrderIdx);
        RMSE(blockIdx).fext(vectOrderIdx).meas  = zeros(3,1);
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            for i = 1 : 3
                RMSE(blockIdx).fext(vectOrderIdx).meas(i) = sqrt(mean(data(blockIdx).data(dataFextIdx).meas(i,:) - ...
                    y_sim_fext(blockIdx).meas{vectOrderIdx,1}(1,:)).^2);
            end
        end
    end
end

%% External moment
% RMSE
for blockIdx = 1 : block.nrOfBlocks
    for vectOrderIdx = 1 : length(dVectorOrder)
        RMSE(blockIdx).mext(vectOrderIdx).label = dVectorOrder(vectOrderIdx);
        RMSE(blockIdx).mext(vectOrderIdx).meas  = zeros(3,1);
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            for i = 1 : 3
                RMSE(blockIdx).mext(vectOrderIdx).meas(i) = sqrt(mean(data(blockIdx).data(dataFextIdx).meas(i+3,:) - ...
                    y_sim_fext(blockIdx).meas{vectOrderIdx,1}(i+3,:)).^2);
            end
        end
    end
end

%% Save RMSE
save(fullfile(bucket.pathToProcessedData_SOTtask2,'RMSE.mat'),'RMSE');


%--------------------------------------------------------------------------
% Xsens frequency  --> 60  Hz, acquired with MVNX2018
% shoes frequency  --> 100 Hz
% FP    frequency  --> 1K  Hz
% EMG   frequency  --> 100 Hz (to be verified)
% exoskeleton      --> passive
%--------------------------------------------------------------------------
% 5 repetitions of the same task (i.e.,5 blocks).
% Data in the masterFile.mat are saved in 5 separate blocks while the 
% suit.mat (extracted from MVNX) does not have this division.

tmp.block_labels = {'block1'; ...
                    'block2'; ...
                    'block3'; ...
                    'block4'; ...
                    'block5'};
tmp.nrOfBlocks = size(tmp.block_labels,1);

for i = 1 : length(masterFile.Subject.Xsens(1).Timestamp)
    tmp.block1 = masterFile.Subject.Xsens(1).Timestamp - masterFile.Subject.Xsens(1).Timestamp(end);
    if tmp.block1(i)<=0
        tmp.block1Init = i;
        break
    end
end
for i = 1 : length(masterFile.Subject.Xsens) %5 blocks
    if i == 1
        tmp.XsensBlockRange(i).first = masterFile.Subject.Xsens(i).Timestamp(tmp.block1Init);
    else
        tmp.XsensBlockRange(i).first = masterFile.Subject.Xsens(i).Timestamp(1);
    end
    tmp.XsensBlockRange(i).last = masterFile.Subject.Xsens(i).Timestamp(end);
end

for i = 1 : size(suit.sensors{1, 1}.meas.sensorOrientation,2) % sens1 since it is equal for all the sensors
    for j = 1 : tmp.nrOfBlocks
        if suit.time.xSens(i) == tmp.XsensBlockRange(1,j).first
            tmp.blockRange(j).first = i;
        end
        if suit.time.xSens(i) == tmp.XsensBlockRange(1,j).last
            tmp.blockRange(j).last = i;
        end
    end
end

%% Timestamps struct
for blockIdx = 1 : (tmp.nrOfBlocks)
    % ---Labels
    timestampTable(blockIdx).block  = tmp.block_labels(blockIdx);

    % ---Xsens Timestamp Range
    if blockIdx == 1 %exception
        for i = 1: size(masterFile.Subject.Xsens(blockIdx).Timestamp,1)
            if masterFile.Subject.Xsens(blockIdx).Timestamp(i) == tmp.XsensBlockRange(1).first
                tmp.exception_first = i;
            end
            if masterFile.Subject.Xsens(blockIdx).Timestamp(i) == tmp.XsensBlockRange(1).last
                tmp.exception_last = i;
            end
        end
        tmp.cutRange = (tmp.exception_first : tmp.exception_last);
        timestampTable(blockIdx).masterfileTimestamps = masterFile.Subject.Xsens(blockIdx).Timestamp(tmp.cutRange,:); %exception
        timestampTable(blockIdx).masterfileTimeRT = masterFile.Subject.Xsens(blockIdx).TimeRT(tmp.cutRange,:); %exception
    else
        timestampTable(blockIdx).masterfileTimestamps  = masterFile.Subject.Xsens(blockIdx).Timestamp;
        timestampTable(blockIdx).masterfileTimeRT  = masterFile.Subject.Xsens(blockIdx).TimeRT;
    end

    % ---Cut MVNX in 5 blocks according to previous ranges
    timestampTable(blockIdx).XsensTimestampRange = [tmp.XsensBlockRange(blockIdx).first, tmp.XsensBlockRange(blockIdx).last];
    timestampTable(blockIdx).XsensCutRange = [tmp.blockRange(blockIdx).first, tmp.blockRange(blockIdx).last];
    tmp.cutRange = (tmp.blockRange(blockIdx).first : tmp.blockRange(blockIdx).last);
    timestampTable(blockIdx).timeMVNX = suit.time.xSens(:,tmp.cutRange);
    %timestampTable(blockIdx).timeMVNX_ms = suit.time.ms(:,tmp.cutRange);

    % ---Create a new sampling vector
    % NOTE: this vector will be used as sampling vector for the FP and
    % ftShoes data contained in the masterfile!
    tmp.RTblock_samples = size(timestampTable(blockIdx).timeMVNX,2);
    tmp.step = (timestampTable(blockIdx).masterfileTimeRT(end) - timestampTable(blockIdx).masterfileTimeRT(1))/(tmp.RTblock_samples -1);
    timestampTable(blockIdx).masterfileNewTimeRT = timestampTable(blockIdx).masterfileTimeRT(1) : tmp.step : timestampTable(blockIdx).masterfileTimeRT(end);
end

%% Subdivide suit.mat meas in 5 blocks accordingly to the above division
for sensIdx = 1: size(suit.sensors,1)
    suit_runtime.sensors{sensIdx, 1}.label        = suit.sensors{sensIdx, 1}.label;
    suit_runtime.sensors{sensIdx, 1}.attachedLink = suit.sensors{sensIdx, 1}.attachedLink;
    suit_runtime.sensors{sensIdx, 1}.position     = suit.sensors{sensIdx, 1}.position;

    for blockIdx = 1 : (tmp.nrOfBlocks)
        % ---Labels
        suit_runtime.sensors{sensIdx, 1}.meas(blockIdx).block  = tmp.block_labels(blockIdx);
        % ---Cut (useful) meas
        tmp.cutRange = (tmp.blockRange(blockIdx).first : tmp.blockRange(blockIdx).last);
        suit_runtime.sensors{sensIdx, 1}.meas(blockIdx).sensorOrientation = suit.sensors{sensIdx, 1}.meas.sensorOrientation(:,tmp.cutRange);
        suit_runtime.sensors{sensIdx, 1}.meas(blockIdx).sensorFreeAcceleration = suit.sensors{sensIdx, 1}.meas.sensorFreeAcceleration(:,tmp.cutRange);
        % NOTE: MVNX data do not need interpolation!
    end
end

%% Create the synchroData struct
% Struct where every external is synchronized:
% - masterTime
% - ftshoes
%
for blockIdx = 1 : (tmp.nrOfBlocks)
    synchroData(blockIdx).block = tmp.block_labels(blockIdx);
    synchroData(blockIdx).masterTime = timestampTable(blockIdx).masterfileNewTimeRT;
end

%% ftShoes Interpolation
% Cutting (when needed) signals
for blockIdx = 1 : (tmp.nrOfBlocks)
     tmp.length = size(masterFile.Subject.FS(blockIdx).Measurement,1);
     for j = 1 : tmp.length
          if (timestampTable(blockIdx).masterfileNewTimeRT(1) - masterFile.Subject.FS(blockIdx).TimeRT(j) < 0.01)
              tmp.idx(blockIdx) = j;
              break;
          end
     end
     tmp.ftShoes.cutRange = (tmp.idx(blockIdx) : size(masterFile.Subject.FS(blockIdx).Measurement,1));
     if tmp.ftShoes.cutRange(1) ~= 1
        tmp.ftShoes.cut(blockIdx).FS1    = masterFile.Subject.FS(blockIdx).FS1(tmp.ftShoes.cutRange,:);
        tmp.ftShoes.cut(blockIdx).FS2    = masterFile.Subject.FS(blockIdx).FS2(tmp.ftShoes.cutRange,:);
        tmp.ftShoes.cut(blockIdx).timeRT = masterFile.Subject.FS(blockIdx).TimeRT(tmp.ftShoes.cutRange,:);
     else
        tmp.ftShoes.cut(blockIdx).FS1    = masterFile.Subject.FS(blockIdx).FS1;
        tmp.ftShoes.cut(blockIdx).FS2    = masterFile.Subject.FS(blockIdx).FS2;
        tmp.ftShoes.cut(blockIdx).timeRT = masterFile.Subject.FS(blockIdx).TimeRT;
     end
end

% Interpolation
for blockIdx = 1 : (tmp.nrOfBlocks)
    for i = 1 : 6
        synchroData(blockIdx).FS1(:,i) = interp1(tmp.ftShoes.cut(blockIdx).timeRT, ...
                                                 tmp.ftShoes.cut(blockIdx).FS1(:,i), ...
                                                 timestampTable(blockIdx).masterfileNewTimeRT);
        synchroData(blockIdx).FS2(:,i) = interp1(tmp.ftShoes.cut(blockIdx).timeRT, ...
                                                 tmp.ftShoes.cut(blockIdx).FS2(:,i), ...
                                                 timestampTable(blockIdx).masterfileNewTimeRT);
    end
end

%% Cleaning up workspace
clearvars tmp;
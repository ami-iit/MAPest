
%--------------------------------------------------------------------------
% Xsens frequency  --> 60  Hz, acquired with MVNX2018, (master)
% FP    frequency  --> 1K  Hz (slave)
% exoskeleton      --> passive  --> TO BE VERIFIED
%--------------------------------------------------------------------------
% Xsens triggered via Xsens sync station the forceplates.
% Dataset assumption: the timestamp 0 of the forceplates is exactly
% the timestamp 0 of Xsens.

%% ------------------------------ XSENS -----------------------------------
% No need to cut/interpolate Xsens data

%% --------------------------- FORCE PLATES -------------------------------
opts.CoPmovingPlots = false;
bucket.CSVfilename = fullfile(bucket.pathToTask, sprintf('S%03d-FP-%s.csv',subjectID,listOfTasks{tasksIdx}));
FPdataFromCSV.data         = table2array(readtable(bucket.CSVfilename,'Delimiter',',')); %array
FPdataFromCSV.orderedLabel = (getListFromCSV(bucket.CSVfilename,1,1,size(FPdataFromCSV.data,2)))'; %list of char

% Extract forces and CoP per each platform
rawForceplateData.time = FPdataFromCSV.data(:,1);
for fpIdx = 1 : length(FPdataFromCSV.orderedLabel)
    % -------------- Right
    % Fx
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fx-R')
        rawForceplateData.Right.Fx = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fx-14-R')
        rawForceplateData.Right.Fx_14 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fx-23-R')
        rawForceplateData.Right.Fx_23 = FPdataFromCSV.data(:,fpIdx);
    end
    % Fy
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fy-R')
        rawForceplateData.Right.Fy = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fy-12-R')
        rawForceplateData.Right.Fy_12 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fy-34-R')
        rawForceplateData.Right.Fy_34 = FPdataFromCSV.data(:,fpIdx);
    end
    % Fz
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fz-R')
        rawForceplateData.Right.Fz = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fz-1-R')
        rawForceplateData.Right.Fz_1 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fz-2-R')
        rawForceplateData.Right.Fz_2 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fz-3-R')
        rawForceplateData.Right.Fz_3 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:Fz-4-R')
        rawForceplateData.Right.Fz_4 = FPdataFromCSV.data(:,fpIdx);
    end
    % CoPx
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:COPx-R')
        rawForceplateData.Right.CoPx = FPdataFromCSV.data(:,fpIdx);
    end
    % CoPy
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'RIGHT plate:COPy-R')
        rawForceplateData.Right.CoPy = FPdataFromCSV.data(:,fpIdx);
    end
    % -------------- Left
    % Fx
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fx-L')
        rawForceplateData.Left.Fx = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fx-14-L')
        rawForceplateData.Left.Fx_14 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fx-23-L')
        rawForceplateData.Left.Fx_23 = FPdataFromCSV.data(:,fpIdx);
    end
    % Fy
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fy-L')
        rawForceplateData.Left.Fy = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fy-12-L')
        rawForceplateData.Left.Fy_12 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fy-34-L')
        rawForceplateData.Left.Fy_34 = FPdataFromCSV.data(:,fpIdx);
    end
    % Fz
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fz-L')
        rawForceplateData.Left.Fz = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fz-1-L')
        rawForceplateData.Left.Fz_1 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fz-2-L')
        rawForceplateData.Left.Fz_2 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fz-3-L')
        rawForceplateData.Left.Fz_3 = FPdataFromCSV.data(:,fpIdx);
    end
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:Fz-4-L')
        rawForceplateData.Left.Fz_4 = FPdataFromCSV.data(:,fpIdx);
    end
    % CoPx
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:COPx-L')
        rawForceplateData.Left.CoPx = FPdataFromCSV.data(:,fpIdx);
    end
    % CoPy
    if strcmp(FPdataFromCSV.orderedLabel{fpIdx}, 'LEFT plate:COPy-L')
        rawForceplateData.Left.CoPy = FPdataFromCSV.data(:,fpIdx);
    end
end

% raw CoP representation
if opts.CoPmovingPlots
    fpRawDataLength = length(rawForceplateData.Right.CoPx);
    plotCoPinForcePlates_v2(listOfTasks{tasksIdx},subjectID,fpRawDataLength, ...
        rawForceplateData.Right, rawForceplateData.Left, bucket)
end

%% Compute moments
tmp.sensorOffset_a = 0.12; %in [m], from datasheet
tmp.sensorOffset_b = 0.2;  %in [m], from datasheet
% Apply Kistler manual formulae for moments
for FPidx = 1 : length(rawForceplateData.Right.CoPx)
    % ------------- Right
    % moment x
%     rawForceplateData.Right.Mx(FPidx,1) = tmp.sensorOffset_length * ...
%         (rawForceplateData.Right.Fz_1 (FPidx,1) + rawForceplateData.Right.Fz_2 (FPidx,1) - ...
%         rawForceplateData.Right.Fz_3 (FPidx,1) - rawForceplateData.Right.Fz_4 (FPidx,1));
    rawForceplateData.Right.Mx(FPidx,1) = tmp.sensorOffset_b * ...
        (-rawForceplateData.Right.Fz_1 (FPidx,1) + rawForceplateData.Right.Fz_2 (FPidx,1) + ...
        rawForceplateData.Right.Fz_3 (FPidx,1) - rawForceplateData.Right.Fz_4 (FPidx,1));
    % moment y
%     rawForceplateData.Right.My(FPidx,1) = tmp.sensorOffset_width * ...
%         (-rawForceplateData.Right.Fz_1 (FPidx,1) + rawForceplateData.Right.Fz_2 (FPidx,1) + ...
%         rawForceplateData.Right.Fz_3 (FPidx,1) - rawForceplateData.Right.Fz_4 (FPidx,1));
    rawForceplateData.Right.My(FPidx,1) = tmp.sensorOffset_a * ...
        (-rawForceplateData.Right.Fz_1 (FPidx,1) - rawForceplateData.Right.Fz_2 (FPidx,1) + ...
        rawForceplateData.Right.Fz_3 (FPidx,1) + rawForceplateData.Right.Fz_4 (FPidx,1));
    % moment z
%     rawForceplateData.Right.Mz(FPidx,1) = tmp.sensorOffset_length * ...
%         (-rawForceplateData.Right.Fx_14(FPidx,1) + rawForceplateData.Right.Fx_23(FPidx,1)) + ...
%         tmp.sensorOffset_width * ...
%         (rawForceplateData.Right.Fy_12(FPidx,1) - rawForceplateData.Right.Fy_34(FPidx,1));
    rawForceplateData.Right.Mz(FPidx,1) = tmp.sensorOffset_b * ...
        (+rawForceplateData.Right.Fx_14(FPidx,1) - rawForceplateData.Right.Fx_23(FPidx,1)) + ...
        tmp.sensorOffset_a * ...
        (rawForceplateData.Right.Fy_12(FPidx,1) - rawForceplateData.Right.Fy_34(FPidx,1));
    % ------------- Left
    % moment x
%     rawForceplateData.Left.Mx(FPidx,1) = tmp.sensorOffset_length * ...
%         (rawForceplateData.Left.Fz_1 (FPidx,1) + rawForceplateData.Left.Fz_2 (FPidx,1) - ...
%         rawForceplateData.Left.Fz_3 (FPidx,1) - rawForceplateData.Left.Fz_4 (FPidx,1));
    rawForceplateData.Left.Mx(FPidx,1) = tmp.sensorOffset_b * ...
        (-rawForceplateData.Left.Fz_1(FPidx,1) + rawForceplateData.Left.Fz_2(FPidx,1) + ...
        rawForceplateData.Left.Fz_3(FPidx,1) - rawForceplateData.Left.Fz_4(FPidx,1));
    % moment y
%     rawForceplateData.Left.My(FPidx,1) = tmp.sensorOffset_width * ...
%         (-rawForceplateData.Left.Fz_1 (FPidx,1) + rawForceplateData.Left.Fz_2 (FPidx,1) + ...
%         rawForceplateData.Left.Fz_3 (FPidx,1) - rawForceplateData.Left.Fz_4 (FPidx,1));
    rawForceplateData.Left.My(FPidx,1) = tmp.sensorOffset_a * ...
        (-rawForceplateData.Left.Fz_1 (FPidx,1) - rawForceplateData.Left.Fz_2 (FPidx,1) + ...
        rawForceplateData.Left.Fz_3 (FPidx,1) + rawForceplateData.Left.Fz_4 (FPidx,1));
    % moment z
%     rawForceplateData.Left.Mz(FPidx,1) = tmp.sensorOffset_length * ...
%         (-rawForceplateData.Left.Fx_14(FPidx,1) + rawForceplateData.Left.Fx_23(FPidx,1)) + ...
%         tmp.sensorOffset_width * ...
%         (rawForceplateData.Left.Fy_12(FPidx,1) - rawForceplateData.Left.Fy_34(FPidx,1));
    rawForceplateData.Left.Mz(FPidx,1) = tmp.sensorOffset_b * ...
        (+rawForceplateData.Left.Fx_14(FPidx,1) - rawForceplateData.Left.Fx_23(FPidx,1)) + ...
        tmp.sensorOffset_a * ...
        (rawForceplateData.Left.Fy_12(FPidx,1) - rawForceplateData.Left.Fy_34(FPidx,1));
end

%% Combine raw data in raw wrenches
% ------------- Right
rawForceplateData.Right.wrench = [rawForceplateData.Right.Fx, ...
    rawForceplateData.Right.Fy, ...
    rawForceplateData.Right.Fz, ...
    rawForceplateData.Right.Mx, ...
    rawForceplateData.Right.My, ...
    rawForceplateData.Right.Mz,];
% ------------- Left
rawForceplateData.Left.wrench = [rawForceplateData.Left.Fx, ...
    rawForceplateData.Left.Fy, ...
    rawForceplateData.Left.Fz, ...
    rawForceplateData.Left.Mx, ...
    rawForceplateData.Left.My, ...
    rawForceplateData.Left.Mz,];

%% Forceplates Interpolation (downsampling)
xsensTimestamp_ms = suit.time.xSens'; %xsens abs timestamp, in [ms]
FPtimestamp_ms    = (rawForceplateData.time(:,1) - rawForceplateData.time(1,1)) * 1e3; %FP abs timestamp in [ms]
synchroData.timestamp = xsensTimestamp_ms; %new synchro timestamp in [ms]

% Interpolation wrench in sensor frame (SF)
% ------------- Right
synchroData.fp.interpolated_right = interp1(FPtimestamp_ms, ...
    rawForceplateData.Right.wrench, ...
    synchroData.timestamp);
% ------------- Left
synchroData.fp.interpolated_left = interp1(FPtimestamp_ms, ...
    rawForceplateData.Left.wrench, ...
    synchroData.timestamp);

%% CoP Interpolation (downsampling)
% Interpolation CoP in sensor frame (SF)
% ------------- Right
synchroData.CoP.interpolated.Right.CoPx = interp1(FPtimestamp_ms, ...
    rawForceplateData.Right.CoPx, ...
    synchroData.timestamp);
synchroData.CoP.interpolated.Right.CoPy = interp1(FPtimestamp_ms, ...
    rawForceplateData.Right.CoPy, ...
    synchroData.timestamp);
% % ------------- Left
synchroData.CoP.interpolated.Left.CoPx = interp1(FPtimestamp_ms, ...
    rawForceplateData.Left.CoPx, ...
    synchroData.timestamp);
synchroData.CoP.interpolated.Left.CoPy = interp1(FPtimestamp_ms, ...
    rawForceplateData.Left.CoPy, ...
    synchroData.timestamp);

%% Check if NaN in interpolated data
lenVect = length(synchroData.CoP.interpolated.Right.CoPx);
for i = 1 : lenVect
    % Right.fp
    if ~isempty(find(isnan(synchroData.fp.interpolated_right(i,:)) == 1))
        synchroData.fp.interpolated_right(i,:) = ...
            synchroData.fp.interpolated_right(i-1,:);
    end
    % Left.fp
    if ~isempty(find(isnan(synchroData.fp.interpolated_left(i,:)) == 1))
        synchroData.fp.interpolated_left(i,:) = ...
            synchroData.fp.interpolated_left(i-1,:);
    end
    
    % Right.CoPx
    if ~isempty(find(isnan(synchroData.CoP.interpolated.Right.CoPx(i,1)) == 1))
        synchroData.CoP.interpolated.Right.CoPx(i,1) = ...
            synchroData.CoP.interpolated.Right.CoPx(i-1,1);
    end
    % Right.CoPy
    if ~isempty(find(isnan(synchroData.CoP.interpolated.Right.CoPy(i,1)) == 1))
        synchroData.CoP.interpolated.Right.CoPy(i,1) = ...
            synchroData.CoP.interpolated.Right.CoPy(i-1,1);
    end
    % Left.CoPx
    if ~isempty(find(isnan(synchroData.CoP.interpolated.Left.CoPx(i,1)) == 1))
        synchroData.CoP.interpolated.Left.CoPx(i,1) = ...
            synchroData.CoP.interpolated.Left.CoPx(i-1,1);
    end
    % Left.CoPy
    if ~isempty(find(isnan(synchroData.CoP.interpolated.Left.CoPy(i,1)) == 1))
        synchroData.CoP.interpolated.Left.CoPy(i,1) = ...
            synchroData.CoP.interpolated.Left.CoPy(i-1,1);
    end
end

%% Interpolated CoP representation
if opts.CoPmovingPlots
    plotCoPinForcePlates_v2(listOfTasks{tasksIdx},subjectID,length(synchroData.timestamp), ...
        synchroData.CoP.interpolated.Right, synchroData.CoP.interpolated.Left, bucket);
end


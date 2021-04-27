
%% Preliminaries
clc; clear all;
 
subjectID = 1;
taskID    = 0;
% bucket.base = 'Pelvis'; % floating base
nrOfDoFs = 48;
gravity = [0, 0, -9.81];
meshFilePrefix='meshes/';
 
% Options
opts.videoRecording = false;
 
bucket.datasetRoot         = fullfile(pwd, 'dataJSI');
bucket.pathToSubject       = fullfile(bucket.datasetRoot, sprintf('S%02d',subjectID));
bucket.pathToTask          = fullfile(bucket.pathToSubject,sprintf('Task%d',taskID));
bucket.pathToRawData       = fullfile(bucket.pathToTask,'data');
bucket.pathToProcessedData = fullfile(bucket.pathToTask,'processed');
 
%% Load data
masterFile = load(fullfile(bucket.pathToRawData,sprintf(('S%02d_%02d.mat'),subjectID,taskID)));
load(fullfile(bucket.pathToProcessedData,'suit.mat'));
load(fullfile(bucket.pathToProcessedData,'selectedJoints.mat'));
% load(fullfile(bucket.pathToProcessedData,'human_state_tmp.mat'));
load(fullfile(bucket.pathToProcessedData,'synchroKin.mat'));
bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj0%d_%ddof.urdf', subjectID, nrOfDoFs));
 
%% Raw data handling
% block.labels = {'block1'; ...
%     'block2'; ...
%     'block3'; ...
%     'block4'; ...
%     'block5'};
% block.nrOfBlocks = size(block.labels,1);
% % %  
% % % for i = 1 : length(masterFile.Subject.Xsens(1).Timestamp)
% % %     tmp.block1 = masterFile.Subject.Xsens(1).Timestamp - masterFile.Subject.Xsens(1).Timestamp(end);
% % %     if tmp.block1(i)<=0
% % %         tmp.block1Init = i;
% % %         break
% % %     end
% % % end
% % % for i = 1 : length(masterFile.Subject.Xsens) %5 blocks
% % %     if i == 1
% % %         tmp.XsensBlockRange(i).first = masterFile.Subject.Xsens(i).Timestamp(tmp.block1Init);
% % %     else
% % %         tmp.XsensBlockRange(i).first = masterFile.Subject.Xsens(i).Timestamp(1);
% % %     end
% % %     tmp.XsensBlockRange(i).last = masterFile.Subject.Xsens(i).Timestamp(end);
% % % end
% % %  
% % % for i = 1 : size(suit.sensors{1, 1}.meas.sensorOrientation,2) % sens1 since it is equal for all the sensors
% % %     for j = 1 : block.nrOfBlocks
% % %         if suit.time.xSens(i) == tmp.XsensBlockRange(1,j).first
% % %             tmp.blockRange(j).first = i;
% % %         end
% % %         if suit.time.xSens(i) == tmp.XsensBlockRange(1,j).last
% % %             tmp.blockRange(j).last = i;
% % %         end
% % %     end
% % % end
% % %  
% % % % Timestamps struct
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     % ---Labels
% % %     timestampTable(blockIdx).block  = block.labels(blockIdx);
% % %     
% % %     % ---Xsens Timestamp Range
% % %     if blockIdx == 1 %exception
% % %         for i = 1: size(masterFile.Subject.Xsens(blockIdx).Timestamp,1)
% % %             if masterFile.Subject.Xsens(blockIdx).Timestamp(i) == tmp.XsensBlockRange(1).first
% % %                 tmp.exception_first = i;
% % %             end
% % %             if masterFile.Subject.Xsens(blockIdx).Timestamp(i) == tmp.XsensBlockRange(1).last
% % %                 tmp.exception_last = i;
% % %             end
% % %         end
% % %         tmp.cutRange = (tmp.exception_first : tmp.exception_last);
% % %         timestampTable(blockIdx).masterfileTimestamps = masterFile.Subject.Xsens(blockIdx).Timestamp(tmp.cutRange,:); %exception
% % %         timestampTable(blockIdx).masterfileTimeRT = masterFile.Subject.Xsens(blockIdx).TimeRT(tmp.cutRange,:); %exception
% % %     else
% % %         timestampTable(blockIdx).masterfileTimestamps  = masterFile.Subject.Xsens(blockIdx).Timestamp;
% % %         timestampTable(blockIdx).masterfileTimeRT  = masterFile.Subject.Xsens(blockIdx).TimeRT;
% % %     end
% % %     
% % %     % ---Cut MVNX in 5 blocks according to previous ranges
% % %     timestampTable(blockIdx).XsensTimestampRange = [tmp.XsensBlockRange(blockIdx).first, tmp.XsensBlockRange(blockIdx).last];
% % %     timestampTable(blockIdx).XsensCutRange = [tmp.blockRange(blockIdx).first, tmp.blockRange(blockIdx).last];
% % %     tmp.cutRange = (tmp.blockRange(blockIdx).first : tmp.blockRange(blockIdx).last);
% % %     timestampTable(blockIdx).timeMVNX = suit.time.xSens(:,tmp.cutRange);
% % % 
% % %     % ---Create a new sampling vector
% % %     % NOTE: this vector will be used as sampling vector for the FP and
% % %     % ftShoes data contained in the masterfile!
% % %     tmp.RTblock_samples = size(timestampTable(blockIdx).timeMVNX,2);
% % %     tmp.step = (timestampTable(blockIdx).masterfileTimeRT(end) - timestampTable(blockIdx).masterfileTimeRT(1))/(tmp.RTblock_samples -1);
% % %     timestampTable(blockIdx).masterfileNewTimeRT = timestampTable(blockIdx).masterfileTimeRT(1) : tmp.step : timestampTable(blockIdx).masterfileTimeRT(end);
% % % end
% % %  
% % % tmp.cutRange = cell(5,1);
% % % for blockIdx = 1 : block.nrOfBlocks
% % %     tmp.cutRange{blockIdx} = (tmp.blockRange(blockIdx).first : tmp.blockRange(blockIdx).last);
% % % end
 
%% Load URDF model with sensors and create human kinDyn
disp('-------------------------------------------------------------------');
disp('Loading the URDF model...');
bucket.base = 'LeftToe';
human_kinDynComp_forViz = iDynTreeWrappers.loadReducedModel(selectedJoints, ...
    bucket.base, ...
    fullfile(bucket.pathToSubject, '/'), ...
    sprintf('XSensURDF_subj0%d_%ddof.urdf', subjectID, nrOfDoFs), ...
    false);
 
%% Prepare visualization
for blockIdx = 1
    [Visualizer,Objects] = iDynTreeWrappers.prepareVisualization(human_kinDynComp_forViz, meshFilePrefix);
    fprintf('------- Visualization of Subject_%02d, Trial_%02d , Block_%02d -------\n ',subjectID,taskID, blockIdx);
    title1 = title(sprintf('Subject %02d, Trial %02d , Block %02d',subjectID,taskID, blockIdx));
    set(title1, 'FontSize', 18);
    
    if opts.videoRecording
        % Path to video folder
        bucket.pathToVideoFolder = fullfile(bucket.pathToProcessedData,'video');
        if ~exist(bucket.pathToVideoFolder)
            mkdir (bucket.pathToVideoFolder)
        end
        newVideoFilename = sprintf('kinViz_Subject_%02d_Trial_%02d_Block_%02d.avi',subjectID,taskID, blockIdx);
        vobj = VideoWriter(newVideoFilename,'Motion JPEG AVI');
        vobj.FrameRate = 24;
        vobj.Quality = 100;
        open(vobj);
    end
    
    %% Compute G_H_base
%     %--------Computation of the suit base orientation and position w.r.t. G
%     for suitLinksIdx = 1 : size(suit.links,1)
%         if strcmp(suit.links{suitLinksIdx, 1}.label, bucket.base)
%             basePos_tot         = suit.links{suitLinksIdx, 1}.meas.position;
%             baseOrientation_tot = suit.links{suitLinksIdx, 1}.meas.orientation;
%             break
%         end
%         break
%     end
%     tmp.cutRange{blockIdx} = (tmp.blockRange(blockIdx).first : tmp.blockRange(blockIdx).last);
%     bucket.basePosition(blockIdx).basePos_wrtG  = basePos_tot(:,tmp.cutRange{blockIdx});
%     bucket.orientation(blockIdx).baseOrientation = baseOrientation_tot(:,tmp.cutRange{blockIdx});
%     clearvars basePos_tot baseOrientation_tot;
%     
%   G_T_base(blockIdx).block = block.labels(blockIdx);
%     G_T_base(blockIdx).G_T_b = computeTransformBaseToGlobalFrame(human_kinDynComp_forViz.kinDynComp, ...
%         synchroKin(blockIdx),...
%         bucket.orientation(blockIdx).baseOrientation, ...
%         bucket.basePosition(blockIdx).basePos_wrtG);
%        
%     G_T_base_whole = computeTransformBaseToGlobalFrame(human_kinDynComp_forViz.kinDynComp, ...
%         human_state_tmp,...
%         baseOrientation_tot, ...
%         basePos_tot);
%       
    G_H_base = [1, 0, 0, 0;
        0, 1, 0, 0;
        0, 0, 1, 0;
        0, 0, 0, 1];
    
    %% Update kinematics
    for lenIdx = 203 : length(synchroKin(blockIdx).masterTime)
        title1 = title(sprintf('Subject %02d, Trial %02d , Block %02d, len %02d',subjectID,taskID, blockIdx, lenIdx));
        % q  = human_state_tmp.q(:,lenIdx); %in [rad]
        q  = synchroKin(blockIdx).q(:,lenIdx); %in [rad]
        dq = zeros(human_kinDynComp_forViz.NDOF,1);
        baseVel = (zeros(6,1));
        % G_H_b = G_T_base(blockIdx).G_T_b{lenIdx, 1}.asHomogeneousTransform();
        % G_H_b_matlab{lenIdx,1} = G_H_b.toMatlab;
        % iDynTreeWrappers.setRobotState(human_kinDynComp_forViz, G_H_b.toMatlab, q, baseVel, dq, gravity)
       iDynTreeWrappers.setRobotState(human_kinDynComp_forViz, G_H_base, q, baseVel, dq, gravity)
        %% Update visualization
        iDynTreeWrappers.updateVisualization(human_kinDynComp_forViz,Visualizer);
        axis tight
        xlim([-0.7 0.7]);
        ylim([-0.7 0.7]);
        zlim([ 0   2.2]);
        drawnow;
        
        % record image displayed in the figure
        if opts.videoRecording
            frame = getframe(1);
            writeVideo(vobj, frame);
        end
    end
    %% save video into the folder
    if opts.videoRecording
        close(vobj); % close the object so its no longer tied up by matlab
        % close(gcf);  % close figure since we don't need it anymore
        % move file into the video folder
        filenameToBeMoved =  fullfile(pwd, newVideoFilename);
        folderNew = bucket.pathToVideoFolder;
        movefile(filenameToBeMoved, folderNew);
    end
end

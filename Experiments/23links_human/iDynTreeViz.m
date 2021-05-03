
%% Preliminaries

% no exo
bucket.tmp = load(fullfile(pwd,'/dataJSI/S01/Task1/processed/processed_SOTtask2/estimatedVariables.mat'));
max_tau_noexo = max(max(bucket.tmp.estimatedVariables.tau(1).values)); % Nm
% exo
bucket.tmp = load(fullfile(pwd,'/dataJSI/S01/Task0/processed/processed_SOTtask2/estimatedVariables.mat'));
max_tau_exo = max(max(bucket.tmp.estimatedVariables.tau(1).values)); % Nm

% max_tau = max(max_tau_noexo, max_tau_exo);
max_tau = mean([max_tau_noexo max_tau_exo]);

clc;
clearvars -except tau_exo tau_noexo max_tau

%% Task-specific code
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
load(fullfile(bucket.pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
if subjectID ==1
    if taskID ==0
        tau_exo = load(fullfile(bucket.pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
    else
        tau_noexo = load(fullfile(bucket.pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
    end
end
bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj0%d_%ddof.urdf', subjectID, nrOfDoFs));
 
%% Load URDF model with sensors and create human kinDyn
disp('-------------------------------------------------------------------');
disp('Loading the URDF model...');
bucket.base = 'RightToe';
human_kinDynComp_forViz = iDynTreeWrappers.loadReducedModel(selectedJoints, ...
    bucket.base, ...
    fullfile(bucket.pathToSubject, '/'), ...
    sprintf('XSensURDF_subj0%d_%ddof.urdf', subjectID, nrOfDoFs), ...
    false);

%% Initialize link2joint map and spheres for dynamics visualization
% The order of the map is the same of Visualizer.linkNames
linkToJointMap = containers.Map;
% inkToJointMap('Pelvis')       = [xxx]; not used
linkToJointMap('L5')            = [1, 2];
linkToJointMap('L3')            = [3, 4];
linkToJointMap('T12')           = [5, 6];
linkToJointMap('T8')            = [7, 8, 9];
linkToJointMap('RightShoulder') = [15];
linkToJointMap('LeftShoulder')  = [23];
% linkToJointMap('Neck')        = [xxx]; not used
% linkToJointMap('Head')        = [xxx]; not used
linkToJointMap('LeftUpperArm')  = [24, 25, 26];
linkToJointMap('LeftForeArm')   = [27, 28];
linkToJointMap('LeftHand')      = [29, 30];
linkToJointMap('RightUpperArm') = [16, 17, 18];
linkToJointMap('RightForeArm')  = [19, 20];
linkToJointMap('RightHand')     = [21, 22];
linkToJointMap('LeftUpperLeg')  = [40, 41, 42];
linkToJointMap('LeftLowerLeg')  = [43, 44];
linkToJointMap('LeftFoot')      = [45,46,47];
% linkToJointMap('LeftToe')     = [xxx]; not used
linkToJointMap('RightUpperLeg') = [31, 32, 33];
linkToJointMap('RightLowerLeg') = [34,35];
linkToJointMap('RightFoot')     = [36, 37, 38];
% linkToJointMap('RightToe')    = [xxx]; not used
 
%% Prepare visualization
for blockIdx = 1
    [Visualizer,Objects] = iDynTreeWrappers.prepareVisualization(human_kinDynComp_forViz, meshFilePrefix);
    figNrLinks = length(Visualizer.linkNames);
    fprintf('------- Visualization of Subject_%02d, Trial_%02d , Block_%02d -------\n ',subjectID,taskID, blockIdx);
    title1 = title(sprintf('Subject %02d, Trial %02d , Block %02d',subjectID,taskID, blockIdx));
    set(title1, 'FontSize', 18);
    
    % Sphere configuration
    %  for jointIdx = 1 : figNrLinks
    %    % tauSphere.abs_min(jointIdx,1) = min(abs(estimatedVariables.tau(blockIdx).values(jointIdx,:)));
    %    tauSphere.abs_max(jointIdx,1) = max(abs(estimatedVariables.tau(blockIdx).values(jointIdx,:)));
    %  end
    [X_sphere,Y_sphere,Z_sphere] = sphere;
    min_tau = 0; % Nm
    %     max_tau = max(max(estimatedVariables.tau(blockIdx).values)); % Nm
%     max_tau = 27;
    radius  = 0.05;

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
    G_H_base = [1, 0, 0, 0;
                0, 1, 0, 0;
                0, 0, 1, 0;
                0, 0, 0, 1];
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
    
    %% Initialiaze (prepare) dynamics
    for sphereIdx = 1 : figNrLinks
        if(linkToJointMap.isKey(Visualizer.linkNames{sphereIdx}))
            color = [1,1,1]; % dummy color
            ball{sphereIdx} = surf(X_sphere * radius, ...
                Y_sphere * radius, ...
                Z_sphere * radius, ...
                'FaceColor',color, ...
                'EdgeColor','none');
        end
    end
    
    %% Update kinematics and dynamics visualization
    view(45,3) % set camera view
    for lenIdx = 650 : length(synchroKin(blockIdx).masterTime)
        %         title1 = title(sprintf('Subject %02d, Trial %02d , Block %02d, len %02d',subjectID,taskID, blockIdx, lenIdx));
        if taskID == 1
            title1 = title('NE');
        else
            title1 = title('WE');
        end
        
        % q  = human_state_tmp.q(:,lenIdx); %in [rad]
        q  = synchroKin(blockIdx).q(:,lenIdx); %in [rad]
        dq = zeros(human_kinDynComp_forViz.NDOF,1);
        baseVel = (zeros(6,1));
        % G_H_b = G_T_base(blockIdx).G_T_b{lenIdx, 1}.asHomogeneousTransform();
        % G_H_b_matlab{lenIdx,1} = G_H_b.toMatlab;
        % iDynTreeWrappers.setRobotState(human_kinDynComp_forViz, G_H_b.toMatlab, q, baseVel, dq, gravity)
        iDynTreeWrappers.setRobotState(human_kinDynComp_forViz, G_H_base, q, baseVel, dq, gravity)

        % --- Update kinematics
        iDynTreeWrappers.updateVisualization(human_kinDynComp_forViz,Visualizer);
        axis tight
        xlim([-0.5 0.5]);
        ylim([-0.6 0.7]);
        zlim([ 0   2.2]);
        drawnow;

        % --- Update dynamics
        for sphereIdx = 1 : figNrLinks
            if(linkToJointMap.isKey(Visualizer.linkNames{sphereIdx}))
                pos = Visualizer.transforms(sphereIdx).Matrix(1:3,4);
                tauSphere.lenVal(sphereIdx) = max(abs(estimatedVariables.tau(blockIdx).values(linkToJointMap(Visualizer.linkNames{sphereIdx}),lenIdx)));
                color = [min(tauSphere.lenVal(sphereIdx),max_tau)/max_tau, max(max_tau-max(tauSphere.lenVal(sphereIdx)-min_tau,min_tau), 0)/max_tau, 0];
                set(ball{sphereIdx}, 'XData', X_sphere * radius + pos(1), ...
                    'YData',Y_sphere * radius + pos(2), ...
                    'ZData',Z_sphere * radius + pos(3), ...
                    'FaceColor',color);
            end
        end
        
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

%% Animated plot
% animated_plot;

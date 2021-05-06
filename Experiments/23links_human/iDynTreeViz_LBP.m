
%% Preliminaries
clc; clear all;
subjectID = 21;

% List of tasks
listOfTasks = {'free'; 'FREE_EXO'; ...
    'FreeDeep'; 'freeDeep_EXO'; ...
    'freeROT'; 'FreeROT_EXO'; ... %'ROM'; ...
    'Squat'; 'Squat_EXO'; ...
    'SquatROT'; 'SquatROT_EXO'; ...
    'Stoop'; 'Stoop_EXO'; ...
    'StoopROT'; 'StoopROT_EXO'; ...
    };
tasksIdx = 1;
bucket.base = 'Pelvis'; % floating base
nrOfDoFs = 48;
gravity = [0, 0, -9.81];
meshFilePrefix='meshes/';

bucket.datasetRoot         = fullfile(pwd, 'dataLBP_SPEXOR');
bucket.pathToSubject       = fullfile(bucket.datasetRoot, sprintf('S%03d',subjectID));
bucket.pathToRawData       = fullfile(bucket.pathToSubject,'data');
bucket.pathToTask          = fullfile(bucket.pathToRawData ,listOfTasks{tasksIdx});
bucket.pathToProcessedData = fullfile(bucket.pathToTask,'processed');

%% Load data
load(fullfile(bucket.pathToProcessedData,'suit.mat'));
load(fullfile(bucket.pathToProcessedData,'selectedJoints.mat'));
load(fullfile(bucket.pathToProcessedData,'synchroKin.mat'));
load(fullfile(bucket.pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj0%d_%ddof.urdf', subjectID, nrOfDoFs));

%% Load URDF model with sensors and create human kinDyn
disp('-------------------------------------------------------------------');
disp('Loading the URDF model...');
human_kinDynComp_forViz = iDynTreeWrappers.loadReducedModel(selectedJoints, ...
    bucket.base, ...
    fullfile(bucket.pathToSubject, '/'), ...
    sprintf('XSensURDF_subj0%d_%ddof.urdf', subjectID, nrOfDoFs), ...
    false);

%% Computation of the suit base orientation and position w.r.t. G
for suitLinksIdx = 1 : size(suit.links,1)
    if strcmp(suit.links{suitLinksIdx, 1}.label, bucket.base)
        bucket.basePosition_wrtG = suit.links{suitLinksIdx, 1}.meas.position;
        bucket.baseOrientation   = suit.links{suitLinksIdx, 1}.meas.orientation;
        break
    end
    break
end

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
for tasksIdx = 1 %: length(listOfTasks)
    [Visualizer,Objects] = iDynTreeWrappers.prepareVisualization(human_kinDynComp_forViz, meshFilePrefix);
    % [transforms,linkNames,linkNames_idyn,~,~,~,~,~] = iDynTreeWrappers.prepareVisualization(human_kinDynComp, meshFilePrefix);
    figNrLinks = length(Visualizer.linkNames);
    fprintf('------- Visualization of Subject_%03d, Task_%s  -------\n ',subjectID,listOfTasks{tasksIdx});
    title1 = title(sprintf('Subject %03d, Task %s',subjectID,listOfTasks{tasksIdx}));
    set(title1, 'FontSize', 18);
    
    % Sphere configuration
    [X_sphere,Y_sphere,Z_sphere] = sphere;
    max_tau = max(max(estimatedVariables.tau.values)); % Nm
    min_tau = 0; % Nm
    radius  = 0.05;
    
    %% Compute G_H_base
    G_T_base = computeTransformBaseToGlobalFrame(human_kinDynComp_forViz.kinDynComp, ...
        synchroKin,...
        bucket.baseOrientation, ...
        bucket.basePosition_wrtG);
    
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
    for lenIdx = 1 : length(synchroKin.q)
        title1 = title(sprintf('Subj %03d, Task <%s>, len %02d' ,subjectID,listOfTasks{tasksIdx}),lenIdx);
%         title1 = title(sprintf('Subj %03d, Task <%s>' ,subjectID,listOfTasks{tasksIdx}));
        
        q  = synchroKin.q(:,lenIdx); %in [rad]
        dq = zeros(human_kinDynComp_forViz.NDOF,1);
        baseVel = (zeros(6,1));
        G_H_b = G_T_base{lenIdx, 1}.asHomogeneousTransform();
        iDynTreeWrappers.setRobotState(human_kinDynComp_forViz, G_H_b.toMatlab, q, baseVel, dq, gravity)
        % --- Update kinematics
        iDynTreeWrappers.updateVisualization(human_kinDynComp_forViz,Visualizer);
        axis tight
        xlim([-1.5 1.5]);
        ylim([-0.7 0.7]);
        zlim([ 0   2.2]);
        drawnow;
        
        % --- Update dynamics
        for sphereIdx = 1 : figNrLinks
            if(linkToJointMap.isKey(Visualizer.linkNames{sphereIdx}))
                pos = Visualizer.transforms(sphereIdx).Matrix(1:3,4);
                tauSphere.lenVal(sphereIdx) = mean(abs(estimatedVariables.tau.values(linkToJointMap(Visualizer.linkNames{sphereIdx}),lenIdx)));
                color = [min(tauSphere.lenVal(sphereIdx),max_tau)/max_tau, max(max_tau-max(tauSphere.lenVal(sphereIdx)-min_tau,min_tau), 0)/max_tau 0];
                set(ball{sphereIdx}, 'XData', X_sphere * radius + pos(1), ...
                    'YData',Y_sphere * radius + pos(2), ...
                    'ZData',Z_sphere * radius + pos(3), ...
                    'FaceColor',color);
            end
        end
    end
end

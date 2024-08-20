
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause


% Author(s): Claudia Latella
% Dynamic Interaction Control, Istituto Italiano di Tecnologia
%--------------------------------------------------------------------------
% Experiment main
%--------------------------------------------------------------------------

% Path to the folder of the subject and the task, respectively
bucket.pathToSubject = fullfile(bucket.datasetRoot, sprintf('S%02d',subjectID));
bucket.pathToTask    = fullfile(bucket.pathToSubject,sprintf('task%d',taskID));

% Path to the folder where `raw` data are saved.
bucket.pathToRawData = fullfile(bucket.pathToTask,'data');

% Path to the folder where .mat struct (processed data) will be saved
bucket.pathToProcessedData   = fullfile(bucket.pathToTask,'processed');
disp(strcat('[Start] Analysis SUBJECT_ ',num2str(subjectID),', TRIAL_',num2str(taskID)'));

% Extraction of the masterFile.
% NOTE: If you have a file containing data/info of your experiment you can extract it here.
% This file clearly depends on the user's choice and it could be different or even not existing.
masterFile = load(fullfile(bucket.pathToRawData,sprintf(('S%02d_%02d.mat'),subjectID,taskID)));

% Option for computing the estimated Sigma (default = FALSE)
opts.Sigma_dgiveny = false;

% Define model templates
addpath(genpath('templates'));

%% ---------------------UNA TANTUM PROCEDURE-------------------------------
%% SUIT struct creation
disp('-------------------------------------------------------------------');
if ~exist(fullfile(bucket.pathToProcessedData,'suit.mat'), 'file')
    disp('[Start] Suit extraction ...');
    % 1) extract data from suit
    if opts.suitAsParsedMVNX
        % data from the suit come as parsed MVNX files
        extractSuitDataFromParsing;
        lenData = suit.properties.lenData;
        inputArg = suit;
    end
    if opts.suitAsIWear
        % data from the suit come as YARP-dumped IWear file
        extractWearableDataFromIWear;
        lenData = wearData.nrOfFrames;
        inputArg = wearData;
    end
    % 2) compute sensor position wrt the links
    disp('[Warning]: Check manually the length of the data for the sensor position computation!');
    disp('[Warning]: By default, the computation of the sensor position is done by considering all the samples. It may take time!');
    suit = computeSuitSensorPosition(inputArg, lenData);
    save(fullfile(bucket.pathToProcessedData,'suit.mat'),'suit');
    disp('[End] Suit extraction');
else
    disp('Suit extraction already saved!');
    load(fullfile(bucket.pathToProcessedData,'suit.mat'));
end

%% Extract subject parameters from SUIT
if ~exist(fullfile(bucket.pathToSubject,'subjectParamsFromData.mat'), 'file')
    subjectParamsFromData = subjectParamsComputation(suit, masterFile.Subject.Info.Weight);
    save(fullfile(bucket.pathToSubject,'subjectParamsFromData.mat'),'subjectParamsFromData');
else
    load(fullfile(bucket.pathToSubject,'subjectParamsFromData.mat'),'subjectParamsFromData');
end

%% Create URDF model
bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj%02d_48dof.urdf', subjectID));
if ~exist(bucket.filenameURDF, 'file')
    bucket.URDFmodel = createXsensLikeURDFmodel(subjectParamsFromData, ...
        suit.sensors,...
        'filename',bucket.filenameURDF,...
        'GazeboModel',false);
end

%% Create OSIM model
bucket.filenameOSIM = fullfile(bucket.pathToSubject, sprintf('XSensOSIM_subj%02d_48dof.osim', subjectID));
if ~exist(bucket.filenameOSIM, 'file')
    bucket.OSIMmodel = createXsensLikeOSIMmodel(subjectParamsFromData, ...
        bucket.filenameOSIM);
end

%% Inverse Kinematic computation (via OpenSim)
disp('-------------------------------------------------------------------');
if ~exist(fullfile(bucket.pathToProcessedData,'human_state_tmp.mat'), 'file')
    disp('[Start] IK computation ...');
    bucket.setupFile = fullfile(pwd, 'templates', 'setupOpenSimIKTool_Template.xml');
    bucket.trcFile   = fullfile(bucket.pathToRawData,sprintf('S%02d_%02d.trc',subjectID,taskID));
    bucket.motFile   = fullfile(bucket.pathToProcessedData,sprintf('S%02d_%02d.mot',subjectID,taskID));
    [human_state_tmp, human_ddq_tmp, selectedJoints] = IK(bucket.filenameOSIM, ...
        bucket.trcFile, ...
        bucket.setupFile, ...
        suit.properties.frameRate, ...
        bucket.motFile);
    % here selectedJoints is the order of the OpenSim computation.
    save(fullfile(bucket.pathToProcessedData,'human_state_tmp.mat'),'human_state_tmp');
    save(fullfile(bucket.pathToProcessedData,'human_ddq_tmp.mat'),'human_ddq_tmp');
    save(fullfile(bucket.pathToProcessedData,'selectedJoints.mat'),'selectedJoints');
    disp('[End] IK computation');
else
    disp('IK computation already saved!');
    load(fullfile(bucket.pathToProcessedData,'human_state_tmp.mat'));
    load(fullfile(bucket.pathToProcessedData,'human_ddq_tmp.mat'));
    load(fullfile(bucket.pathToProcessedData,'selectedJoints.mat'));
end
% disp('[Warning]: The IK is expressed in current frame and not in fixed frame!');
disp('-------------------------------------------------------------------');

%% Raw data handling
rawDataHandling;

% This section is highly user dependent.  Here you should have a collection
% of subfunctions/subscripts that allow you to synchronize your data 
% (e.g., state, forceplates, ftShoes, robot).  This section should provide 
% the synchronized timestamp, as well.
% 
% The outcome of this section is to have:
% - timestamp
% - q,dq,ddq
% - forces from forceplates (e.g., synchroDataFromFP)
% - forces from forceplates (e.g., synchroDataFromShoes)
% - robot (e.g., synchroDataFromRobot)
% - ...
% - ...
% all synchronized in a Matlab struct.
% 
% It could come in handy if you create here a Matlab struct only for the
% synchronized kinematics (e.g., synchroKin.mat) structured as follows:
% synchroKin = []
% synchroKin.timestamp
% synchroKin.state.q
% synchroKin.state.dq
% synchroKin.ddq

%% Transform feet forces from sensor into human frames
% Preliminary assumption on contact links: 2 contacts only.
bucket.contactLink = cell(2,1);

% Define contacts configuration.
% The code here following is valid if you are using sensorized shoes.
% You could change the code to fit other type of force acquisition (e.g.,
% forceplates).
bucket.contactLink{1} = 'RightFoot'; % human link in contact with RightShoe
bucket.contactLink{2} = 'LeftFoot';  % human link in contact with LeftShoe
shoes = transformShoesWrenches(synchroDataFromShoes, subjectParamsFromData);

%% ------------------------RUNTIME PROCEDURE-------------------------------
%% Load URDF model with sensors
humanModel.filename = bucket.filenameURDF;
humanModelLoader = iDynTree.ModelLoader();
if ~humanModelLoader.loadReducedModelFromFile(humanModel.filename, ...
        cell2iDynTreeStringVector(selectedJoints))
    % here the model loads the same order of selectedJoints.
    fprintf('Something wrong with the model loading.')
end

humanModel = humanModelLoader.model();
human_kinDynComp = iDynTree.KinDynComputations();
human_kinDynComp.loadRobotModel(humanModel);

bucket.base = 'Pelvis'; % floating base

% Sensors
humanSensors = humanModelLoader.sensors();
humanSensors.removeAllSensorsOfType(iDynTree.GYROSCOPE_SENSOR);
% humanSensors.removeAllSensorsOfType(iDynTree.ACCELEROMETER_SENSOR);

%% Add link angular acceleration sensors
% iDynTree.THREE_AXIS_ANGULAR_ACCELEROMETER_SENSOR is not supported by the
% URDF model.  It requires to be added differently

% Angular Acceleration struct
angAcc_sensor = struct;
for angAccSensIdx = 1 : length(suit.sensors)
    angAcc_sensor(angAccSensIdx).attachedLink = suit.sensors{angAccSensIdx, 1}.label;
    angAcc_sensor(angAccSensIdx).iDynModelIdx = humanModel.getLinkIndex(suit.links{angAccSensIdx, 1}.label);
    angAcc_sensor(angAccSensIdx).sensorName   = strcat(angAcc_sensor(angAccSensIdx).attachedLink, '_angAcc');

    angAcc_sensor(angAccSensIdx).S_R_L        = iDynTree.Rotation().RPY(suit.sensors{angAccSensIdx, 1}.RPY(1), ...
        suit.sensors{angAccSensIdx, 1}.RPY(2), suit.sensors{angAccSensIdx, 1}.RPY(3)).toMatlab;
    angAcc_sensor(angAccSensIdx).pos_SwrtL    = suit.sensors{angAccSensIdx, 1}.position;

    for suitLinkIdx = 1 : length(suit.links)
        if strcmp(suit.sensors{angAccSensIdx, 1}.label,suit.links{suitLinkIdx, 1}.label)
            sampleToMatch = suitLinkIdx;
            for lenSample = 1 : suit.nrOfFrames
                G_R_S_mat = quat2Mat(suit.sensors{angAccSensIdx, 1}.meas.sensorOrientation(:,lenSample));
                angAcc_sensor(angAccSensIdx).S_meas_L = G_R_S_mat' * suit.links{sampleToMatch, 1}.meas.angularAcceleration;
            end
            break;
        end
    end
end

% Create new angular accelerometer sensor in berdy sensor
for newSensIdx = 1 : length(suit.sensors)
    humanSensors = addAccAngSensorInBerdySensors(humanSensors,angAcc_sensor(newSensIdx).sensorName, ...
        angAcc_sensor(newSensIdx).attachedLink,angAcc_sensor(angAccSensIdx).iDynModelIdx, ...
        angAcc_sensor(angAccSensIdx).S_R_L, angAcc_sensor(angAccSensIdx).pos_SwrtL);
end

%% Initialize berdy
% Specify berdy options
berdyOptions = iDynTree.BerdyOptions;

berdyOptions.baseLink = bucket.base;
berdyOptions.includeAllNetExternalWrenchesAsSensors          = true;
berdyOptions.includeAllNetExternalWrenchesAsDynamicVariables = true;
berdyOptions.includeAllJointAccelerationsAsSensors           = true;
berdyOptions.includeAllJointTorquesAsSensors                 = false;

berdyOptions.berdyVariant = iDynTree.BERDY_FLOATING_BASE;
berdyOptions.includeFixedBaseExternalWrench = false;

% Load berdy
berdy = iDynTree.BerdyHelper;
berdy.init(humanModel, humanSensors, berdyOptions);

% Get the current traversal
traversal = berdy.dynamicTraversal;

% Floating base settings
currentBase = berdy.model().getLinkName(traversal.getBaseLink().getIndex());
disp(strcat('[Info] Current base is < ', currentBase,'>.'));
human_kinDynComp.setFloatingBase(currentBase);
baseKinDynModel = human_kinDynComp.getFloatingBase();

% Consistency check: berdy.model base and human_kinDynComp.model have to be consistent!
if currentBase ~= baseKinDynModel
    error(strcat('The berdy model base (',currentBase,') and the kinDyn model base (',baseKinDynModel,') do not match!'));
end

% Get the tree is visited as the order of variables in vector d
dVectorOrder = cell(traversal.getNrOfVisitedLinks(), 1);
dJointOrder = cell(traversal.getNrOfVisitedLinks()-1, 1);
for i = 0 : traversal.getNrOfVisitedLinks() - 1
    if i ~= 0
        joint  = traversal.getParentJoint(i);
        dJointOrder{i} = berdy.model().getJointName(joint.getIndex());
    end
    link = traversal.getLink(i);
    dVectorOrder{i + 1} = berdy.model().getLinkName(link.getIndex());
end

% ---------------------------------------------------
% CHECK: print the order of variables in d vector
% printBerdyDynVariables_floating(berdy)
% ---------------------------------------------------

%% Measurements wrapping

disp('-------------------------------------------------------------------');
disp('[Start] Wrapping measurements...');
fext.rightHuman = shoes.Right_HF;
fext.leftHuman  = shoes.Left_HF;

data  = dataPackaging(humanModel, ...
    humanSensors, ...
    suit_runtime, ...
    angAcc_sensor, ...
    fext, ...
    synchroKin.ddq, ...
    bucket.contactLink, ...
    priors);
% y vector as input for MAP
[data.y, data.Sigmay] = berdyMeasurementsWrapping(berdy, data);
disp('[End] Wrapping measurements');

% ---------------------------------------------------
% CHECK: print the order of measurement in y
% printBerdySensorOrder(berdy);
% ---------------------------------------------------

%% ------------------------------- MAP ------------------------------------
%% Set MAP priors
priors.mud    = zeros(berdy.getNrOfDynamicVariables(), 1);
priors.Sigmad = bucket.Sigmad * eye(berdy.getNrOfDynamicVariables());
priors.SigmaD = bucket.SigmaD * eye(berdy.getNrOfDynamicEquations());

%% Possibility to remove a sensor from the analysis
% except fot the accelerometers and gyroscope for whose removal already
% exists the iDynTree option.

sensorsToBeRemoved = [];

% %-----HOW TO REMOVE WRENCH SENSORS FROM THE HANDS
% bucket.temp.type = iDynTree.NET_EXT_WRENCH_SENSOR;
% bucket.temp.id = 'LeftHand';
% sensorsToBeRemoved = [sensorsToBeRemoved; bucket.temp];
% 
% bucket.temp.type = iDynTree.NET_EXT_WRENCH_SENSOR;
% bucket.temp.id = 'RightHand';
% sensorsToBeRemoved = [sensorsToBeRemoved; bucket.temp];

% %-----HOW TO REMOVE WRENCH SENSORS FROM THE FEET
% bucket.temp.type = iDynTree.NET_EXT_WRENCH_SENSOR;
% bucket.temp.id = 'RightFoot';
% sensorsToBeRemoved = [sensorsToBeRemoved; bucket.temp];
%
% bucket.temp.type = iDynTree.NET_EXT_WRENCH_SENSOR;
% bucket.temp.id = 'LeftFoot';
% sensorsToBeRemoved = [sensorsToBeRemoved; bucket.temp];

%% Angular velocity of the currentBase
% Code to handle the info of the angular velocity of the base.
% This value is mandatorily required in the floating-base formalism.
% The new MVNX2018 does not provide the sensorAngularVelocity anymore.

% Define the end effector frame.  In this frame the velocity is assumed to
% be zero (e.g., a frame associated to a link that is in fixed contact with
% the ground).
disp('-------------------------------------------------------------------');
endEffectorFrame = 'LeftFoot';
disp(strcat('[Info] Current end effector is < ', endEffectorFrame,'>.'));


disp(strcat('[Start] Computing the <',currentBase,'> angular velocity...'));
if ~exist(fullfile(bucket.pathToProcessedData,'baseAngVelocity.mat'), 'file')
    [baseAngVel, baseKinDynModel] = computeBaseAngularVelocity( human_kinDynComp, ...
        currentBase, ...
        synchroKin.state, ...
        endEffectorFrame);
    save(fullfile(bucket.pathToProcessedData,'baseAngVelocity.mat'),'baseAngVel');
else
    load(fullfile(bucket.pathToProcessedData,'baseAngVelocity.mat'));
end
disp(strcat('[End] Computing the <',currentBase,'> angular velocity...'));

%% MAP computation
disp('-------------------------------------------------------------------');
if ~exist(fullfile(bucket.pathToProcessedData,'estimation.mat'), 'file')
    
    priors.Sigmay = data.Sigmay;
    if opts.Sigma_dgiveny
        disp('[Start] Complete MAP computation...');
        [estimation.mu_dgiveny, estimation.Sigma_dgiveny] = MAPcomputation_floating(berdy, ...
            traversal, ...
            synchroKin.state, ...
            data.y, ...
            priors, ...
            baseAngVel, ...
            'SENSORS_TO_REMOVE', sensorsToBeRemoved);
        disp('[End] Complete MAP computation');
        % TODO: variables extraction
        % Sigma_tau extraction from Sigma d --> since Sigma d is very big, it
        % cannot be saved! Therefore once computed it is necessary to extract data
        % related to tau and save that one!
        % TODO: extractSigmaOfEstimatedVariables
    else
        disp('[Start] mu_dgiveny MAP computation...');
        [estimation.mu_dgiveny] = MAPcomputation_floating(berdy, ...
            traversal, ...
            synchroKin.state,...
            data.y, ...
            priors, ...
            baseAngVel, ...
            'SENSORS_TO_REMOVE', sensorsToBeRemoved);
        disp('[End] mu_dgiveny MAP computation');
    end
    
    save(fullfile(bucket.pathToProcessedData,'estimation.mat'),'estimation');
else
    disp('MAP computation already saved!');
    load(fullfile(bucket.pathToProcessedData,'estimation.mat'));
end

%% Variables extraction from MAP estimation
disp('-------------------------------------------------------------------');
if ~exist(fullfile(bucket.pathToProcessedData,'estimatedVariables.mat'), 'file')
    
    % torque extraction (via Berdy)
    disp('[Start] Torque extraction...');
    estimatedVariables.tau.label  = selectedJoints;
    estimatedVariables.tau.values = extractEstimatedTau_from_mu_dgiveny(berdy, ...
        estimation.mu_dgiveny, ...
        synchroKin.state.q);
    disp('[End] Torque extraction');
    
    % fext extraction (no via Berdy)
    disp('-------------------------------------------------------------------');
    disp('[Start] External force extraction...');
    estimatedVariables.Fext.label  = dVectorOrder;
    estimatedVariables.Fext.values = extractEstimatedFext_from_mu_dgiveny(berdy, ...
        dVectorOrder, ...
        estimation.mu_dgiveny);
    disp('[End] External force extraction for Block');
    
    % save extracted viariables
    save(fullfile(bucket.pathToProcessedData,'estimatedVariables.mat'),'estimatedVariables');
else
    disp('Torque and ext force extraction already saved!');
    load(fullfile(bucket.pathToProcessedData,'estimatedVariables.mat'));
end

%% Simulated y
% This section is useful to compare the measurements in the y vector and
% the results of the MAP.  Note: you cannot compare directly the results of
% the MAP (i.e., mu_dgiveny) with the measurements in the y vector but you
% have to pass through the y_sim and only later to compare y and y_sim.
disp('-------------------------------------------------------------------');
if ~exist(fullfile(bucket.pathToProcessedData,'y_sim.mat'), 'file')
    
    disp('[Start] Simulated y computation...');
    [y_sim] = sim_y_floating(berdy, ...
        synchroKin.state, ...
        traversal, ...
        baseAngVel, ...
        estimation.mu_dgiveny);
    disp('[End] Simulated y computation');
    save(fullfile(bucket.pathToProcessedData,'y_sim.mat'),'y_sim');
else
    disp('Simulated y computation already saved!');
    load(fullfile(bucket.pathToProcessedData,'y_sim.mat'));
end

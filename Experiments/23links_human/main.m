
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%--------------------------------------------------------------------------
% LBP_SPEXOR_experiments main
%--------------------------------------------------------------------------

if opts.task1_SOT %Task1
    bucket.pathToProcessedData_SOTtask1   = fullfile(bucket.pathToProcessedData,'processed_SOTtask1');
    if ~exist(bucket.pathToProcessedData_SOTtask1)
        mkdir(bucket.pathToProcessedData_SOTtask1)
    end
end

if ~opts.task1_SOT %Task2
    bucket.pathToProcessedData_SOTtask2   = fullfile(bucket.pathToProcessedData,'processed_SOTtask2');
    if ~exist(bucket.pathToProcessedData_SOTtask2)
        mkdir(bucket.pathToProcessedData_SOTtask2)
    end
end

if opts.task1_SOT
    %% --------------------------------------------------------------------
    %% ======================== DATA EXTRACTION ===========================
    %% --------------------------------------------------------------------
    %% SUIT struct creation
    if ~exist(fullfile(bucket.pathToProcessedData,'suit.mat'), 'file')
        disp('-------------------------------------------------------------------');
        disp('[Start] Suit extraction ...');
        % 1) extract data from C++ parsed files
        fileName = sprintf('S%03d_%s-001',subjectID,listOfTasks{tasksIdx});
        extractSuitDataFromParsing;
        % 2) transform the sensorFreeAcceleration of MVNX2018 into the oldest version
        gravity = [0; 0; -9.81];
        for sensIdx = 1: size(suit.sensors,1)
            len = size(suit.sensors{sensIdx, 1}.meas.sensorOrientation,2);
            for lenIdx = 1 : len
                G_R_S = quat2Mat(suit.sensors{sensIdx, 1}.meas.sensorOrientation(:,lenIdx));% fromQuaternion(quaternion);
                % Transformation:        S_a_old = S_R_G * (G_a_new - gravity)
                suit.sensors{sensIdx, 1}.meas.sensorOldAcceleration(:,lenIdx) = ...
                    transpose(G_R_S) * (suit.sensors{sensIdx, 1}.meas.sensorFreeAcceleration(:,lenIdx) - gravity);
            end
        end
        % 3) compute sensor position
        suit = computeSuitSensorPosition(suit);
        suit.properties.mass = mass; % in kg
        suit.properties.height = height; % in m
        % 4) remove suit sensor for the hands since it is not used
        for sensIdx = 1 : suit.properties.nrOfSensors
            if strcmp(suit.sensors{sensIdx, 1}.label, 'RightHandGeneric')
                suit.sensors(sensIdx) = [];
                suit.properties.nrOfSensors = suit.properties.nrOfSensors - 1;
            end
        end
        save(fullfile(bucket.pathToProcessedData,'suit.mat'),'suit');
        disp('[End] Suit extraction');
    else
        load(fullfile(bucket.pathToProcessedData,'suit.mat'));
    end

    %% Extract subject parameters from SUIT
    if ~exist(fullfile(bucket.pathToSubject,'subjectParamsFromData.mat'), 'file')
        subjectParamsFromData = subjectParamsComputation(suit, suit.properties.mass);
        save(fullfile(bucket.pathToSubject,'subjectParamsFromData.mat'),'subjectParamsFromData');
    else
        load(fullfile(bucket.pathToSubject,'subjectParamsFromData.mat'),'subjectParamsFromData');
    end
    
    if opts.EXO
        % Distribute manually the mass of the exo (6.8 kg) as follows.
        if ~exist(fullfile(bucket.pathToSubject,'subjectParamsFromDataEXO.mat'), 'file')
            subjectParamsFromDataEXO = subjectParamsFromData;
            % --- 1 kg per shoulder
            % right
            subjectParamsFromDataEXO.rightShoulderMass = subjectParamsFromData.rightShoulderMass + 1;
            subjectParamsFromDataEXO.rightShoulderIxx  = (subjectParamsFromDataEXO.rightShoulderMass/12) * ...
                (3 * (subjectParamsFromData.rightSho_z/2)^2 + subjectParamsFromData.rightSho_y^2);
            subjectParamsFromDataEXO.rightShoulderIyy  = (subjectParamsFromDataEXO.rightShoulderMass/2) * ...
                ((subjectParamsFromData.rightSho_z/2)^2);
            subjectParamsFromDataEXO.rightShoulderIzz  = (subjectParamsFromDataEXO.rightShoulderMass/12) * ...
                (3 * (subjectParamsFromData.rightSho_z/2)^2 + subjectParamsFromData.rightSho_y^2);
            % left
            subjectParamsFromDataEXO.leftShoulderMass = subjectParamsFromData.leftShoulderMass + 1;
            subjectParamsFromDataEXO.leftShoulderIxx  = (subjectParamsFromDataEXO.leftShoulderMass/12) * ...
                (3 * (subjectParamsFromData.leftSho_z/2)^2 + subjectParamsFromData.leftSho_y^2);
            subjectParamsFromDataEXO.leftShoulderIyy  = (subjectParamsFromDataEXO.leftShoulderMass/2) * ...
                ((subjectParamsFromData.leftSho_z/2)^2);
            subjectParamsFromDataEXO.leftShoulderIzz  = (subjectParamsFromDataEXO.leftShoulderMass/12) * ...
                (3 * (subjectParamsFromData.leftSho_z/2)^2 + subjectParamsFromData.leftSho_y^2);

            % --- 3 kg at the pelvis
            subjectParamsFromDataEXO.pelvisMass = subjectParamsFromData.pelvisMass + 3;
            subjectParamsFromDataEXO.pelvisIxx  = (subjectParamsFromDataEXO.pelvisMass/12) * ...
                ((subjectParamsFromData.pelvisBox(2))^2 + (subjectParamsFromData.pelvisBox(3))^2);
            subjectParamsFromDataEXO.pelvisIyy  = (subjectParamsFromDataEXO.pelvisMass/12) * ...
                ((subjectParamsFromData.pelvisBox(3))^2 + (subjectParamsFromData.pelvisBox(1))^2);
            subjectParamsFromDataEXO.pelvisIzz  = (subjectParamsFromDataEXO.pelvisMass/12) * ...
                ((subjectParamsFromData.pelvisBox(3))^2 + (subjectParamsFromData.pelvisBox(2))^2);

            % --- 0.9 kg per upper leg
            % right
            subjectParamsFromDataEXO.rightUpperLegMass = subjectParamsFromData.rightUpperLegMass + 0.9;
            subjectParamsFromDataEXO.rightUpperLegIxx  = (subjectParamsFromDataEXO.rightUpperLegMass/12) * ...
                (3 * (subjectParamsFromData.rightUpperLeg_x/2)^2 + subjectParamsFromData.rightUpperLeg_z^2);
            subjectParamsFromDataEXO.rightUpperLegIyy  = (subjectParamsFromDataEXO.rightUpperLegMass/12) * ...
                (3 * (subjectParamsFromData.rightUpperLeg_x/2)^2 + subjectParamsFromData.rightUpperLeg_z^2);
            subjectParamsFromDataEXO.rightUpperLegIzz  = (subjectParamsFromDataEXO.rightUpperLegMass/2) * ...
                ((subjectParamsFromData.rightUpperLeg_x/2)^2);
            % left
            subjectParamsFromDataEXO.leftUpperLegMass = subjectParamsFromData.leftUpperLegMass + 0.9;
            subjectParamsFromDataEXO.leftUpperLegIxx  = (subjectParamsFromDataEXO.leftUpperLegMass/12) * ...
                (3 * (subjectParamsFromData.leftUpperLeg_x/2)^2 + subjectParamsFromData.leftUpperLeg_z^2);
            subjectParamsFromDataEXO.leftUpperLegIyy  = (subjectParamsFromDataEXO.leftUpperLegMass/12) * ...
                (3 * (subjectParamsFromData.leftUpperLeg_x/2)^2 + subjectParamsFromData.leftUpperLeg_z^2);
            subjectParamsFromDataEXO.leftUpperLegIzz  = (subjectParamsFromDataEXO.leftUpperLegMass/2) * ...
                ((subjectParamsFromData.leftUpperLeg_x/2)^2);

            save(fullfile(bucket.pathToSubject,'subjectParamsFromDataEXO.mat'),'subjectParamsFromDataEXO');
        else
            load(fullfile(bucket.pathToSubject,'subjectParamsFromDataEXO.mat'),'subjectParamsFromDataEXO');
        end
    end

    %% --------------------------------------------------------------------
    %% ========================= HUMAN MODELING ===========================
    %% --------------------------------------------------------------------
    %% Create URDF model
    if strcmp(listOfTasks{tasksIdx}, 'free')
        if opts.noC7joints
            % model NO exo, with C7 joints FIXED
            bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj%03d_48dof_noC7.urdf', subjectID));
            if ~exist(bucket.filenameURDF, 'file')
                bucket.URDFmodel = createXsensLikeURDFmodel(subjectParamsFromData, ...
                    suit.sensors,...
                    'filename',bucket.filenameURDF,...
                    'GazeboModel',false);
            end
            % model WITH exo, with C7 joints FIXED  -->TODO
            if opts.EXO
                bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj%03d_48dof_EXO_noC7.urdf', subjectID));
                if ~exist(bucket.filenameURDF, 'file')
                    bucket.URDFmodel = createXsensLikeURDFmodel(subjectParamsFromDataEXO, ...
                        suit.sensors,...
                        'filename',bucket.filenameURDF,...
                        'GazeboModel',false);
                end
            end
        else
            % model NO exo  or EXO, with C7 joints (complete) REVOLUTE
            bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj%03d_48dof.urdf', subjectID));
            if ~exist(bucket.filenameURDF, 'file')
                bucket.URDFmodel = createXsensLikeURDFmodel(subjectParamsFromData, ...
                    suit.sensors,...
                    'filename',bucket.filenameURDF,...
                    'GazeboModel',false);
            end
            % model WITH exo, with C7 joints (complete) REVOLUTE --->TODO
            if opts.EXO
                bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj%03d_48dof_EXO.urdf', subjectID));
                if ~exist(bucket.filenameURDF, 'file')
                    bucket.URDFmodel = createXsensLikeURDFmodel(subjectParamsFromDataEXO, ...
                        suit.sensors,...
                        'filename',bucket.filenameURDF,...
                        'GazeboModel',false);
                end
            end
        end

        %% Create OSIM model
        if opts.noC7joints
            % model NO exo, with C7 joints LOCKED
            bucket.filenameOSIM = fullfile(bucket.pathToSubject, sprintf('XSensOSIM_subj%03d_48dof_noC7.osim', subjectID));
            if ~exist(bucket.filenameOSIM, 'file')
                bucket.OSIMmodel = createXsensLikeOSIMmodel(subjectParamsFromData, ...
                    bucket.filenameOSIM);
            end
            % model WITH exo, with C7 joints LOCKED
            if opts.EXO && opts.EXO_torqueLevelAnalysis
                bucket.filenameOSIM = fullfile(bucket.pathToSubject, sprintf('XSensOSIM_subj%03d_48dof_EXO_noC7.osim', subjectID));
                if ~exist(bucket.filenameOSIM, 'file')
                    bucket.OSIMmodel = createXsensLikeOSIMmodel(subjectParamsFromDataEXO, ...
                        bucket.filenameOSIM);
                end
            end
        else
            % model NO exo or EXO in forceLevelAnalysis, with C7 joints (complete) UNLOCKED
            bucket.filenameOSIM = fullfile(bucket.pathToSubject, sprintf('XSensOSIM_subj%03d_48dof.osim', subjectID));
            if ~exist(bucket.filenameOSIM, 'file')
                bucket.OSIMmodel = createXsensLikeOSIMmodel(subjectParamsFromData, ...
                    bucket.filenameOSIM);
            end
            % model WITH exo in torqueLevelAnalysis, with C7 joints (complete) UNLOCKED
            if opts.EXO && opts.EXO_torqueLevelAnalysis
                bucket.filenameOSIM = fullfile(bucket.pathToSubject, sprintf('XSensOSIM_subj%03d_48dof_EXO.osim', subjectID));
                if ~exist(bucket.filenameOSIM, 'file')
                    bucket.OSIMmodel = createXsensLikeOSIMmodel(subjectParamsFromDataEXO, ...
                        bucket.filenameOSIM);
                end
            end
        end
    end

    %% --------------------------------------------------------------------
    %% ========================= IK COMPUTATION ===========================
    %% --------------------------------------------------------------------
    %% Inverse Kinematic computation
    if ~exist(fullfile(bucket.pathToProcessedData,'human_state_tmp.mat'), 'file')
        disp('-------------------------------------------------------------------');
        disp('[Start] IK computation ...');
        bucket.setupFile = fullfile(pwd, 'templates', 'setupOpenSimIKTool_Template.xml');
        fileTrcName = sprintf('S%03d-KIN-%s.trc',subjectID,listOfTasks{tasksIdx});
        bucket.trcFile   = fullfile(bucket.pathToTask,fileTrcName);
        bucket.motFile   = fullfile(bucket.pathToProcessedData,sprintf('S%03d_%s-001.mot',subjectID,listOfTasks{tasksIdx}));
        [human_state_tmp, ~, selectedJoints] = IK(bucket.filenameOSIM, ...
            bucket.trcFile, ...
            bucket.setupFile, ...
            suit.properties.frameRate, ...
            bucket.motFile);
        % here selectedJoints is the order of the Osim computation.
        save(fullfile(bucket.pathToProcessedData,'human_state_tmp.mat'),'human_state_tmp');
        %     save(fullfile(bucket.pathToProcessedData,'human_ddq_tmp.mat'),'human_ddq_tmp');
        save(fullfile(bucket.pathToProcessedData,'selectedJoints.mat'),'selectedJoints');
        disp('[End] IK computation');
    else
        load(fullfile(bucket.pathToProcessedData,'human_state_tmp.mat'));
        %     load(fullfile(bucket.pathToProcessedData,'human_ddq_tmp.mat'));
        load(fullfile(bucket.pathToProcessedData,'selectedJoints.mat'));
    end
    % disp('[Warning]: The IK is expressed in current frame and not in fixed frame!');

    % External ddq computation
    Sg.samplingTime = 1/suit.properties.frameRate;
    Sg.polinomialOrder = 3;
    Sg.window = 57;
    human_ddq_tmp = zeros(size(human_state_tmp.q));
    [~,~,human_ddq_tmp] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window,human_state_tmp.q,Sg.samplingTime); % in deg
    human_ddq_tmp = human_ddq_tmp * pi/180;      % in rad
    save(fullfile(bucket.pathToProcessedData,'human_ddq_tmp.mat'),'human_ddq_tmp');

    synchroKin.q   = human_state_tmp.q;
    synchroKin.dq  = human_state_tmp.dq;
    synchroKin.ddq = human_ddq_tmp;
    save(fullfile(bucket.pathToProcessedData,'synchroKin.mat'),'synchroKin');

    %% --------------------------------------------------------------------
    %% ========================== DATA PROCESS ============================
    %% --------------------------------------------------------------------
    %% Raw data handling
    rawDataHandling;

    %% Covariance tuning test
    if ~opts.tuneCovarianceTest || powerIdx == 1

        %% Transform forces into human forces
        % Preliminary assumption on contact links: 2 contacts only (or both feet
        % with the shoes or both feet with two force plates)
        bucket.contactLink = cell(2,1);
        % Define contacts configuration
        bucket.contactLink{1} = 'RightFoot'; % human link in contact with Right force plate
        bucket.contactLink{2} = 'LeftFoot';  % human link in contact with LeftS force plate
        forceplates = transformForceplatesWrenches(synchroData, subjectParamsFromData);
        
        %% Removal of C7 joints kinematics quantities
        if opts.noC7joints
            if ~exist(fullfile(bucket.pathToProcessedData,'selectedJointsReduced.mat'), 'file')
                load(fullfile(bucket.pathToProcessedData,'synchroKin.mat'));
                synchroKinReduced = synchroKin;
                % Get the indices to be removed
                for sjIdx = 1 : size(selectedJoints,1)
                    if (strcmp(selectedJoints{sjIdx,1},'jRightC7Shoulder_rotx'))
                        jRshoC7Rotx_idx = sjIdx;
                    end
                end
                selectedJoints(jRshoC7Rotx_idx,:) = [];

                for sjIdx = 1 : size(selectedJoints,1)
                    if (strcmp(selectedJoints{sjIdx,1},'jLeftC7Shoulder_rotx'))
                        jLshoC7Rotx_idx = sjIdx;
                    end
                end
                selectedJoints(jLshoC7Rotx_idx,:) = [];

                selectedJointsReduced = selectedJoints;
                for blockIdx = blockID
                    synchroKinReduced(blockIdx).q(jRshoC7Rotx_idx,:) = [];
                    synchroKinReduced(blockIdx).dq(jRshoC7Rotx_idx,:) = [];
                    synchroKinReduced(blockIdx).ddq(jRshoC7Rotx_idx,:) = [];
                end
                for blockIdx = blockID
                    synchroKinReduced(blockIdx).q(jLshoC7Rotx_idx,:) = [];
                    synchroKinReduced(blockIdx).dq(jLshoC7Rotx_idx,:) = [];
                    synchroKinReduced(blockIdx).ddq(jLshoC7Rotx_idx,:) = [];
                end
                save(fullfile(bucket.pathToProcessedData,'selectedJointsReduced.mat'),'selectedJointsReduced');
                save(fullfile(bucket.pathToProcessedData,'synchroKinReduced.mat'),'synchroKinReduced');
            else
                load(fullfile(bucket.pathToProcessedData,'selectedJointsReduced.mat'));
                load(fullfile(bucket.pathToProcessedData,'synchroKinReduced.mat'));
            end

            % Overwrite old variables with the new reduced variables
            selectedJoints = selectedJointsReduced;
            save(fullfile(bucket.pathToProcessedData,'selectedJoints.mat'),'selectedJoints');
            synchroKin = synchroKinReduced;
            save(fullfile(bucket.pathToProcessedData,'synchroKin.mat'),'synchroKin');
            % Remove useless quantities
            clearvars selectedJointsReduced synchroKinReduced;
        end

        %% ----------------------------------------------------------------
        %% ============================ RUN TIME ==========================
        %% ----------------------------------------------------------------
        %% Load URDF model with sensors
        disp('-------------------------------------------------------------------');
        disp('Loading the URDF model...');
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
        % humanSensors.removeAllSensorsOfType(iDynTree.THREE_AXIS_ANGULAR_ACCELEROMETER_SENSOR);

        %% Initialize berdy
        disp('Initializing berdy for the URDF model...');
        % Specify berdy options
        berdyOptions = iDynTree.BerdyOptions;

        berdyOptions.baseLink = bucket.base;
        berdyOptions.includeAllNetExternalWrenchesAsSensors          = true;
        berdyOptions.includeAllNetExternalWrenchesAsDynamicVariables = true;
        berdyOptions.includeAllJointAccelerationsAsSensors           = true;
        berdyOptions.includeAllJointTorquesAsSensors                 = false;
        berdyOptions.includeCoMAccelerometerAsSensorInTask1          = true;
        berdyOptions.includeCoMAccelerometerAsSensorInTask2          = false;
        berdyOptions.stackOfTasksMAP                                 = true;

        % Option useful for the new measurement equation
        %      X_{COMconstrainedLinks} * fˆx_{COMconstrainedLinks} = m * ddx_COM
        % where COMconstrainedLinks is a vector containing link names.
        COMconstrainedLinks = iDynTree.StringVector();
        COMconstrainedLinks.push_back('LeftFoot');
        COMconstrainedLinks.push_back('RightFoot');
        COMconstrainedLinks.push_back('LeftHand');
        COMconstrainedLinks.push_back('RightHand');
        berdyOptions.comConstraintLinkNamesVector = COMconstrainedLinks;

        berdyOptions.berdyVariant = iDynTree.BERDY_FLOATING_BASE;
        berdyOptions.includeFixedBaseExternalWrench = false;

        % Load berdy
        berdy = iDynTree.BerdyHelper;
        berdy.init(humanModel, humanSensors, berdyOptions);

        % Get the current traversal
        traversal = berdy.dynamicTraversal;

        % Floating base settings
        currentBase = berdy.model().getLinkName(traversal.getBaseLink().getIndex());
        disp(strcat('Current base is < ', currentBase,'>.'));
        human_kinDynComp.setFloatingBase(currentBase);
        baseKinDynModel = human_kinDynComp.getFloatingBase();
        % Consistency check: berdy.model base and human_kinDynComp.model have to be consistent!
        if currentBase ~= baseKinDynModel
            error(strcat('[ERROR] The berdy model base (',currentBerdyBase,') and the kinDyn model base (',baseKinDynModel,') do not match!'));
        end
 
        % Get the tree is visited IS the order of variables in vector d
        dVectorOrder = cell(traversal.getNrOfVisitedLinks(), 1); %for each link in the traversal get the name
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
        % printBerdyDynVariables_floating(berdy, opts.stackOfTaskMAP);
        % ---------------------------------------------------

        %% Add link angular acceleration sensors
        % iDynTree.THREE_AXIS_ANGULAR_ACCELEROMETER_SENSOR is not supported by the
        % URDF model.  It requires to be added differently.
        disp('-------------------------------------------------------------------');
        disp('[Start] Computing the link angular acceleration...');
        if exist(fullfile(bucket.pathToProcessedData,'angAcc_sensor.mat'), 'file')
            load(fullfile(bucket.pathToProcessedData,'angAcc_sensor.mat'));
        else
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
                        for lenSample = 1 : suit.properties.lenData
                            G_R_S_mat = quat2Mat(suit.sensors{angAccSensIdx, 1}.meas.sensorOrientation(:,lenSample));
                            angAcc_sensor(angAccSensIdx).meas.S_meas_L = G_R_S_mat' * suit.links{sampleToMatch, 1}.meas.angularAcceleration;
                        end
                        break;
                    end
                end
            end
            if ~opts.tuneCovarianceTest
                save(fullfile(bucket.pathToProcessedData,'angAcc_sensor.mat'),'angAcc_sensor');
            end
        end
        % Create new angular accelerometer sensor in berdy sensor
        for newSensIdx = 1 : length(suit.sensors)
            humanSensors = addAccAngSensorInBerdySensors(humanSensors,angAcc_sensor(newSensIdx).sensorName, ...
                angAcc_sensor(newSensIdx).attachedLink,angAcc_sensor(newSensIdx).iDynModelIdx, ...
                angAcc_sensor(newSensIdx).S_R_L, angAcc_sensor(newSensIdx).pos_SwrtL);
        end
        disp('[End] Computing the link angular acceleration.');

        %% Compute the transformation of the base w.r.t. the global suit frame G
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Computing the <',currentBase,'> iDynTree transform w.r.t. the global frame G...'));
        %--------Computation of the suit base orientation and position w.r.t. G
        for suitLinksIdx = 1 : size(suit.links,1)
            if strcmp(suit.links{suitLinksIdx, 1}.label, currentBase)
                bucket.basePosition_wrtG   = suit.links{suitLinksIdx, 1}.meas.position;
                bucket.baseOrientation = suit.links{suitLinksIdx, 1}.meas.orientation;
                break
            end
            break
        end
        G_T_base = computeTransformBaseToGlobalFrame(human_kinDynComp, ...
            synchroKin,...
            bucket.baseOrientation, ...
            bucket.basePosition_wrtG);
        disp(strcat('[End] Computing the <',currentBase,'> iDynTree transform w.r.t. the global frame G'));

        %% Contact pattern definition
        % Trials are performed with both the feet attached to the ground (i.e.,
        % doubleSupport).  No single support is assumed for this analysis.
        contactPattern = cell(length(synchroData.timestamp),1);
        for tmpIdx = 1 : length(synchroData.timestamp)
            contactPattern{tmpIdx} = 'doubleSupport';
        end

        %% Velocity of the currentBase
        % Code to handle the info of the velocity of the base.
        % This value is mandatorily required in the floating-base formalism.
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Computing the <',currentBase,'> velocity...'));
        [baseVel.baseLinVelocity, baseVel.baseAngVelocity] = computeBaseVelocity(human_kinDynComp, ...
            synchroKin,...
            G_T_base, ...
            contactPattern);
        % save
        if ~opts.tuneCovarianceTest
            save(fullfile(bucket.pathToProcessedData,'baseVel.mat'),'baseVel');
        end
        disp(strcat('[End] Computing the <',currentBase,'> velocity'));

        %% Compute the rate of change of centroidal momentum w.r.t. the base
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Computing the rate of change of centroidal momentum w.r.t. the <',currentBase,'>...'));
        if ~exist(fullfile(bucket.pathToProcessedData_SOTtask1,'base_dh.mat'), 'file')
            tmp.baseVelocity6D = [baseVel.baseLinVelocity ; baseVel.baseAngVelocity];
            base_dh = computeRateOfChangeOfCentroidalMomentumWRTbase(human_kinDynComp, humanModel, ...
                synchroKin, ...
                tmp.baseVelocity6D, ...
                G_T_base);
            save(fullfile(bucket.pathToProcessedData_SOTtask1,'base_dh.mat'),'base_dh');
        else
            load(fullfile(bucket.pathToProcessedData_SOTtask1,'base_dh.mat'),'base_dh');
        end
        disp(strcat('[End] Computing the rate of change of centroidal momentum w.r.t. the <',currentBase,'>'));
     end
end

%% ------------------------------------------------------------------------
%% ============================ EXO (if) ==================================
%% ------------------------------------------------------------------------

if opts.EXO && opts.task1_SOT
    %% Preliminaries
    bucket.pathToProcessedData_EXO   = fullfile(bucket.pathToProcessedData,'processed_EXO');
    if ~exist(bucket.pathToProcessedData_EXO)
        mkdir(bucket.pathToProcessedData_EXO)
    end
    % Load raw meas from EXO table
    loadSPEXORtableMeas;

    % Define beam length - subject pairing --> TODO
    % hp --> S021 --> beam28

    %% Extract measurements from SPEXOR angles compatible with the suit
    % The assumption is to consider the kinematic of the pelvis around
    % jL5S1 roty equal to the beta angle of the SPEXOR analysis
    L5S1rotyAngleInRad = synchroKin.q(2,:)';
    lenKinVect = length(L5S1rotyAngleInRad);
    % Check if there are negative angles.  In case they have to be removed
    % and set to 0.  The removal is required since is not coverd by the exo angle.
    for lenIdx = 1 : lenKinVect
        if L5S1rotyAngleInRad(lenIdx) < 0
            L5S1rotyAngleInRad(lenIdx) = 0;
        end
    end
    L5S1rotyAngleInRad_rounded = round(L5S1rotyAngleInRad,3);

    % Extraction from SPEXOR table according to L5S1rotyAngleInRad_rounded
    for lenSuitIdx = 1: lenKinVect
        for exoTableIdx = 1 : length(EXO.betaInRad)
            if round(L5S1rotyAngleInRad_rounded(lenSuitIdx,1) - EXO.betaInRad(exoTableIdx,1),1) == 0
                EXO.roundedTable(1).beamHeight(lenSuitIdx)     = EXO.extractedTable(1).beamHeight(exoTableIdx);
                EXO.roundedTable(1).beamDeviation(lenSuitIdx)  = EXO.extractedTable(1).beamDeviation(exoTableIdx);
                EXO.roundedTable(1).beamLength(lenSuitIdx)     = EXO.extractedTable(1).beamLength(exoTableIdx);
                EXO.roundedTable(1).beamDeflection(lenSuitIdx) = EXO.extractedTable(1).beamDeflection(exoTableIdx);
                EXO.roundedTable(1).force(lenSuitIdx)          = EXO.extractedTable(1).force(exoTableIdx);
                EXO.roundedTable(1).beamBaseMoment(lenSuitIdx) = EXO.extractedTable(1).beamBaseMoment(exoTableIdx);
                EXO.roundedTable(1).alpha(lenSuitIdx)          = EXO.extractedTable(1).alpha(exoTableIdx);
            end
        end
    end

    %% Transform forces from the EXO into human forces
    disp('-------------------------------------------------------------------');
    disp('[Start] Transforming EXO force in human frames...');
    transformSPEXORforcesInHumanFrames;
    if ~opts.tuneCovarianceTest
        save(fullfile(bucket.pathToProcessedData_EXO,'EXOfext.mat'),'EXOfext');
    end
    disp('[End] Transforming EXO force in human frames');
end

%% ------------------------------------------------------------------------
%% ====================== MEASUREMENTS WRAPING ============================
%% ------------------------------------------------------------------------
disp('-------------------------------------------------------------------');
disp('[Start] Wrapping measurements...');
fext.rightHuman = forceplates.humanRightFootWrench;
fext.leftHuman  = forceplates.humanLeftFootWrench;

data  = dataPackaging(humanModel,...
    currentBase, ...
    humanSensors,...
    suit,...
    angAcc_sensor, ...
    fext,...
    base_dh, ...
    synchroKin.ddq,...
    bucket.contactLink, ...
    priors, ...
    opts.stackOfTaskMAP);

if opts.EXO
    % Find links where SPEXOR forces are acting
    lenCheck = length(data);
    for idIdx = 1 : lenCheck
        if strcmp(data(idIdx).id,'T8')
            tmp.T8Idx = idIdx;
        end
        if strcmp(data(idIdx).id,'Pelvis')
            tmp.pelvisIdx = idIdx;
        end
    end
    % Add to data struct the EXO forces
    % T8
    data(tmp.T8Idx).meas = EXOfext.T8;
    data(tmp.T8Idx).var  = priors.exo_fext;
    % PELVIS
    data(tmp.pelvisIdx).meas = EXOfext.PELVIS;
    data(tmp.pelvisIdx).var  = priors.exo_fext;
end

if ~opts.task1_SOT %Task2
    estimatedFextFromSOTtask1 = load(fullfile(bucket.pathToProcessedData_SOTtask1,'estimatedVariables.mat'));
    for linkIdx = 1 : length(estimatedFextFromSOTtask1.estimatedVariables.Fext.label)
        for dataIdx = 1 : length(data)
            if strcmp(data(dataIdx).id, estimatedFextFromSOTtask1.estimatedVariables.Fext.label{linkIdx})
                data(dataIdx).meas = estimatedFextFromSOTtask1.estimatedVariables.Fext.values(6*(linkIdx-1)+1:6*linkIdx,:);
                break;
            end
        end
    end
end

% y vector as input for MAP
[y, Sigmay] = berdyMeasurementsWrapping(berdy, data, opts.stackOfTaskMAP);

if opts.task1_SOT
    % modify variances for the external forces at the hands
    range_leftHand = rangeOfSensorMeasurement(berdy, iDynTree.NET_EXT_WRENCH_SENSOR, 'LeftHand',opts.stackOfTaskMAP);
    Sigmay(range_leftHand:range_leftHand+5,range_leftHand:range_leftHand+5) = diag(priors.fext_hands);
    
    range_rightHand = rangeOfSensorMeasurement(berdy, iDynTree.NET_EXT_WRENCH_SENSOR, 'RightHand',opts.stackOfTaskMAP);
    Sigmay(range_rightHand:range_rightHand+5,range_rightHand:range_rightHand+5) = diag(priors.fext_hands);
end
disp('[End] Wrapping measurements');

if opts.tuneCovarianceTest
    % Saving data
    if opts.task1_SOT
        save(fullfile(bucket.pathToProcessedData_SOTtask1,'data.mat'),'data');
    else
        save(fullfile(bucket.pathToProcessedData_SOTtask2,'data.mat'),'data');
    end
end
% ---------------------------------------------------
% CHECK: print the order of measurement in y
% printBerdySensorOrder(berdy, opts.stackOfTaskMAP);
% ---------------------------------------------------

%% ------------------------------------------------------------------------
%% ================================== MAP =================================
%% ------------------------------------------------------------------------
%% ------------------------------- MAP ------------------------------------
%% Set MAP priors
priors.mud    = zeros(berdy.getNrOfDynamicVariables(opts.stackOfTaskMAP), 1);
priors.Sigmad = bucket.Sigmad * eye(berdy.getNrOfDynamicVariables(opts.stackOfTaskMAP));
priors.SigmaD = bucket.SigmaD * eye(berdy.getNrOfDynamicEquations(opts.stackOfTaskMAP));

%% Possibility to remove a sensor from the analysis
% excluding the accelerometers and gyroscope for whose removal already
% exists the iDynTree option.
sensorsToBeRemoved = [];

% bucket.temp.type = iDynTree.NET_EXT_WRENCH_SENSOR;
% bucket.temp.id = 'LeftHand';
% sensorsToBeRemoved = [sensorsToBeRemoved; bucket.temp];
% % %
% bucket.temp.type = iDynTree.NET_EXT_WRENCH_SENSOR;
% bucket.temp.id = 'RightHand';
% sensorsToBeRemoved = [sensorsToBeRemoved; bucket.temp];
% % %
% % bucket.temp.type = iDynTree.NET_EXT_WRENCH_SENSOR;
% % bucket.temp.id = 'RightFoot';
% % sensorsToBeRemoved = [sensorsToBeRemoved; bucket.temp];
% %
% % bucket.temp.type = iDynTree.NET_EXT_WRENCH_SENSOR;
% % bucket.temp.id = 'LeftFoot';
% % sensorsToBeRemoved = [sensorsToBeRemoved; bucket.temp];

%% MAP computation
priors.Sigmay = Sigmay;
if opts.Sigma_dgiveny
    disp('-------------------------------------------------------------------');
    disp('[Start] Complete MAP computation ...');
    [estimation.mu_dgiveny, estimation.Sigma_dgiveny] = MAPcomputation_floating(berdy, ...
        traversal, ...
        synchroKin,...
        y, ...
        G_T_base, ...
        priors, ...
        baseVel.baseAngVelocity, ...
        opts, ...
        'SENSORS_TO_REMOVE', sensorsToBeRemoved);
    disp('[End] Complete MAP computation');
    % TODO: variables extraction
    % Sigma_tau extraction from Sigma d --> since sigma d is very big, it
    % cannot be saved! therefore once computed it is necessary to extract data
    % related to tau and save that one!
    % TODO: extractSigmaOfEstimatedVariables
else
    disp('-------------------------------------------------------------------');
    disp('[Start] Complete MAP computation ...');
    estimation.mu_dgiveny = MAPcomputation_floating(berdy, ...
        traversal, ...
        synchroKin,...
        y, ...
        G_T_base, ...
        priors, ...
        baseVel.baseAngVelocity, ...
        opts, ...
        'SENSORS_TO_REMOVE', sensorsToBeRemoved);
    disp('[End] Complete MAP computation');
end

if opts.task1_SOT
    save(fullfile(bucket.pathToProcessedData_SOTtask1,'estimation.mat'),'estimation');
else
    save(fullfile(bucket.pathToProcessedData_SOTtask2,'estimation.mat'),'estimation');
end

%% Variables extraction from MAP estimation
% if Task1 --> extract only fext
% if Task2 --> extract all

% fext extraction (no via Berdy)
disp('-------------------------------------------------------------------');
disp('[Start] External force MAP extraction ...');
estimatedVariables.Fext.label  = dVectorOrder;
estimatedVariables.Fext.values = extractEstimatedFext_from_mu_dgiveny(berdy, ...
    dVectorOrder, ...
    estimation.mu_dgiveny, ...
    opts.stackOfTaskMAP);
disp('[End] External force MAP extraction');

if opts.task1_SOT
    save(fullfile(bucket.pathToProcessedData_SOTtask1,'estimatedVariables.mat'),'estimatedVariables');
end
disp('[End] External force MAP extraction');

if ~opts.task1_SOT
    % 6D acceleration (no via Berdy)
    disp('-------------------------------------------------------------------');
    disp('[Start] Acceleration MAP extraction ...');
    estimatedVariables.Acc.label  = dVectorOrder;
    estimatedVariables.Acc.values = extractEstimatedAcc_from_mu_dgiveny(berdy, ...
        dVectorOrder, ...
        estimation.mu_dgiveny, ...
        opts.stackOfTaskMAP);
    disp('[End] Acceleration MAP extraction');
    % torque extraction (via Berdy)
    disp('-------------------------------------------------------------------');
    disp('[Start] Torque MAP extraction ...');
    estimatedVariables.tau.label  = selectedJoints;
    estimatedVariables.tau.values = extractEstimatedTau_from_mu_dgiveny(berdy, ...
        estimation.mu_dgiveny, ...
        synchroKin.q);
    disp('[End] Torque MAP extraction');
    % joint acc extraction (no via Berdy)
    disp('-------------------------------------------------------------------');
    disp('[Start] Joint acceleration MAP extraction ...');
    estimatedVariables.ddq.label  = selectedJoints;
    %     estimatedVariables.ddq.values = extractEstimatedDdq_from_mu_dgiveny_floating(berdy, ...
    %         selectedJoints, ...
    %         estimation.mu_dgiveny);
    % ---------------------------
    estimatedVariables.ddq.values = estimation.mu_dgiveny(...
        length(estimation.mu_dgiveny)-(humanModel.getNrOfDOFs-1) : size(estimation.mu_dgiveny,1) ,:);
    % ---------------------------
    disp('[End] Joint acceleration MAP extraction');
    % fint extraction (no via Berdy)
    disp('-------------------------------------------------------------------');
    disp('[Start] Internal force MAP extraction ...');
    estimatedVariables.Fint.label  = selectedJoints;
    estimatedVariables.Fint.values = extractEstimatedFint_from_mu_dgiveny(berdy, ...
        selectedJoints, ...
        estimation.mu_dgiveny, ...
        opts.stackOfTaskMAP);
    disp('[End] Internal force MAP extraction');
    
    % save extracted viariables
    save(fullfile(bucket.pathToProcessedData_SOTtask2,'estimatedVariables.mat'),'estimatedVariables');
end

%% Simulated y
% This section is useful to compare the measurements in the y vector and
% the results of the MAP.  Note: you cannot compare directly the results of
% the MAP (i.e., mu_dgiveny) with the measurements in the y vector but you
% have to pass through the y_sim and only later to compare y and y_sim.
disp('-------------------------------------------------------------------');
disp('[Start] Simulated y computation ...');
y_sim = sim_y_floating(berdy, ...
    synchroKin,...
    traversal, ...
    G_T_base, ...
    baseVel.baseAngVelocity, ...
    estimation.mu_dgiveny, ...
    opts);
disp('[End] Simulated y computation');

if opts.task1_SOT
    save(fullfile(bucket.pathToProcessedData_SOTtask1,'y_sim.mat'),'y_sim');
else
    save(fullfile(bucket.pathToProcessedData_SOTtask2,'y_sim.mat'),'y_sim');
end

%% Variables extraction from y_sim
extractSingleVar_from_y_sim_all;


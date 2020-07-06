
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%--------------------------------------------------------------------------
% JSI_experiments main
%--------------------------------------------------------------------------
bucket.pathToSubject = fullfile(bucket.datasetRoot, sprintf('S%02d',subjectID));
bucket.pathToTask    = fullfile(bucket.pathToSubject,sprintf('Task%d',taskID));
bucket.pathToRawData = fullfile(bucket.pathToTask,'data');
bucket.pathToProcessedData   = fullfile(bucket.pathToTask,'processed');

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
    % Extraction of the masterFile
    masterFile = load(fullfile(bucket.pathToRawData,sprintf(('S%02d_%02d.mat'),subjectID,taskID)));
    % Option for computing the estimated Sigma
    opts.Sigma_dgiveny = false;

    % Define the template to be used
    if opts.noC7joints
        addpath(genpath('templatesNoC7'));
        rmpath('templates'); %if exists
        disp('[Warning]: The following analysis will be done with C7joints locked/fixed in the models!');
    else
        addpath(genpath('templates'));
        rmpath('templatesNoC7'); %if exists
    end

    %% SUIT struct creation
    if ~exist(fullfile(bucket.pathToProcessedData,'suit.mat'), 'file')
        disp('-------------------------------------------------------------------');
        disp('[Start] Suit extraction ...');
        % 1) extract data from C++ parsed files
        extractSuitDataFromParsing;
        % 2) compute sensor position
        suit = computeSuitSensorPosition(suit);
        save(fullfile(bucket.pathToProcessedData,'suit.mat'),'suit');
        disp('[End] Suit extraction');
    else
        load(fullfile(bucket.pathToProcessedData,'suit.mat'));
    end

    %% IMPORTANT NOTE:
    % The subjects performed the experimental tasks with the drill on the right
    % hand. This code will be modified for taking into account the presence of
    % the drill. URDF/OSIM models and IK computation will be affected
    % by this change.

    %% Extract subject parameters from SUIT
    if ~exist(fullfile(bucket.pathToSubject,'subjectParamsFromData.mat'), 'file')
        subjectParamsFromData = subjectParamsComputation(suit, masterFile.Subject.Info.Weight);
        save(fullfile(bucket.pathToSubject,'subjectParamsFromData.mat'),'subjectParamsFromData');
    else
        load(fullfile(bucket.pathToSubject,'subjectParamsFromData.mat'),'subjectParamsFromData');
    end

    if opts.EXO && opts.EXO_torqueLevelAnalysis
        % Add manually the mass of the exo (1.8 kg) on the pelvis:
        if ~exist(fullfile(bucket.pathToSubject,'subjectParamsFromDataEXO.mat'), 'file')
            subjectParamsFromDataEXO = subjectParamsFromData;
            subjectParamsFromDataEXO.pelvisMass = subjectParamsFromData.pelvisMass + 1.8;
            subjectParamsFromDataEXO.pelvisIxx  = (subjectParamsFromDataEXO.pelvisMass/12) * ...
                ((subjectParamsFromData.pelvisBox(2))^2 + (subjectParamsFromData.pelvisBox(3))^2);
            subjectParamsFromDataEXO.pelvisIyy  = (subjectParamsFromDataEXO.pelvisMass/12) * ...
                ((subjectParamsFromData.pelvisBox(3))^2 + (subjectParamsFromData.pelvisBox(1))^2);
            subjectParamsFromDataEXO.pelvisIzz  = (subjectParamsFromDataEXO.pelvisMass/12) * ...
                ((subjectParamsFromData.pelvisBox(3))^2 + (subjectParamsFromData.pelvisBox(2))^2);

            save(fullfile(bucket.pathToSubject,'subjectParamsFromDataEXO.mat'),'subjectParamsFromDataEXO');
        else
            load(fullfile(bucket.pathToSubject,'subjectParamsFromDataEXO.mat'),'subjectParamsFromDataEXO');
        end
    end

    %% Create URDF model
    if opts.noC7joints
        % model NO exo, with C7 joints FIXED
        bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj%02d_48dof_noC7.urdf', subjectID));
        if ~exist(bucket.filenameURDF, 'file')
            bucket.URDFmodel = createXsensLikeURDFmodel(subjectParamsFromData, ...
                suit.sensors,...
                'filename',bucket.filenameURDF,...
                'GazeboModel',false);
        end
        % model WITH exo, with C7 joints FIXED
        if opts.EXO && opts.EXO_torqueLevelAnalysis
            bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj%02d_48dof_EXO_noC7.urdf', subjectID));
            if ~exist(bucket.filenameURDF, 'file')
                bucket.URDFmodel = createXsensLikeURDFmodel(subjectParamsFromDataEXO, ...
                    suit.sensors,...
                    'filename',bucket.filenameURDF,...
                    'GazeboModel',false);
            end
        end
    else
        % model NO exo  or EXO in forceLevelAnalysis, with C7 joints (complete) REVOLUTE
        bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj%02d_48dof.urdf', subjectID));
        if ~exist(bucket.filenameURDF, 'file')
            bucket.URDFmodel = createXsensLikeURDFmodel(subjectParamsFromData, ...
                suit.sensors,...
                'filename',bucket.filenameURDF,...
                'GazeboModel',false);
        end
        % model WITH exo in torqueLevelAnalysis, with C7 joints (complete) REVOLUTE
        if opts.EXO && opts.EXO_torqueLevelAnalysis
            bucket.filenameURDF = fullfile(bucket.pathToSubject, sprintf('XSensURDF_subj%02d_48dof_EXO.urdf', subjectID));
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
        bucket.filenameOSIM = fullfile(bucket.pathToSubject, sprintf('XSensOSIM_subj%02d_48dof_noC7.osim', subjectID));
        if ~exist(bucket.filenameOSIM, 'file')
            bucket.OSIMmodel = createXsensLikeOSIMmodel(subjectParamsFromData, ...
                bucket.filenameOSIM);
        end
        % model WITH exo, with C7 joints LOCKED
        if opts.EXO && opts.EXO_torqueLevelAnalysis
            bucket.filenameOSIM = fullfile(bucket.pathToSubject, sprintf('XSensOSIM_subj%02d_48dof_EXO_noC7.osim', subjectID));
            if ~exist(bucket.filenameOSIM, 'file')
                bucket.OSIMmodel = createXsensLikeOSIMmodel(subjectParamsFromDataEXO, ...
                    bucket.filenameOSIM);
            end
        end
    else
        % model NO exo or EXO in forceLevelAnalysis, with C7 joints (complete) UNLOCKED
        bucket.filenameOSIM = fullfile(bucket.pathToSubject, sprintf('XSensOSIM_subj%02d_48dof.osim', subjectID));
        if ~exist(bucket.filenameOSIM, 'file')
            bucket.OSIMmodel = createXsensLikeOSIMmodel(subjectParamsFromData, ...
                bucket.filenameOSIM);
        end
        % model WITH exo in torqueLevelAnalysis, with C7 joints (complete) UNLOCKED
        if opts.EXO && opts.EXO_torqueLevelAnalysis
            bucket.filenameOSIM = fullfile(bucket.pathToSubject, sprintf('XSensOSIM_subj%02d_48dof_EXO.osim', subjectID));
            if ~exist(bucket.filenameOSIM, 'file')
                bucket.OSIMmodel = createXsensLikeOSIMmodel(subjectParamsFromDataEXO, ...
                    bucket.filenameOSIM);
            end
        end
    end
    %% Inverse Kinematic computation
    if ~exist(fullfile(bucket.pathToProcessedData,'human_state_tmp.mat'), 'file')
        disp('-------------------------------------------------------------------');
        disp('[Start] IK computation ...');
        bucket.setupFile = fullfile(pwd, 'templates', 'setupOpenSimIKTool_Template.xml');
        bucket.trcFile   = fullfile(bucket.pathToRawData,sprintf('S%02d_%02d.trc',subjectID,taskID));
        bucket.motFile   = fullfile(bucket.pathToProcessedData,sprintf('S%02d_%02d.mot',subjectID,taskID));
        [human_state_tmp, selectedJoints] = IK(bucket.filenameOSIM, ...
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

    %% q, dq, ddq signals filtering
    Sg.samplingTime = 1/(suit.properties.frameRate);
    % because the signal have been downsampled to align the suit signals
    Sg.polinomialOrder = 3;
    Sg.window = 407;

    for jntIdx = 1 : length(selectedJoints)
        [human_state_tmp_q_2tbr(jntIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            human_state_tmp.q(jntIdx,:),Sg.samplingTime);
        [human_state_tmp_dq_2tbr(jntIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            human_state_tmp.dq(jntIdx,:),Sg.samplingTime);
        [human_ddq_tmp_2tbr(jntIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            human_ddq_tmp(jntIdx,:),Sg.samplingTime);
    end
    human_state_tmp.q  = human_state_tmp_q_2tbr;
    human_state_tmp.dq = human_state_tmp_dq_2tbr;
    human_ddq_tmp = human_ddq_tmp_2tbr;

    % Remove useless quantities
    clearvars human_state_tmp_q_2tbr human_state_tmp_dq_2tbr human_ddq_tmp_2tbr;

    %% Raw data handling
    rawDataHandling;

    %% Covariance tuning test
    if opts.tuneCovarianceTest
        blockID = 1; %considering only one trial for covariance tuning
    else
        blockID = 1 : block.nrOfBlocks;
    end

    if ~opts.tuneCovarianceTest || powerIdx == 1
        %% Save synchroData with the kinematics infos
        fieldsToBeRemoved = {'RightShoe_SF','LeftShoe_SF','FP_SF'};
        synchroKin = rmfield(synchroData,fieldsToBeRemoved);
        % save
        if ~opts.tuneCovarianceTest
            save(fullfile(bucket.pathToProcessedData,'synchroKin.mat'),'synchroKin');
        end

        %% Transform forces into human forces
        % Preliminary assumption on contact links: 2 contacts only (or both feet
        % with the shoes or both feet with two force plates)
        bucket.contactLink = cell(2,1);

        % Define contacts configuration
        bucket.contactLink{1} = 'RightFoot'; % human link in contact with RightShoe
        bucket.contactLink{2} = 'LeftFoot';  % human link in contact with LeftShoe
        for blockIdx = blockID
            shoes(blockIdx) = transformShoesWrenches(synchroData(blockIdx), subjectParamsFromData);
        end

        %% Shoes signal filtering
        Sg.samplingTime = 1/(suit.properties.frameRate);
        % because the signals of the shoes have been downsampled to align the suit signals
        Sg.polinomialOrder = 3;
        Sg.window = 407;

        for blockIdx = blockID
            for elemIdx = 1 : 6
                [shoes2tbr(blockIdx).Left_HF(elemIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
                    shoes(blockIdx).Left_HF(elemIdx,:),Sg.samplingTime);
                [shoes2tbr(blockIdx).Right_HF(elemIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
                    shoes(blockIdx).Right_HF(elemIdx,:),Sg.samplingTime);
            end
            shoes(blockIdx).Left_HF = shoes2tbr(blockIdx).Left_HF;
            shoes(blockIdx).Right_HF = shoes2tbr(blockIdx).Right_HF;
        end
        % Remove useless quantities
        clearvars shoes2tbr;

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

        %% ------------------------RUNTIME PROCEDURE-------------------------------
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

        % Angular Acceleration struct
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
                            for blockIdx = blockID
                                % ---Labels
                                angAcc_sensor(angAccSensIdx).meas(blockIdx).block  = block.labels(blockIdx);
                                % ---Cut meas
                                tmp.cutRange{blockIdx} = (tmp.blockRange(blockIdx).first : tmp.blockRange(blockIdx).last);
                                angAcc_sensor(angAccSensIdx).meas(blockIdx).S_meas_L = G_R_S_mat' * suit.links{sampleToMatch, 1}.meas.angularAcceleration(:,tmp.cutRange{blockIdx});
                            end
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
            if suit.links{suitLinksIdx, 1}.label == currentBase
                basePos_tot  = suit.links{suitLinksIdx, 1}.meas.position;
                baseOrientation_tot = suit.links{suitLinksIdx, 1}.meas.orientation;
                break
            end
            break
        end

        for blockIdx = blockID
            tmp.cutRange{blockIdx} = (tmp.blockRange(blockIdx).first : tmp.blockRange(blockIdx).last);
            bucket.basePosition(blockIdx).basePos_wrtG  = basePos_tot(:,tmp.cutRange{blockIdx});
            bucket.orientation(blockIdx).baseOrientation = baseOrientation_tot(:,tmp.cutRange{blockIdx});
        end
        clearvars basePos_tot baseOrientation_tot;

        for blockIdx = blockID
            G_T_base(blockIdx).block = block.labels(blockIdx);
            G_T_base(blockIdx).G_T_b = computeTransformBaseToGlobalFrame(human_kinDynComp, ...
                synchroKin(blockIdx),...
                bucket.orientation(blockIdx).baseOrientation, ...
                bucket.basePosition(blockIdx).basePos_wrtG);
        end
        disp(strcat('[End] Computing the <',currentBase,'> iDynTree transform w.r.t. the global frame G'));

        %% Contact pattern definition
        % Trials are performed with both the feet attached to the ground (i.e.,
        % doubleSupport).  No single support is assumed for this analysis.
        for blockIdx = blockID
            contactPattern(blockIdx).block = block.labels(blockIdx);
            contactPattern(blockIdx).contactPattern = cell(length(synchroKin(blockIdx).masterTime),1);
            for tmpIdx = 1 : length(synchroKin(blockIdx).masterTime)
                contactPattern(blockIdx).contactPattern{tmpIdx} = 'doubleSupport';
            end
        end

        %% Velocity of the currentBase
        % Code to handle the info of the velocity of the base.
        % This value is mandatorily required in the floating-base formalism.
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Computing the <',currentBase,'> velocity...'));
        for blockIdx = blockID
            baseVel(blockIdx).block = block.labels(blockIdx);
            [baseVel(blockIdx).baseLinVelocity, baseVel(blockIdx).baseAngVelocity] = computeBaseVelocity(human_kinDynComp, ...
                synchroKin(blockIdx),...
                G_T_base(blockIdx), ...
                contactPattern(blockIdx).contactPattern);
        end
        % save
        if ~opts.tuneCovarianceTest
            save(fullfile(bucket.pathToProcessedData,'baseVel.mat'),'baseVel');
        end
        disp(strcat('[End] Computing the <',currentBase,'> velocity'));

        %% Compute the rate of change of centroidal momentum w.r.t. the base
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Computing the rate of change of centroidal momentum w.r.t. the <',currentBase,'>...'));
        if ~exist(fullfile(bucket.pathToProcessedData_SOTtask1,'base_dh.mat'), 'file')
            for blockIdx = blockID
                base_dh(blockIdx).block = block.labels(blockIdx);
                tmp.baseVelocity6D = [baseVel(blockIdx).baseLinVelocity ; baseVel(blockIdx).baseAngVelocity];
                base_dh(blockIdx).base_dh = computeRateOfChangeOfCentroidalMomentumWRTbase(human_kinDynComp, humanModel, ...
                    synchroKin(blockIdx), ...
                    tmp.baseVelocity6D, ...
                    G_T_base(blockIdx).G_T_b);
            end
            save(fullfile(bucket.pathToProcessedData_SOTtask1,'base_dh.mat'),'base_dh');
        else
            load(fullfile(bucket.pathToProcessedData_SOTtask1,'base_dh.mat'),'base_dh');
        end
        disp(strcat('[End] Computing the rate of change of centroidal momentum w.r.t. the <',currentBase,'>'));
    end
end

%% EXO analysis (if)
if opts.EXO && opts.task1_SOT
    bucket.pathToProcessedData_EXO   = fullfile(bucket.pathToProcessedData,'processed_EXO');
    if ~exist(bucket.pathToProcessedData_EXO)
        mkdir(bucket.pathToProcessedData_EXO)
    end
    % Load raw meas from EXO table
    loadEXOtableMeas;
    % Compute angles compatible with the EXO
    computeAnglesFromEXO;
    if ~opts.tuneCovarianceTest
        save(fullfile(bucket.pathToProcessedData_EXO,'CoC.mat'),'CoC');
    end

    % Extraction and round of the shoulder angle vectors
    for blockIdx = blockID
        % -------Right shoulder
        EXO.tmp.qToCompare_right = (- CoC(blockIdx).Rsho_qFirst(1,:) + 90)'; % operation to compare the angles: change sign and then +90 deg
        EXO.rightRoundedTable(blockIdx).block = block.labels(blockIdx);
        EXO.rightRoundedTable(blockIdx).qToCompare_right_round = round(EXO.tmp.qToCompare_right);

        % -------Left shoulder
        EXO.tmp.qToCompare_left = (CoC(blockIdx).Lsho_qFirst(1,:) + 90)'; % operation to compare the angles: +90 deg
        EXO.leftRoundedTable(blockIdx).block = block.labels(blockIdx);
        EXO.leftRoundedTable(blockIdx).qToCompare_left_round = round(EXO.tmp.qToCompare_left);
    end

    % Extraction from table of values accordingly to the shoulder angle vectors (rounded_q)
    for blockIdx = blockID
        % -------Right
        for qIdx = 1 : size(EXO.rightRoundedTable(blockIdx).qToCompare_right_round,1)
            for tableIdx = 1 : size(EXO.extractedTable(subjectID).shoulder_angles,1)
                if (EXO.rightRoundedTable(blockIdx).qToCompare_right_round(qIdx) == EXO.extractedTable(subjectID).shoulder_angles(tableIdx,1))
                    EXO.rightRoundedTable(blockIdx).F_arm_scher(qIdx)   = EXO.extractedTable(subjectID).F_arm_scher(tableIdx,1);
                    EXO.rightRoundedTable(blockIdx).F_arm_support(qIdx) = EXO.extractedTable(subjectID).F_arm_support(tableIdx,1);
                    % EXO.rightRoundedTable(blockIdx).F_ASkraft_x(qIdx)   = EXO.extractedTable(subjectID).F_ASkraft_x(tableIdx,1);
                    % EXO.rightRoundedTable(blockIdx).F_ASkraft_y(qIdx)   = EXO.extractedTable(subjectID).F_ASkraft_y(tableIdx,1);
                    EXO.rightRoundedTable(blockIdx).F_KGkraft_x(qIdx)   = EXO.extractedTable(subjectID).F_KGkraft_x(tableIdx,1);
                    EXO.rightRoundedTable(blockIdx).F_KGkraft_y(qIdx)   = EXO.extractedTable(subjectID).F_KGkraft_y(tableIdx,1);
                    EXO.rightRoundedTable(blockIdx).M_support_mod(qIdx) = EXO.extractedTable(subjectID).M_support_mod(tableIdx,1);
                end
            end
        end
        % -------Left
        for qIdx = 1 : size(EXO.leftRoundedTable(blockIdx).qToCompare_left_round,1)
            for tableIdx = 1 : size(EXO.extractedTable(subjectID).shoulder_angles,1)
                if (EXO.leftRoundedTable(blockIdx).qToCompare_left_round(qIdx) == EXO.extractedTable(subjectID).shoulder_angles(tableIdx,1))
                    EXO.leftRoundedTable(blockIdx).F_arm_scher(qIdx)   = EXO.extractedTable(subjectID).F_arm_scher(tableIdx,1);
                    EXO.leftRoundedTable(blockIdx).F_arm_support(qIdx) = EXO.extractedTable(subjectID).F_arm_support(tableIdx,1);
                    % EXO.leftRoundedTable(blockIdx).F_ASkraft_x(qIdx)   = EXO.extractedTable(subjectID).F_ASkraft_x(tableIdx,1);
                    % EXO.leftRoundedTable(blockIdx).F_ASkraft_y(qIdx)   = EXO.extractedTable(subjectID).F_ASkraft_y(tableIdx,1);
                    EXO.leftRoundedTable(blockIdx).F_KGkraft_x(qIdx)   = EXO.extractedTable(subjectID).F_KGkraft_x(tableIdx,1);
                    EXO.leftRoundedTable(blockIdx).F_KGkraft_y(qIdx)   = EXO.extractedTable(subjectID).F_KGkraft_y(tableIdx,1);
                    EXO.leftRoundedTable(blockIdx).M_support_mod(qIdx) = EXO.extractedTable(subjectID).M_support_mod(tableIdx,1);
                end
            end
        end
    end

    % Transform forces from the EXO into human forces
    disp('-------------------------------------------------------------------');
    disp('[Start] Transforming EXO force in human frames...');
    transformEXOforcesInHumanFrames;
    if ~opts.tuneCovarianceTest
        save(fullfile(bucket.pathToProcessedData_EXO,'EXOfext.mat'),'EXOfext');
    end
    disp('[End] Transforming EXO force in human frames');
end

%% Measurements wrapping
disp('-------------------------------------------------------------------');
disp('[Start] Wrapping measurements...');
for blockIdx = blockID
    fext.rightHuman = shoes(blockIdx).Right_HF;
    fext.leftHuman  = shoes(blockIdx).Left_HF;
    
    data(blockIdx).block = block.labels(blockIdx);
    data(blockIdx).data  = dataPackaging(blockIdx, ...
        humanModel,...
        currentBase, ...
        humanSensors,...
        suit_runtime,...
        angAcc_sensor, ...
        fext,...
        base_dh(blockIdx).base_dh, ...
        synchroKin(blockIdx).ddq,...
        bucket.contactLink, ...
        priors, ...
        opts.stackOfTaskMAP);

    if opts.EXO
        % Find links where EXO forces are acting
        lenCheck = length(data(blockIdx).data);
        for idIdx = 1 : lenCheck
            if strcmp(data(1).data(idIdx).id,'Pelvis')
                tmp.pelvisIdx = idIdx;
            end
            if strcmp(data(1).data(idIdx).id,'LeftUpperArm')
                tmp.LUAIdx = idIdx;
            end
            if strcmp(data(1).data(idIdx).id,'RightUpperArm')
                tmp.RUAIdx = idIdx;
            end
        end
        % Add to data struct the EXO forces
        % PELVIS
        data(blockIdx).data(tmp.pelvisIdx).meas = EXOfext(blockIdx).PELVIS;
        data(blockIdx).data(tmp.pelvisIdx).var  = priors.exo_fext;
        % LUA
        data(blockIdx).data(tmp.LUAIdx).meas = EXOfext(blockIdx).LUA;
        data(blockIdx).data(tmp.LUAIdx).var  = priors.exo_fext;
        % RUA
        data(blockIdx).data(tmp.RUAIdx).meas = EXOfext(blockIdx).RUA;
        data(blockIdx).data(tmp.RUAIdx).var  = priors.exo_fext;
    end

    if ~opts.task1_SOT %Task2
        estimatedFextFromSOTtask1 = load(fullfile(bucket.pathToProcessedData_SOTtask1,'estimatedVariables.mat'));
        for linkIdx = 1 : length(estimatedFextFromSOTtask1.estimatedVariables.Fext(blockIdx).label)
            for dataIdx = 1 : length(data)
                if strcmp(data(blockIdx).data(dataIdx).id, estimatedFextFromSOTtask1.estimatedVariables.Fext(blockIdx).label{linkIdx})
                    data(blockIdx).data(dataIdx).meas = estimatedFextFromSOTtask1.estimatedVariables.Fext(blockIdx).values(6*(linkIdx-1)+1:6*linkIdx,:);
                    break;
                end
            end
        end
    end

    % y vector as input for MAP
    [data(blockIdx).y, data(blockIdx).Sigmay] = berdyMeasurementsWrapping(berdy, ...
        data(blockIdx).data, ...
        opts.stackOfTaskMAP);

    if opts.task1_SOT
        % modify variances for the external forces at the hands
        range_leftHand = rangeOfSensorMeasurement(berdy, iDynTree.NET_EXT_WRENCH_SENSOR, 'LeftHand',opts.stackOfTaskMAP);
        data(blockIdx).Sigmay(range_leftHand:range_leftHand+5,range_leftHand:range_leftHand+5) = diag(priors.fext_hands);

        range_rightHand = rangeOfSensorMeasurement(berdy, iDynTree.NET_EXT_WRENCH_SENSOR, 'RightHand',opts.stackOfTaskMAP);
        data(blockIdx).Sigmay(range_rightHand:range_rightHand+5,range_rightHand:range_rightHand+5) = diag(priors.fext_hands);
    end
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

%% --------------------------- ID comparisons -----------------------------
% Section to benchmark MAP with
% - iDynTree::kinDynComputation::InverseDynamics()
% - iDynTree::ExtWrenchesAndJointTorquesEstimator::estimateExtWrenchesAndJointTorques()
if opts.MAPbenchmarking
    MAPbenchmarking;
end

%% MAP computation
for blockIdx = blockID
    priors.Sigmay = data(blockIdx).Sigmay;
    estimation(blockIdx).block = block.labels(blockIdx);
    if opts.Sigma_dgiveny
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Complete MAP computation for Block ',num2str(blockIdx),'...'));
        [estimation(blockIdx).mu_dgiveny, estimation(blockIdx).Sigma_dgiveny] = MAPcomputation_floating(berdy, ...
            traversal, ...
            synchroKin(blockIdx),...
            data(blockIdx).y, ...
            G_T_base(blockIdx).G_T_b, ...
            priors, ...
            baseVel(blockIdx).baseAngVelocity, ...
            opts, ...
            'SENSORS_TO_REMOVE', sensorsToBeRemoved);
        disp(strcat('[End] Complete MAP computation for Block ',num2str(blockIdx)));
        % TODO: variables extraction
        % Sigma_tau extraction from Sigma d --> since sigma d is very big, it
        % cannot be saved! therefore once computed it is necessary to extract data
        % related to tau and save that one!
        % TODO: extractSigmaOfEstimatedVariables
    else
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] mu_dgiveny MAP computation for Block ',num2str(blockIdx),'...'));
        [estimation(blockIdx).mu_dgiveny] = MAPcomputation_floating(berdy, ...
            traversal, ...
            synchroKin(blockIdx),...
            data(blockIdx).y, ...
            G_T_base(blockIdx).G_T_b, ...
            priors, ...
            baseVel(blockIdx).baseAngVelocity, ...
            opts, ...
            'SENSORS_TO_REMOVE', sensorsToBeRemoved);
        disp(strcat('[End] mu_dgiveny MAP computation for Block ',num2str(blockIdx)));
    end
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
for blockIdx = blockID
    disp('-------------------------------------------------------------------');
    disp(strcat('[Start] External force MAP extraction for Block ',num2str(blockIdx),'...'));
    estimatedVariables.Fext(blockIdx).block  = block.labels(blockIdx);
    estimatedVariables.Fext(blockIdx).label  = dVectorOrder;
    estimatedVariables.Fext(blockIdx).values = extractEstimatedFext_from_mu_dgiveny(berdy, ...
        dVectorOrder, ...
        estimation(blockIdx).mu_dgiveny, ...
        opts.stackOfTaskMAP);
    disp(strcat('[End] External force extraction for Block ',num2str(blockIdx)));
end
if opts.task1_SOT
    save(fullfile(bucket.pathToProcessedData_SOTtask1,'estimatedVariables.mat'),'estimatedVariables');
end
disp('[End] External force MAP extraction');

if ~opts.task1_SOT
    % 6D acceleration (no via Berdy)
    for blockIdx = blockID
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Acceleration MAP extraction for Block ',num2str(blockIdx),'...'));
        estimatedVariables.Acc(blockIdx).block  = block.labels(blockIdx);
        estimatedVariables.Acc(blockIdx).label  = dVectorOrder;
        estimatedVariables.Acc(blockIdx).values = extractEstimatedAcc_from_mu_dgiveny(berdy, ...
            dVectorOrder, ...
            estimation(blockIdx).mu_dgiveny, ...
            opts.stackOfTaskMAP);
        disp(strcat('[End] Acceleration MAP extraction for Block ',num2str(blockIdx)));
    end
    % torque extraction (via Berdy)
    for blockIdx = blockID
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Torque MAP extraction for Block ',num2str(blockIdx),'...'));
        estimatedVariables.tau(blockIdx).block  = block.labels(blockIdx);
        estimatedVariables.tau(blockIdx).label  = selectedJoints;
        estimatedVariables.tau(blockIdx).values = extractEstimatedTau_from_mu_dgiveny(berdy, ...
            estimation(blockIdx).mu_dgiveny, ...
            synchroKin(blockIdx).q);
        disp(strcat('[End] Torque MAP extraction for Block ',num2str(blockIdx)));
    end
    % joint acc extraction (no via Berdy)
    for blockIdx = blockID
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Joint acceleration MAP extraction for Block ',num2str(blockIdx),'...'));
        estimatedVariables.ddq(blockIdx).block  = block.labels(blockIdx);
        estimatedVariables.ddq(blockIdx).label  = selectedJoints;
        %     estimatedVariables.ddq(blockIdx).values = extractEstimatedDdq_from_mu_dgiveny_floating(berdy, ...
        %         selectedJoints, ...
        %         estimation(blockIdx).mu_dgiveny);
        % ---------------------------
        estimatedVariables.ddq(blockIdx).values = estimation(blockIdx).mu_dgiveny(...
            length(estimation(blockIdx).mu_dgiveny)-(humanModel.getNrOfDOFs-1) : size(estimation(blockIdx).mu_dgiveny,1) ,:);
        % ---------------------------
        disp(strcat('[End] Joint acceleration MAP extraction for Block ',num2str(blockIdx)));
    end
    % fint extraction (no via Berdy)
    for blockIdx = blockID
        disp('-------------------------------------------------------------------');
        disp(strcat('[Start] Internal force MAP extraction for Block ',num2str(blockIdx),'...'));
        estimatedVariables.Fint(blockIdx).block  = block.labels(blockIdx);
        estimatedVariables.Fint(blockIdx).label  = selectedJoints;
        estimatedVariables.Fint(blockIdx).values = extractEstimatedFint_from_mu_dgiveny(berdy, ...
            selectedJoints, ...
            estimation(blockIdx).mu_dgiveny, ...
            opts.stackOfTaskMAP);
        disp(strcat('[End] Internal force MAP extraction for Block ',num2str(blockIdx)));
    end
    % save extracted viariables
    save(fullfile(bucket.pathToProcessedData_SOTtask2,'estimatedVariables.mat'),'estimatedVariables');
end

%% Simulated y
% This section is useful to compare the measurements in the y vector and
% the results of the MAP.  Note: you cannot compare directly the results of
% the MAP (i.e., mu_dgiveny) with the measurements in the y vector but you
% have to pass through the y_sim and only later to compare y and y_sim.
for blockIdx = blockID
    disp('-------------------------------------------------------------------');
    disp(strcat('[Start] Simulated y computation for Block ',num2str(blockIdx),'...'));
    y_sim(blockIdx).block = block.labels(blockIdx);
    [y_sim(blockIdx).y_sim] = sim_y_floating(berdy, ...
        synchroKin(blockIdx),...
        traversal, ...
        G_T_base(blockIdx).G_T_b, ...
        baseVel(blockIdx).baseAngVelocity, ...
        estimation(blockIdx).mu_dgiveny, ...
        opts);
    disp(strcat('[End] Simulated y computation for Block ',num2str(blockIdx)));
end

if opts.task1_SOT
    save(fullfile(bucket.pathToProcessedData_SOTtask1,'y_sim.mat'),'y_sim');
else
    save(fullfile(bucket.pathToProcessedData_SOTtask2,'y_sim.mat'),'y_sim');
end

%% Variables extraction from y_sim
extractSingleVar_from_y_sim_all;

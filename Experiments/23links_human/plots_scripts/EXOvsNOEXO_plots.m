
% Plots EXO vs. NO EXO
% block.nrOfBlocks = 1

%% Preliminaries
close all;
clc; clear all;
addpath(genpath('../../external'));

bucket.datasetRoot = fullfile(pwd, 'dataJSI');
% bucket.datasetRoot = pwd;

% Group options
group1 = true;
group2 = false;

if group1
    % GROUP 1
    subjectID = [1];
    % subjectID = [1,3,5,7,9,11];
    taskID = [0,1];
end
if group2
    % GROUP 2
    subjectID = [2,4,6,8,10,12];
    taskID = [0, 1, 2];
end

% Blocks
block.labels = {'block1'; ...
    'block2'; ...
    'block3'; ...
    'block4'; ...
    'block5'};
block.nrOfBlocks = size(block.labels,1);

% NO EXO color
orangeAnDycolor = [0.952941176470588   0.592156862745098   0.172549019607843];
% WITH EXO color
greenAnDycolor  = [0.282352941176471   0.486274509803922   0.427450980392157];

% Preliminaries
addpath(genpath('../../src'));
suitFrameRate = 60; %Hz
Sg.samplingTime = 1/suitFrameRate;
% because the signal have been downsampled to align the suit signals
Sg.polinomialOrder = 3;
Sg.window = 51;

%% Plots
for subjIdx = 1 : length(subjectID)
    pathToSubject = fullfile(bucket.datasetRoot, sprintf('S%02d',subjectID(subjIdx)));
    
    if group1
        pathToTask00 = fullfile(pathToSubject,sprintf('task%d',taskID(1)));
        pathToTask01 = fullfile(pathToSubject,sprintf('task%d',taskID(2)));
        
        pathToProcessedData00 = fullfile(pathToTask00,'processed');
        pathToProcessedData01 = fullfile(pathToTask01,'processed');
        
        exo00   = load(fullfile(pathToProcessedData00,'processed_SOTtask2/estimatedVariables.mat'));
        noexo01 = load(fullfile(pathToProcessedData01,'processed_SOTtask2/estimatedVariables.mat'));
        
        selectedJoints = load(fullfile(pathToProcessedData01,'selectedJoints.mat'));
        
        % Create a struct .mat for the comparison with NE and WE per subject
        comparisonWEvsNE.jointsOrder = selectedJoints.selectedJoints;
        comparisonWEvsNE.torqueNorm = struct;
        
        % ------------------ do task 01 vs. 00 comparison -----------------
%         for jointsIdx = 1 : length(selectedJoints.selectedJoints)
%             fig = figure('Name', 'EXO vs NOEXO analysis','NumberTitle','off');
%             axes1 = axes('Parent',fig,'FontSize',16);
%             box(axes1,'on');
%             hold(axes1,'on');
%             grid on;
%             
%             for blockIdx = 1 : block.nrOfBlocks
%                 subplot (5,1,blockIdx)
%                 % Task 01 --> NO EXO
%                 plot1 = plot(noexo01.estimatedVariables.tau(blockIdx).values(jointsIdx,:),'color',orangeAnDycolor,'lineWidth',1.5);
%                 hold on;
%                 % Task 00 --> WITH EXO
%                 plot2 = plot(exo00.exo_insideMAP.estimatedVariables.tau(blockIdx).values(jointsIdx,:),'color',greenAnDycolor,'lineWidth',1.5);
%                 title(sprintf('%s, S%02d, Block %s',selectedJoints.selectedJoints{jointsIdx,1}, ...
%                     subjectID(subjIdx), num2str(blockIdx)),'Interpreter','latex');
%                 ylabel('torque [Nm]');
%                 if blockIdx == 5
%                     xlabel('samples');
%                 end
%                 set(gca,'FontSize',15)
%                 grid on;
%                 %legend
%                 leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
%                 set(leg,'Interpreter','latex');
%                 axis tight
%             end
%         end
    else
        pathToTask00 = fullfile(pathToSubject,sprintf('task%d',taskID(1)));
        pathToTask01 = fullfile(pathToSubject,sprintf('task%d',taskID(2)));
        pathToTask02 = fullfile(pathToSubject,sprintf('task%d',taskID(3)));
        
        pathToProcessedData00 = fullfile(pathToTask00,'processed');
        pathToProcessedData01 = fullfile(pathToTask01,'processed');
        pathToProcessedData02 = fullfile(pathToTask02,'processed');
        
        noexo00 = load(fullfile(pathToProcessedData00,'processed_SOTtask2/estimatedVariables.mat'));
        exo01   = load(fullfile(pathToProcessedData01,'processed_SOTtask2/estimatedVariables.mat'));
        noexo02 = load(fullfile(pathToProcessedData02,'processed_SOTtask2/estimatedVariables.mat'));
        
        % ------------------ do task 02 vs. 01 comparison -----------------
        for jointsIdx = 1 : length(selectedJoints.selectedJoints)
            fig = figure('Name', 'EXO vs NOEXO analysis','NumberTitle','off');
            axes1 = axes('Parent',fig,'FontSize',16);
            box(axes1,'on');
            hold(axes1,'on');
            grid on;
            for blockIdx = 1 : block.nrOfBlocks
                subplot (5,1,blockIdx)
                % Task 02 --> NO EXO
                plot1 = plot(noexo02.estimatedVariables.tau(blockIdx).values(jointsIdx,:),'color',orangeAnDycolor,'lineWidth',1.5);
                hold on;
                % Task 01 --> WITH EXO
                plot2 = plot(exo01.estimatedVariables.tau(blockIdx).values(jointsIdx,:),greenAnDycolor,'lineWidth''lineWidth',1.5);
                title(sprintf('%s, S%02d, Block %s',selectedJoints.selectedJoints{jointsIdx,1}, ...
                    subjectID(subjIdx), num2str(blockIdx)),'Interpreter','latex');
                ylabel('torque [Nm]');
                if blockIdx == 5
                    xlabel('samples');
                end
                set(gca,'FontSize',15)
                grid on;
                %legend
                leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
                set(leg,'Interpreter','latex');
                axis tight
            end
        end
    end
end

%% Norm computation
torso_range    = (1:14);
rightArm_range = (15:22);
leftArm_range  = (23:30);
rightLeg_range = (31:39);
leftLeg_range  = (40:48);

if group1
    % exo00
    for blockIdx = 1 : block.nrOfBlocks
        comparisonWEvsNE.torqueNorm(blockIdx).block = block.labels(blockIdx);
        len = size(exo00.estimatedVariables.tau(1).values,2);
        for i = 1 : len
            comparisonWEvsNE.torqueNorm(blockIdx).complete_exo00(1,i) = norm(exo00.estimatedVariables.tau(blockIdx).values(:,i));
            comparisonWEvsNE.torqueNorm(blockIdx).torso_exo00(1,i)    = norm(exo00.estimatedVariables.tau(blockIdx).values(torso_range,i));
            comparisonWEvsNE.torqueNorm(blockIdx).rightArm_exo00(1,i) = norm(exo00.estimatedVariables.tau(blockIdx).values(rightArm_range,i));
            comparisonWEvsNE.torqueNorm(blockIdx).leftArm_exo00(1,i)  = norm(exo00.estimatedVariables.tau(blockIdx).values(leftArm_range,i));
            comparisonWEvsNE.torqueNorm(blockIdx).rightLeg_exo00(1,i) = norm(exo00.estimatedVariables.tau(blockIdx).values(rightLeg_range,i));
            comparisonWEvsNE.torqueNorm(blockIdx).leftLeg_exo00(1,i)  = norm(exo00.estimatedVariables.tau(blockIdx).values(leftLeg_range,i));
        end
    end
    
    % noexo01
    for blockIdx = 1 : block.nrOfBlocks
        len = size(noexo01.estimatedVariables.tau(1).values,2);
        for i = 1 : len
            comparisonWEvsNE.torqueNorm(blockIdx).complete_noexo01(1,i) = norm(noexo01.estimatedVariables.tau(blockIdx).values(:,i));
            comparisonWEvsNE.torqueNorm(blockIdx).torso_noexo01(1,i)    = norm(noexo01.estimatedVariables.tau(blockIdx).values(torso_range,i));
            comparisonWEvsNE.torqueNorm(blockIdx).rightArm_noexo01(1,i) = norm(noexo01.estimatedVariables.tau(blockIdx).values(rightArm_range,i));
            comparisonWEvsNE.torqueNorm(blockIdx).leftArm_noexo01(1,i)  = norm(noexo01.estimatedVariables.tau(blockIdx).values(leftArm_range,i));
            comparisonWEvsNE.torqueNorm(blockIdx).rightLeg_noexo01(1,i) = norm(noexo01.estimatedVariables.tau(blockIdx).values(rightLeg_range,i));
            comparisonWEvsNE.torqueNorm(blockIdx).leftLeg_noexo01(1,i)  = norm(noexo01.estimatedVariables.tau(blockIdx).values(leftLeg_range,i));
        end
    end
    
    %% Norm plots
    
    % Filtering
    comparisonWEvsNE_filt = comparisonWEvsNE;
    for blockIdx = 1 : block.nrOfBlocks
        % exo00
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).complete_exo00,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).complete_exo00,Sg.samplingTime);
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).torso_exo00,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).torso_exo00,Sg.samplingTime);
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).rightArm_exo00,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).rightArm_exo00,Sg.samplingTime);
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).leftArm_exo00,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).leftArm_exo00,Sg.samplingTime);
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).rightLeg_exo00,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).rightLeg_exo00,Sg.samplingTime);
        % noexo01
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).complete_noexo01,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).complete_noexo01,Sg.samplingTime);
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).torso_noexo01,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).torso_noexo01,Sg.samplingTime);
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).rightArm_noexo01,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).rightArm_noexo01,Sg.samplingTime);
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).leftArm_noexo01,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).leftArm_noexo01,Sg.samplingTime);
        [comparisonWEvsNE_filt.torqueNorm(blockIdx).rightLeg_noexo01,~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            comparisonWEvsNE.torqueNorm(blockIdx).rightLeg_noexo01,Sg.samplingTime);
    end
    
    % ============= general
    fig = figure('Name', 'EXO vs NOEXO norm COMPLETE','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).complete_noexo01,'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).complete_exo00,'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Complete norm, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau norm');
        if blockIdx == 5
            xlabel('samples');
        end
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= torso
    fig = figure('Name', 'EXO vs NOEXO norm TORSO','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).torso_noexo01,'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
%         plot3 = plot(comparisonWEvsNE.torqueNorm(blockIdx).torso_noexo01,'color',orangeAnDycolor,'lineWidth',1.5);
%         hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).torso_exo00,'color',greenAnDycolor,'lineWidth',1.5);
        hold on
%         plot4 = plot(comparisonWEvsNE.torqueNorm(blockIdx).torso_exo00,'color',greenAnDycolor,'lineWidth',1.5);
         title(sprintf('Torso norm, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau norm');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= right arm
    fig = figure('Name', 'EXO vs NOEXO norm RIGHT ARM','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).rightArm_noexo01,'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).rightArm_exo00,'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Right arm norm, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau norm');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= left arm
    fig = figure('Name', 'EXO vs NOEXO norm LEFT ARM','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).leftArm_noexo01,'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).leftArm_exo00,'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Left arm norm, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau norm');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    %     tightfig;
    
    % ============= right leg
    fig = figure('Name', 'EXO vs NOEXO norm_RIGHT LEG','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).rightLeg_noexo01,'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).rightLeg_exo00,'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Right leg norm, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau norm');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= left leg
    fig = figure('Name', 'EXO vs NOEXO norm_LEFT LEG','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).leftLeg_noexo01,'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(comparisonWEvsNE_filt.torqueNorm(blockIdx).leftLeg_exo00,'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Left leg norm, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau norm');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    %% shoulders plots
    tmp.rC7ShoIdx = 15;
    tmp.rShoRotxIdx = 16;
    tmp.rShoRotyIdx = 17;
    tmp.rShoRotzIdx = 18;
    
    tmp.lC7ShoIdx = 23;
    tmp.lShoRotxIdx = 24;
    tmp.lShoRotyIdx = 25;
    tmp.lShoRotzIdx = 26;
    
    % Filtering
    for blockIdx = 1 : block.nrOfBlocks
         % exo00
        [exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.rC7ShoIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            exo00.estimatedVariables.tau(blockIdx).values(tmp.rC7ShoIdx,:),Sg.samplingTime);
        [exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.lC7ShoIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            exo00.estimatedVariables.tau(blockIdx).values(tmp.lC7ShoIdx,:),Sg.samplingTime);
        [exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotxIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            exo00.estimatedVariables.tau(blockIdx).values(tmp.rShoRotxIdx,:),Sg.samplingTime);
        [exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotyIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            exo00.estimatedVariables.tau(blockIdx).values(tmp.rShoRotyIdx,:),Sg.samplingTime);
        [exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotzIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            exo00.estimatedVariables.tau(blockIdx).values(tmp.rShoRotzIdx,:),Sg.samplingTime);
        [exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotxIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            exo00.estimatedVariables.tau(blockIdx).values(tmp.lShoRotxIdx,:),Sg.samplingTime);
        [exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotyIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            exo00.estimatedVariables.tau(blockIdx).values(tmp.lShoRotyIdx,:),Sg.samplingTime);
        [exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotzIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            exo00.estimatedVariables.tau(blockIdx).values(tmp.lShoRotzIdx,:),Sg.samplingTime);
        % exo01
        [noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.rC7ShoIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            noexo01.estimatedVariables.tau(blockIdx).values(tmp.rC7ShoIdx,:),Sg.samplingTime);
        [noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.lC7ShoIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            noexo01.estimatedVariables.tau(blockIdx).values(tmp.lC7ShoIdx,:),Sg.samplingTime);
        [noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotxIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            noexo01.estimatedVariables.tau(blockIdx).values(tmp.rShoRotxIdx,:),Sg.samplingTime);
        [noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotyIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            noexo01.estimatedVariables.tau(blockIdx).values(tmp.rShoRotyIdx,:),Sg.samplingTime);
        [noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotzIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            noexo01.estimatedVariables.tau(blockIdx).values(tmp.rShoRotzIdx,:),Sg.samplingTime);
        [noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotxIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            noexo01.estimatedVariables.tau(blockIdx).values(tmp.lShoRotxIdx,:),Sg.samplingTime);
        [noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotyIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            noexo01.estimatedVariables.tau(blockIdx).values(tmp.lShoRotyIdx,:),Sg.samplingTime);
        [noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotzIdx,:),~,~] = SgolayFilterAndDifferentiation(Sg.polinomialOrder,Sg.window, ...
            noexo01.estimatedVariables.tau(blockIdx).values(tmp.lShoRotzIdx,:),Sg.samplingTime);
    end
    
    % ============= right c7 shoulder
    fig = figure('Name', 'EXO vs NOEXO RIGHT SHOULDER','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.rC7ShoIdx,(Sg.window):(end-Sg.window)),'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
%         plot3 = plot(noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.rC7ShoIdx,:),'color',orangeAnDycolor,'lineWidth',1.5);
        % Task 01 --> WITH EXO
        plot2 = plot(exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.rC7ShoIdx,(Sg.window):(end-Sg.window)),'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Right C7 shoulder, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= left c7 shoulder
    fig = figure('Name', 'EXO vs NOEXO LEFT SHOULDER','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.lC7ShoIdx,(Sg.window):(end-Sg.window)),'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.lC7ShoIdx,(Sg.window):(end-Sg.window)),'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Left C7 shoulder, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= right shoulder rotx
    fig = figure('Name', 'EXO vs NOEXO RIGHT SHOULDER','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotxIdx,(Sg.window):(end-Sg.window)),'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotxIdx,(Sg.window):(end-Sg.window)),'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Right shoulder rotx, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= left shoulder rotx
    fig = figure('Name', 'EXO vs NOEXO LEFT SHOULDER','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotxIdx,(Sg.window):(end-Sg.window)),'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotxIdx,(Sg.window):(end-Sg.window)),'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Left shoulder rotx, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= right shoulder roty
    fig = figure('Name', 'EXO vs NOEXO RIGHT SHOULDER','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotyIdx,(Sg.window):(end-Sg.window)),'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotyIdx,(Sg.window):(end-Sg.window)),'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Right shoulder roty, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= left shoulder roty
    fig = figure('Name', 'EXO vs NOEXO LEFT SHOULDER','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotyIdx,(Sg.window):(end-Sg.window)),'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotyIdx,(Sg.window):(end-Sg.window)),'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Left shoulder roty, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= right shoulder rotz
    fig = figure('Name', 'EXO vs NOEXO RIGHT SHOULDER','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotzIdx,(Sg.window):(end-Sg.window)),'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.rShoRotzIdx,(Sg.window):(end-Sg.window)),'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Right shoulder rotz, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
    
    % ============= left shoulder rotz
    fig = figure('Name', 'EXO vs NOEXO LEFT SHOULDER','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        % Task 00 --> NO EXO
        plot1 = plot(noexo01_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotzIdx,(Sg.window):(end-Sg.window)),'color',orangeAnDycolor,'lineWidth',1.5);
        hold on;
        % Task 01 --> WITH EXO
        plot2 = plot(exo00_filt.estimatedVariables.tau(blockIdx).values(tmp.lShoRotzIdx,(Sg.window):(end-Sg.window)),'color',greenAnDycolor,'lineWidth',1.5);
        title(sprintf('Left shoulder rotz, S%02d, Block %s',subjectID(subjIdx), num2str(blockIdx)));
        ylabel('\tau');
        if blockIdx == 5
            xlabel('samples');
        end
        ylim([0 200]);
        set(gca,'FontSize',15)
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex');
        axis tight
    end
end

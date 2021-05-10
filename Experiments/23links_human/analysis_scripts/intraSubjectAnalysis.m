
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% Preliminaries
% NE color
orangeAnDycolor = [0.952941176470588   0.592156862745098   0.172549019607843];
% WE color
greenAnDycolor  = [0.282352941176471   0.486274509803922   0.427450980392157];
% Intra-subject folder
bucket.pathToIntraSubj = fullfile(bucket.pathToSubject,'/intraSubj');
if ~exist(bucket.pathToIntraSubj)
    mkdir (bucket.pathToIntraSubj)
end
% Plot folder
bucket.pathToPlots = fullfile(bucket.pathToSubject,'/plots');
if ~exist(bucket.pathToPlots)
    mkdir (bucket.pathToPlots)
end
saveON = false;
plotOK = false;

% New plot label for free tasks
freeTasksPlotLabel = {'Free';'FreeDeep';'FreeROT'};
% New plot label for motion tasks
motionTasksPlotLabel = {'Squat';'SquatROT';'Stoop'; 'StoopROT'};

nrOfValidTask = length(freeTasksPlotLabel) + length(motionTasksPlotLabel);

%% Extraction tasks estimation
for tasksIdx = 1 : length(listOfTasks)
    % label
    intraSubj(tasksIdx).tasks = listOfTasks{tasksIdx};
    % estimation
    bucket.pathToTask   = fullfile(bucket.pathToSubjectRawData,listOfTasks{tasksIdx});
    bucket.pathToProcessedData   = fullfile(bucket.pathToTask,'processed');
    intraSubj(tasksIdx).estimatedVariables = ...
        load(fullfile(bucket.pathToProcessedData,'processed_SOTtask2/estimatedVariables.mat'));
end
%% Check if NaN in loaded raw data
for tasksIdx = 1 : length(listOfTasks)
    lenVect = size(intraSubj(tasksIdx).estimatedVariables.estimatedVariables.tau.values,1);
    for i = 1 : lenVect
        if ~isempty(find(isnan(intraSubj(tasksIdx).estimatedVariables.estimatedVariables.tau.values(i,:)) == 1))
            nanVal = find(isnan(intraSubj(tasksIdx).estimatedVariables.estimatedVariables.tau.values(i,:)) == 1);
            intraSubj(tasksIdx).estimatedVariables.estimatedVariables.tau.values(i,nanVal) = ...
                (intraSubj(tasksIdx).estimatedVariables.estimatedVariables.tau.values(i,nanVal-1)+ ...
                intraSubj(tasksIdx).estimatedVariables.estimatedVariables.tau.values(i,nanVal+1))/2;
        end
    end
end

%% ========================================================================
%% =========================== ALL JOINTS =================================
%% ========================================================================
    % Plot task for free tasks
    close all;
    fig = figure('Name', 'intra-subject mean torques per free tasks ALL','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    
    for plotIdx = 1 : 3
        subplot (3,1,plotIdx)
        % NE
        plot1 = plot(mean(intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values), ...
            'color',orangeAnDycolor,'lineWidth',4);
        axis tight;
        ax = gca;
        ax.FontSize = 20;
        hold on
        % WE
        plot2 = plot(mean(intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values), ...
            'color',greenAnDycolor,'lineWidth',4);
        hold on
        title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
        ylabel('$\bar\tau^{wb}$','HorizontalAlignment','center',...
            'FontSize',40,'interpreter','latex');
        if plotIdx == 3
            xlabel('samples','FontSize',25);
        end
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex','FontSize',25);
        % axis tight
        %     ylim([40,400]);
    end
    tightfig();
    % save
    if saveON
        save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_ALL'),fig,600);
    end
    
    % Plot task for motion tasks
    fig = figure('Name', 'intra-subject mean torques per motion tasks ALL','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    
    for plotIdx = 1 : 4
        subplot (4,1,plotIdx)
        % NE
        plot1 = plot(mean(intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values), ...
            'color',orangeAnDycolor,'lineWidth',4);
        axis tight;
        ax = gca;
        ax.FontSize = 20;
        hold on
        % WE
        plot2 = plot(mean(intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values), ...
            'color',greenAnDycolor,'lineWidth',4);
        hold on
        title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
        ylabel('$\bar\tau^{wb}$','HorizontalAlignment','center',...
            'FontSize',40,'interpreter','latex');
        if plotIdx == 4
            xlabel('samples','FontSize',25);
        end
        grid on;
        %legend
        leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
        set(leg,'Interpreter','latex','FontSize',25);
        % axis tight
        %     ylim([40,400]);
    end
    tightfig();
    % save
    if saveON
        save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_ALL'),fig,600);
    end

%% ========================================================================
%% =============================== TORSO ==================================
%% ========================================================================
% if plotOK
%% L5S1
% ----------- rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL5S1_rotx')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L5S1_rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L5S1}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_L5S1_rotx'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L5S1 rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L5S1}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_L5S1_roty'),fig,600);
end

% ----------- roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL5S1_roty')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L5S1_roty','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L5S1}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_L5S1_roty'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L5S1 roty','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L5S1}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_L5S1_roty'),fig,600);
end

%% L4L3
% ----------- rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL4L3_rotx')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L4L3_rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L4L3}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_L4L3_rotx'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L4L3 rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L4L3}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_L4L3_roty'),fig,600);
end

% ----------- roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL4L3_roty')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L4L3_rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L4L3}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_L4L3_roty'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L4L3 rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L4L3}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_L4L3_roty'),fig,600);
end

%% L1T12
% ----------- rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL1T12_rotx')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L1T12_rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L1T12}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_L1T12_rotx'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L1T12 rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L1T12}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_L1T12_roty'),fig,600);
end

% ----------- roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL1T12_roty')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L1T12_roty','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L1T12}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_L1T12_roty'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks L1T12 roty','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{L1T12}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_L1T12_roty'),fig,600);
end

%% T9T8
% ----------- rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT9T8_rotx')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T9T8_rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T9T8}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_T9T8_rotx'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T9T8 rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T9T8}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_T9T8_roty'),fig,600);
end

% ----------- roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT9T8_roty')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T9T8_roty','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T9T8}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_T9T8_roty'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T9T8 rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T9T8}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_T9T8_roty'),fig,600);
end

% ----------- rotz
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT9T8_rotz')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T9T8_rotz','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T9T8}_{z}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_T9T8_rotz'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T9T8 rotz','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T9T8}_{z}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_T9T8_rotz'),fig,600);
end

%% T1C7
% ----------- rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT1C7_rotx')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T1C7_rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T1C7}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_T1C7_rotx'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T1C7 rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T1C7}_{x}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_T1C7_roty'),fig,600);
end

% ----------- roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT1C7_roty')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T1C7_roty','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T1C7}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_T1C7_roty'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T1C7 rotx','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T1C7}_{y}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_T1C7_roty'),fig,600);
end

% ----------- rotz
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT1C7_rotz')
        jointIndex = jIdx;
    end
end
% Plot task for free tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T1C7_rotz','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 3
    subplot (3,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', freeTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T1C7}_{z}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 3
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_freetask_T1C7_rotz'),fig,600);
end

% Plot task for motion tasks
fig = figure('Name', 'intra-subject mean torques per free tasks T1C7 rotz','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

for plotIdx = 1 : 4
    subplot (4,1,plotIdx)
    % NE
    plot1 = plot((intraSubj(2*(plotIdx-1)+7).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',orangeAnDycolor,'lineWidth',4);
    axis tight;
    ax = gca;
    ax.FontSize = 20;
    hold on
    % WE
    plot2 = plot((intraSubj(2*(plotIdx-1)+8).estimatedVariables.estimatedVariables.tau.values(jointIndex,:)), ...
        'color',greenAnDycolor,'lineWidth',4);
    hold on
    title(sprintf('Task  < %s >', motionTasksPlotLabel{plotIdx}),'FontSize',22);
    ylabel('$\bar\tau^{T1C7}_{z}$','HorizontalAlignment','center',...
        'FontSize',40,'interpreter','latex');
    if plotIdx == 4
        xlabel('samples','FontSize',25);
    end
    grid on;
    %legend
    leg = legend([plot1,plot2],{'NE','WE'},'Location','northeast');
    set(leg,'Interpreter','latex','FontSize',25);
    % axis tight
    %     ylim([40,400]);
end
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'intrasubj_meanWbTau_motiontask_T1C7_rotz'),fig,600);
end
% end

%% ========================================================================
%% ====================== whole-body bar plot =============================
%% ========================================================================
%% Torso
nrOfValidTask = length(freeTasksPlotLabel) + length(motionTasksPlotLabel);
%% L5S1
% Table mean per area
% ---rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL5S1_rotx')
        jointIndex = jIdx;
    end
end
singleJointsTau.torso.tableTorsoMean.L5S1_rotx  = zeros(nrOfValidTask,3);
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L5S1_rotx(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.L5S1_rotx(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L5S1_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L5S1_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L5S1_rotx(exoCheckIdx,2));
end
% ---roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL5S1_roty')
        jointIndex = jIdx;
    end
end
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L5S1_roty  = zeros(nrOfValidTask,3);
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L5S1_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L5S1_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L5S1_roty(exoCheckIdx,2));
end

%% L4L3
% Table mean per area
% ---rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL4L3_rotx')
        jointIndex = jIdx;
    end
end
singleJointsTau.torso.tableTorsoMean.L4L3_rotx  = zeros(nrOfValidTask,3);
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L4L3_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L4L3_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L4L3_rotx(exoCheckIdx,2));
end
% ---roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL4L3_roty')
        jointIndex = jIdx;
    end
end
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L4L3_roty  = zeros(nrOfValidTask,3);
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L4L3_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L4L3_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L4L3_roty(exoCheckIdx,2));
end

%% L1T12
% Table mean per area
% ---rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL1T12_rotx')
        jointIndex = jIdx;
    end
end
singleJointsTau.torso.tableTorsoMean.L1T12_rotx  = zeros(nrOfValidTask,3);
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L1T12_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L1T12_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L1T12_rotx(exoCheckIdx,2));
end
% ---roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jL1T12_roty')
        jointIndex = jIdx;
    end
end
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L1T12_roty  = zeros(nrOfValidTask,3);
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.L1T12_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.L1T12_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.L1T12_roty(exoCheckIdx,2));
end

%% T9T8
% Table mean per area
% ---rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT9T8_rotx')
        jointIndex = jIdx;
    end
end
singleJointsTau.torso.tableTorsoMean.T9T8_rotx  = zeros(nrOfValidTask,3);
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T9T8_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotx(exoCheckIdx,2));
end
% ---roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT9T8_roty')
        jointIndex = jIdx;
    end
end
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T9T8_roty  = zeros(nrOfValidTask,3);
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T9T8_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_roty(exoCheckIdx,2));
end
% ---rotz
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT9T8_rotz')
        jointIndex = jIdx;
    end
end
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz  = zeros(nrOfValidTask,3);
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T9T8_rotz(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotz(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T9T8_rotz(exoCheckIdx,2));
end

%% T1C7
% Table mean per area
% ---rotx
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT1C7_rotx')
        jointIndex = jIdx;
    end
end
singleJointsTau.torso.tableTorsoMean.T1C7_rotx  = zeros(nrOfValidTask,3);
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T1C7_rotx(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotx(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotx(exoCheckIdx,2));
end
% ---roty
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT1C7_roty')
        jointIndex = jIdx;
    end
end
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T1C7_roty  = zeros(nrOfValidTask,3);
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T1C7_roty(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_roty(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_roty(exoCheckIdx,2));
end
% ---rotz
for jIdx = 1 : length(selectedJoints)
    if strcmp(selectedJoints{jIdx}, 'jT1C7_rotz')
        jointIndex = jIdx;
    end
end
for taskIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz  = zeros(nrOfValidTask,3);
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(taskIdx,1) = mean(intraSubj(2*(taskIdx-1)+1).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(taskIdx,2) = mean(intraSubj(2*(taskIdx-1)+2).estimatedVariables.estimatedVariables.tau.values(jointIndex,:));
end
% Chech overall effort status due to exo presence
for exoCheckIdx = 1 : nrOfValidTask
    singleJointsTau.torso.tableTorsoMean.T1C7_rotz(exoCheckIdx,3) = ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotz(exoCheckIdx,1)) - ...
        abs(singleJointsTau.torso.tableTorsoMean.T1C7_rotz(exoCheckIdx,2));
end

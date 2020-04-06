
% Copyright (C) 2019 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%                     MEASUREMENTS vs. ESTIMATIONS
%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% Preliminaries
opts.normPlot = true;
normColor = [0.494117647058824   0.184313725490196   0.556862745098039];

%% Linear acceleration
% Match the order between measurements and estimation (only for block 1)
nrOfLinAccelerometer = length(y_sim_linAcc(1).order);
tmp.linAccOrderIndex_inEstimVector = [];
tmp.linAccOrderIndex_inMeasVector  = [];
for linAccIdx_inEstimVector = 1 : nrOfLinAccelerometer
    for linAccIdx_inMeasVector = 1 : nrOfLinAccelerometer
        if strcmp(y_sim_linAcc(1).order(linAccIdx_inEstimVector), data(1).data(linAccIdx_inMeasVector).id)
            tmp.linAccOrderIndex_inEstimVector = [tmp.linAccOrderIndex_inEstimVector; linAccIdx_inEstimVector];
            tmp.linAccOrderIndex_inMeasVector  = [tmp.linAccOrderIndex_inMeasVector; linAccIdx_inMeasVector];
            break;
        end
    end
end
% Compute linAcc difference (meas - estim)
for blockIdx = 1 : block.nrOfBlocks
    tmp.linAcc_meas  = [];
    tmp.linAcc_estim = [];
    for nrOfLinAccelerometerIdx = 1 : nrOfLinAccelerometer
        tmp.linAcc_meas = [tmp.linAcc_meas; ...
            data(blockIdx).data(tmp.linAccOrderIndex_inMeasVector(nrOfLinAccelerometerIdx)).meas];
        tmp.linAcc_estim = [tmp.linAcc_estim; ...
            y_sim_linAcc(blockIdx).meas{tmp.linAccOrderIndex_inEstimVector(nrOfLinAccelerometerIdx),1}];
    end
    normAnalysis(blockIdx).linAcc_diff = (tmp.linAcc_meas - tmp.linAcc_estim);
end
% Norm all samples
for blockIdx = 1 : block.nrOfBlocks
    len = length(synchroData(blockIdx).masterTime);
    normAnalysis(blockIdx).linAcc_norm = zeros(1,len);
    for lenIdx = 1 : len
        normAnalysis(blockIdx).linAcc_norm(1,lenIdx) = norm(normAnalysis(blockIdx).linAcc_diff(:,lenIdx));
    end
end

% TODO: Norm only base?
% TODO: Norm per each link?

% Plot
if opts.normPlot
    fig = figure('Name', 'norm all samples - linAcc','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        plot1 = plot(normAnalysis(blockIdx).linAcc_norm,'color',normColor,'lineWidth',1.5);
        hold on;
        title(sprintf('Error norm, S%02d,  Block %s', subjectID, num2str(blockIdx)));
        ylabel('$a^{lin}$ [m/$s^2$]','Interpreter','latex');
        if blockIdx == 5
            xlabel('samples');
        end
        set(gca,'FontSize',15)
        grid on;
%         %legend
%         leg = legend([plot1],{'norm'},'Location','northeast');
%         set(leg,'Interpreter','latex');
%         axis tight
    end
end

%%  Angular acceleration acceleration
% TODO

%% External force
% Define range in data (only for block 1) for forces
tmp.fextIndex = [];
for fextInDataIdx = 1 : length(data(1).data)
    if data(1).data(fextInDataIdx).type == 1002
        tmp.fextIndex = [tmp.fextIndex; fextInDataIdx];
        continue;
    end
end
% Match the order between measurements and estimation (only for block 1)
nrOfExtForce = length(y_sim_fext(1).order);
tmp.fextOrderIndex_inEstimVector = [];
tmp.fextOrderIndex_inMeasVector  = [];
for fextIdx_inEstimVector = 1 : nrOfExtForce
    for fextIdx_inMeasVector = 1 : nrOfExtForce
        if strcmp(y_sim_fext(1).order(fextIdx_inEstimVector), data(1).data(tmp.fextIndex(fextIdx_inMeasVector)).id)
            tmp.fextOrderIndex_inEstimVector = [tmp.fextOrderIndex_inEstimVector; fextIdx_inEstimVector];
            tmp.fextOrderIndex_inMeasVector  = [tmp.fextOrderIndex_inMeasVector; tmp.fextIndex(fextIdx_inMeasVector)];
            break;
        end
    end
end
% Compute fext difference (meas - estim)
for blockIdx = 1 : block.nrOfBlocks
    tmp.fext_meas  = [];
    tmp.fext_estim = [];
    for nrOfExtForceIdx = 1 : nrOfExtForce
        tmp.fext_meas = [tmp.fext_meas; ...
            data(blockIdx).data(tmp.fextOrderIndex_inMeasVector(nrOfExtForceIdx)).meas(1:3,:)];
        tmp.fext_estim = [tmp.fext_estim; ...
            y_sim_fext(blockIdx).meas{tmp.fextOrderIndex_inEstimVector(nrOfExtForceIdx),1}(1:3,:)];
    end
    normAnalysis(blockIdx).fext_diff = (tmp.fext_meas - tmp.fext_estim);
end
% Norm all samples
for blockIdx = 1 : block.nrOfBlocks
    len = length(synchroData(blockIdx).masterTime);
    normAnalysis(blockIdx).fext_norm = zeros(1,len);
    for lenIdx = 1 : len
        normAnalysis(blockIdx).fext_norm(1,lenIdx) = norm(normAnalysis(blockIdx).fext_diff(:,lenIdx));
    end
end

% TODO: Norm per each link?

% Plot
if opts.normPlot
    fig = figure('Name', 'norm all samples - ext force','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        plot1 = plot(normAnalysis(blockIdx).fext_norm,'color',normColor,'lineWidth',1.5);
        hold on;
        title(sprintf('Error norm, S%02d,  Block %s', subjectID, num2str(blockIdx)));
        ylabel('$f^{ext}$ [N]','Interpreter','latex');
        if blockIdx == 5
            xlabel('samples');
        end
        set(gca,'FontSize',15)
        grid on;
%         %legend
%         leg = legend([plot1],{'norm'},'Location','northeast');
%         set(leg,'Interpreter','latex');
%         axis tight
    end
end

%% External moment
nrOfExtMoment = nrOfExtForce; 
% Compute mext difference (meas - estim)
for blockIdx = 1 : block.nrOfBlocks
    tmp.mext_meas  = [];
    tmp.mext_estim = [];
    for nrOfExtMomentIdx = 1 : nrOfExtMoment
        tmp.mext_meas = [tmp.mext_meas; ...
            data(blockIdx).data(tmp.fextOrderIndex_inMeasVector(nrOfExtMomentIdx)).meas(4:6,:)];
        tmp.mext_estim = [tmp.mext_estim; ...
            y_sim_fext(blockIdx).meas{tmp.fextOrderIndex_inEstimVector(nrOfExtMomentIdx),1}(4:6,:)];
    end
    normAnalysis(blockIdx).mext_diff = (tmp.mext_meas - tmp.mext_estim);
end
% Norm all samples
for blockIdx = 1 : block.nrOfBlocks
    len = length(synchroData(blockIdx).masterTime);
    normAnalysis(blockIdx).mext_norm = zeros(1,len);
    for lenIdx = 1 : len
        normAnalysis(blockIdx).mext_norm(1,lenIdx) = norm(normAnalysis(blockIdx).mext_diff(:,lenIdx));
    end
end

% TODO: Norm per each link?

% Plot
if opts.normPlot
    fig = figure('Name', 'norm all samples - ext moment','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    grid on;
    for blockIdx = 1 : block.nrOfBlocks
        subplot (5,1,blockIdx)
        plot1 = plot(normAnalysis(blockIdx).mext_norm,'color',normColor,'lineWidth',1.5);
        hold on;
        title(sprintf('Error norm, S%02d,  Block %s', subjectID, num2str(blockIdx)));
        ylabel('$m^{ext}$ [Nm]','Interpreter','latex');
        if blockIdx == 5
            xlabel('samples');
        end
        set(gca,'FontSize',15)
        grid on;
%         %legend
%         leg = legend([plot1],{'norm'},'Location','northeast');
%         set(leg,'Interpreter','latex');
%         axis tight
    end
end

%% Save norm
save(fullfile(bucket.pathToProcessedData_SOTtask2,'normAnalysis.mat'),'normAnalysis');

%% Preliminaries
% close all;
nrOfDoFs = double(humanModel.getNrOfDOFs);

close all;
bucket.pathToCovarianceTuningData   = fullfile(bucket.pathToTask,'covarianceTuning');
% Load estimated variables
% estimVar_power1 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power1/estimatedVariables.mat'),'estimatedVariables');
% estimVar_power2 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power2/estimatedVariables.mat'),'estimatedVariables');
% estimVar_power3 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power3/estimatedVariables.mat'),'estimatedVariables');
% estimVar_power4 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power4/estimatedVariables.mat'),'estimatedVariables');

% Load y_sim_linAcc
y_sim_linAcc_power1 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power1/y_sim_linAcc.mat'),'y_sim_linAcc');
y_sim_linAcc_power2 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power2/y_sim_linAcc.mat'),'y_sim_linAcc');
y_sim_linAcc_power3 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power3/y_sim_linAcc.mat'),'y_sim_linAcc');
y_sim_linAcc_power4 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power4/y_sim_linAcc.mat'),'y_sim_linAcc');

% Load y_sim_fext
y_sim_fext_power1 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power1/y_sim_fext.mat'),'y_sim_fext');
y_sim_fext_power2 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power2/y_sim_fext.mat'),'y_sim_fext');
y_sim_fext_power3 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power3/y_sim_fext.mat'),'y_sim_fext');
y_sim_fext_power4 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power4/y_sim_fext.mat'),'y_sim_fext');

% Load data
data_power3 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power3/data.mat'),'data');

% Define new legend colors
meas_col   = [0.466666666666667   0.674509803921569   0.188235294117647];
power1_col = [1     0     1];
power2_col = [1     0     0];
power3_col = [0     0     1];
power4_col = [0     0     0];

%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%                     MEASUREMENTS vs. ESTIMATIONS
%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

%%  Linear acceleration 

% ----x component
nrOfLinAccelerometer = length(y_sim_linAcc_power3.y_sim_linAcc(1).order);
for blockIdx = blockID
    fig = figure('Name', strcat('3D linear acceleration x component - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for linAccIdx = 1  : nrOfLinAccelerometer
        subplot (3,6,linAccIdx)
        % from the measurement
        plot1 = plot(data_power3.data(blockIdx).data(linAccIdx).meas(1,:),'color',meas_col,'lineWidth',0.8);
        hold on;
        % from the estimation (y_sim)
        plot_power1 = plot(y_sim_linAcc_power1.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(1,:),'color',power1_col,'lineWidth',0.8);
        hold on;
        plot_power2 = plot(y_sim_linAcc_power2.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(1,:),'color',power2_col,'lineWidth',0.8);
        hold on;
        plot_power3 = plot(y_sim_linAcc_power3.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(1,:),'color',power3_col,'lineWidth',0.8);
        hold on;
        plot_power4 = plot(y_sim_linAcc_power4.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(1,:),'color',power4_col,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',y_sim_linAcc_power3.y_sim_linAcc(blockIdx).order{linAccIdx, 1}),'FontSize',15 );
       ylabel('$a^{lin}_{x}$ [m/$s^2$]','Interpreter','latex', 'FontSize',30 );
        %legend
        if linAccIdx == nrOfLinAccelerometer
            leg = legend([plot1,plot_power1,plot_power2,plot_power3,plot_power4],{'meas','estim n=1','estim n=2','estim n=3','estim n=4'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','vertical');
            set(leg,'FontSize',30);
        end
    end
end
% ----y component
for blockIdx = blockID
    fig = figure('Name', strcat('3D linear acceleration y component - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for linAccIdx = 1  : nrOfLinAccelerometer
        subplot (3,6,linAccIdx)
        % from the measurement
        plot1 = plot(data_power3.data(blockIdx).data(linAccIdx).meas(2,:),'color',meas_col,'lineWidth',1);
        hold on;
        % from the estimation (y_sim)
        plot_power1 = plot(y_sim_linAcc_power1.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(2,:),'color',power1_col,'lineWidth',0.8);
        hold on;
        plot_power2 = plot(y_sim_linAcc_power2.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(2,:),'color',power2_col,'lineWidth',0.8);
        hold on;
        plot_power3 = plot(y_sim_linAcc_power3.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(2,:),'color',power3_col,'lineWidth',0.8);
        hold on;
        plot_power4 = plot(y_sim_linAcc_power4.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(2,:),'color',power4_col,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',y_sim_linAcc_power3.y_sim_linAcc(blockIdx).order{linAccIdx, 1}),'FontSize',15 );
       ylabel('$a^{lin}_{y}$ [m/$s^2$]','Interpreter','latex', 'FontSize',30 );
        %legend
        if linAccIdx == nrOfLinAccelerometer
            leg = legend([plot1,plot_power1,plot_power2,plot_power3,plot_power4],{'meas','estim n=1','estim n=2','estim n=3','estim n=4'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','vertical');
            set(leg,'FontSize',30);
        end
    end
end
% ----z component
for blockIdx = blockID
    fig = figure('Name', strcat('3D linear acceleration z component - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for linAccIdx = 1  : nrOfLinAccelerometer
        subplot (3,6,linAccIdx)
        % from the measurement
        plot1 = plot(data_power3.data(blockIdx).data(linAccIdx).meas(3,:),'color',meas_col,'lineWidth',1);
        hold on;
        % from the estimation (y_sim)
        plot_power1 = plot(y_sim_linAcc_power1.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(3,:),'color',power1_col,'lineWidth',0.8);
        hold on;
        plot_power2 = plot(y_sim_linAcc_power2.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(3,:),'color',power2_col,'lineWidth',0.8);
        hold on;
        plot_power3 = plot(y_sim_linAcc_power3.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(3,:),'color',power3_col,'lineWidth',0.8);
        hold on;
        plot_power4 = plot(y_sim_linAcc_power4.y_sim_linAcc(blockIdx).meas{linAccIdx,1}(3,:),'color',power4_col,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',y_sim_linAcc_power3.y_sim_linAcc(blockIdx).order{linAccIdx, 1}),'FontSize',15 );
        ylabel('$a^{lin}_{z}$ [m/$s^2$]','Interpreter','latex', 'FontSize',30 );
        %legend
        if linAccIdx == nrOfLinAccelerometer
            leg = legend([plot1,plot_power1,plot_power2,plot_power3,plot_power4],{'meas','estim n=1','estim n=2','estim n=3','estim n=4'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','vertical');
            set(leg,'FontSize',30);
        end
    end
end

%%  3D external forces
% Define range in data (only for block 1) for forces
tmp.fextIndex = [];
for fextInDataIdx = 1 : length(data(1).data)
    if data(1).data(fextInDataIdx).type == 1002
        tmp.fextIndex = [tmp.fextIndex; fextInDataIdx];
        continue;
    end
end

% ----x component
for blockIdx = blockID
    fig = figure('Name', strcat('external force x component - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for vectOrderIdx = 1 : length(dVectorOrder)
        subplot (5,10,vectOrderIdx)
        % from the measurement
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            if strcmp(data(blockIdx).data(dataFextIdx).id,dVectorOrder{vectOrderIdx})
                plot1 = plot(data(blockIdx).data(dataFextIdx).meas(1,:),'color',meas_col,'lineWidth',2);
                break;
            end
        end
        hold on
        % from the estimation (y_sim)
        plot_power1  = plot(y_sim_fext_power1.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(1,:),'color',power1_col,'lineWidth',0.8);
        hold on;
        plot_power2  = plot(y_sim_fext_power2.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(1,:),'color',power2_col,'lineWidth',0.8);
        hold on;
        plot_power3  = plot(y_sim_fext_power3.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(1,:),'color',power3_col,'lineWidth',0.8);
        hold on;
        plot_power4  = plot(y_sim_fext_power4.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(1,:),'color',power4_col,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',dVectorOrder{vectOrderIdx,1}));
        ylabel('$f^{x}_{x}$ [N]','Interpreter','latex', 'FontSize',30 );
        %legend
        if vectOrderIdx == length(dVectorOrder)
            leg = legend([plot1,plot_power1,plot_power2,plot_power3,plot_power4],{'meas','estim n=1','estim n=2','estim n=3','estim n=4'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','vertical');
            set(leg,'FontSize',30);
        end
    end
end
% ----y component
for blockIdx = blockID
    fig = figure('Name', strcat('external force y component - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for vectOrderIdx = 1 : length(dVectorOrder)
        subplot (5,10,vectOrderIdx)
        % from the measurement
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            if strcmp(data(blockIdx).data(dataFextIdx).id,dVectorOrder{vectOrderIdx})
                plot1 = plot(data(blockIdx).data(dataFextIdx).meas(2,:),'color',meas_col,'lineWidth',2);
                break;
            end
        end
        hold on
       % from the estimation (y_sim)
        plot_power1  = plot(y_sim_fext_power1.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(2,:),'color',power1_col,'lineWidth',0.8);
        hold on;
        plot_power2  = plot(y_sim_fext_power2.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(2,:),'color',power2_col,'lineWidth',0.8);
        hold on;
        plot_power3  = plot(y_sim_fext_power3.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(2,:),'color',power3_col,'lineWidth',0.8);
        hold on;
        plot_power4  = plot(y_sim_fext_power4.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(2,:),'color',power4_col,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',dVectorOrder{vectOrderIdx,1}));
        ylabel('$f^{x}_{y}$ [N]','Interpreter','latex', 'FontSize',30 );
        %legend
        if vectOrderIdx == length(dVectorOrder)
            leg = legend([plot1,plot_power1,plot_power2,plot_power3,plot_power4],{'meas','estim n=1','estim n=2','estim n=3','estim n=4'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','vertical');
            set(leg,'FontSize',30);
        end
    end
end
% ----z component
for blockIdx = blockID
    fig = figure('Name', strcat('external force z component - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for vectOrderIdx = 1 : length(dVectorOrder)
        subplot (5,10,vectOrderIdx)
        % from the measurement
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            if strcmp(data(blockIdx).data(dataFextIdx).id,dVectorOrder{vectOrderIdx})
                plot1 = plot(data(blockIdx).data(dataFextIdx).meas(3,:),'color',meas_col,'lineWidth',2);
                break;
            end
        end
        hold on
       % from the estimation (y_sim)
        plot_power1  = plot(y_sim_fext_power1.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(3,:),'color',power1_col,'lineWidth',0.8);
        hold on;
        plot_power2  = plot(y_sim_fext_power2.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(3,:),'color',power2_col,'lineWidth',0.8);
        hold on;
        plot_power3  = plot(y_sim_fext_power3.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(3,:),'color',power3_col,'lineWidth',0.8);
        hold on;
        plot_power4  = plot(y_sim_fext_power4.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(3,:),'color',power4_col,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',dVectorOrder{vectOrderIdx,1}));
        ylabel('$f^{x}_{z}$ [N]','Interpreter','latex', 'FontSize',30 );
        %legend
        if vectOrderIdx == length(dVectorOrder)
            leg = legend([plot1,plot_power1,plot_power2,plot_power3,plot_power4],{'meas','estim n=1','estim n=2','estim n=3','estim n=4'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','vertical');
            set(leg,'FontSize',30);
        end
    end
end

%%  3D external moments
% ----x component
for blockIdx = blockID
    fig = figure('Name', strcat('external moment x component - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for vectOrderIdx = 1 : length(dVectorOrder)
        subplot (5,10,vectOrderIdx)
        % from the measurement
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            if strcmp(data(blockIdx).data(dataFextIdx).id,dVectorOrder{vectOrderIdx})
                plot1 = plot(data(blockIdx).data(dataFextIdx).meas(4,:),'color',meas_col,'lineWidth',2);
                break;
            end
        end
        hold on
        % from the estimation (y_sim)
        plot_power1 = plot(y_sim_fext_power1.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(4,:),'color',power1_col,'lineWidth',0.8);
        hold on;
        plot_power2 = plot(y_sim_fext_power2.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(4,:),'color',power2_col,'lineWidth',0.8);
        hold on;
        plot_power3 = plot(y_sim_fext_power3.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(4,:),'color',power3_col,'lineWidth',0.8);
        hold on;
        plot_power4 = plot(y_sim_fext_power4.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(4,:),'color',power4_col,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',dVectorOrder{vectOrderIdx,1}));
        ylabel('$m^{x}_{x}$ [Nm]','Interpreter','latex', 'FontSize',30 );
        %legend
        if vectOrderIdx == length(dVectorOrder)
            leg = legend([plot1,plot_power1,plot_power2,plot_power3,plot_power4],{'meas','estim n=1','estim n=2','estim n=3','estim n=4'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','vertical');
            set(leg,'FontSize',30);
        end
    end
end
% ----y component
for blockIdx = blockID
    fig = figure('Name', strcat('external moment y component - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for vectOrderIdx = 1 : length(dVectorOrder)
        subplot (5,10,vectOrderIdx)
        % from the measurement
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            if strcmp(data(blockIdx).data(dataFextIdx).id,dVectorOrder{vectOrderIdx})
                plot1 = plot(data(blockIdx).data(dataFextIdx).meas(5,:),'color',meas_col,'lineWidth',2);
                break;
            end
        end
        hold on
        % from the estimation (y_sim)
        plot_power1 = plot(y_sim_fext_power1.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(5,:),'color',power1_col,'lineWidth',0.8);
        hold on;
        plot_power2 = plot(y_sim_fext_power2.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(5,:),'color',power2_col,'lineWidth',0.8);
        hold on;
        plot_power3 = plot(y_sim_fext_power3.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(5,:),'color',power3_col,'lineWidth',0.8);
        hold on;
        plot_power4 = plot(y_sim_fext_power4.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(5,:),'color',power4_col,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',dVectorOrder{vectOrderIdx,1}));
        ylabel('$m^{x}_{y}$ [Nm]','Interpreter','latex', 'FontSize',30 );
        %legend
        if vectOrderIdx == length(dVectorOrder)
            leg = legend([plot1,plot_power1,plot_power2,plot_power3,plot_power4],{'meas','estim n=1','estim n=2','estim n=3','estim n=4'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','vertical');
            set(leg,'FontSize',30);
        end
    end
end
% ----z component
for blockIdx = blockID
    fig = figure('Name', strcat('external moment z component - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for vectOrderIdx = 1 : length(dVectorOrder)
        subplot (5,10,vectOrderIdx)
        % from the measurement
        for dataFextIdx = tmp.fextIndex(1) : tmp.fextIndex(end)
            if strcmp(data(blockIdx).data(dataFextIdx).id,dVectorOrder{vectOrderIdx})
                plot1 = plot(data(blockIdx).data(dataFextIdx).meas(6,:),'color',meas_col,'lineWidth',2);
                break;
            end
        end
        hold on
        % from the estimation (y_sim)
        plot_power1 = plot(y_sim_fext_power1.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(6,:),'color',power1_col,'lineWidth',0.8);
        hold on;
        plot_power2 = plot(y_sim_fext_power2.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(6,:),'color',power2_col,'lineWidth',0.8);
        hold on;
        plot_power3 = plot(y_sim_fext_power3.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(6,:),'color',power3_col,'lineWidth',0.8);
        hold on;
        plot_power4 = plot(y_sim_fext_power4.y_sim_fext(blockIdx).meas{vectOrderIdx,1}(6,:),'color',power4_col,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',dVectorOrder{vectOrderIdx,1}));
        ylabel('$m^{x}_{z}$ [Nm]','Interpreter','latex', 'FontSize',30 );
        %legend
        if vectOrderIdx == length(dVectorOrder)
            leg = legend([plot1,plot_power1,plot_power2,plot_power3,plot_power4],{'meas','estim n=1','estim n=2','estim n=3','estim n=4'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','vertical');
            set(leg,'FontSize',30);
        end
    end
end

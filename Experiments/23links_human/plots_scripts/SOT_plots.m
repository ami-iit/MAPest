
%% Preliminaries
close all;
nrOfDoFs = double(humanModel.getNrOfDOFs);
load(fullfile(bucket.pathToProcessedData_SOTtask2,'estimatedVariables.mat'),'estimatedVariables');
load(fullfile(bucket.pathToProcessedData_SOTtask2,'y_sim_linAcc.mat'),'y_sim_linAcc');
load(fullfile(bucket.pathToProcessedData_SOTtask2,'y_sim_fext.mat'),'y_sim_fext');
% load(fullfile(bucket.pathToProcessedData_SOTtask2,'y_sim_ddq.mat'),'y_sim_ddq');

% Define new legend colors
r_dark = [0.580392156862745   0.050980392156863   0.149019607843137];
g_dark = [0.305882352941176   0.509803921568627   0.039215686274510];
b_dark = [0.031372549019608   0.031372549019608   0.631372549019608];


%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%                                ESTIMATION
%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

%% Estimated 6D accelerations
% for Idx = 1  : length(dVectorOrder)
%     fig = figure('Name', '6D acceleration - ESTIMATION','NumberTitle','off');
%     axes1 = axes('Parent',fig,'FontSize',16);
%     box(axes1,'on');
%     hold(axes1,'on');
%     grid on;
%
%     plot1 = plot(estimatedVariables.Acc.values(6*(Idx-1)+1:6*Idx,:)','lineWidth',1.5);
%     title(sprintf('%s',dVectorOrder{Idx,1}),'Interpreter','latex');
%     leg = legend(plot1,{'$alin_x$','$alin_y$','$alin_z$','$aang_x$','$aang_y$','$aang_z$'},'Location','northeast');
%     set(leg,'Interpreter','latex');
% %     pause
% end

%% Estimated external wrenches
% for Idx = 1  : length(dVectorOrder)
%     fig = figure('Name', '6D external force - ESTIMATION','NumberTitle','off');
%     axes1 = axes('Parent',fig,'FontSize',16);
%     box(axes1,'on');
%     hold(axes1,'on');
%     grid on;
%
%     plot1 = plot(estimatedVariables.Fext.values(6*(Idx-1)+1:6*Idx,:)','lineWidth',1.5);
%     title(sprintf('%s',dVectorOrder{Idx,1}),'Interpreter','latex');
%     leg = legend(plot1,{'$f_x$','$f_y$','$f_z$','$m_x$','$m_y$','$m_z$'},'Location','northeast');
%     set(leg,'Interpreter','latex');
% %     pause
% end

%% Estimated torques
for blockIdx = 1 : block.nrOfBlocks
    fig = figure('Name', strcat('torque - ESTIMATION - Block ',num2str(blockIdx)),'NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for nrDofsIdx = 1 : nrOfDoFs
        subplot (5,10,nrDofsIdx)
        plot1 = plot(estimatedVariables.tau(blockIdx).values(nrDofsIdx,:),'m','lineWidth',0.8);
        title(sprintf('%s',estimatedVariables.tau(blockIdx).label{nrDofsIdx, 1}));
        %legend
        if nrDofsIdx == nrOfDoFs
            leg = legend([plot1],{'$\tau_{ESTIM}$'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','horizontal');
            set(leg,'FontSize',30);
        end
    end
end

%% Estimated 6D internal forces
% forces
for blockIdx = 1 : block.nrOfBlocks
    fig = figure('Name', strcat('internal force - ESTIMATION - Block ',num2str(blockIdx)), 'NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for nrDofsIdx = 1  : nrOfDoFs
        subplot (5,10,nrDofsIdx)
        plot1 = plot(estimatedVariables.Fint(blockIdx).values(6*(nrDofsIdx-1)+1,:)','r','lineWidth',0.8);
        hold on
        plot2 = plot(estimatedVariables.Fint(blockIdx).values(6*(nrDofsIdx-1)+2,:)','g','lineWidth',0.8);
        hold on
        plot3 = plot(estimatedVariables.Fint(blockIdx).values(6*(nrDofsIdx-1)+3,:)','b','lineWidth',0.8);
        title(sprintf('%s',estimatedVariables.Fint(blockIdx).label{nrDofsIdx, 1}));
        %legend
        if nrDofsIdx == nrOfDoFs
            leg = legend([plot1,plot2,plot3],{'$f^{int}_{x,MEAS}$','$f^{int}_{y,MEAS}$','$f^{int}_{z,MEAS}$'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','horizontal');
            set(leg,'FontSize',30);
        end
    end
end
% moments
for blockIdx = 1 : block.nrOfBlocks
    fig = figure('Name', strcat('internal moment - ESTIMATION - Block ',num2str(blockIdx)), 'NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for nrDofsIdx = 1  : nrOfDoFs
        subplot (5,10,nrDofsIdx)
        plot1 = plot(estimatedVariables.Fint(blockIdx).values(6*(nrDofsIdx-1)+4,:)','r','lineWidth',0.8);
        hold on
        plot2 = plot(estimatedVariables.Fint(blockIdx).values(6*(nrDofsIdx-1)+5,:)','g','lineWidth',0.8);
        hold on
        plot3 = plot(estimatedVariables.Fint(blockIdx).values(6*(nrDofsIdx-1)+6,:)','b','lineWidth',0.8);
        title(sprintf('%s',estimatedVariables.Fint(blockIdx).label{nrDofsIdx, 1}));
        %legend
        if nrDofsIdx == nrOfDoFs
            leg = legend([plot1,plot2,plot3],{'$m^{int}_{x,MEAS}$','$m^{int}_{y,MEAS}$','$m^{int}_{z,MEAS}$'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','horizontal');
            set(leg,'FontSize',30);
        end
    end
end

%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%                     MEASUREMENTS vs. ESTIMATIONS
%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

%%  Linear acceleration
nrOfLinAccelerometer = length(y_sim_linAcc(1).order);
for blockIdx = 1 : block.nrOfBlocks
    fig = figure('Name', strcat('3D linear acceleration - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for linAccIdx = 1  : nrOfLinAccelerometer
        subplot (3,6,linAccIdx)
        % from the measurement
        plot1 = plot(data(blockIdx).data(linAccIdx).meas(1,:),'r','lineWidth',0.8);
        hold on;
        plot2 = plot(data(blockIdx).data(linAccIdx).meas(2,:),'g','lineWidth',0.8);
        hold on;
        plot3 = plot(data(blockIdx).data(linAccIdx).meas(3,:),'b','lineWidth',0.8);
        hold on
        % from the estimation (y_sim)
        plot4  = plot(y_sim_linAcc(blockIdx).meas{linAccIdx,1}(1,:),'color',r_dark,'lineWidth',0.8);
        hold on;
        plot5  = plot(y_sim_linAcc(blockIdx).meas{linAccIdx,1}(2,:),'color',g_dark,'lineWidth',0.8);
        hold on;
        plot6  = plot(y_sim_linAcc(blockIdx).meas{linAccIdx,1}(3,:),'color',b_dark,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',y_sim_linAcc(blockIdx).order{linAccIdx, 1}));
        %legend
        if linAccIdx == nrOfLinAccelerometer
            leg = legend([plot1,plot2,plot3,plot4,plot5,plot6],{'$a_{x,MEAS}$','$a_{y,MEAS}$','$a_{z,MEAS}$','$a_{x,ESTIM}$','$a_{y,ESTIM}$','$a_{z,ESTIM}$'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','horizontal');
            set(leg,'FontSize',30);
        end
    end
end

%% 6D external forces
% forces
for blockIdx = 1 : block.nrOfBlocks
    fig = figure('Name', strcat('external force - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for vectOrderIdx = 1 : length(dVectorOrder)
        subplot (5,10,vectOrderIdx)
        % from the measurement
        for dataFextIdx = 83 : 131 % manual setting
            if strcmp(data(blockIdx).data(dataFextIdx).id,dVectorOrder{vectOrderIdx})
                plot1 = plot(data(blockIdx).data(dataFextIdx).meas(1,:),'r','lineWidth',0.8);
                hold on;
                plot2 = plot(data(blockIdx).data(dataFextIdx).meas(2,:),'g','lineWidth',0.8);
                hold on;
                plot3 = plot(data(blockIdx).data(dataFextIdx).meas(3,:),'b','lineWidth',0.8);
                break;
            end
        end
        hold on
        % from the estimation (y_sim)
        plot4  = plot(y_sim_fext(blockIdx).meas{vectOrderIdx,1}(1,:),'color',r_dark,'lineWidth',0.8);
        hold on;
        plot5  = plot(y_sim_fext(blockIdx).meas{vectOrderIdx,1}(2,:),'color',g_dark,'lineWidth',0.8);
        hold on;
        plot6  = plot(y_sim_fext(blockIdx).meas{vectOrderIdx,1}(3,:),'color',b_dark,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',dVectorOrder{vectOrderIdx,1}));
        %legend
        if vectOrderIdx == length(dVectorOrder)
            leg = legend([plot1,plot2,plot3,plot4,plot5,plot6],{'$f^{ext}_{x,MEAS}$','$f^{ext}_{y,MEAS}$','$f^{ext}_{z,MEAS}$', ...
                '$f^{ext}_{x,ESTIM}$','$f^{ext}_{y,ESTIM}$','$f^{ext}_{z,ESTIM}$'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','horizontal');
            set(leg,'FontSize',30);
        end
    end
end
% moments
for blockIdx = 1 : block.nrOfBlocks
    fig = figure('Name', strcat('external moment - MEAS vs. ESTIM - Block ',num2str(blockIdx))','NumberTitle','off');
    axes1 = axes('Parent',fig,'FontSize',16);
    box(axes1,'on');
    hold(axes1,'on');
    for vectOrderIdx = 1 : length(dVectorOrder)
        subplot (5,10,vectOrderIdx)
        % from the measurement
        for dataFextIdx = 66 : 114
            if strcmp(data(blockIdx).data(dataFextIdx).id,dVectorOrder{vectOrderIdx})
                plot1 = plot(data(blockIdx).data(dataFextIdx).meas(4,:),'r','lineWidth',0.8);
                hold on;
                plot2 = plot(data(blockIdx).data(dataFextIdx).meas(5,:),'g','lineWidth',0.8);
                hold on;
                plot3 = plot(data(blockIdx).data(dataFextIdx).meas(6,:),'b','lineWidth',0.8);
                break;
            end
        end
        hold on
        % from the estimation (y_sim)
        plot4  = plot(y_sim_fext(blockIdx).meas{vectOrderIdx,1}(4,:),'color',r_dark,'lineWidth',0.8);
        hold on;
        plot5  = plot(y_sim_fext(blockIdx).meas{vectOrderIdx,1}(5,:),'color',g_dark,'lineWidth',0.8);
        hold on;
        plot6  = plot(y_sim_fext(blockIdx).meas{vectOrderIdx,1}(6,:),'color',b_dark,'lineWidth',0.8);
        grid on;
        title(sprintf('%s',dVectorOrder{vectOrderIdx,1}));
        %legend
        if vectOrderIdx == length(dVectorOrder)
            leg = legend([plot1,plot2,plot3,plot4,plot5,plot6],{'$m^{ext}_{x,MEAS}$','$m^{ext}_{y,MEAS}$','$m^{ext}_{z,MEAS}$', ...
                '$m^{ext}_{x,ESTIM}$','$m^{ext}_{y,ESTIM}$','$m^{ext}_{z,ESTIM}$'});
            set(leg,'Interpreter','latex', ...
                'Position',[0.436917552718887 0.0353846154974763 0.158803168001834 0.0237869821356598], ...
                'Orientation','horizontal');
            set(leg,'FontSize',30);
        end
    end
end

%% Joint acceleration
% fig = figure('Name', 'joint acceleration - MEAS vs. ESTIM','NumberTitle','off');
% axes1 = axes('Parent',fig,'FontSize',16);
% box(axes1,'on');
% hold(axes1,'on');
%
% for nrDofsIdx = 1  : nrDofs
%     subplot (5,10,nrDofsIdx)
%     % from the measurement
%     plot1 = plot(synchroKin.ddq(nrDofsIdx,:),'k','lineWidth',1);
%     hold on
%     % from the estimation (y_sim)
%     plot2 = plot(y_sim_ddq.meas{nrDofsIdx},'m','lineWidth',1);
%
%     title(sprintf('%s',y_sim_ddq.order{nrDofsIdx, 1}));
% end

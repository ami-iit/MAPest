
%% Preliminaries
close all;
bucket.pathToCovarianceTuningData   = fullfile(bucket.pathToTask,'covarianceTuning');
RMSE_power1 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power1/RMSE.mat'),'RMSE');
RMSE_power2 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power2/RMSE.mat'),'RMSE');
RMSE_power3 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power3/RMSE.mat'),'RMSE');
RMSE_power4 = load(fullfile(bucket.pathToCovarianceTuningData,'processed_SOTtask2_power4/RMSE.mat'),'RMSE');

%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%                             NORM ANALYSIS
%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%% Compute the norm of the RMSE
nrOfLinAccelerometer = length(RMSE_power2.RMSE.linAcc);
nrOfExternalWrenches = length(RMSE_power2.RMSE.fext); %same for mext

% Linear acceleration
for linAccIdx = 1  : nrOfLinAccelerometer
    RMSE_power1.RMSE.linAcc(linAccIdx).norm = norm(RMSE_power1.RMSE.linAcc(linAccIdx).meas);
    RMSE_power2.RMSE.linAcc(linAccIdx).norm = norm(RMSE_power2.RMSE.linAcc(linAccIdx).meas);
    RMSE_power3.RMSE.linAcc(linAccIdx).norm = norm(RMSE_power3.RMSE.linAcc(linAccIdx).meas);
    RMSE_power4.RMSE.linAcc(linAccIdx).norm = norm(RMSE_power4.RMSE.linAcc(linAccIdx).meas);
end

for fextIdx = 1  : nrOfExternalWrenches
    % 3D external forces
    RMSE_power1.RMSE.fext(fextIdx).norm = norm(RMSE_power1.RMSE.fext(fextIdx).meas);
    RMSE_power2.RMSE.fext(fextIdx).norm = norm(RMSE_power2.RMSE.fext(fextIdx).meas);
    RMSE_power3.RMSE.fext(fextIdx).norm = norm(RMSE_power3.RMSE.fext(fextIdx).meas);
    RMSE_power4.RMSE.fext(fextIdx).norm = norm(RMSE_power4.RMSE.fext(fextIdx).meas);
    % 3D external moments
    RMSE_power1.RMSE.mext(fextIdx).norm = norm(RMSE_power1.RMSE.mext(fextIdx).meas);
    RMSE_power2.RMSE.mext(fextIdx).norm = norm(RMSE_power2.RMSE.mext(fextIdx).meas);
    RMSE_power3.RMSE.mext(fextIdx).norm = norm(RMSE_power3.RMSE.mext(fextIdx).meas);
    RMSE_power4.RMSE.mext(fextIdx).norm = norm(RMSE_power4.RMSE.mext(fextIdx).meas);
end

%% Plot for linear acceleration
fig = figure('Name', 'Linear acc - covariance tuning','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on

y = 1:1:nrOfLinAccelerometer;
ylim([0 nrOfLinAccelerometer+1])
yticks(0:1:nrOfLinAccelerometer+1)
tickLabelsList = cell(1,nrOfLinAccelerometer+1);
for linAccIdx = 1  : nrOfLinAccelerometer
    xlabel( '$a^{lin}$ RMSE norm [m/$s^2$]','Interpreter','latex', 'FontSize',22);
    plot_power1 = plot(RMSE_power1.RMSE.linAcc(linAccIdx).norm, y(linAccIdx),'om', 'Linewidth', 2);
    hold on;
    plot_power2 = plot(RMSE_power2.RMSE.linAcc(linAccIdx).norm, y(linAccIdx),'or', 'Linewidth', 2);
    hold on;
    plot_power3 = plot(RMSE_power3.RMSE.linAcc(linAccIdx).norm, y(linAccIdx),'ob', 'Linewidth', 2);
    hold on;
    plot_power4 = plot(RMSE_power4.RMSE.linAcc(linAccIdx).norm, y(linAccIdx),'ok', 'Linewidth', 2);
    
    tickLabelsList{linAccIdx+1} = angAcc_sensor(linAccIdx).attachedLink;
end
yticklabels(tickLabelsList);
%title and legend
tit = title('Power trustiness for $\Sigma = 1e^{\pm n}$' );
set(tit,'Interpreter','latex', 'FontSize',25);
leg = legend([plot_power1, plot_power2, plot_power3, plot_power4],{'n=1','n=2','n=3','n=4'},'Location','northeast');
set(leg,'Interpreter','latex','FontSize',25);

%% Plot for 3D external forces
fig = figure('Name', 'Ext forces - covariance tuning','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on

y = 1:1:nrOfExternalWrenches;
ylim([0 nrOfExternalWrenches+1])
yticks(0:1:nrOfExternalWrenches+1)
tickLabelsList = cell(1,nrOfExternalWrenches+1);
for fextIdx = 1  : nrOfExternalWrenches
    xlabel( '$f^{x}$ RMSE norm [N]','Interpreter','latex', 'FontSize',22);
    plot_power1 = plot(RMSE_power1.RMSE.fext(fextIdx).norm, y(fextIdx),'om', 'Linewidth', 2);
    hold on;
    plot_power2 = plot(RMSE_power2.RMSE.fext(fextIdx).norm, y(fextIdx),'or', 'Linewidth', 2);
    hold on;
    plot_power3 = plot(RMSE_power3.RMSE.fext(fextIdx).norm, y(fextIdx),'ob', 'Linewidth', 2);
    hold on;
    plot_power4 = plot(RMSE_power4.RMSE.fext(fextIdx).norm, y(fextIdx),'ok', 'Linewidth', 2);
    
    tickLabelsList{fextIdx+1} = string(RMSE_power2.RMSE.fext(fextIdx).label);
end
yticklabels(tickLabelsList);
%title and legend
tit = title('Power trustiness for $\Sigma = 1e^{\pm n}$' );
set(tit,'Interpreter','latex', 'FontSize',25);
leg = legend([plot_power1, plot_power2, plot_power3, plot_power4],{'n=1','n=2','n=3','n=4'},'Location','northeast');
set(leg,'Interpreter','latex','FontSize',25);

%% Plot for 3D external moments
fig = figure('Name', 'Ext moments - covariance tuning','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on

y = 1:1:nrOfExternalWrenches;
ylim([0 nrOfExternalWrenches+1])
yticks(0:1:nrOfExternalWrenches+1)
tickLabelsList = cell(1,nrOfExternalWrenches+1);
for fextIdx = 1  : nrOfExternalWrenches
    xlabel( '$m^{x}$ RMSE norm [Nm]','Interpreter','latex', 'FontSize',22);
    plot_power1 = plot(RMSE_power1.RMSE.mext(fextIdx).norm, y(fextIdx),'om', 'Linewidth', 2);
    hold on;
    plot_power2 = plot(RMSE_power2.RMSE.mext(fextIdx).norm, y(fextIdx),'or', 'Linewidth', 2);
    hold on;
    plot_power3 = plot(RMSE_power3.RMSE.mext(fextIdx).norm, y(fextIdx),'ob', 'Linewidth', 2);
    hold on;
    plot_power4 = plot(RMSE_power4.RMSE.mext(fextIdx).norm, y(fextIdx),'ok', 'Linewidth', 2);
    
    tickLabelsList{fextIdx+1} = string(RMSE_power2.RMSE.fext(fextIdx).label);
end
yticklabels(tickLabelsList);
%title and legend
tit = title('Power trustiness for $\Sigma^{\pm n}$' );
set(tit,'Interpreter','latex', 'FontSize',25);
leg = legend([plot_power1, plot_power2, plot_power3, plot_power4],{'n=1','n=2','n=3','n=4'},'Location','northeast');
set(leg,'Interpreter','latex','FontSize',25);

% % % % %% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% % % % %                    SINGLE COMPONENTS ANALYSIS
% % % % %  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% % % % %% Plot for linear acceleration
% % % % fig = figure('Name', 'Linear acc - covariance tuning','NumberTitle','off');
% % % % axes1 = axes('Parent',fig,'FontSize',16);
% % % % box(axes1,'on');
% % % % hold(axes1,'on');
% % % % grid on
% % % %
% % % % axis_labels = {'x','y','z'};
% % % % for axisComponentsIdx = 1:3
% % % %     subplot (1,3,axisComponentsIdx)
% % % %     y = 1:1:nrOfLinAccelerometer;
% % % %     ylim([0 nrOfLinAccelerometer+1])
% % % %     tickLabelsList = cell(1,nrOfLinAccelerometer+1);
% % % %     for linAccIdx = 1  : nrOfLinAccelerometer
% % % %         grid on
% % % %                 plot_power1 = plot(RMSE_power1.RMSE.linAcc(linAccIdx).meas(axisComponentsIdx), y(linAccIdx),'or', 'Linewidth', 2);
% % % %         hold on;
% % % %         plot_power2 = plot(RMSE_power2.RMSE.linAcc(linAccIdx).meas(axisComponentsIdx), y(linAccIdx),'or', 'Linewidth', 2);
% % % %         hold on;
% % % %         plot_power3 = plot(RMSE_power3.RMSE.linAcc(linAccIdx).meas(axisComponentsIdx), y(linAccIdx),'ob', 'Linewidth', 2);
% % % %         hold on;
% % % %         plot_power4 = plot(RMSE_power4.RMSE.linAcc(linAccIdx).meas(axisComponentsIdx), y(linAccIdx),'ok', 'Linewidth', 2);
% % % %         tickLabelsList{linAccIdx+1} = angAcc_sensor(linAccIdx).attachedLink;
% % % %     end
% % % %     yticks(0:1:nrOfLinAccelerometer+1)
% % % %     if axisComponentsIdx == 1
% % % %         yticklabels(tickLabelsList);
% % % %     else
% % % %         set(gca,'yticklabel',[])
% % % %     end
% % % %     xlabel( sprintf('$a_{%s}^{lin}$ [m/$s^2$]',string(axis_labels(axisComponentsIdx))),'Interpreter','latex', 'FontSize',22);
% % % %     %title and legend
% % % %     if axisComponentsIdx == 2
% % % %         tit = title('Power trustiness for $\Sigma = 1e^{\pm n}$' );
% % % %         set(tit,'Interpreter','latex', 'FontSize',25);
% % % %     end
% % % %     leg = legend([plot_power2, plot_power3, plot_power4],{'n=2','n=3','n=4'},'Location','northeast');
% % % %     set(leg,'Interpreter','latex','FontSize',25);
% % % % end
% % % %
% % % % %% Plot for 3D external forces
% % % % fig = figure('Name', 'Ext forces - covariance tuning','NumberTitle','off');
% % % % axes1 = axes('Parent',fig,'FontSize',16);
% % % % box(axes1,'on');
% % % % hold(axes1,'on');
% % % % grid on
% % % %
% % % % axis_labels = {'x','y','z'};
% % % % for axisComponentsIdx = 1:3
% % % %     subplot (1,3,axisComponentsIdx)
% % % %     y = 1:1:nrOfExternalWrenches;
% % % %     ylim([0 nrOfExternalWrenches+1])
% % % %     tickLabelsList = cell(1,nrOfExternalWrenches+1);
% % % %     for fextIdx = 1  : nrOfExternalWrenches
% % % %         grid on
% % % %                 plot_power1 = plot(RMSE_power1.RMSE.fext(fextIdx).meas(axisComponentsIdx), y(fextIdx),'or', 'Linewidth', 2);
% % % %         hold on;
% % % %         plot_power2 = plot(RMSE_power2.RMSE.fext(fextIdx).meas(axisComponentsIdx), y(fextIdx),'or', 'Linewidth', 2);
% % % %         hold on;
% % % %         plot_power3 = plot(RMSE_power3.RMSE.fext(fextIdx).meas(axisComponentsIdx), y(fextIdx),'ob', 'Linewidth', 2);
% % % %         hold on;
% % % %         plot_power4 = plot(RMSE_power4.RMSE.fext(fextIdx).meas(axisComponentsIdx), y(fextIdx),'ok', 'Linewidth', 2);
% % % %         tickLabelsList{fextIdx+1} = string(RMSE_power2.RMSE.fext(fextIdx).label);
% % % %     end
% % % %     yticks(0:1:nrOfExternalWrenches+1)
% % % %     if axisComponentsIdx == 1
% % % %         yticklabels(tickLabelsList);
% % % %     else
% % % %         set(gca,'yticklabel',[])
% % % %     end
% % % %     xlabel( sprintf('$f_{%s}^{x}$ [N]',string(axis_labels(axisComponentsIdx))),'Interpreter','latex', 'FontSize',22);
% % % %     %title and legend
% % % %     if axisComponentsIdx == 2
% % % %         tit = title('Power trustiness for $\Sigma = 1e^{\pm n}$' );
% % % %         set(tit,'Interpreter','latex', 'FontSize',25);
% % % %     end
% % % %     leg = legend([plot_power2, plot_power3, plot_power4],{'n=2','n=3','n=4'},'Location','northeast');
% % % %     set(leg,'Interpreter','latex','FontSize',25);
% % % % end
% % % %
% % % % %% Plot for 3D external moments
% % % % fig = figure('Name', 'Ext moments - covariance tuning','NumberTitle','off');
% % % % axes1 = axes('Parent',fig,'FontSize',16);
% % % % box(axes1,'on');
% % % % hold(axes1,'on');
% % % % grid on
% % % %
% % % % axis_labels = {'x','y','z'};
% % % % for axisComponentsIdx = 1:3
% % % %     subplot (1,3,axisComponentsIdx)
% % % %     y = 1:1:nrOfExternalWrenches;
% % % %     ylim([0 nrOfExternalWrenches+1])
% % % %     tickLabelsList = cell(1,nrOfExternalWrenches+1);
% % % %     for fextIdx = 1  : nrOfExternalWrenches
% % % %         grid on
% % % %                 plot_power1 = plot(RMSE_power1.RMSE.mext(fextIdx).meas(axisComponentsIdx), y(fextIdx),'or', 'Linewidth', 2);
% % % %         hold on;
% % % %         plot_power2 = plot(RMSE_power2.RMSE.mext(fextIdx).meas(axisComponentsIdx), y(fextIdx),'or', 'Linewidth', 2);
% % % %         hold on;
% % % %         plot_power3 = plot(RMSE_power3.RMSE.mext(fextIdx).meas(axisComponentsIdx), y(fextIdx),'ob', 'Linewidth', 2);
% % % %         hold on;
% % % %         plot_power4 = plot(RMSE_power4.RMSE.mext(fextIdx).meas(axisComponentsIdx), y(fextIdx),'ok', 'Linewidth', 2);
% % % %         tickLabelsList{fextIdx+1} = string(RMSE_power2.RMSE.fext(fextIdx).label);
% % % %     end
% % % %     yticks(0:1:nrOfExternalWrenches+1)
% % % %     if axisComponentsIdx == 1
% % % %         yticklabels(tickLabelsList);
% % % %     else
% % % %         set(gca,'yticklabel',[])
% % % %     end
% % % %     xlabel( sprintf('$m_{%s}^{x}$ [Nm]',string(axis_labels(axisComponentsIdx))),'Interpreter','latex', 'FontSize',22);
% % % %     %title and legend
% % % %     if axisComponentsIdx == 2
% % % %         tit = title('Power trustiness for $\Sigma = 1e^{\pm n}$' );
% % % %         set(tit,'Interpreter','latex', 'FontSize',25);
% % % %     end
% % % %     leg = legend([plot_power2, plot_power3, plot_power4],{'n=2','n=3','n=4'},'Location','northeast');
% % % %     set(leg,'Interpreter','latex','FontSize',25);
% % % % end
% % % %

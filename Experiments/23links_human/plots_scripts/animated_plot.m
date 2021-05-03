
close all;

% NO EXO color
orangeAnDycolor = [0.952941176470588   0.592156862745098   0.172549019607843];
% WITH EXO color
greenAnDycolor  = [0.282352941176471   0.486274509803922   0.427450980392157];

% Load variables
tau_noexo = load(fullfile(pwd,'/dataJSI/S01/Task1/processed/processed_SOTtask2/estimatedVariables.mat'));
tau_exo   = load(fullfile(pwd,'/dataJSI/S01/Task0/processed/processed_SOTtask2/estimatedVariables.mat'));
synchroKin = load(fullfile(pwd,'/dataJSI/S01/Task0/processed/synchroKin.mat'));

fig = figure('Name', 'NE vs WE - Subject 1, Block 1','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
axis tight
set(gcf,'color','w');

% ----------------------------- NE ----------------------------------
subplot (3,4,[1,2]) % ---- torso
grid on;
torso_range    = (1:12);
title1 = title('Torso', 'Fontsize', 20);
h1_NE = animatedline('color',orangeAnDycolor,'lineWidth',4);
h1_len_NE = length(synchroKin.synchroKin(1).masterTime);
h1_vect_NE = 1:1:h1_len_NE;
axis([-0,h1_len_NE,-20,15]);
ylabel('\tau [Nm]', 'Fontsize', 20);
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
set(gca,'Ytick',-20:15:15)

subplot (3,4,6) % ---- right arm , with drill
grid on;
rightArm_range = (15:22);
title1 = title('Right arm', 'Fontsize', 20);
h2_NE = animatedline('color',orangeAnDycolor,'lineWidth',4);
h2_len_NE = h1_len_NE;
h2_vect_NE = h1_vect_NE;
axis([-0,h1_len_NE,-20,15]);
% ylabel('\tau [Nm]');
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
set(gca,'Ytick',-20:15:15)

subplot (3,4,5) % ---- left arm , no drill
grid on;
leftArm_range  = (23:30);
title1 = title('Left arm', 'Fontsize', 20);
h3_NE = animatedline('color',orangeAnDycolor,'lineWidth',4);
h3_len_NE = h1_len_NE;
h3_vect_NE = h1_vect_NE;
axis([-0,h1_len_NE,-20,15]);
ylabel('\tau [Nm]', 'Fontsize', 20);
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
set(gca,'Ytick',-20:15:15)

subplot (3,4,10) % ---- right leg
grid on;
rightLeg_range = (31:39);
title1 = title('Right leg', 'Fontsize', 20);
h4_NE = animatedline('color',orangeAnDycolor,'lineWidth',4);
h4_len_NE = h1_len_NE;
h4_vect_NE = h1_vect_NE;
axis([-0,h1_len_NE,-20,15]);
% ylabel('\tau [Nm]');
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
xlabel('samples', 'Fontsize', 16);
xlabel('samples', 'Fontsize', 16);
set(gca,'Ytick',-20:15:15)

subplot (3,4,9) % ---- left leg
grid on;
leftLeg_range  = (40:48);
title1 = title('Left leg', 'Fontsize', 20);
h5_NE = animatedline('color',orangeAnDycolor,'lineWidth',4);
h5_len_NE = h1_len_NE;
h5_vect_NE = h1_vect_NE;
axis([-0,h1_len_NE,-20,15]);
ylabel('\tau [Nm]', 'Fontsize', 20);
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
xlabel('samples', 'Fontsize', 16);
xlabel('samples', 'Fontsize', 16);
set(gca,'Ytick',-20:15:15)

% ----------------------------- WE ----------------------------------
subplot (3,4,[3,4]) % ---- torso
grid on;
torso_range    = (1:12);
title1 = title('Torso', 'Fontsize', 20);
h1_WE = animatedline('color',greenAnDycolor,'lineWidth',4);
h1_len_WE = length(synchroKin.synchroKin(1).masterTime);
h1_vect_WE = 1:1:h1_len_WE;
axis([-0,h1_len_WE,-20,15]);
% ylabel('\tau [Nm]');
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
set(gca,'Ytick',-20:15:15)

subplot (3,4,8) % ---- right arm , with drill
grid on;
rightArm_range = (15:22);
title1 = title('Right arm', 'Fontsize', 20);
h2_WE = animatedline('color',greenAnDycolor,'lineWidth',4);
h2_len_WE = h1_len_WE;
h2_vect_WE = h1_vect_WE;
axis([-0,h1_len_WE,-20,15]);
% ylabel('\tau [Nm]');
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
set(gca,'Ytick',-20:15:15)

subplot (3,4,7) % ---- left arm , no drill
grid on;
leftArm_range  = (23:30);
title1 = title('Left arm', 'Fontsize', 20);
h3_WE = animatedline('color',greenAnDycolor,'lineWidth',4);
h3_len_WE = h1_len_WE;
h3_vect_WE = h1_vect_WE;
axis([-0,h1_len_WE,-20,15]);
% ylabel('\tau [Nm]');
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
set(gca,'Ytick',-20:15:15)

subplot (3,4,12) % ---- right leg
grid on;
rightLeg_range = (31:39);
title1 = title('Right leg', 'Fontsize', 20);
h4_WE = animatedline('color',greenAnDycolor,'lineWidth',4);
h4_len_WE = h1_len_WE;
h4_vect_WE = h1_vect_WE;
axis([-0,h1_len_WE,-20,15]);
% ylabel('\tau [Nm]');
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
xlabel('samples', 'Fontsize', 16);
xlabel('samples', 'Fontsize', 16);
set(gca,'Ytick',-20:15:15)

subplot (3,4,11) % ---- left leg
grid on;
leftLeg_range  = (40:48);
title1 = title('Left leg', 'Fontsize', 20);
h5_WE = animatedline('color',greenAnDycolor,'lineWidth',4);
h5_len_WE = h1_len_WE;
h5_vect_WE = h1_vect_WE;
axis([-0,h1_len_WE,-20,15]);
% ylabel('\tau [Nm]');
ax=gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
xlabel('samples', 'Fontsize', 16);
set(gca,'Ytick',-20:15:15)

% ------------------------------ Animation --------------------------------
tightfig();
for animIdx = 1 : h1_len_NE
    % NE
    addpoints(h1_NE, h1_vect_NE(animIdx), mean(tau_noexo.estimatedVariables.tau(1).values(torso_range,animIdx)));
    addpoints(h2_NE, h2_vect_NE(animIdx), mean(tau_noexo.estimatedVariables.tau(1).values(rightArm_range,animIdx)));
    addpoints(h3_NE, h3_vect_NE(animIdx), mean(tau_noexo.estimatedVariables.tau(1).values(leftArm_range,animIdx)));
    addpoints(h4_NE, h4_vect_NE(animIdx), mean(tau_noexo.estimatedVariables.tau(1).values(rightLeg_range,animIdx)));
    addpoints(h5_NE, h5_vect_NE(animIdx), mean(tau_noexo.estimatedVariables.tau(1).values(leftLeg_range,animIdx)));
    % WE
    addpoints(h1_WE, h1_vect_WE(animIdx), mean(tau_exo.estimatedVariables.tau(1).values(torso_range,animIdx)));
    addpoints(h2_WE, h2_vect_WE(animIdx), mean(tau_exo.estimatedVariables.tau(1).values(rightArm_range,animIdx)));
    addpoints(h3_WE, h3_vect_WE(animIdx), mean(tau_exo.estimatedVariables.tau(1).values(leftArm_range,animIdx)));
    addpoints(h4_WE, h4_vect_WE(animIdx), mean(tau_exo.estimatedVariables.tau(1).values(rightLeg_range,animIdx)));
    addpoints(h5_WE, h5_vect_WE(animIdx), mean(tau_exo.estimatedVariables.tau(1).values(leftLeg_range,animIdx)));
    
    drawnow limitrate % super fast
%     drawnow
    pause(0.005)
end


% Function to compute the relation between hip joint angle and hip torque
%for both hips.

deflection_angle_rad = 1; % in [rad]
% deflection_angle_rad = [0:1:110]*pi/180; % in [rad]

%% Preliminaries
k  = 21 * 10 * 10 * 10;	% [N/m] spring stiffness
sn = 0.07163;        	% [m] max pretension of spring
C  = 0.03;             	% [m] distance to rollers 0.03
B  = 0.01;              % [m] lever arm length 0.01
R  = 0.0075;        	% radius of profile 0.0075
restlength = 0.0;
pretension = 0.3;		% pretension of spring  67%
P01 = sn * pretension;

springPelvisThighActiveAngle = zeros(size(deflection_angle_rad));
F01 = zeros(size(deflection_angle_rad));
T01 = zeros(size(deflection_angle_rad));
for angleIdx = 1 : length(deflection_angle_rad)
    springPelvisThighActiveAngle(angleIdx) = abs(deflection_angle_rad(angleIdx) - restlength);
    
    I 		= C * cos(springPelvisThighActiveAngle(angleIdx)) - B;
    H 		= R - C * sin(springPelvisThighActiveAngle(angleIdx));
    A 		= sqrt(I * I + H * H);
    E 		= sqrt(A * A - R * R);
    gamma 	= atan2(H,I);
    theta 	= atan2(E,R);
    lambda 	= pi/2 - gamma - theta;
    kappa 	= pi/2 - gamma - theta - springPelvisThighActiveAngle(angleIdx);
    D 		= R * lambda;
    J 		= C * sin(kappa);
    
    Delta_L01 = (- C + B + D + E + P01);
    F01(angleIdx)	= k * (-C+B+D+E+P01);
    T01(angleIdx) = 2 * F01(angleIdx).* J;  % 2 is for the resulting torque 
                                              % is for both  maccepa (both legs)
end

%% Plot
fig = figure('Name', 'maccepaTorques','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
grid on;

% forces vs. deflection angles 
subplot (1,2,1)
plot1 = plot(deflection_angle_rad*180/pi,F01, 'k','lineWidth',4);
axis tight;
ax = gca;
ax.FontSize = 15;
hold on;
title('Maccepa forces','FontSize',22);
ylabel('f [N]','HorizontalAlignment','center',...
    'FontSize',40,'interpreter','latex');
xlabel('deflection angle [deg]','HorizontalAlignment','center',...
    'FontSize',20,'interpreter','latex');
grid on;

% torques vs. deflection angles
subplot (1,2,2)
plot1 = plot(deflection_angle_rad*180/pi, T01, ...
    'k','lineWidth',4);
axis tight;
ax = gca;
ax.FontSize = 15;
hold on
title('Maccepa spring torques','FontSize',22);
ylabel('$\tau$ [Nm]','HorizontalAlignment','center',...
    'FontSize',40,'interpreter','latex');
xlabel('deflection angle [deg]','HorizontalAlignment','center',...
    'FontSize',20,'interpreter','latex');
grid on;


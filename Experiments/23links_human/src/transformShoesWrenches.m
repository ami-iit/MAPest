
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function [shoes] = transformShoesWrenches(synchroStruct, subjectParamsFromData)
% TRANSFORMSHOESWRENCHES transforms external wrenches coming
% from the ftShoes into human frames.
%
% Inputs:
% - synchroStruct,        : right and left data releated to a block;
% - subjectParamsFromData : for getting the ankle heights, i.e the origin
%                           position of the reference frame of both feet
%                           wrt their projection on each shoe.
% Outputs:
% - shoes  : struct containing the Shoes wrenches transformed in human frames
%            (humanFootWrench) in Left and Right folders.
%
% Shoes wrenches are estimated in their frames (origin and
% orientation) that are located at a known position.
% For the human estimation we need to get from this wrenches but:
% - multiplied by -1 (as the wrench applied on the human is exactly the
%   opposite of the one excerted on each shoe)
% - expressed in the frame of the human link in contact.
%
% This function computes the wrenches that the each shoe exerts on the link
% in contact.  See the sketch footInShoe.pdf for the reference frames
% locations.
%
% Author(s): Claudia Latella
% Dynamic Interaction Control, Istituto Italiano di Tecnologia

%% Build the transformations
% LEFT---------------------------------------------------------------------
leftHeel_T_leftFtShoeRot = iDynTree.Rotation();
leftHeel_T_leftFtShoeRot.fromMatlab([ 1.0,  0.0,  0.0; ...
    0.0,  1.0,  0.0; ...
    0.0,  0.0,  1.0]);
leftHeel_T_leftFtShoePos = iDynTree.Position();
leftFtShoeSeenFromLeftHeel = [0.037; 0 ; -0.050]; %FtShoe (totalForce ref)
leftHeel_T_leftFtShoePos.fromMatlab(leftFtShoeSeenFromLeftHeel); % in m
leftFoot_T_leftHeelPos = iDynTree.Position();
leftHeelSeenFromLeftFoot = subjectParamsFromData.pLeftHeelFoot;
leftFoot_T_leftHeelPos.fromMatlab(leftHeelSeenFromLeftFoot); % in m
leftFoot_T_leftFtShoe = iDynTree.Transform(leftHeel_T_leftFtShoeRot,...
    leftFoot_T_leftHeelPos + leftHeel_T_leftFtShoePos);

% RIGHT--------------------------------------------------------------------
rightHeel_T_rightFtShoeRot = iDynTree.Rotation();
rightHeel_T_rightFtShoeRot.fromMatlab([ 1.0,  0.0,  0.0; ...
    0.0,  1.0,  0.0; ...
    0.0,  0.0,  1.0]);
rightHeel_T_rightFtShoePos = iDynTree.Position();
rightFtShoeSeenFromRightHeel = [0.037; 0 ; -0.050];
rightHeel_T_rightFtShoePos.fromMatlab(rightFtShoeSeenFromRightHeel); % in m
rightFoot_T_rightHeelPos = iDynTree.Position();
rightHeelSeenFromRightFoot = subjectParamsFromData.pRightHeelFoot;
rightFoot_T_rightHeelPos.fromMatlab(rightHeelSeenFromRightFoot); % in m
rightFoot_T_rightFtShoe = iDynTree.Transform(rightHeel_T_rightFtShoeRot,...
    rightFoot_T_rightHeelPos + rightHeel_T_rightFtShoePos);

%% Transform wrenches from shoes frames into human frames

leftShoeWrench(1:3,:) = synchroStruct.LeftShoe_SF(:,1:3)';
leftShoeWrench(4:6,:) = synchroStruct.LeftShoe_SF(:,4:6)';

rightShoeWrench(1:3,:) = synchroStruct.RightShoe_SF(:,1:3)';
rightShoeWrench(4:6,:) = synchroStruct.RightShoe_SF(:,4:6)';

shoes.block = synchroStruct.block;
% HF = human frame
shoes.Left_HF = ...
    -1*(leftFoot_T_leftFtShoe.asAdjointTransformWrench().toMatlab()*leftShoeWrench);
shoes.Right_HF = ...
    -1*(rightFoot_T_rightFtShoe.asAdjointTransformWrench().toMatlab()*rightShoeWrench);

%% Plot tmp
% %
% % LEFT SHOE
% fig = figure();
% axes1 = axes('Parent',fig,'FontSize',16);
%               box(axes1,'on');
%               hold(axes1,'on');
%               grid on;
% len = length(shoes.Left.humanFootWrench);
%
% subplot (231) % comparison forces component x
% plot1 = plot(leftShoeWrench(1,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Left.humanFootWrench(1,:),'r','lineWidth',1.5);
% ylabel('forces','HorizontalAlignment','center',...
%        'FontWeight','bold',...
%        'FontSize',18,...
%        'Interpreter','latex');
% xlim([0  len]);
% title ('x');
% grid on;
%
% subplot (232) % comparison forces component y
% plot1 = plot(leftShoeWrench(2,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Left.humanFootWrench(2,:),'r','lineWidth',1.5);
% title ('y');
% xlim([0  len]);
% grid on;
%
% subplot (233) % comparison forces component z
% plot1 = plot(leftShoeWrench(3,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Left.humanFootWrench(3,:),'r','lineWidth',1.5);
% title ('z');
% xlim([0  len]);
% grid on;
%
% subplot (234) % comparison moment component x
% plot1 = plot(leftShoeWrench(4,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Left.humanFootWrench(4,:),'r','lineWidth',1.5);
% ylabel('moments','HorizontalAlignment','center',...
%        'FontWeight','bold',...
%        'FontSize',18,...
%        'Interpreter','latex');
% xlim([0  len]);
% grid on;
%
% subplot (235) % comparison moment component y
% plot1 = plot(leftShoeWrench(5,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Left.humanFootWrench(5,:),'r','lineWidth',1.5);
% xlim([0  len]);
% grid on;
%
% subplot (236) % comparison moment component z
% plot1 = plot(leftShoeWrench(6,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Left.humanFootWrench(6,:),'r','lineWidth',1.5);
% xlim([0  len]);
% grid on;
%
% leg = legend([plot1,plot2],{'LeftShoes-frame','LeftFoot-frame'});
% set(leg,'Interpreter','latex', ...
%         'Position',[0.369020817175207 0.95613614004149 0.303215550427647 0.0305007585806261], ...
%        'Orientation','horizontal');
% set(leg,'FontSize',13);
%
% % RIGHT SHOE
% fig = figure();
% axes1 = axes('Parent',fig,'FontSize',16);
%               box(axes1,'on');
%               hold(axes1,'on');
%               grid on;
%
% subplot (231) % comparison forces component x
% plot1 = plot(rightShoeWrench(1,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Right.humanFootWrench(1,:),'r','lineWidth',1.5);
% ylabel('forces','HorizontalAlignment','center',...
%        'FontWeight','bold',...
%        'FontSize',18,...
%        'Interpreter','latex');
% xlim([0  len]);
% title ('x');
% grid on;
%
% subplot (232) % comparison forces component y
% plot1 = plot(rightShoeWrench(2,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Right.humanFootWrench(2,:),'r','lineWidth',1.5);
% title ('y');
% xlim([0  len]);
% grid on;
%
% subplot (233) % comparison forces component z
% plot1 = plot(rightShoeWrench(3,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Right.humanFootWrench(3,:),'r','lineWidth',1.5);
% title ('z');
% xlim([0  len]);
% grid on;
%
% subplot (234) % comparison moment component x
% plot1 = plot(rightShoeWrench(4,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Right.humanFootWrench(4,:),'r','lineWidth',1.5);
% ylabel('moments','HorizontalAlignment','center',...
%        'FontWeight','bold',...
%        'FontSize',18,...
%        'Interpreter','latex');
% xlim([0  len]);
% grid on;
%
% subplot (235) % comparison moment component y
% plot1 = plot(rightShoeWrench(5,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Right.humanFootWrench(5,:),'r','lineWidth',1.5);
% xlim([0  len]);
% grid on;
%
% subplot (236) % comparison moment component z
% plot1 = plot(rightShoeWrench(6,:),'b','lineWidth',1.5);
% hold on
% plot2 = plot(shoes.Right.humanFootWrench(6,:),'r','lineWidth',1.5);
% xlim([0  len]);
% grid on;
%
% leg = legend([plot1,plot2],{'RightShoe_frame','RightFoot_frame'});
% set(leg,'Interpreter','latex', ...
%         'Position',[0.369020817175207 0.95613614004149 0.303215550427647 0.0305007585806261], ...
%        'Orientation','horizontal');
% set(leg,'FontSize',13);

end

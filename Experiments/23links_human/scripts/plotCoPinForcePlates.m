function plotCoPinForcePlates(typeOfTask,subjectID,signalLength, CoPdata_right, CoPdata_left, bucket)
% PLOTCOPINFORCEPLATES graphically shows how the CoP varies in both the
% plates w.r.t. time.

close all;
opts.videoRecording = false;
% Path to video folder
opts.videoRecording
if opts.videoRecording
    bucket.pathToVideoFolder = fullfile(bucket.pathToTask,'video');
    if ~exist(bucket.pathToVideoFolder)
        mkdir (bucket.pathToVideoFolder)
    end
end

%% RIGHT FP
fig = figure();
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');

if opts.videoRecording
    newVideoFilename = 'CoP_right.avi';
    vobj = VideoWriter(newVideoFilename,'Motion JPEG AVI');
    vobj.FrameRate = 0.5;
    vobj.Quality = 100;
    open(vobj);
end

% Force plate corners w.r.t. Matlab standard axes
deltaValue = 35;
% frame origin
p_FPx_0 = 0;
p_FPy_0 = 0;
% FP Channel 1
p_FPx_1 = +250;
p_FPy_1 = +300;
text(p_FPx_1-deltaValue,p_FPy_1-deltaValue,'1','FontSize', 15);
% FP Channel 2
p_FPx_2 = +250;
p_FPy_2 = -300;
text(p_FPx_2-deltaValue,p_FPy_2+deltaValue,'2','FontSize', 15);
% FP Channel 3
p_FPx_3 = -250;
p_FPy_3 = -300;
text(p_FPx_3+deltaValue,p_FPy_3+deltaValue,'3','FontSize', 15);
% FP Channel 4
p_FPx_4 = -250;
p_FPy_4 = +300;
text(p_FPx_4+deltaValue,p_FPy_4-deltaValue,'4','FontSize', 15);

% limits
xlim([-(p_FPy_1 + 100); (p_FPy_1 + 100)]);
ylim([-(p_FPx_1 + 100); (p_FPx_1 + 100)]);

% force plate axes
plot([150 0],[0 0],'r'); % x axis
text(180,0,'x','FontSize', 15);
plot([0 0],[-200 0],'g'); % y axis
text(0,-230,'y','FontSize', 15);

plot_FPorigin = plot(p_FPx_0, p_FPy_0,'ob');
plot([p_FPx_1 p_FPx_2],[p_FPy_1 p_FPy_3],'k');
plot([p_FPx_2 p_FPx_3],[p_FPy_2 p_FPy_3],'k');
plot([p_FPx_3 p_FPx_4],[p_FPy_3 p_FPy_4],'k');
plot([p_FPx_4 p_FPx_1],[p_FPy_4 p_FPy_1],'k');

% Half of the box is positioned on the top
% text(p_FPx_4+deltaValue,p_FPy_4+2*deltaValue,'Right half of the box here','FontSize', 15);

titleR = title(sprintf('CoP on Right force plate, %s, Subj %03d',typeOfTask,subjectID));
set(titleR, 'FontSize', 20);
xlabel(' length [mm]');
ylabel(' width [mm]');

% Force plate corners w.r.t. force plate axes
for lengthIdx = 1 : signalLength
    p_CoPxR = CoPdata_right.CoPx(lengthIdx,1);
    p_CoPyR = CoPdata_right.CoPy(lengthIdx,1);
    plot_CoP_right = plot(p_CoPxR, -p_CoPyR,'ok');
    pause(0.001)
    if opts.videoRecording
        % record video
        frame = getframe(1);
        writeVideo(vobj, frame);
    end
end

if opts.videoRecording
    % save video into the folder
    close(vobj); % close the object so its no longer tied up by matlab
    % close(gcf);  % close figure since we don't need it anymore
    % move file into the video folder
    filenameToBeMoved =  fullfile(pwd, newVideoFilename);
    folderNew = bucket.pathToVideoFolder;
    movefile(filenameToBeMoved, folderNew);
end

%% LEFT FP
fig = figure();
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');

if opts.videoRecording
    newVideoFilename = 'CoP_left.avi';
    vobj = VideoWriter(newVideoFilename,'Motion JPEG AVI');
    vobj.FrameRate = 0.5;
    vobj.Quality = 100;
    open(vobj);
end

% Force plate corners w.r.t. Matlab standard axes
deltaValue = 35;
% frame origin
p_FPx_0 = 0;
p_FPy_0 = 0;
% FP Channel 1
p_FPx_1 = +250;
p_FPy_1 = +300;
text(p_FPx_1-deltaValue,p_FPy_1-deltaValue,'3','FontSize', 15);
% FP Channel 2
p_FPx_2 = +250;
p_FPy_2 = -300;
text(p_FPx_2-deltaValue,p_FPy_2+deltaValue,'4','FontSize', 15);
% FP Channel 3
p_FPx_3 = -250;
p_FPy_3 = -300;
text(p_FPx_3+deltaValue,p_FPy_3+deltaValue,'1','FontSize', 15);
% FP Channel 4
p_FPx_4 = -250;
p_FPy_4 = +300;
text(p_FPx_4+deltaValue,p_FPy_4-deltaValue,'2','FontSize', 15);

% limits
xlim([-(p_FPy_1 + 100); (p_FPy_1 + 100)]);
ylim([-(p_FPx_1 + 100); (p_FPx_1 + 100)]);

% force plate axes
plot([-150 0],[0 0],'r'); % x axis
text(-180,0,'x','FontSize', 15);
plot([0 0],[200 0],'g'); % y axis
text(0,230,'y','FontSize', 15);

plot_FPorigin = plot(p_FPx_0, p_FPy_0,'ob');
plot([p_FPx_1 p_FPx_2],[p_FPy_1 p_FPy_3],'k');
plot([p_FPx_2 p_FPx_3],[p_FPy_2 p_FPy_3],'k');
plot([p_FPx_3 p_FPx_4],[p_FPy_3 p_FPy_4],'k');
plot([p_FPx_4 p_FPx_1],[p_FPy_4 p_FPy_1],'k');

% Half of the box is positioned on the top
% text(p_FPx_1-10*deltaValue,p_FPy_1+2*deltaValue,'Left half of the box here','FontSize', 15);

titleR = title(sprintf('CoP on Left force plate, %s, Subj %03d',typeOfTask,subjectID));
set(titleR, 'FontSize', 20);
xlabel(' length [mm]');
ylabel(' width [mm]');

% Force plate corners w.r.t. force plate axes
for lengthIdx = 1 : signalLength
    p_CoPxL = CoPdata_left.CoPx(lengthIdx,1);
    p_CoPyL = CoPdata_left.CoPy(lengthIdx,1);
    plot_CoP_left = plot(-p_CoPxL, p_CoPyL,'ok');
    pause(0.001)
    if opts.videoRecording
        % record video
        frame = getframe(1);
        writeVideo(vobj, frame);
    end
end

if opts.videoRecording
    % save video into the folder
    close(vobj); % close the object so its no longer tied up by matlab
    % close(gcf);  % close figure since we don't need it anymore
    % move file into the video folder
    filenameToBeMoved =  fullfile(pwd, newVideoFilename);
    folderNew = bucket.pathToVideoFolder;
    movefile(filenameToBeMoved, folderNew);
end
end


% =========================================================================
%                 NORM MEAN AREAS EFFECTS
% =========================================================================

areas.label = {'Torso'; ...
    'Head'; ...
    'LeftArm'; ...
    'RightArm'; ...
    'LeftLeg'; ...
    'RightLeg'};
areas.range = {[1:12]; ...
    [13:14]; ...
    [23:30]; ...
    [15:22]; ...
    [40:48]; ...
    [31:39]};

% =========================================================================
%                 NORM MEAN WHOLE-BODY EFFECTS
% =========================================================================
%% Intra-subject whole-body torque norm
for areaIdx = 1 : length(areas.label)
    for subjIdx = 1 : nrOfSubject
        for blockIdx = 1 : block.nrOfBlocks
            intraSubj(subjIdx).torqueNormNE(blockIdx).block = block.labels(blockIdx);
            intraSubj(subjIdx).torqueNormWE(blockIdx).block = block.labels(blockIdx);
            lenNE = length(intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values);
            lenWE = length(intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values);
            % ---- norm NE
            for i = 1 : lenNE
                intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm(1,i) = ...
                    norm(intraSubj(subjIdx).NE.estimatedVariables.tau(blockIdx).values(areas.range{areaIdx},i));
            end
            % ---- norm WE
            for i = 1 : lenWE
                intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm(1,i) = ...
                    norm(intraSubj(subjIdx).WE.estimatedVariables.tau(blockIdx).values(areas.range{areaIdx},i));
            end
        end
    end
    
    % Normalization and mean
    for subjIdx = 1 : nrOfSubject
        for blockIdx = 1 : block.nrOfBlocks
            % ---- normalized norm NE
            intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm_normalized = ...
                (intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm - ...
                min(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm))/ ...
                (max(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm) - ...
                min(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm));
            % mean of the normalized norm NE
            intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNormMean(areaIdx).normMean = ...
                mean(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm_normalized);
            % ---- normalized norm WE
            intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm_normalized = ...
                (intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm - ...
                min(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm))/ ...
                (max(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm) - ...
                min(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm));
            % mean of the normalized norm WE
            intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNormMean(areaIdx).normMean = ...
                mean(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm_normalized);
        end
    end
end

%% Statistics
tmp.tmp_vect = [];
for areaIdx = 1 : length(areas.label)
    stats_vect = [];
    for blockIdx = 1 : block.nrOfBlocks
        for subjIdx = 1 : nrOfSubject
            % NE
            tmp.tmp_vect(subjIdx,1) = ...
                intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNormMean(areaIdx).normMean;
            % WE
            tmp.tmp_vect(subjIdx,2) = ...
                intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNormMean(areaIdx).normMean;
        end
        stats_vect = [stats_vect; tmp.tmp_vect];
    end
    completeStats(areaIdx,1).stats_vect_perArea = stats_vect;
    % ANOVA2 computation
    % Computation two-way analysis of variance (ANOVA) with balanced designs.
    % - columns --> conditions (NE or WE), nrOfGroups = 2
    % - rows    --> block (per subject) --> block.nrOfBlocks*nrOfSubject
    repetitions = block.nrOfBlocks;
    [~,~,stats_anova2] = anova2(completeStats(areaIdx,1).stats_vect_perArea,repetitions);
    completeStats(areaIdx,1).c = multcompare(stats_anova2);
end

%% ----- Box plot
% ============================= single block ==============================
fig = figure('Name', 'stats joints per area','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');

for blockIdx = 1 : block.nrOfBlocks
    % -------------------------------- torso ------------------------------
    areaIdx = 1;
    sub1 = subplot(6,6,blockIdx);
    tmp.range = nrOfSubject*(blockIdx-1)+1 : nrOfSubject*blockIdx;
    box1 = boxplot(completeStats(areaIdx,1).stats_vect_perArea(tmp.range,:));
    ax = gca;
    ax.FontSize = 20;
    set(box1, 'Linewidth', 2.5);
    h = findobj(gca,'Tag','Box');
    % Group 1
    patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
    % Group 2
    patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);
    
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',20);
    if blockIdx == 1
        ylabel('$|\tau^{t}|$', 'HorizontalAlignment','center',...
            'FontSize',25,'interpreter','latex');
    else
        set(gca,'YTickLabel',[]);
    end
    set(gca,'XTickLabel',[]);
    %     xlabel('Conditions','HorizontalAlignment','center',...
    %         'FontSize',25,'interpreter','latex');
    %     set(sub1,'TickLabelInterpreter','none','XTick',[1 2],...
    %         'XTickLabel',{'WE','NE'});
    ax=gca;
    ax.XAxis.FontSize = 20;
    ylim([0 1]);
    grid on;
    
    hold on;
    % -------------------------------- head -------------------------------
    areaIdx = 2;
    sub1 = subplot(6,6,blockIdx+6);
    tmp.range = nrOfSubject*(blockIdx-1)+1 : nrOfSubject*blockIdx;
    box1 = boxplot(completeStats(areaIdx,1).stats_vect_perArea(tmp.range,:));
    ax = gca;
    ax.FontSize = 20;
    set(box1, 'Linewidth', 2.5);
    h = findobj(gca,'Tag','Box');
    % Group 1
    patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
    % Group 2
    patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);
    
    if blockIdx == 1
        ylabel('$|\tau^{h}|$', 'HorizontalAlignment','center',...
            'FontSize',25,'interpreter','latex');
    else
        set(gca,'YTickLabel',[]);
    end
    set(gca,'XTickLabel',[]);
    %     xlabel('Conditions','HorizontalAlignment','center',...
    %         'FontSize',25,'interpreter','latex');
    %     set(sub1,'TickLabelInterpreter','none','XTick',[1 2],...
    %         'XTickLabel',{'WE','NE'});
    ax=gca;
    ax.XAxis.FontSize = 20;
    ylim([0 1]);
    grid on;
    
    hold on;
    % ---------------------------- left arm ------------------------------
    areaIdx = 3;
    sub1 = subplot(6,6,blockIdx+12);
    tmp.range = nrOfSubject*(blockIdx-1)+1 : nrOfSubject*blockIdx;
    box1 = boxplot(completeStats(areaIdx,1).stats_vect_perArea(tmp.range,:));
    ax = gca;
    ax.FontSize = 20;
    set(box1, 'Linewidth', 2.5);
    h = findobj(gca,'Tag','Box');
    % Group 1
    patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
    % Group 2
    patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);
    
    if blockIdx == 1
        ylabel('$|\tau^{larm}|$', 'HorizontalAlignment','center',...
            'FontSize',25,'interpreter','latex');
    else
        set(gca,'YTickLabel',[]);
    end
    set(gca,'XTickLabel',[]);
    %     xlabel('Conditions','HorizontalAlignment','center',...
    %         'FontSize',25,'interpreter','latex');
    %     set(sub1,'TickLabelInterpreter','none','XTick',[1 2],...
    %         'XTickLabel',{'WE','NE'});
    ax=gca;
    ax.XAxis.FontSize = 20;
    ylim([0 1]);
    grid on;
    
    hold on;
    % ---------------------------- right arm ------------------------------
    areaIdx = 4;
    sub1 = subplot(6,6,blockIdx+18);
    tmp.range = nrOfSubject*(blockIdx-1)+1 : nrOfSubject*blockIdx;
    box1 = boxplot(completeStats(areaIdx,1).stats_vect_perArea(tmp.range,:));
    ax = gca;
    ax.FontSize = 20;
    set(box1, 'Linewidth', 2.5);
    h = findobj(gca,'Tag','Box');
    % Group 1
    patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
    % Group 2
    patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);
    
    if blockIdx == 1
        ylabel('$|\tau^{rarm}|$', 'HorizontalAlignment','center',...
            'FontSize',25,'interpreter','latex');
    else
        set(gca,'YTickLabel',[]);
    end
    set(gca,'XTickLabel',[]);
    %     xlabel('Conditions','HorizontalAlignment','center',...
    %         'FontSize',25,'interpreter','latex');
    %     set(sub1,'TickLabelInterpreter','none','XTick',[1 2],...
    %         'XTickLabel',{'WE','NE'});
    ax=gca;
    ax.XAxis.FontSize = 20;
    ylim([0 1]);
    grid on;
    % ---------------------------- left leg ------------------------------
    areaIdx = 5;
    sub1 = subplot(6,6,blockIdx+24);
    tmp.range = nrOfSubject*(blockIdx-1)+1 : nrOfSubject*blockIdx;
    box1 = boxplot(completeStats(areaIdx,1).stats_vect_perArea(tmp.range,:));
    ax = gca;
    ax.FontSize = 20;
    set(box1, 'Linewidth', 2.5);
    h = findobj(gca,'Tag','Box');
    % Group 1
    patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
    % Group 2
    patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);
    
    if blockIdx == 1
        ylabel('$|\tau^{lleg}|$', 'HorizontalAlignment','center',...
            'FontSize',25,'interpreter','latex');
    else
        set(gca,'YTickLabel',[]);
    end
    set(gca,'XTickLabel',[]);
    %     xlabel('Conditions','HorizontalAlignment','center',...
    %         'FontSize',25,'interpreter','latex');
    %     set(sub1,'TickLabelInterpreter','none','XTick',[1 2],...
    %         'XTickLabel',{'WE','NE'});
    ax=gca;
    ax.XAxis.FontSize = 20;
    ylim([0 1]);
    grid on;
    
    hold on;
    % ---------------------------- right leg ------------------------------
    areaIdx = 6;
    sub1 = subplot(6,6,blockIdx+30);
    tmp.range = nrOfSubject*(blockIdx-1)+1 : nrOfSubject*blockIdx;
    box1 = boxplot(completeStats(areaIdx,1).stats_vect_perArea(tmp.range,:));
    ax = gca;
    ax.FontSize = 20;
    set(box1, 'Linewidth', 2.5);
    h = findobj(gca,'Tag','Box');
    % Group 1
    patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
    % Group 2
    patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);
    
    if blockIdx == 1
        ylabel('$|\tau^{rleg}|$', 'HorizontalAlignment','center',...
            'FontSize',25,'interpreter','latex');
    else
        set(gca,'YTickLabel',[]);
    end
    %     xlabel('Conditions','HorizontalAlignment','center',...
    %         'FontSize',25,'interpreter','latex');
    set(sub1,'TickLabelInterpreter','none','XTick',[1 2],...
        'XTickLabel',{'WE','NE'});
    ax=gca;
    ax.XAxis.FontSize = 20;
    ylim([0 1]);
    grid on;
end

% ================================ total ==================================
for areaIdx = 1 : length(areas.label)
    sub2 = subplot(6,6,6*areaIdx);
    box1 = boxplot(completeStats(areaIdx).stats_vect_perArea);
    ax = gca;
    ax.FontSize = 20;
    set(box1, 'Linewidth', 2.5);
    h = findobj(gca,'Tag','Box');
    % Group 1
    patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
    % Group 2
    patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);
    
    % ----- Statistical significance among pair of groups
    % Add stars and lines highlighting significant differences between pairs of groups.
    % Stars are drawn according to:
    %   * represents p<=0.05
    %  ** represents p<=1E-2
    % *** represents p<=1E-3
    H = sigstar({[1,2]},[completeStats(areaIdx,1).c(1,6)]);
    if areaIdx == 1
        title('Total','FontSize',20);
    end
    % % %     ylabel('Normalized $\tau_{NORM}$ mean', 'HorizontalAlignment','center',...
    % % %         'FontSize',25,'interpreter','latex');
    % % % % xlabel('Factor: subjects ','HorizontalAlignment','center',...
    % % % %     'FontSize',25,'interpreter','latex');
    set(gca,'xTickLabel',[]);
    if areaIdx == 6
        set(sub2,'TickLabelInterpreter','none','XTick',[1 2],...
            'XTickLabel',{'WE','NE'});
    else
        set(gca,'XTickLabel',[]);
    end
    ax=gca;
    ax.XAxis.FontSize = 20;
    ylim([0 1]);
    grid on;
end

% tightfig();
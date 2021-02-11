
%% RMSE for group variability
% % % for subjIdx = 1 : nrOfSubject
% % %     tmp.RMSE_vectorAcrossBlocks = [];
% % %     for blockIdx = 1 : block.nrOfBlocks
% % %         NE_vect = intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm_normalized ...
% % %             (:,min(intraSubj(subjIdx).lengthNE(blockIdx).len,intraSubj(subjIdx).lengthWE(blockIdx).len));
% % %         WE_vect = intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm_normalized ...
% % %             (:,min(intraSubj(subjIdx).lengthNE(blockIdx).len,intraSubj(subjIdx).lengthWE(blockIdx).len));
% % %         % RMSE on normalized vectors
% % %         intraSubj(subjIdx).RMSE_normalized(blockIdx).RMSE = ...
% % %             sqrt(mean((NE_vect - WE_vect).^2));
% % %         tmp.RMSE_vectorAcrossBlocks = [tmp.RMSE_vectorAcrossBlocks; intraSubj(subjIdx).RMSE_normalized(blockIdx).RMSE];
% % %     end
% % %     intraSubj(subjIdx).RMSE_subj = tmp.RMSE_vectorAcrossBlocks;
% % % end
% % %
% % % RMSE_normalized_group1 = [intraSubj(1).RMSE_subj; ...
% % %     intraSubj(3).RMSE_subj; ...
% % %     intraSubj(5).RMSE_subj; ...
% % %     intraSubj(7).RMSE_subj; ...
% % %     intraSubj(9).RMSE_subj; ...
% % %     intraSubj(11).RMSE_subj];
% % % RMSE_normalized_group2 = [intraSubj(2).RMSE_subj; ...
% % %     intraSubj(4).RMSE_subj; ...
% % %     intraSubj(6).RMSE_subj; ...
% % %     intraSubj(8).RMSE_subj; ...
% % %     intraSubj(10).RMSE_subj; ...
% % %     intraSubj(12).RMSE_subj];
% % % RMSE_normalized_groups = [RMSE_normalized_group1, RMSE_normalized_group2];
% % %
% % % % anova2
% % % repetitions = 5;
% % % [~,~,stats_anova2] = anova2(RMSE_normalized_groups,repetitions);
% % % c = multcompare(stats_anova2);
% % %
% % % % box plot
% % % fig = figure('Name', 'stats all joints','NumberTitle','off');
% % % axes1 = axes('Parent',fig,'FontSize',16);
% % % box(axes1,'on');
% % % hold(axes1,'on')
% % %
% % % box1 = boxplot(RMSE_normalized_groups);
% % % ax = gca;
% % % ax.FontSize = 20;
% % % set(box1, 'Linewidth', 2.5);
% % %
% % % % ----- Statistical significance among pair of groups
% % % % Add stars and lines highlighting significant differences between pairs of groups.
% % % % Stars are drawn according to:
% % % %   * represents p<=0.05
% % % %  ** represents p<=1E-2
% % % % *** represents p<=1E-3
% % % H = sigstar({[1,2]},[c(1,6)]);
% % % title('Total','FontSize',20);
% % % % % %     ylabel('Normalized $\tau_{NORM}$ mean', 'HorizontalAlignment','center',...
% % % % % %         'FontSize',25,'interpreter','latex');
% % % % % % % xlabel('Factor: subjects ','HorizontalAlignment','center',...
% % % % % % %     'FontSize',25,'interpreter','latex');
% % % set(sub2,'TickLabelInterpreter','none','XTick',[1 2],...
% % %     'XTickLabel',{'WE','NE'});
% % % ax=gca;
% % % ax.XAxis.FontSize = 20;
% % % ylim([0 1]);
% % % grid on;

%% Statistics
stats_vect = [];
tmp.tmp_vect = [];
for blockIdx = 1 : block.nrOfBlocks
    for subjIdx = 1 : nrOfSubject
        % NE
        tmp.tmp_vect(subjIdx,1) = ...
            mean(intraSubj(subjIdx).torqueNormNE(blockIdx).torqueNorm_normalized);
        % WE
        tmp.tmp_vect(subjIdx,2) = ...
            mean(intraSubj(subjIdx).torqueNormWE(blockIdx).torqueNorm_normalized);
    end
    stats_vect = [stats_vect; tmp.tmp_vect];
end
% ANOVA2 computation
% Computation two-way analysis of variance (ANOVA) with balanced designs.
% - columns --> conditions (NE or WE), nrOfGroups = 2
% - rows    --> block (per subject) --> block.nrOfBlocks*nrOfSubject
repetitions = block.nrOfBlocks;
% [p,tbl] = anova2(stats_vect,repetitions);
[~,tbl,stats_anova2] = anova2(stats_vect,repetitions);
c = multcompare(stats_anova2);

%% ----- Box plot
% ============================= single block ==============================
fig = figure('Name', 'stats all joints','NumberTitle','off');
axes1 = axes('Parent',fig,'FontSize',16);
box(axes1,'on');
hold(axes1,'on');
for blockIdx = 1 : block.nrOfBlocks
    sub1 = subplot(1,6,blockIdx);
    tmp.range = nrOfSubject*(blockIdx-1)+1 : nrOfSubject*blockIdx;
    box1 = boxplot(stats_vect(tmp.range,:));
    ax = gca;
    ax.FontSize = 30;
    set(box1, 'Linewidth', 2.5);
    h = findobj(gca,'Tag','Box');
    % Group 1
    patch(get(h(1),'XData'),get(h(1),'YData'),orangeAnDycolor,'FaceAlpha',.8);
    % Group 2
    patch(get(h(2),'XData'),get(h(2),'YData'),greenAnDycolor,'FaceAlpha',.8);
    
    title(sprintf('Block %s', num2str(blockIdx)),'FontSize',20);
    if blockIdx == 1
        ylabel('$||\tau^{wb}||$', 'HorizontalAlignment','center',...
            'FontSize',40,'interpreter','latex');
    else
        set(gca,'YTickLabel',[]);
    end
    %     xlabel('Conditions','HorizontalAlignment','center',...
    %             'FontSize',25,'interpreter','latex');
    %     set(sub1,'TickLabelInterpreter','none','XTick',[1 2],...
    %         'XTickLabel',{'WE','NE'});
    set(gca,'XTickLabel',[]);
    ax=gca;
    ax.XAxis.FontSize = 20;
    ylim([0.18 0.85]);
    grid on;
    box off;
end

% ================================ total ==================================
sub2 = subplot(1,6,6);
box1 = boxplot(stats_vect);
ax = gca;
ax.FontSize = 30;
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
H = sigstar({[1,2]},[c(1,6)]);
title('Total','FontSize',20);
% % %     ylabel('Normalized $\tau_{NORM}$ mean', 'HorizontalAlignment','center',...
% % %         'FontSize',25,'interpreter','latex');
% % % % xlabel('Factor: subjects ','HorizontalAlignment','center',...
% % % %     'FontSize',25,'interpreter','latex');
% set(sub2,'TickLabelInterpreter','none','XTick',[1 2],...
%     'XTickLabel',{'WE','NE'});
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
ax=gca;
ax.XAxis.FontSize = 20;
ylim([0.18 0.85]);
grid on;
box off;

%legend
leg = legend({'NE','WE'},'Location','southeast');
set(leg,'Interpreter','latex','FontSize',30);

% % align_Ylabels(gcf)
% subplotsqueeze(gcf, 1.12);
tightfig();
% save
if saveON
    save2pdf(fullfile(bucket.pathToPlots,'anova2_normTauWB'),fig,600);
end

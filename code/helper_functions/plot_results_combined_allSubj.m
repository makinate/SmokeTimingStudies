function plot_results_combined_allSubj
% plot combined results

addpath([ pwd '/helper_functions']);   % add path to helper functions

subjs = {'EAC','MK'};

for s = 1:length(subjs)
    
    data_path = ['../data/' subjs{s} '/'];
    
    % load smoke data
    smoke_path = dir([data_path subjs{s} '_smoke*.mat']);
    load( [data_path smoke_path.name] );
    smoke = plot_results_smoke(dat,0);
    
    % load cyl data
    cyl_path = dir([data_path subjs{s} '_cylinder*.mat']);
    load( [data_path cyl_path.name] );
    cyl = plot_results_smoke(dat,0);
    
    % store for plotting/stats
    allSubjSpeedSmoke(s,:) = smoke.mean_sp;
    allSubjSpeedCyl(s,:) = cyl.mean_sp;
    %allSubjDurSmoke(:,s) = smoke
    
end

% compute mean and stdev across subjects
mean_speed_smoke = mean(allSubjSpeedSmoke,1);
std_speed_smoke = std(allSubjSpeedSmoke,[],1);

mean_speed_cyl = mean(allSubjSpeedCyl,1);
std_speed_cyl = std(allSubjSpeedCyl,[],1);

f_resp = figure; hold on; %title(['Speed = ' num2str(speeds(s)) ', Distance = ' num2str(distances(d))]);
setupfig(16,16,16); % setup figure width, height, and font size (helperfunction)

% speed effect
subplot(2,2,1); hold on; title('speed');
%plot(dat.speeds,mean_sp,'k-')
plot(smoke.speeds + 0.1,mean_speed_smoke,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
errorbar(smoke.speeds + 0.1,mean_speed_smoke,std_speed_smoke);
plot(cyl.speeds - 0.1,mean_speed_cyl,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
errorbar(cyl.speeds - 0.1,mean_speed_cyl,std_speed_cyl);
xlabel('speed');
ylabel('reaction time');

keyboard

% duration effect
subplot(2,2,2); hold on; title('duration');
%plot(dat.speeds,mean_sp,'k-')
plot(smoke.durationsFs,smoke.mean_dur,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
plot(cyl.durationsFs,cyl.mean_dur,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
xlabel('duration');
ylabel('reaction time');

% density
subplot(2,2,3); hold on; title('density');
%plot(dat.speeds,mean_sp,'k-')
plot(smoke.densities,smoke.mean_dens,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
plot(10,cyl.mean_dens,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
xlabel('densities');
ylabel('reaction time');

% distance
subplot(2,2,4); hold on; title('distance');
%plot(dat.speeds,mean_sp,'k-')
plot(smoke.distances,smoke.mean_dist,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
plot(cyl.distances,cyl.mean_dist,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
xlabel('distance');
ylabel('reaction time');

%for stimType = {'smoke', 'cylinder'}

% open plot
% load data for cylinder
% plot data for cylinder
% load data for smoke
% plot data for smoke
% make plots pretty


%     % manually select files, can combine multiple
%     if isempty(dat)
%
%         [files,path] = uigetfile(['../data/' subj '/*.mat'],'Select sessions to analyze','multiselect','on');
%
%         % initialize fields needed for plotting
%         dat.speeds                = [];
%         dat.densities             = [];
%         dat.durationsFs           = [];
%         dat.distances             = [];
%         dat.trials.speed          = [];
%         dat.trials.resp           = [];
%         dat.trials.respTime       = [];
%         dat.test_type             = [];
%
%         % load these fields from each selected file
%         if ~iscell(files) % determine if files is NOT a cell array
%
%             % just one file to be loaded
%             load([path '/' files])
%             display([path '/' files])
%
%         else
%
%             % load each file
%             for fii = 1:length(files)
%
%                 display(files(fii));
%                 tmp = load([path '/' files{fii}]);
%
%                 display(dat.trials);
%
%                 dat.speeds        = [dat.speeds tmp.dat.speeds];
%                 dat.densities     = [dat.densities tmp.dat.densities];
%                 dat.durationsFs   = [dat.durationsFs tmp.dat.durationsFs];
%                 dat.distances     = [dat.distances tmp.dat.distances];
%                 dat.trials.resp   = [dat.trials.resp permute(tmp.dat.trials.resp, [2 1])];
%
%                 % make one plot for each distance
%                 for d = 1:length(dat.distances)
%                     figure(f_resp); hold on;
%                     subplot(2,3,d); hold on;
%                     plot(5,5);
%                 end
%
%             end
%
%
%
%         end
%
%     end

%end


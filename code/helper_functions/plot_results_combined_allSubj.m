function plot_results_combined_allSubj
% plot combined results smoke study

addpath([ pwd '/helper_functions']);   % add path to helper functions

% subject list; expand this as more and more subjects come in
% study1: 
%subjs = {'EAC', 'MK', 'HS', 'SHP', 'MM', 'MJM', 'SBM', 'MJD', 'SLH', 'ESG', 'AMO', 'BVB', 'SRF', 'IWP', 'KCH'};
% study 2
%subjs = {'KB','CC', 'ITF', 'SP', 'DG', 'SH', 'AR', 'CS', 'DN', 'HV', 'JM', 'AC'};
% combined
subjs = {'EAC', 'MK', 'HS', 'SHP', 'MM', 'MJM', 'SBM', 'MJD', 'SLH', 'ESG', 'AMO', 'BVB', 'SRF', 'IWP', 'KCH','KB','CC', 'ITF', 'SP', 'DG', 'SH', 'AR', 'CS', 'DN', 'HV', 'JM', 'AC'};


% open txt file for writing
f_ID  = fopen('ANOVA_table.txt', 'w');
f_raw = fopen('raw_table.txt', 'w');

% add header to file
fprintf(f_ID, '%s %s %s %s %s %s\n', 'sbj', 'speed', 'density', 'distance', 'duration', 'resp');
fprintf(f_raw, '%s %s %s %s %s %s %s\n', 'sbj', 'rep', 'speed', 'density', 'distance', 'duration', 'resp');
for s = 1:length(subjs)
    
    data_path = ['../data/' subjs{s} '/'];
    
    % load smoke data
    smoke_path = dir([data_path subjs{s} '_smoke*.mat']);
    load( [data_path smoke_path.name] );
    smoke = plot_results_smoke(dat,0);
    
    % load disk data
    disk_path = dir([data_path subjs{s} '_disk*.mat']);
    load( [data_path disk_path.name] );
    disk = plot_results_smoke(dat,0);
    
    % store for plotting/stats
    allSubjSpeedSmoke(s,:) = smoke.mean_sp;
    allSubjSpeedDisk(s,:)  = disk.mean_sp;
    
    allSubjDurSmoke(s,:)   = smoke.mean_dur;
    allSubjDurDisk(s,:)    = disk.mean_dur;
    
    allSubjDistSmoke(s,:)  = smoke.mean_dist;
    allSubjDistDisk(s,:)   = disk.mean_dist;
    
    allSubjDensSmoke(s,:)  = smoke.mean_dens;
    allSubjDensDisk(s,:)   = disk.mean_dens;
    
    for den = [1 10 20 99]
        for dist = [210 230 250]
            for dur = [35 70]
                for sp = [10 20]
                    if den == 99
                        
                        tmp_resp = disk.median_resp(disk.speed == sp & disk.distance == dist & disk.density == den & disk.duration == dur);
                        
                        % save data into txt file for R
                        fprintf(f_ID, '%f %f %f %f %f %f\n', s,sp,den, dist,dur, tmp_resp);
                        
                        % save raw data for each rep
                        for rep = [1:5]
                            
                            tmp_resp = disk.trials.resp(disk.trials.speed == sp & disk.trials.distance == dist & disk.trials.density == den & disk.trials.duration == dur & disk.trials.repeat == rep);
                            fprintf(f_raw, '%f %f %f %f %f %f %f\n', s,rep, sp,den, dist,dur, tmp_resp);
                        end
                    else
                        tmp_resp = smoke.median_resp(smoke.speed == sp & smoke.distance == dist & smoke.density == den & smoke.duration == dur);
                        % save data into txt file for R
                        fprintf(f_ID, '%f %f %f %f %f %f\n', s, sp, den, dist,dur, tmp_resp);
                        % save raw data for each rep
                        for rep = [1:5]
                            
                            tmp_resp = smoke.trials.resp(smoke.trials.speed == sp & smoke.trials.distance == dist & smoke.trials.density == den & smoke.trials.duration == dur & smoke.trials.repeat == rep);
                            fprintf(f_raw, '%f %f %f %f %f %f %f\n', s,rep, sp,den, dist,dur, tmp_resp);
                        end
                        
                    end
                end
            end
        end
    end
    
end

fclose(f_ID);
fclose(f_raw);
% compute mean and stdev across subjects
mean_speed_smoke = mean(allSubjSpeedSmoke,1);
std_speed_smoke = std(allSubjSpeedSmoke,[],1);
SEM_speed_smoke = std(allSubjSpeedSmoke,[],1)/sqrt(length(subjs));

mean_speed_disk = mean(allSubjSpeedDisk,1);
std_speed_disk = std(allSubjSpeedDisk,[],1);
SEM_speed_disk = std(allSubjSpeedDisk,[],1)/sqrt(length(subjs));


mean_dur_smoke = mean(allSubjDurSmoke,1);
std_dur_smoke = std(allSubjDurSmoke,[],1);
SEM_dur_smoke = std(allSubjDurSmoke,[],1)/sqrt(length(subjs));


mean_dur_disk = mean(allSubjDurDisk,1);
std_dur_disk = std(allSubjDurDisk,[],1);
SEM_dur_disk = std(allSubjDurDisk,[],1)/sqrt(length(subjs));


mean_dist_smoke = mean(allSubjDistSmoke,1);
std_dist_smoke = std(allSubjDistSmoke,[],1);
SEM_dist_smoke = std(allSubjDistSmoke,[],1)/sqrt(length(subjs));

mean_dist_disk = mean(allSubjDistDisk,1);
std_dist_disk = std(allSubjDistDisk,[],1);
SEM_dist_disk = std(allSubjDistDisk,[],1)/sqrt(length(subjs));

mean_dens_smoke = mean(allSubjDensSmoke,1);
std_dens_smoke = std(allSubjDensSmoke,[],1);
SEM_dens_smoke = std(allSubjDensSmoke,[],1)/sqrt(length(subjs));

mean_dens_disk = mean(allSubjDensDisk,1);
std_dens_disk = std(allSubjDensDisk,[],1);
SEM_dens_disk = std(allSubjDensDisk,[],1)/sqrt(length(subjs));

f_resp = figure; hold on;
setupfig(16,16,16); % setup figure width, height, and font size (helperfunction)
str = ['N = ' num2str(length(subjs))];
dim = [.4 .5 .4 .4];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
% speed effect
subplot(2,2,1); hold on; title('speed');
%plot(dat.speeds,mean_sp,'k-')
a = plot(smoke.speeds + 0.5, mean_speed_smoke,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
errorbar(smoke.speeds + 0.5, mean_speed_smoke,SEM_speed_smoke);
b = plot(disk.speeds - 0.5,  mean_speed_disk,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
errorbar(disk.speeds - 0.5,  mean_speed_disk,SEM_speed_disk);
ylim([.5 2]);
xlabel('speed');
ylabel('reaction time');
legend([a,b], 'smoke', 'disk', 'Location', 'southwest');



% duration effect
subplot(2,2,2); hold on; title('duration');
%plot(dat.speeds,mean_sp,'k-')
%plot(smoke.durationsFs,smoke.mean_dur,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
%plot(disk.durationsFs,disk.mean_dur,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
plot(smoke.durationsFs + 0.5,       mean_dur_smoke,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
errorbar(disk.durationsFs + 0.5,    mean_dur_smoke, SEM_dur_smoke);
plot(disk.durationsFs  - 0.5,       mean_dur_disk,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
errorbar(disk.durationsFs - 0.5,    mean_dur_disk,  SEM_dur_disk);
ylim([.5 2]);
xlabel('duration');
ylabel('reaction time');



% density
subplot(2,2,3); hold on; title('density');
%plot(dat.speeds,mean_sp,'k-')
%plot(smoke.densities,smoke.mean_dens,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
%plot(10,disk.mean_dens,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
plot(smoke.densities,    mean_dens_smoke,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
errorbar(smoke.densities, mean_dens_smoke, SEM_dens_smoke);
plot(10.5,               mean_dens_disk,'-o', 'color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
errorbar(10.5,            mean_dens_disk,  SEM_dens_disk);
ylim([.5 2]);
xlabel('densities');
ylabel('reaction time');

% distance
subplot(2,2,4); hold on; title('distance');
%plot(dat.speeds,mean_sp,'k-')
%plot(smoke.distances,smoke.mean_dist,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
%plot(disk.distances,disk.mean_dist,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
plot(smoke.distances + 0.5, mean_dist_smoke,'-o','color',ColorIt('r'),'markerfacecolor',ColorIt('r'))
errorbar(disk.distances + 0.5,    mean_dist_smoke, SEM_dist_smoke);
plot(disk.distances  - 0.5, mean_dist_disk,'-o','color',ColorIt('k'),'markerfacecolor',ColorIt('k'))
errorbar(disk.distances - 0.5,    mean_dist_disk,  SEM_dist_disk);
ylim([.5 2]);
xlabel('distance');
ylabel('reaction time');

% save plots
saveas(f_resp,['./plots/summary_allSubjs.eps'],'epsc');
saveas(f_resp,['./plots/summary_allSubjs.jpg']);
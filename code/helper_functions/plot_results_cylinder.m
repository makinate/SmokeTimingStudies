function plot_results_cylinder(dat)
%
% plot motion detection performance for pre- and post- tests or
% introduction for a given dataset (dat)
%
% CONSIDER REMOVING
% if showTraining == 1, then the randomly selecting training direction will
% be written at the top of the plot. this is set to zero in
% run_porepost_test so that the experimentor can check data quality without
% being exposed to what the training direction is
%
% if dat is empty, you will be prompted to select one or more files with
% the file browser

% manually select files, can combine multiple
if isempty(dat)
    
    [files,path] = uigetfile('../data/*.mat','Select sessions to analyze','multiselect','on');
    
    % initialize fields needed for plotting
    %     dat.coherences          = [];
    %     dat.directions          = [];
    %     dat.trials.coherence    = [];
    %     dat.trials.direction    = [];
    %     dat.trials.resp         = [];
    %     dat.trials.isCorrect    = [];
    dat.speeds                = [];
    dat.densities             = [];
    dat.durations             = [];
    dat.distances             = [];
    dat.trials.speed          = [];
    
    % load these fields from each selected file
    if ~iscell(files) % determine if files is NOT a cell array
        
        % just one file to be loaded
        load([path '/' files])
        display([path '/' files])
        
    else
        
        % load each file
        for fii = 1:length(files)
            
            display(files(fii));
            tmp = load([path '/' files{fii}]);
            
            %             dat.coherences          = [dat.coherences tmp.dat.coherences];
            %             dat.directions          = [dat.directions tmp.dat.directions];
            %             dat.trials.coherence    = [dat.trials.coherence tmp.dat.trials.coherence];
            %             dat.trials.direction    = [dat.trials.direction tmp.dat.trials.direction];
            %             dat.trials.resp         = [dat.trials.resp tmp.dat.trials.resp];
            %             dat.trials.isCorrect    = [dat.trials.isCorrect tmp.dat.trials.isCorrect];
            
            dat.speeds        = [dat.speeds tmp.dat.speeds];
            dat.densities     = [dat.densities tmp.dat.densities];
            dat.durationsFs   = [dat.durationsFs tmp.dat.durationsFs];
            dat.distances     = [dat.distances tmp.dat.distances];
            dat.trials.resp   = [dat.trials.resp tmp.dat.trials.resp];
        end
        
        % unique stimulus types?
        %         dat.coherences = unique(dat.coherences);
        %         dat.directions = unique(dat.directions);
        dat.speeds      = unique(dat.speeds);
        dat.densities   = unique(dat.densities);
        dat.durationsFs   = unique(dat.durationsFs);
        dat.distances   = unique(dat.distances);
        
        
        % just takes the test type from the last loaded file, you assumes that
        % you did not accidently select two different test types (e.g., a pre
        % and a post)
        dat.test_type = tmp.dat.test_type;
        %dat.main_dirction = tmp.dat.main_direction;
        
    end
    
end

% list of marker shapes
mkShape = {'o','s','^'};

figure; hold on;
setupfig(14,12,16);

%initialize subplot counter
scnt = 1;

for du = 1:length(dat.durationsFs)
    
    % for each distance
    for di = 1:length(dat.distances)
        

        subplot(2,3,scnt); hold on; title(['dist = ' num2str(dat.distances(di)) ', dur = ' num2str(dat.durationsFs(du))]);
        
        % for each density
        for d = 1:length(dat.densities)
            
            %for each speed
            for s = 1:length(dat.speeds)
                
                speed(s,d,di,du)    = dat.speeds(s);
                density(s,d,di,du)  = dat.densities(d);
                distance(s,d,di,du) = dat.distances(di);
                duration(s,d,di,du) = dat.durationsFs(du);
                
                % trials with this combination of parameters
                trial_inds = dat.trials.speed == speed(s,d,di,du) & dat.trials.density == density(s,d,di,du) & dat.trials.distance == distance(s,d,di,du) & dat.trials.duration == duration(s,d,di,du) & ~isnan(dat.trials.resp);
                
                resp_tmp = dat.trials.resp(trial_inds);
                
                outlier = any(resp_tmp > 2);
                
                subplot(2,3,scnt); hold on;
                plot(speed(s,d,di,du), resp_tmp, mkShape{d}, 'color',ColorIt(d),'markerfacecolor',ColorIt(d),'markersize',10);
                xlim([0 30]); ylim([0 2]);
                ylabel('response time (sec)');
                xlabel('stim speed (au)');
                %title(['speed = ' num2str(speed(s))]);

                %plot outlier indicator
                if outlier
                    plot(speed(s,d,di,du) + d - 2, 2, '*', 'color',ColorIt(d),'markerfacecolor',ColorIt(d),'markersize',10);
                end
                
                median_resp(s,d,di,du) = median(dat.trials.resp(trial_inds));
                
            end
            
            h(d) = plot(speed(:,d,di,du), median_resp(:,d,di,du), '-', 'color',ColorIt(d),'linewidth',2);
            
        end
        
        
        scnt = scnt + 1;
        
        
    end
    
    
end


% figure; hold on;
% setupfig(14,12,16);
% 
% % speed effect
% for s = 1:length(dat.speeds)
%     mean_sp(s) = mean(reshape(median_resp(s, :, :, :), 1, []));
% end
% subplot(2,2,1); hold on; title('speed');
% %plot(dat.speeds,mean_sp,'k-')
% bar(dat.speeds,mean_sp)
% xlabel('speed');
% ylabel('reaction time');
% 
% % duration effect
% for d = 1:length(dat.durationsFs)
%     mean_dur(d) = mean(reshape(median_resp(:, :, :, d), 1, []));
% end
% subplot(2,2,2); hold on; title('duration');
% bar(dat.durationsFs,mean_dur)
% xlabel('duration');
% ylabel('reaction time');
% 
% 
% % distance
% for d = 1:length(dat.distances)
%     mean_dist(d) = mean(reshape(median_resp(:, :, d, :), 1, []));
% end
% subplot(2,2,3); hold on; title('distance');
% bar(dat.distances,mean_dist)
% xlabel('distance');
% ylabel('reaction time');



function dat = plot_results_smoke(dat,showPlots)
%
% plot TTC performance for smoke and cylinders for a given dataset (dat)
%
addpath([ pwd '/plots']);   % add path to helper functions
% if dat is empty, you will be prompted to select one or more files with
% the file browser

% manually select files, can combine multiple
if isempty(dat)
    
    [files,path] = uigetfile('../data/*.mat','Select sessions to analyze','multiselect','on');
    
    % initialize fields needed for plotting
    
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

% permute the resp variable
%dat.trials.resp_perm = permute(dat.trials.resp, [2 1]);

% list of marker shapes
mkShape = {'o','s','^'};

if showPlots
    figure; hold on;
    setupfig(14,12,16);
end

%initialize subplot counter
scnt = 1;

for du = 1:length(dat.durationsFs)
    
    % for each distance
    for di = 1:length(dat.distances)
        
        if showPlots
            subplot(2,3,scnt); hold on; title(['dist = ' num2str(dat.distances(di)) ', dur = ' num2str(dat.durationsFs(du))]);
        end
        
        % for each density
        for d = 1:length(dat.densities)
            
            %for each speed
            for s = 1:length(dat.speeds)
                
                speed(du, di, d, s)    = dat.speeds(s);
                density(du, di, d, s)  = dat.densities(d);
                distance(du, di, d, s) = dat.distances(di);
                duration(du, di, d, s) = dat.durationsFs(du);
                
                % make an index vector trials with this combination of parameters
                trial_inds = dat.trials.speed == speed(du, di, d, s) & dat.trials.density == density(du, di, d, s) & dat.trials.distance == distance(du, di, d, s) & dat.trials.duration == duration(du, di, d, s) & ~isnan(dat.trials.resp);
                
                % get the resoinse time for indexed values
                resp_tmp = dat.trials.resp(trial_inds);
                
                % find outliers in response time
                outlier = any(resp_tmp > 2);
                
                if showPlots
                    % make 2 (duration)x3(distance) scatter plots
                    subplot(2,3,scnt); hold on;
                    plot(speed(du, di, d, s), resp_tmp, mkShape{d}, 'color',ColorIt(d),'markerfacecolor',ColorIt(d),'markersize',10);
                    xlim([0 30]); ylim([0 2]);
                    ylabel('response time (sec)');
                    xlabel('stim speed (au)');
                    
                    %plot outlier indicator
                    if outlier
                        plot(speed(du, di, d, s) + d - 2, 2, '*', 'color',ColorIt(d),'markerfacecolor',ColorIt(d),'markersize',10);
                    end
                    
                end
                
                % calculate the median response time for indexed values and
                % throw them in a 4D matrix
                median_resp(du, di, d, s) = median(dat.trials.resp(trial_inds));
                
            end
            
            
            if showPlots
                % plot the median
                h(d) = plot(speed(du,di,d,s), median_resp(du,di,d,s), '-', 'color',ColorIt(d),'linewidth',2);
                
            end
            
        end
        
        if showPlots
            if scnt == 1
                % add a legend
                legend(h,'dens=0.1','dens=10','dens=20')
                
            end
        end
        
        scnt = scnt + 1;
        
        
    end
    
    
end

if showPlots
    % save previous figure
    saveas(gca,['./plots/' dat.subj '_' dat.test_type '_scatter.eps'],'epsc')
    saveas(gca,['./plots/' dat.subj '_' dat.test_type '_scatter.jpg'])
    
    figure; hold on;
    setupfig(14,12,16);
end

% speed effect
for s = 1:length(dat.speeds)
    dat.mean_sp(s) = mean(reshape(median_resp(:, :, :, s), 1, []));
end

if showPlots
    subplot(2,2,1); hold on; title('speed');
    %plot(dat.speeds,mean_sp,'k-')
    bar(dat.speeds,dat.mean_sp)
    xlabel('speed');
    ylabel('reaction time');
end

% duration effect
for d = 1:length(dat.durationsFs)
    dat.mean_dur(d) = mean(reshape(median_resp(d, :, :, :), 1, []));
end

if showPlots
    subplot(2,2,2); hold on; title('duration');
    bar(dat.durationsFs,dat.mean_dur)
    xlabel('duration');
    ylabel('reaction time');
end

% density
for d = 1:length(dat.densities)
    dat.mean_dens(d) = mean(reshape(median_resp(:, :, d, :), 1, []));
end

if showPlots
    subplot(2,2,3); hold on; title('density');
    bar(dat.densities,dat.mean_dens)
    xlabel('density');
    ylabel('reaction time');
end

% distance
for d = 1:length(dat.distances)
    dat.mean_dist(d) = mean(reshape(median_resp(:, d, :, :), 1, []));
end

if showPlots
    subplot(2,2,4); hold on; title('distance');
    bar(dat.distances,dat.mean_dist)
    xlabel('distance');
    ylabel('reaction time');
    
    saveas(gca,['./plots/' dat.subj '_' dat.test_type '_summary.eps'],'epsc')
    saveas(gca,['./plots/' dat.subj '_' dat.test_type '_summary.jpg'])
end



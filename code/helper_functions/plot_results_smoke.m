function plot_results_smoke(dat)
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

figure; hold on;

set(gcf,'color',[1 1 1]);

%for each speed
for s = 1:length(dat.speeds)
    
    % for each density
    for d = 1:length(dat.densities)
        
        % for each distance
        for di = 1:length(dat.distances)
            
            for du = 1:length(dat.durationsFs)
        
                speed(s,d,di,du)    = dat.speeds(s);
                density(s,d,di,du)  = dat.densities(d);
                distance(s,d,di,du) = dat.distances(di);
                duration(s,d,di,du) = dat.durationsFs(du);

                % trials with this coherence and this direction
                trial_inds = dat.trials.speed == speed(s,d,di,du) & dat.trials.density == density(s,d,di,du) & dat.trials.distance == distance(s,d,di,du) & dat.trials.duration == duration(s,d,di,du) & ~isnan(dat.trials.resp);

                resp_tmp = dat.trials.resp(trial_inds);

                subplot(1,2,s); hold on;
                plot(distance(s,d,di,du), resp_tmp, 'ko');
                
                ylabel('response time');
                title(['speed = ' num2str(speed(s))]);
                legend();
        
        
                median_resp(s,d,di,du) = median(dat.trials.resp(trial_inds));

            end
        end
        
        
    end
    
    subplot(1,2,s); hold on;
    plot(distance(s,:), median_resp(s,:));
    xlabel('distance');
    
end



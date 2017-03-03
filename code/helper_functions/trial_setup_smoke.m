function [dat] = trial_setup_smoke(dat)
%
% define features of trial structure

%  TRIAL STRUCTURE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dat.trials.speed        = [];
dat.trials.density      = [];
dat.trials.duration     = [];
dat.trials.repeat       = [];

tr_cnt = 0;

for c = 1:length(dat.speeds)
    
    for n = 1:length(dat.densities)
        
        for d = 1:length(dat.durationsMs)
            
            for r = 1:dat.repeats
                
                tr_cnt = tr_cnt + 1;
                
                % signal trials
                dat.trials.speed        = [dat.trials.speed dat.speeds(c)];
                dat.trials.density      = [dat.trials.density dat.densities(n)];
                dat.trials.duration     = [dat.trials.duration dat.durationsMs(d)];
                dat.trials.repeat       = [dat.trials.repeat r];
                
            end
        end
        
    end
    
end

% randomize trial order
dat.trials.trialnum = Shuffle(1:tr_cnt);

% emptry response arrays
dat.trials.respTime         = NaN*ones(1,tr_cnt);




function [dat] = trial_setup_smoke(dat)
%
% define features of trial structure

% TRIAL STRUCTURE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dat.trials.speed        = [];
dat.trials.density      = [];
dat.trials.duration     = [];
dat.trials.repeat       = [];
dat.trials.distance     = [];

% set up a trial counter
tr_cnt = 0;
trialnum_total = length(dat.speeds) + length(dat.densities) + length(dat.durationsFs) + length(dat.distances); 


for c = 1:length(dat.speeds)
    for n = 1:length(dat.densities)
        for d = 1:length(dat.durationsFs)
            for p = 1:length(dat.distances)
                for r = 1:dat.repeats                   
                    % increase the trial counter +1 for each trial
                    tr_cnt = tr_cnt + 1;

                    % smoke trials
                    dat.trials.speed        = [dat.trials.speed dat.speeds(c)];
                    dat.trials.density      = [dat.trials.density dat.densities(n)];
                    dat.trials.duration     = [dat.trials.duration dat.durationsFs(d)];
                    dat.trials.distance     = [dat.trials.distance dat.distances(p)];
                    dat.trials.repeat       = [dat.trials.repeat r];
                end
            end
        end
    end   
end

% randomize trial order
dat.trials.trialnum = Shuffle(1:tr_cnt);

% empty response arrays
dat.trials.resp             = zeros(trialnum_total,1);;
dat.trials.respTime         = NaN*ones(1,tr_cnt);




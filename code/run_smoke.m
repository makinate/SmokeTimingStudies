function run_smoke(varargin)
%
% test motion direction discrimination at a range of directions and
% coherences
%
% provide a string to specify the screen that is being used (from
% screen_info), or else you will be prompted for it

addpath([ pwd '/helper_functions']);   % add path to helper functions

% GET EXPERIMENT VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% select screen, if not provided
dat.scr = select_screen(varargin);

% find out participant code and whether this is a pre- or post-test run
dat.subj        = input('Enter participant code:','s');
test_type       = input('What test type is this? Enter 1 if smoke, enter 2 if cylinder:');

% set up stimulus parameters (these are just ones I want easy access to,
% others are set in helper_functions keys_setup..., trials_setup...stimulus_setup...

dat.speeds              = [10 20];                        % coherence conditions (0 trials will be added to match
dat.durationsMs         = [400 750];                    % motion directions to test
dat.repeats             = [5];                       % number of repeats for each coherence level (at each motion direction), we can do less for high coherences

if test_type == 1
    
    % if a pre-test, set up initial pre-test variables
    dat.test_type           = 'smoke';
    dat.densities           = [0.01 0.1 0.2];                    % motion directions to test

elseif test_type == 2
    
    dat.test_type           = 'cylinder';
    dat.densities           = [1];                    % motion directions to test
    
else
    error('invalid test type');
end

dat.feedback    = 0; % provide auditory feedback? should be zero unless debugging
do_plot         = 1; % plot results immediately

% get start time for file names
dat.timeNow     = datestr(clock,'mm_dd_yy_HHMMSS'); 
dat.fileName    = [ dat.subj '_' dat.test_type '_' dat.timeNow '.mat'];

% run PTB commands in try/catch loop
try
    
    % SET UP SCREEN, STIMULUS, WINDOW, KEYS %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [dat.scr, w, ~]         = screen_setup(dat.scr);        % PTB window
    dat                     = trial_setup_smoke(dat);     % trial properties
    [dat,keys]              = keys_setup_smoke(dat);              % key responses
    dat.start               = GetSecs;

    % DRAW INTRO SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Screen(w,'TextSize',dat.stm.fontSize);
    

    % RUN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for t = 1:length(dat.trials.trialnum)                   % for each trial
        
        % trial info
        trial           = dat.trials.trialnum(t);               % which stimulus index to take
        speed       = dat.trials.speed(trial);     % percent coherence
        density       = dat.trials.density(trial);          % direction of motion
        duration       = dat.trials.duration(trial);          % direction of motion
        
        % display info in matlab prompt for debugging
        display(['speed = ' num2str(speed) ' ... density = ' num2str(density)]);
        
        %preload video frames for this stimulus
        frames = load_stimulus_frames(dat.test_type,speed,density,duration);
        
        % prompt for key press to start
        Screen('FillRect', w, [0 0 0]);
        DrawFormattedText(w, 'Press space bar to start', 'center', dat.scr.y_center_pix - dat.scr.heightPix/2.25, [255 255 255]);
        draw_fixation_circle(w,dat);
        DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        KbWait(-3);
        %WaitSecs(0.25);			% slight delay before starting
        
        % start trial with fixation pattern only
        Screen('FillRect', w, [0 0 0]);
        draw_fixation_circle(w,dat);
        DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        WaitSecs(0.25);			% slight delay before starting
        
        % display frames at framerate
        for x = 1:length(frames)
            
            textureIndex=Screen('MakeTexture',w, frames(:,:,x));
            Screen('DrawTexture', w, textureIndex);
            Screen('Flip',  w, [], 1);
            
        end
        stimDone = GetSecs;
        
        Screen('FillRect', w, [0 0 0]);
        Screen('Flip',  w, [], 1);
        
        % get subject responses
        while keys.isDown == 0
            
            % check for response
            [dat,keys] = keys_get_response_smoke(keys,dat,trial,stimDone);
            
        end
        keys.isDown = 0;
        
        if keys.killed
            break
        end

    end
    
    % aggregate and save data structures
    dat.keys    = keys;
    dat.end     = GetSecs;
    store_results(dat);
    
    % exit
    Screen('FillRect', w, [0 0 0]);
    DrawFormattedText(w, 'Done', 'center', 'center', [255 255 255]);
    Screen('Flip',  w, [], 1);
    WaitSecs(2);
    
    cleanup(0,dat);
    
    % draw and save plot if requested
    if do_plot && t > 1
        plot_results_testing(dat,0);
        saveas(gcf,['../data/' dat.subj '/' strrep(dat.fileName,'mat','pdf')]);
    end
    
catch
    
    cleanup(0,dat);
    psychrethrow(psychlasterror);
    
end




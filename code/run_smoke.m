function run_smoke(varargin)
% test TTC estimation ability for smoke and cylindrical stimuli


addpath([ pwd '/helper_functions']);   % add path to helper functions

%% GET EXPERIMENT VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% select screen, if not provided
dat.scr = select_screen(varargin);

% find out participant code and whether this is a pre- or post-test run
dat.subj        = input('Enter participant code:','s');
test_type       = input('What test type is this? Enter 1 if smoke, enter 2 if cylinder:');
training        = input('Is this a training session? Enter 1 if training, enter 0 if test:');

% randomly decide which condition to run
%stimulus_type = [1 2];
%test_type = stimulus_type(randi(length(stimulus_type)));


% set up stimulus parameters (these are just ones I want easy access to,
% others are set in helper_functions keys_setup..., trials_setup...stimulus_setup...

dat.speeds       = [10 20];         % speed conditions
dat.durationsFs  = [45 75];       % trial duration in frames; short (750 ms) --> 45 frames; long (1250 ms) --> 1250 ms
dat.distances    = [210, 230, 250]; % distance of camera (cm) from smoke source
dat.repeats      = [5];             % number of repeats for each coherence level (at each motion direction), we can do less for high coherences

if test_type == 1
    
    % if a pre-test, set up initial pre-test variables
    dat.test_type           = 'smoke';
    dat.densities           = [01 10 20];    % smoke density conditions
    plume_object            ='plumes';
    
elseif test_type == 2
    
    dat.test_type           = 'cylinder';
    dat.densities           = [99];
    plume_object            = 'objects';
    
else
    error('invalid test type');
end

dat.feedback    = 0; % provide auditory feedback? should be zero unless debugging
do_plot         = 1; % plot results immediately

% get start time for file names
dat.timeNow     = datestr(clock,'mm_dd_yy_HHMMSS');
dat.fileName    = [ dat.subj '_' dat.test_type '_' dat.timeNow '.mat'];



%% run PTB commands in try/catch loop
try
    
    % SET UP SCREEN, STIMULUS, WINDOW, KEYS %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [dat.scr, w, ~]         = screen_setup(dat.scr);      % PTB window
    dat                     = trial_setup_smoke(dat);     % trial properties
    [dat,keys]              = keys_setup_smoke(dat);      % key responses
    dat.start               = GetSecs;
    dat                     = stimulus_setup(dat);        % stimulus visual properties
    dat.training            = training;
    
    % hide mouse cursor
    HideCursor();
    
    %% DRAW INTRO SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Screen(w,'TextSize',dat.stm.fontSize);
    Screen('FillRect', w, [0 0 0]);
      
    DrawFormattedText(w, ['Welcome to our experiment! \nYou will see a number of ' dat.test_type ' ' plume_object ' moving closer to you.'], 'center', dat.scr.y_center_pix - dat.scr.heightPix/3, [255 255 255]);
    DrawFormattedText(w, ['The ' dat.test_type ' ' plume_object ' will disappear before they actually reach you.'], 'center', dat.scr.y_center_pix - dat.scr.heightPix/5, [255 255 255]);
    DrawFormattedText(w, ['Press the space bar at the time \nyou think that the ' dat.test_type ' would have actually reached you.'], 'center', dat.scr.y_center_pix, [255 255 255]);
    DrawFormattedText(w, 'Press space bar to start', 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);
    Screen('Flip',  w, [], 1);
    KbWait(-3);
    WaitSecs(0.25);			% slight delay before starting
    
    %% RUN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if training
        dat.training_test = 'training';
        
        % pick 10 random trials for training
        trialnum = 10;
        
        % don't plot the results
        do_plot = 0;
    else
        dat.training_test = 'test';
        trialnum = length(dat.trials.trialnum);

    end
    
    
    for t = 1:trialnum                   % for each trial
        
        % trial info
        trial       = dat.trials.trialnum(t);      % which stimulus index to take
        speed       = dat.trials.speed(trial);     % smoke speed
        density     = dat.trials.density(trial);   % smoke density
        duration    = dat.trials.duration(trial);  % trial duration in frames
        distance    = dat.trials.distance(trial);  % distance of camera from smoke source
        repeat      = dat.trials.repeat(trial);    % which repeat
        
        
        % display info in matlab prompt for debugging
        display(['trial = ' num2str(trial) '  speed = ' num2str(speed) '   density = ' num2str(density)]);
        
        %preload video frames for this stimulus
        frames = load_stimulus_frames(dat.scr.image_dir, dat.test_type, speed, density, duration, distance, repeat);

        % give participant a break halfway
        if sum(dat.trials.resp ~= 0) == trialnum/2 && training ~= 1
            Screen('FillRect', w, [0 0 0]);
            DrawFormattedText(w, ['You are halfway done with this section! \nTake a short break if you want to.'], 'center', dat.scr.y_center_pix - dat.scr.heightPix/3, [255 255 255]);
            DrawFormattedText(w, 'Press space bar to continue', 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);
            Screen('Flip',  w, [], 1);
            KbWait(-3);     
        else
            display('do nothing');
        end
        
        
        % prompt for key press to start
        Screen('FillRect', w, [0 0 0]);
        DrawFormattedText(w, 'Press space bar to start', 'center', dat.scr.y_center_pix - dat.scr.heightPix/2.25, [255 255 255]);
        draw_fixation_circle(w,dat);
        DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        KbWait(-3);
        
        % start trial with fixation pattern only
        Screen('FillRect', w, [0 0 0]);
        draw_fixation_circle(w,dat);
        DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        WaitSecs(0.25);			% slight delay before starting
        
        stimStart = GetSecs;
        
        % display frames at framerate
        for x = 1:duration
            textureIndex = Screen('MakeTexture',w, frames(:,:,x));
            Screen('DrawTexture', w, textureIndex);
            [~,~,~, missed(x), ~] = Screen('Flip',  w, [], 1);
        end
        
        % do some diagnostics
        for i = 1:length(missed)
            if missed(i) <= 0
                missed(i) = 0
            else
                missed(i) = 1
            end
        end
        
        % returns the percent of missed frames for a trial
        dat.total_missedFrames(t)   = sum(missed);
        dat.percent_missedFrames(t) = sum(missed)/duration;
        
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
    
    %% aggregate and save data structures
    dat.keys    = keys;
    dat.end     = GetSecs;
    store_results(dat);
    
    % exit
    Screen('FillRect', w, [0 0 0]);
    DrawFormattedText(w, ['Done. \nPlease find the experimenter!'], 'center', 'center', [255 255 255]);
    Screen('Flip',  w, [], 1);
    WaitSecs(2);
    
    cleanup(0,dat);
    ShowCursor();
    % draw and save plot if requested
    if do_plot && t > 1
        if test_type == 1
            plot_results_smoke(dat);
        else
            plot_results_cylinder(dat);
        end
        saveas(gcf,['../data/' dat.subj '/' strrep(dat.fileName,'mat','pdf')]);
    end
    
catch
    
    cleanup(0,dat);
    psychrethrow(psychlasterror);
    
end




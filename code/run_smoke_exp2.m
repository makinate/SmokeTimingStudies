function run_smoke_exp2(varargin)
% 2nd version of smoke timing studies using faster speeds than exp 1
% test TTC estimation ability for smoke and cylindrical stimuli
 


addpath([ pwd '/helper_functions']);   % add path to helper functions

%% GET EXPERIMENT VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% select screen, if not provided
dat.scr = select_screen(varargin);

% find out participant code and whether this is a pre- or post-test run
dat.subj        = input('Enter participant code:','s');
test_type       = input('What test type is this? Enter 1 if smoke, enter 2 if disk:');
training        = input('Is this a training session? Enter 1 if training, enter 0 if test:');

% randomly decide which condition to run
%stimulus_type = [1 2];
%test_type = stimulus_type(randi(length(stimulus_type)));

% set up stimulus parameters (these are just ones I want easy access to,
% others are set in helper_functions keys_setup..., trials_setup...stimulus_setup...

dat.speeds       = [250 300 350];         % speed conditions
dat.durationsFs  = [35 70];         % trial duration in frames; short (750 ms) --> 45 frames; long (1250 ms) --> 1250 ms
dat.distances    = [210, 230, 250]; % distance of camera (cm) from smoke source
dat.repeats      = [5];             % number of repeats for each coherence level (at each motion direction), we can do less for high coherences

if test_type == 1
    
    % if a pre-test, set up initial pre-test variables
    dat.test_type           = 'smoke';
    dat.densities           = [01 10 20];    % smoke density conditions
    plume_object            =' plumes';
    
elseif test_type == 2
    
    dat.test_type           = 'disk';
    dat.densities           = [99];
    plume_object            = 's';
    
else
    error('invalid test type');
end

dat.feedback    = 0; % provide auditory feedback? should be zero unless debugging
do_plot         = 1; % plot results immediately

% get start time for file names
dat.timeNow     = datestr(clock,'mm_dd_yy_HHMMSS');
if training
    dat.fileName    = [ 'training_' dat.subj '_' dat.test_type '_' dat.timeNow '.mat'];
else
    dat.fileName    = [ dat.subj '_' dat.test_type '_' dat.timeNow '.mat'];
end



%% run PTB commands in try/catch loop
try
    
    % SET UP SCREEN, STIMULUS, WINDOW, KEYS %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [dat.scr, w, ~]         = screen_setup(dat.scr);      % PTB window
    dat                     = trial_setup_smoke(dat);     % trial properties
    [dat,keys]              = keys_setup_smoke(dat);      % key responses
    dat.start               = GetSecs;
    dat                     = stimulus_setup(dat);        % stimulus visual properties
      
    % hide mouse cursor
    HideCursor();
    
    %% DRAW INTRO SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Screen(w,'TextSize',dat.stm.fontSize);
    Screen('FillRect', w, [0 0 0]);
    
    DrawFormattedText(w, ['Welcome to our experiment! \nYou will see a number of ' dat.test_type plume_object ' moving closer to you.'], 'center', dat.scr.y_center_pix - dat.scr.heightPix/3, [255 255 255]);
    DrawFormattedText(w, ['The ' dat.test_type plume_object ' will disappear before they actually reach you.'], 'center', dat.scr.y_center_pix - dat.scr.heightPix/5, [255 255 255]);
    DrawFormattedText(w, ['Press the space bar (yellow) at the time \nyou think that the ' dat.test_type ' would have actually reached you.'], 'center', dat.scr.y_center_pix, [255 255 255]);
    DrawFormattedText(w, 'Press control (red button) to start', 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);
    Screen('Flip',  w, [], 1);
    KbWait(-3);
    
    Screen('FillRect', w, [0 0 0]);
    DrawFormattedText(w, 'Loading first trial...', 'center', 'center', [255 255 255]);
    Screen('Flip',  w, [], 1);
    %WaitSecs(0.25);			% slight delay before starting
    
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
        frames = load_stimulus_frames(dat.scr.image_dir, dat.test_type, speed, density, duration, distance, repeat, 'cyclo');
        
        % load frames into texture indices
        for x = 1:duration
            textureIndex(x) = Screen('MakeTexture',w, frames(:,:,x));
        end
        
        % give participant a break halfway
        if t == round(trialnum/2) && training ~= 1
            Screen('FillRect', w, [0 0 0]);
            DrawFormattedText(w, ['You are halfway done with this section! \nTake a short break if you want to.'], 'center', dat.scr.y_center_pix - dat.scr.heightPix/3, [255 255 255]);
            DrawFormattedText(w, 'Press control (red button) to continue', 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);
            Screen('Flip',  w, [], 1);
            KbWait(-3);
        end
        
        
        % prompt for key press to start
        Screen('FillRect', w, [0 0 0]);
        DrawFormattedText(w, 'Press control (red button) to start', 'center', dat.scr.y_center_pix - dat.scr.heightPix/2.25, [255 255 255]);
        draw_fixation_circle(w,dat);
        DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        KbWait(-3, 2); % wait for button press
        KbWait(-3, 1); % wait for button to be released
        
        
        % start trial with fixation pattern only
        Screen('FillRect', w, [0 0 0]);
        draw_fixation_circle(w,dat);
        DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        WaitSecs(0.25);			% slight delay before starting
        
        stimStart = GetSecs;
        
        % display frames at framerate
        for x = 1:duration
            %textureIndex = Screen('MakeTexture',w, frames(:,:,x));
            Screen('DrawTexture', w, textureIndex(x));
            [~,~,~, missed(x), ~] = Screen('Flip',  w, [], 1);
            Screen('Close', textureIndex(x))
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
        
        WaitSecs(0.25);
        Screen('FillRect', w, [0 0 0]);
        DrawFormattedText(w, 'Loading next trial...', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        
        % do some diagnostics
        for i = 1:length(missed)
            if missed(i) <= 0
                missed(i) = 0;
            else
                missed(i) = 1;
            end
        end
        
        % returns the percent of missed frames for a trial
        dat.total_missedFrames(t)   = sum(missed);
        dat.percent_missedFrames(t) = sum(missed)/duration;
        dat.stim_target_dur_sec(t)  = (1/dat.scr.frameRate)*duration;
        dat.stim_actual_dur_sec(t) = stimDone - stimStart;
        
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
        plot_results_smoke(dat,1);
        saveas(gcf,['../data/' dat.subj '/' strrep(dat.fileName,'mat','png')]);
    end
    
catch
    
    cleanup(0,dat);
    psychrethrow(psychlasterror);
    
end

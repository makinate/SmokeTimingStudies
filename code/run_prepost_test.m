function run_prepost_test(varargin)
%
% test motion direction discrimination at a range of directions and
% coherences
%
% provide a string to specify the screen that is being used (from
% screen_info), or else you will be prompted for it

addpath([ pwd '/helper_functions']);   % add path to helper functions
addpath([pwd '/ShadlenDotsX' ]);

% GET EXPERIMENT VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% select screen, if not provided
dat.scr = select_screen(varargin);

% find out participant code and whether this is a pre- or post-test run
dat.subj        = input('Enter participant code:','s');
test_type       = input('What test type is this? Enter 1 if pre-test, enter 2 if post-test:');

% set up stimulus parameters (these are just ones I want easy access to,
% others are set in helper_functions keys_setup..., trials_setup...stimulus_setup...
if test_type == 1
    
    % if a pre-test, set up initial pre-test variables
    dat.test_type           = 'pretest';

    dat.coherences           = [10 5 2.5];                        % coherence conditions (0 trials will be added to match
    dat.directions           = [45 135 225 315];                    % motion directions to test
    dat.main_direction       = randsample(dat.directions,1);        % randomly selection motion direction for VPL

    dat.repeats              = [45 45 45];                       % number of repeats for each coherence level (at each motion direction), we can do less for high coherences 
    
elseif test_type == 2
    
    % if a post-test, load stimulus variables from pre-test file
    dat             = load_pretest_file(dat.subj);
    dat.test_type   = 'posttest';
    
else
    error('invalid test type');
end

dat.feedback    = 0; % provide auditory feedback? should be zero unless debugging
dat.save_stim   = 0; % save stimulus images, should basically always be zero!!
do_plot         = 1; % plot results immediately

% get start time for file names
dat.timeNow     = datestr(clock,'mm_dd_yy_HHMMSS'); 
dat.fileName    = [ dat.subj '_' dat.test_type '_' dat.timeNow '.mat'];

% run PTB commands in try/catch loop
try
    
    % SET UP SCREEN, STIMULUS, WINDOW, KEYS %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [dat.scr, w, ~]         = screen_setup(dat.scr);        % PTB window
    dat                     = trial_setup_testing(dat);     % trial properties
    [dat,keys]              = keys_setup(dat);              % key responses
    
    % only generate stimulus properties & key responses if pretest
    if strcmp(dat.test_type,'pretest')
        dat         = stimulus_setup(dat);  % stimulus visual properties
    end
 
    screenInfo              = createScreenInfoForShadlen(dat,w); % screen info struct for Shadlen code
    dat.start               = GetSecs;

    % DRAW INTRO SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Screen(w,'TextSize',dat.stm.fontSize);
    
    Screen('FillRect', w, [0 0 0]);
    DrawFormattedText(w, 'During each trial, fixate the plus in the middle of the screen', 'center', dat.scr.y_center_pix - dat.scr.heightPix/2.25, [255 255 255]);
    DrawFormattedText(w, 'You will be asked to respond to this question:', 'center', dat.scr.y_center_pix - dat.scr.heightPix/2.5, [255 255 255]);
    draw_response_screen(w,dat,0);
    DrawFormattedText(w, 'Press space bar to start', 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);

    Screen('Flip',  w, [], 1);
    KbWait(-3);
    WaitSecs(0.25);			% slight delay before starting
    
    % RUN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for t = 1:length(dat.trials.trialnum)                   % for each trial
        
        % trial info
        trial           = dat.trials.trialnum(t);               % which stimulus index to take
        coherence       = dat.trials.coherence(trial)./100;     % percent coherence
        direction       = dat.trials.direction(trial);          % direction of motion
        
        % display info in matlab prompt for debugging
        display(['coherence = ' num2str(coherence*100) ' ... direction = ' num2str(direction)]);
        
        % start trial with fixation pattern only
        Screen('FillRect', w, [0 0 0]);
        draw_fixation_circle(w,dat);
        DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        WaitSecs(0.25);			% slight delay before starting
        
        % pregenerate dot parameters for Shadlen code
        dotInfo     = createDotInfoForShadlen(dat,coherence,direction);
        
        % display dots
        [frames, rseed, start_time, end_time, ~, ~] = dotsX_emily_allatonce(screenInfo, dotInfo, dat, [], []);
        
        % prompt for response
        draw_response_screen(w,dat,t);
        
        % get subject responses
        while keys.isDown == 0
            
            % check for response
            [dat,keys] = keys_get_response_testing(keys,dat,trial,direction);
            
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




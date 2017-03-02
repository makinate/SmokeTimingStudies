function run_introduction(varargin)
%
% test motion direction discrimination at a range of directions and
% coherences
%
% provide a string to specify the screen that is being used (from
% screen_info), or else you will be prompted for it

addpath([pwd '/helper_functions']);   % add path to helper functions
addpath([pwd '/ShadlenDotsX' ]);

% GET EXPERIMENT VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% select screen, if not provided
dat.scr = select_screen(varargin);

% find out participant code and whether this is a pre- or post-test run
dat.subj        = input('Enter participant code:','s');

dat.test_type            = 'introduction';
%dat.speed                = [0.01 0.20];                  % velInFlow parameters used in smoke sim files; higher values faster smoke
%dat.density              = [0.01 0.1 0.2];               % density parameter for smoke rendering; higher values, denser smoke

dat.coherences           = [100 50 15];                         % coherence conditions (0 trials will be added to match
dat.directions           = [45 135 225 315];                    % motion directions to test
dat.main_direction       = randsample(dat.directions,1);        % randomly selection motion direction for VPL
dat.repeats              = [4 4 4];                             % number of repeats for each coherence level (at each motion direction), we can do less for high coherences

dat.smoke_dir            = 'E:\Dropbox\Dartmouth\Smoke\Manta\render_out\02-23-2017\onlyBaseFlow_fast_front_02-23-2017'

dat.feedback    = 1; % provide auditory feedback? should be zero unless debugging
dat.save_stim   = 0; % save stimulus images, should basically always be zero!!
do_plot         = 1; % plot results immediately

% get start time for file names
dat.timeNow     = datestr(clock,'mm_dd_yy_HHMMSS'); 
dat.fileName    = [ dat.subj '_introduction_' dat.timeNow '.mat'];

% run PTB commands in try/catch loop
try
    
    % SET UP SCREEN, STIMULUS, WINDOW, KEYS %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [dat.scr, w, ~]         = screen_setup(dat.scr);        % PTB window
    dat                     = trial_setup_introduction(dat);     % trial properties
    [dat,keys]              = keys_setup(dat);              % key responses
    dat                     = stimulus_setup(dat);          % stimulus visual properties

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
    WaitSecs(0.25);	
    
    Screen('FillRect', w, [0 0 0]);
    DrawFormattedText(w, 'BLOCK 1: These trials should be very easy', 'center', dat.scr.y_center_pix - dat.scr.heightPix/4, [255 255 255]);
    draw_fixation_circle(w,dat);
    DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
    DrawFormattedText(w, 'Press space bar to start', 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);
    Screen('Flip',  w, [], 1);
    KbWait(-3);
    
    WaitSecs(0.25);			% slight delay before starting
    
    
    % RUN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for t = 1:length(dat.trials.trialnum)                   % for each trial
        
        % trial info
        block           = dat.trials.block(t);
        trial           = dat.trials.trialnum(t);               % which stimulus index to take
        coherence       = dat.trials.coherence(trial)./100;     % percent coherence
        direction       = dat.trials.direction(trial);          % direction of motion
        
        % display info in matlab prompt for debugging
        display(['coherence = ' num2str(coherence*100) ' ... direction = ' num2str(direction)]);
        
        % indicate the start of a new block if needed
        if block > dat.block
            
            WaitSecs(0.25);
            Screen('FillRect', w, [0 0 0]);
            DrawFormattedText(w, ['BLOCK ' num2str(block) ': The trials will now get harder'], 'center', dat.scr.y_center_pix - dat.scr.heightPix/4, [255 255 255]);
            DrawFormattedText(w, ['If you do not know the answer, just guess'], 'center', dat.scr.y_center_pix - dat.scr.heightPix/5, [255 255 255]);
            draw_fixation_circle(w,dat);
            DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
            DrawFormattedText(w, 'Press space bar to start', 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);
            Screen('Flip',  w, [], 1);
            KbWait(-3);
            WaitSecs(0.25);			% slight delay before starting
            
            dat.block = block;
            
        end
        
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




function run_training(varargin)
%
% task irrelevant training on a particular direction and coherence
%
% the direction is loaded from the subjects pre-test file, the coherence is
% set by you below
%
% provide a string to specify the screen that is being used (from
% screen_info), or else you will be prompted for it

addpath([ pwd '/helper_functions']);   % add path to helper functions
addpath([pwd '/ShadlenDotsX' ]);

% GET EXPERIMENT VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% select screen, if not provided
dat.scr = select_screen(varargin);

% find out participant code
dat.subj = input('Enter participant code:','s');

% find out if this is a short pre-training session
pretrain  = input('Is this pre-training? (1 for yes, just enter for no):');

% if we're not debugging, do the usual stuff
if ~strcmp(dat.subj,'db')
    
    % how many repeats and how to average over repeats in the plot?
    if(pretrain)
        
        % pretraining is a short run to introduce the task
        dat.repeats         = 10;
        dat.directions      = [45 135 225 315];                 % directions of motion
        dat.main_direction  = randsample(dat.directions,1);     % direction to-be-trained, random for pretraining because this is selected later
        window_size         = 2;                                % window size for averaging window when plotting percent correct by trial number
        
    else
        
        % for full training session, load pretest stimulus parameters (including the direction to-be-trained)
        dat = load_pretest_file(dat.subj);
        
        dat.repeats     = 415; %set to be about an hour
        window_size     = 10; % window size for averaging window when plotting percent correct by trial number
        pretrain        = 0;
        
    end
    
    % set of low percent coherence so that people don't really notice it
    dat.coherence  = 10;
    
    % not debugging
    dbg = 0;
    
else
    
    % debugging
    % if we're debugging, we don't need to load the stimulus properties from a pre-training files
    % instead, we just set up some varibles in a way that is nice for debugging
    dbg = 1;
    
    dat.coherence    	= 100;              % percent coherence of background motion
    dat.directions      = [45 135 225 315]; % directions of motion
    dat.main_direction  = 135;              % direction to-be-trained
    dat.repeats       	= 3;                % number of repeats
    
    window_size         = 2; % window size for averaging window when plotting percent correct by trial number
    
end

dat.breakIntervalSec    = 300; % interval between enforced breaks
dat.feedback            = 0; % audio feedback, should be zero unless debugging of pretraining
dat.save_stim           = 0; % save stimulus images, should basically always be zero!!
do_plot                 = 1; % plot results immediately

% get start time for file names
dat.timeNow     = datestr(clock,'mm_dd_yy_HHMMSS');

if(pretrain)
    dat.fileName    = [ dat.subj '_pretraining_' dat.timeNow '.mat'];
    dat.feedback    = 1; 
else
    dat.fileName    = [ dat.subj '_training_' dat.timeNow '.mat'];
end


% run PTB commands in try/catch loop
try
    
    % SET UP SCREEN, STIMULUS, WINDOW, KEYS %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [dat.scr, w, ~]  = screen_setup(dat.scr);         % PTB window
    
    % if debugging and stimulus wasn't loaded, load one now
    if(dbg || pretrain)
        dat = stimulus_setup(dat);
    end
    
    [dat,keys] = keys_setup(dat);                   % key responses
    dat        = trial_setup_training(dat);         % trial properties
    screenInfo = createScreenInfoForShadlen(dat,w); % screen info struct for Shadlen code
    dat.start  = GetSecs;                           % start time
    
    % DRAW INTRO SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Screen(w,'TextSize',dat.stm.fontSize);
    
    Screen('FillRect', w, [0 0 0]);
    DrawFormattedText(w, 'During each trial, fixate the plus in the middle of the screen', 'center', dat.scr.y_center_pix - dat.scr.heightPix/2.25, [255 255 255]);
    DrawFormattedText(w, '10 letters will flash, one after another', 'center', dat.scr.y_center_pix - dat.scr.heightPix/2.5, [255 255 255]);
    DrawFormattedText(w, 'When prompted, type in the two letters that were a lighter font', 'center', dat.scr.y_center_pix - dat.scr.heightPix/3, [255 255 255]);
    draw_fixation_circle(w,dat);
    DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
    DrawFormattedText(w, 'Press space bar to start', 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);
    Screen('Flip',  w, [], 1);
    KbWait(-3);
    WaitSecs(0.25);			% slight delay before starting
    
    breakTime = GetSecs;    % start a counter that determines when short breaks should be enforced
    
    % RUN TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for t = 1:length(dat.trials.trialnum)                   % for each trial
        
        % trial info
        trial           = dat.trials.trialnum(t);           % which stimulus index to take
        letter_inds     = dat.trials.letterInds(t,:);       % indices of 10 letter in alphabet
        letter_colors   = dat.trials.letterColors(t,:);     % color flag for each letter
        white_inds      = dat.trials.whiteInds(t,:);        % indices of letter that are bright
        letter_code     = [];                               % place holder for letter key codes
        
        display(['Letters are ... ' dat.letter_set(letter_inds(white_inds(1))) ' ' dat.letter_set(letter_inds(white_inds(2))) ]);
        
        % indicate break time if needed
        if GetSecs-breakTime > dat.breakIntervalSec
            
            WaitSecs(0.25);
            Screen('FillRect', w, [0 0 0]);
            DrawFormattedText(w, ['Take a break, then press space bar to restart'], 'center', dat.scr.y_center_pix - dat.scr.heightPix/4, [255 255 255]);
            draw_fixation_circle(w,dat);
            DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
            Screen('Flip',  w, [], 1);
            KbWait(-3);
            WaitSecs(0.25);			% slight delay before starting
            
            breakTime = GetSecs;    % restart break counter
            
        end
        
        % prep letter/dot sequence
        for x = 1:length(letter_inds)
            
            % pregenerate dot parameters
            if letter_colors(x) == 1
                % if this is a white letter pair with training direction
                dotInfo(x) = createDotInfoForShadlen(dat,dat.coherence/100,dat.main_direction);
            else
                % 75% of trials show training directions, others show
                % random direction
                
                %random number from uniform dist 0-1
                rn = rand;
                
                if rand >= 0.25
                    % pair with training direction
                    dotInfo(x) = createDotInfoForShadlen(dat,dat.coherence/100,dat.main_direction);
                else
                    % otherwise pair with random direction
                    dotInfo(x) = createDotInfoForShadlen(dat,dat.coherence/100,randsample(dat.directions,1));
                end
            end
            
        end
        
        % start trial with fixation point
        Screen('FillRect', w, [0 0 0]);
        draw_fixation_circle(w,dat);
        DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        WaitSecs(0.25);			% slight delay before starting
        
        % keep track to timing to let us know if there are issues
        all_frames          = 0;
        trial_start_time    = GetSecs;

        % draw letter/dot sequence
        for x = 1:length(letter_inds)
            
            % display dots
            [frames, ~, ~, ~, ~, ~] = dotsX_emily_allatonce(screenInfo, dotInfo(x), dat, letter_inds(x),letter_colors(x));
            
            all_frames = all_frames+frames;

        end
        
        trial_actual_duration = GetSecs - trial_start_time;
        
        % prompt for response
        DrawFormattedText(w, 'Type in two light letters', 'center', dat.scr.y_center_pix - dat.scr.heightPix/4, [255 255 255]);
        %DrawFormattedText(w, ['trial ' num2str(t) '/' num2str(length(dat.trials.trialnum)) ], 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);
        draw_fixation_circle(w,dat);
        DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
        Screen('Flip',  w, [], 1);
        
        % get subject responses
        while keys.isDown == 0
            
            % check for response
            [dat,keys,letter_code] = keys_get_response_training(keys,dat,trial,letter_code,letter_inds(white_inds));
            
        end
        
        keys.isDown = 0;
        
        if keys.killed
            break
        end
        
        display(['requested frames = ' num2str(x*dat.trial_sec*dat.scr.frameRate) '... presented frames = ' num2str(all_frames)]);
        display(['requested duration = ' num2str(x*dat.trial_sec) '... presented duration = ' num2str(trial_actual_duration)]);
        
        if abs(all_frames - x*dat.trial_sec*dat.scr.frameRate) > 3 || abs(trial_actual_duration - (dat.trial_sec*x)) > 0.3
            error('code has timing issues on this display');
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
    
    if do_plot && t > 1
        plot_results_training(dat,window_size);
        saveas(gcf,['../data/' dat.subj '/' strrep(dat.fileName,'mat','pdf')]);
    end
    
catch
    
    cleanup(0,dat);
    psychrethrow(psychlasterror);
    
end




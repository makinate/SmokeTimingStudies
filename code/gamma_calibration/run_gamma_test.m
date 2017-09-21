% validate image linearity pipeline

addpath(genpath('../helper_functions/'));

% test different combos of images and display types
imagetypes  = {'sRGB','linearized'};
LUTtypes    = {'default','linearized'};

% select image and LUT to test
it = 2;
lt = 2;

% Prepare pipeline for configuration
PsychImaging('PrepareConfiguration');
Screen('Preference', 'SkipSyncTests', 1); % don't to timing tests

% open black screen
[w, winRect] = Screen('OpenWindow', 0, [0,0,0],[],[], []);

% Enable alpha blending with proper blend-function. We need it for drawing
% of smoothed points.
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% store original (linear) LUT
[OriginalLUT, ~, ~] = Screen('ReadNormalizedGammaTable', w);

if lt == 2
    % load LUT for ViewSonic, needs to be modified if we use a
    % different display
    
    % load LUT that linearizes display output
    load('perceptual_gamma_correctionLUT_ViewSonic.mat');
    dat.scr.LUT = newLUT_interp;
    
    % apply new LUT
    Screen('LoadNormalizedGammaTable',w,newLUT_interp);
end

if it == 1
    % load test image and don't modify
    im = imread_as_grayscale('testim_sRGB.png',0);
    
elseif it == 2
    % load test image and linearize
    im = imread_as_grayscale('testim_sRGB.png',1);
end

im = im*255;

% apply to texture
textureIndex = Screen('MakeTexture',w, im);

% draw to screen
Screen('DrawTexture', w, textureIndex);
Screen('Flip',  w, [], 1);

% wait to key to close out
KbWait;

% restore original LUT
Screen('LoadNormalizedGammaTable',w,OriginalLUT);

sca;

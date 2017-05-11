function frames = load_stimulus_frames(image_dir, test_type, speed, density, duration, distance, repeat, eye)

% preallocate motion matrices
%frames = NaN(848,1507,duration);
frames = NaN(1080,1920,duration);

% generate filename (paths should be somewhere too)
% load in all pngs, or something based on duration

% EDIT TO INCLUDE PATHS FOR LEFT AND RIGHT IMAGES
if strcmp(eye,'cyclo')
    image_folders = [image_dir '/' test_type '/speed' num2str(speed) '_rep' num2str(sprintf('%02d',repeat)) '_den' num2str(sprintf('%02d',density)) '_dist' num2str(distance) '_' test_type '_front'];
elseif strcmp(eye,'left')
    image_folders = [image_dir '/' test_type '/speed' num2str(speed) '_rep' num2str(sprintf('%02d',repeat)) '_den' num2str(sprintf('%02d',density)) '_dist' num2str(distance) '_' test_type '_front'];
elseif strcmp(eye,'right')
    image_folders = [image_dir '/' test_type '/speed' num2str(speed) '_rep' num2str(sprintf('%02d',repeat)) '_den' num2str(sprintf('%02d',density)) '_dist' num2str(distance) '_' test_type '_front'];
end
    display(image_folders)


% get file listing
listing = dir([image_folders '/*.png']);
display(listing);

% read in image to video
for x = 1: duration
    
    % read image from folder
    im = imread([image_folders '/' listing(x).name]);
    
    % convert it to grayscale (removes color dim)
    im = rgb2gray(im);
    
    % CROP OUT PREDETERMINED REGION TO SET ZERO DISPARITY POINT
    if strcmp(eye,'left')
        
    elseif strcmp(eye,'right')
        
    end
    
    % upsample images to be 1920 wide (specify bicubic)
    % DO THIS ONLY IF NEEDED; ADJUST VIEWING DISTANCE IN LAB AND
    % screen_info
    im = imresize(im, [1080 1920], 'bicubic');
    
    % add image to frames object
    frames(:,:,x) = im;
    
end


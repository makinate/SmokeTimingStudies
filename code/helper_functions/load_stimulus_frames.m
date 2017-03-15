function frames = load_stimulus_frames(image_dir, test_type, speed, density, duration, distance, repeat)

% preallocate motion matrices
frames = NaN(848,1507,duration);

% generate filename (paths should be somewhere too)
% load in all pngs, or something based on duration

image_folders = [image_dir test_type '/speed' num2str(speed) '_rep' num2str(sprintf('%02d',repeat)) '_den' num2str(sprintf('%02d',density)) '_dist' num2str(distance) '_' test_type '_front'];
display(image_folders)

% get file listing
listing = dir([image_folders '/*.png']);

% read in image to video
for x = 1: duration
        
    % read image from folder
    im = imread([image_folders '/' listing(x).name]);
    % convert it to grayscale (removes color dim)
    im = rgb2gray(im);
    
    % add image to frames object
    frames(:,:,x) = im;

end


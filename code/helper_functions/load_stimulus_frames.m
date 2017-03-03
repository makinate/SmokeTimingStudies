function frames = load_stimulus_frames(test_type,speed,density,duration)
%
%

% generate filename (paths should be somewhere too)

% load in all pngs, or something based on duration

image_folders = ['E:/Dropbox/Dartmouth/Smoke/Blender/renderings/laptop']

% get file listing
listing = dir([folder_name '/*.png']);

% if this slow, try preallocating the frames matrix
% frames = zeros(x,y,duration)

% read in image to video
for x = 1:duration
    
        im = imread([folder_name '/' listing(x).name]);
        
        frames(:,:,x) = im;

end


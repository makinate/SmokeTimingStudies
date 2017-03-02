% load an image stack
folder_name     = dir(dat.smoke_dir);
max_frames      = 10;


% get file listing
listing = dir(folder_name);

% read in image to video
for x = 0:min([length(listing) max_frames])
    
    if ~strcmp('.',listing(x).name(1))
        
        display(num2str(x));
        
        im = imread([folder_name '/' listing(x).name]);
        
        imshow(im);
        
    end
    
end

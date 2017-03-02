function     draw_smoke(w,dat)

%rectt   =   CenterRectOnPoint([0 0 2*dat.stm.fixationRadiusPix 2*dat.stm.fixationRadiusPix], dat.scr.widthPix/2, dat.scr.heightPix/2);
%Screen( 'FillOval', w, repmat(dat.stm.fixationIntensity,1,3),  rectt );

% load image
im = imread(dat.smoke_dir);

% make image grey scale

im = rgb2gray(im);

% upsample images to be 1920 wide (specify bicubic)
if (dbug)
    im = imresize(im, [848/2 1507], 'bicubic');
    imshow(im);
else
    im = imresize(im, [1080/2 1920], 'bicubic');
end

% next 3 lines have to be run one after another for left and right
Screen('SelectStereoDrawBuffer', windowPtr, 0);   % Select left-eye image buffer for drawing     
Screen('DrawTexture', windowPtr, textureIndex); % Draw left stim
Screen('Flip', windowPtr);

end
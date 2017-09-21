function im = imread_as_grayscale(image_path, linearize)
%
% load in 8 bit image and return as grayscale 0-1;
% if linearize == 1, assume sRGB nonlinearity (~1/2.2) and linearize

% load in
im = imread(image_path);

% make sure image is grayscale
if size(im,3) == 3
    im = rgb2gray(im);
    %frame = 0.21*frame(:,:,1) + 0.72*frame(:,:,2) + 0.07*frame(:,:,3); ...conceptually
elseif size(im,3) ~= 1
    error('not a single or 3 channel image, dont know what to do with it!');
end

% normalize image to 0-1 (assuming it's an 8 bit image!)
im = double(im)/255;

% linearize it / undo gamma correction
if linearize
    %% linearize the image

    % define threshold value for linearization
    threshold = 0.04045;

    % find index of images below threshold
    im_small = find(im <= threshold);
    im_big   = find(im > threshold);

    % apply linearization to image based on indices
    im(im_small) = im(im_small)/12.92;
    im(im_big)   = ((im(im_big)+0.055)./(1+0.055)).^2.4;
end


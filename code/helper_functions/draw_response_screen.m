function draw_response_screen(w,dat,t)

draw_fixation_circle(w,dat);


%draw_smoke(w,dat);
DrawFormattedText(w, '+', 'center', 'center', [255 255 255]);
myimgfile='E:\Dropbox\Dartmouth\Smoke\Manta\render_out\02-28-2017\front_slow_noGrid_02-28-2017\0051.png';
ima=imread(myimgfile, 'png');
Screen('PutImage', w, ima); % put image on screen

%DrawFormattedText_mod(w, 'Press 1', 'center', dat.scr.y_center_pix-150, [255 255 255],-200);
% draw_arrow(w, [dat.scr.x_center_pix+2*dat.stm.fixationRadiusPix dat.scr.y_center_pix-2*dat.stm.fixationRadiusPix], 135, [255 255 255], [30 30 100 10]);
% DrawFormattedText(w, [dat.scr.response_mapping{1}], ...
%     dat.scr.x_center_pix+2*dat.stm.fixationRadiusPix+100, dat.scr.y_center_pix-2*dat.stm.fixationRadiusPix-100, [255 255 255]);
% 
% draw_arrow(w, [dat.scr.x_center_pix-2*dat.stm.fixationRadiusPix dat.scr.y_center_pix-2*dat.stm.fixationRadiusPix], 45, [255 255 255], [30 30 100 10]);
% DrawFormattedText(w, [dat.scr.response_mapping{2}], ...
%     dat.scr.x_center_pix-2*dat.stm.fixationRadiusPix-100, dat.scr.y_center_pix-2*dat.stm.fixationRadiusPix-100, [255 255 255]);
% 
% draw_arrow(w, [dat.scr.x_center_pix-2*dat.stm.fixationRadiusPix dat.scr.y_center_pix+2*dat.stm.fixationRadiusPix], 315, [255 255 255], [30 30 100 10]);
% DrawFormattedText(w, [dat.scr.response_mapping{3}], ...
%     dat.scr.x_center_pix-2*dat.stm.fixationRadiusPix-100, dat.scr.y_center_pix+2*dat.stm.fixationRadiusPix+100, [255 255 255]);
% 
% draw_arrow(w, [dat.scr.x_center_pix+2*dat.stm.fixationRadiusPix dat.scr.y_center_pix+2*dat.stm.fixationRadiusPix], 225, [255 255 255], [30 30 100 10]);
% DrawFormattedText(w, [dat.scr.response_mapping{4}], ...
%     dat.scr.x_center_pix+2*dat.stm.fixationRadiusPix+100, dat.scr.y_center_pix+2*dat.stm.fixationRadiusPix+100, [255 255 255]);

DrawFormattedText(w, 'Press "k" when you think the smoke/cylinder reached you after it was blacked out', 'center', dat.scr.y_center_pix - dat.scr.heightPix/3.5, [255 255 255]);

% if t > 0
% DrawFormattedText(w, ['trial ' num2str(t) '/' num2str(length(dat.trials.trialnum)) ], 'center', dat.scr.y_center_pix + dat.scr.heightPix/4, [255 255 255]);
% end

Screen('Flip',  w, [], 1);
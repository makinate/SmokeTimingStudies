function scr = screen_info(screen_name)
%
% get info for experiment screen

scr.name  = screen_name;

switch screen_name
    
    case 'mmLab'  % this is a ViewSonic V3D231 Modelnumber: VS14136
        
        scr.screenNumber        = 0;        % Use max screen number - 0 for primary screen or single screen set ups, 1 for secondary screen (only if 2 screen are enabled)
        
        scr.viewDistCm          = 39.65;       % distance subject views screen from; fix this later
        scr.widthCm             = 50.8;                         
        scr.heightCm            = 28.57;  
        scr.skipSync            = 0;        % skip sync test for testing on this computer
        
        % keys used to indicate directions in this order: (1) up right, (2) up left, (3) down left, (4) down right
        % note to self: adjust this for own experiment. probably only 1
        % response key needed. 
        % scr.response_mapping    = {'h'};
        scr.response_mapping    = {'u','r','c','m'};
        
        scr.letter_intensity_difference = 80; % number less than 106, smaller numbers should make the letter task harder
        
        scr.image_dir = '/users/makinate/Dropbox/Dartmouth/Smoke/Manta/render_out/VSS'; 
 
    case 'maxLab'  % this is a Asus VS238H-P
        
        scr.screenNumber        = 2;        % Use max screen number - 0 for primary screen or single screen set ups, 1 for secondary screen (only if 2 screen are enabled)
        
        scr.viewDistCm          = 75;       % distance subject views screen from; fix this later
        scr.widthCm             = 50.92;                         
        scr.heightCm            = 28.64;  
        scr.skipSync            = 1;        % skip sync test for testing on this computer
        
        % keys used to indicate directions in this order: (1) up right, (2) up left, (3) down left, (4) down right
        % note to self: adjust this for own experiment. probably only 1
        % response key needed. 
        % scr.response_mapping    = {'h'};
        scr.response_mapping    = {'u','r','c','m'};
        
        scr.letter_intensity_difference = 80; % number less than 106, smaller numbers should make the letter task harder
       
        scr.image_dir = 'E:/Dropbox/Dartmouth/Smoke/Manta/render_out/VSS/';
    
    case 'emilyOffice'
        
        scr.screenNumber        = 1;        % Use max screen number - 0 for primary screen or single screen set ups, 1 for secondary screen (only if 2 screen are enabled)
        
        scr.viewDistCm          = 75;       % distance subject views screen from
        scr.widthCm             = 37.6;   	% display width (cm)
        scr.heightCm            = 30.15;   	% display height (cm)
        scr.skipSync            = 0;        % whether to skip timing tests, generally unwise to skip unless there is a known issue with tehm
        
        % keys used to indicate directions in this order: (1) up right, (2) up left, (3) down left, (4) down right
        scr.response_mapping    = {'u','r','c','m'};
        
        scr.letter_intensity_difference = 80; % number less than 106, smaller numbers should make the letter task harder
        
        scr.image_dir = uigetdir; 
            
    case 'emilyOfficeHD'
        
        scr.screenNumber        = 0;      
        scr.viewDistCm          = 60;                         
        scr.widthCm             = 50.92;                         
        scr.heightCm            = 28.64;                     
        scr.skipSync            = 0;
        
        scr.response_mapping    = {'u','r','c','m'};
        
        scr.letter_intensity_difference = 80; % number less than 106, smaller numbers should make the letter task harder
        
        scr.image_dir = uigetdir; 
        
    case 'emilyLaptop'
        
        scr.screenNumber        = 0;      
        scr.viewDistCm          = 57;                            
        scr.widthCm             = 33;                          
        scr.heightCm            = 20.5;                          
        scr.skipSync            = 1;
        
        scr.response_mapping    = {'u','r','c','m'};
        
        scr.letter_intensity_difference = 80; % number less than 106, smaller numbers should make the letter task harder
        
        scr.image_dir = uigetdir; 
        
    case 'MackeyLaptop'
        
        scr.screenNumber        = 0;      
        scr.viewDistCm          = 60;                         
        scr.widthCm             = 26;                         
        scr.heightCm            = 16.2;                     
        scr.skipSync            = 0;
        
        scr.response_mapping    = {'u','r','c','m'};
        
        scr.letter_intensity_difference = 40; % number less than 106, smaller numbers should make the letter task harder
        
        scr.image_dir = uigetdir; 
        
    case 'MackeyHD' %changed scr.screenNumber to 1 for dual screen use
        
        scr.screenNumber        = 1;      
        scr.viewDistCm          = 57;                            
        scr.widthCm             = 47.5;                          
        scr.heightCm            = 27;                          
        scr.skipSync            = 0;
        
        scr.response_mapping    = {'9','7','1','3'};
        
        scr.letter_intensity_difference = 40; % number less than 106, smaller numbers should make the letter task harder
        
        scr.image_dir = uigetdir; 

    case 'emilyLab'
        
        scr.screenNumber        = 2;      
        scr.viewDistCm          = 57;                            
        scr.widthCm             = 51;                          
        scr.heightCm            = 28.8;                          
        scr.skipSync            = 1;
        
        scr.response_mapping    = {'u','r','c','m'};
        
        scr.letter_intensity_difference = 50; % number less than 106, smaller numbers should make the letter task harder
        
        scr.image_dir = uigetdir; 
        
    otherwise
        
        error('screen name provided does not exist. add screen to screen_info file in helper_functions');
        
end


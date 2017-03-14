function [dat,keys] = keys_get_response_smoke(keys,dat,trial,stimDone)
%
%

[~, timeOfPress, keyCode, ~] = KbCheck(-3);

resp = keyCode(keys.space);

% if there was a new response
if resp == 1
    
    % get response time
    dat.trials.resp(trial)  = timeOfPress - stimDone;
    keys.isDown = 1;
    display(['TTC estimate: ' num2str(dat.trials.resp(trial))]);
elseif keyCode(keys.esc)
    
    keys.killed = 1;
    keys.isDown = 1;
    
elseif sum(resp) == 0
    
    keys.isDown = 0;
    
end


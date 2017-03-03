function [dat,keys] = keys_setup_smoke(dat)

KbName('UnifyKeyNames');  % will switch internal naming scheme from OS sceme to MaxOS-X naming scheme. Call this at the beginning of each script

keys.space      = KbName('space');
keys.esc        = KbName('ESCAPE');

keys.isDown = 0;
keys.killed = 0;

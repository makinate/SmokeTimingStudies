# MotionCoherenceStudies

************************************************
Setting up to run the pilot:

You’ll need to install Psychtoolbox-3 for Matlab:
http://psychtoolbox.org/download/

Before running the study, be sure to pull the most up-to-date version of the code from the master branch of the repository.

************************************************
In order for the study to run on your computer/display, you will need to:

-create a case for your display system in helper_functions/screen_info and fill in the appropriate specs, including keyboard responses

-either use this display name when you run the functions (e.g. run_prepost_test(‘emilyLaptop’), or run functions without it (e.g. run_prepost_test) and enter the name when prompted

************************************************
General idea:

This code is designed to run a “task irrelevant perceptual learning” paradigm. The idea is that people can get trained to be better at performing a perceptual task even when they don’t know that they are being trained. To test this, you first measure how well participants can detection noisy motion patterns in 4 different directions from fields of random dots. This is their baseline performance on the perceptual task. Then you have them perform a second, unrelated task. During this second task, there are dots moving in the background in only 1 of the 4 directions. In this case, the unrelated task is a letter recall task, and the dots move with near-threshold coherence so that they don’t distract from the letter task. After ~1 hr of training, you then re-test on the motion detection task and see if the participants performance changed at all. The hypothesis is that they should improve for the direction of motion that was presented during the letter recall, but not for the others.

So there are three phases: pre-test, training, post-test.

In practice, it’s good to expose participants to both tasks up-front before you really start the whole experiment. So I have added two additional phases before the experiment starts, where you expose them to both the motion direction task and the letter recall task very briefly

************************************************
Order of functions to run:

INTRODUCING A PARTICIPANT TO THE TWO TASKS:

(1) run_introduction
	motion direction discrimination practice run, trials are blocked by difficulty, starting with very easy then going to very hard
	look at the results plotted after they finish, make sure they can do the direction discrimination task at reasonable coherences — 100%, 50%, okay if they can’t do it at 15%

(2) run_training
	letter recall task
	you’ll be prompted whether this is a “pre-training” session, say “1” for yes
	this will do a very short version of the letter recall test to familiarize the participant

(these both just take a few minutes)

RUNNING THE FULL STUDY:

(3) run_prepost_test 
	motion direction discrimination task, now trials of all difficulties are randomly intermixed
	should take ~ 10-15 minutes to finish
	you’ll be prompted whether this is pre- or post-, say it’s pre-
 
(4) run_training
	letter recall task
	you’ll be prompted whether this is a “pre-training” session, just hit enter for no
	this can be run as many times as you want. I like to do it in chunks of 200 repeats and take little breaks in between
	should be run for ~1h at least

(5) run_prepost_test 
	same as pretest
	should take ~ 10-15 minutes to finish
	you’ll be prompted whether this is pre- or post-, say it’s post-

************************************************
Plotting functions:

If you leave “do_plot” set to 1, summary plots will automatically be shown after each program finishes and will be saved along with mat files. You can also call the plotting functions on their own and select a file to plot from your file browser. These plots will be displayed but not automatically saved. Plotting functions are:

plot_results_testing([],1) (can be used for output of run_introduction or run_prepost_test)
plot_results_training([],10) (can be used for output of run_training)

plot_results_preposttest_comparison (separate plotting function that can be used to plot pre- and post-test results on the came axes)

************************************************
Other notes:

If you use junk as the subject name, these files won’t show up in version tracking, which is nice for testing.

For run_training, you can also use the subject name “db” which runs in debugging mode that allows you to manually set some stimulus parameters

We might need to adjust stuff like speed and letter brightness to look good on your display, we can discuss

The code blocks keyboard output to the matlab prompt while running (ListenChar(2)) and reenables after closing. If the code crashes, the best way to get your matlab prompt to listen to the keyboard again is to do “ctrl+c ctrl+c”. if the stimulus screen is still open after you do this, also type the letters “sca” then press “enter”

The motion direction to-be-trained is set when you call run_prepost_test and specify that this is a pretest for a subject. After that, the training and posttest functions load this information to determine which is the training direction. if a participant has multiple pre-test files in their folder, you will get an error telling you to delete the duplicates so that the direction to be trained is unambiguous. However, if you are testing and use “junk” as the subject name, you can just set the stimulus stuff in the code to debug

Hitting escape when any of the response screens are up will exit the program. If you try to exit before the trials start, you have to hit it twice, one at the intro screen, once after the first trial response prompt comes up

During training, if you press a key that isn’t a letter, a noise is made and you have to press a different key

For all programs, you can set dat.feedback = 1 near the top to give audio feedback, but we should probably not actually use this for direction discrimination. I turned it on for the “pre-training” of letter recall (step 2).

We’ll also need to do some timing diagnostics to make sure your display is updating the stimulus properly at each frame

We are using a standard codebase from the Shadlen lab at Columbia to generate random dot patterns. The original codebase interleaves three dot patterns every 3 frames. I don’t think this is necessary for our study, so I made an alternate version with that part removed. But this makes me nervous, so I need to ask around to find out if this interleaving step is needed for our type of study.

For letter recall, I was originally doing 8 black, 2 white, then prompt to type in the white letters. But in order to increase the duration that each letter is on-screen and also keep the task difficult, I changed this so that all 10 letters are gray, but 2 are just a slightly lighter gray than other 8. 
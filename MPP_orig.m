function MPP_orig(SubjectID, condition, extendcondition, varargin)
% This is an eyetracking script! It runs the standard calibrator (see
% options below) then tries to run the original MPP script (with, for now,
% no collection of eyedata once calibration is over).

%**************************
% Preliminaries
%**************************

%*** Parse the input
p = inputParser;
p.addRequired('SubjectID');
p.addRequired('condition', @isstr);
p.addRequired('extendcondition', @isstr);
p.addParamValue('use_eyetracker', 1, @isnumeric); %use 0 for no eyetracker
p.addParamValue('experiment_name', 'SAMPLEEXP', @isstr);
p.addParamValue('eyetracker_name', 'Lion', @isstr); %in case you have multiple eyetrackers in the lab...
p.addParamValue('calib_version', 'Adult', @isstr); %can replace with 'Kid' for a cooler kid display. 
p.addParamValue('max_calib', 5, @isnumeric); %in case we want to NOT loop on the calibration forever.

p.parse(SubjectID, condition, extendcondition, varargin{:});
inputs = p.Results;

%*** Set global variables
global EXPERIMENT %String for experiment name
global SUBJECT %String for subject name
global EXPFOLDER %This folder, path generated below
global DATAFOLDER %Where to save all data
global RESOURCEFOLDER %Where to find the PTB and Tobii helper fns
global USE_EYETRACKER %boolean
global TOBII %Tobii mothership object
global EYETRACKER %will be the Tobii eyetracker object
global CALIBVERSION %kid friendliness galore
global MAXCALIB %Give up after n tries
global EXPWIN %Psychtoolbox stuff
global KEYBOARD 
global KEYID 
global CENTER 
global WHITE 
global BLACK 

EXPERIMENT = inputs.experiment_name;
CALIBVERSION = inputs.calib_version;
MAXCALIB = inputs.max_calib;
USE_EYETRACKER = inputs.use_eyetracker;
if ~ischar(inputs.SubjectID)
    SUBJECT = num2str(inputs.SubjectID);
else
    SUBJECT = inputs.SubjectID;
end

addpath(genpath('/Applications/TobiiProSDK'));
addpath(genpath('/Users/snedlab/Desktop/MPP-Common-Resources'));
RESOURCEFOLDER = '/Users/snedlab/Desktop/MPP-Common-Resources';
EXPFOLDER = fileparts(which('Tobii_calibration_with_psychtoolbox.m')); %add this folder to the path too.
addpath(genpath(EXPFOLDER));
DATAFOLDER = [EXPFOLDER '/Data'];

%Make PTB less verbose and get basic info about your stim-presenting screen
Screen('Preference', 'Verbosity', 0);
Screen('Preference', 'SkipSyncTests',1);
Screen('Preference', 'VisualDebugLevel',0);
PsychPortAudio('Verbosity',0);

Calib=SetCalibParams;

%Window and Keyboard variables
CENTER = [round((Calib.screen.width - Calib.screen.x)/2) ...
    round((Calib.screen.height -Calib.screen.y)/2)];
BLACK = BlackIndex(EXPWIN); 
WHITE = WhiteIndex(EXPWIN);
KbName('UnifyKeyNames');
KEYBOARD=max(GetKeyboardIndices);
KEYID.SPACE=KbName('SPACE');
KEYID.Y = KbName('y');
KEYID.N = KbName('n');


%****************************
% Connect to eye tracker
%****************************

if USE_EYETRACKER
    TOBII = EyeTrackingOperations();
    if strcmp(inputs.eyetracker_name, 'Lion')
        EYETRACKER = TOBII.get_eyetracker('tet-tcp://169.254.5.184'); 
    elseif strcmp(inputs.eyetracker_name, 'Koala')
        display('Koala room eyetracker isnt implemented yet, go use lion');
        %EYETRACKER = TOBII.get_eyetracker('tet-tcp://169.254.92.114');
    end
    
    display('Connected to the Tobii server, congratulations!');
    %Get and print the Frame rate of the current ET
    fprintf('Frame rate: %d Hz.\n', EYETRACKER.get_gaze_output_frequency());
end

%NOTES ON CONNECTING: To find your IP, try typing arp -a in the terminal and see if you see one
%with tt060 at the beginning, make sure IP address is correct by using ping
%169.254.92.137 (your IP address). If you can ping but can't connect,
%- turn the tobii off & back on again
%- unplug the ethernet cable & replug
%- run ping <ip> and then telnet <ip>. If only the latter fails...(I don't
%know, I am stuck here for Koala room.)


%*********************
% Track status of eyes (position participant before calibrating)
%*********************

if USE_EYETRACKER
    TrackEyesOnscreen(Calib);
end

%*********************
% Calibration
%*********************

if USE_EYETRACKER
    disp('Starting Calibration workflow');
    HandleCalibWorkflow(Calib);
    disp('Calibration workflow finished');
end
 
%*********************
% Calibration finished, go on to your experiment 
%********************

Screen('FillRect',EXPWIN,BLACK);
Screen(EXPWIN,'Flip');
disp('Starting simple Experiment');

%---run simple example of experiment loop
% 2 choices for you here: SimpleExp just puts some text onscreen,
% while SimpleMov plays some cute movies. 

Do_MPP_trials(SUBJECT, condition, extendcondition);

%---Clean up and exit nicely
Screen('Close',EXPWIN);
clear all;

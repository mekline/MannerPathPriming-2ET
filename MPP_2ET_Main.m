function MPP_2ET_Main(SubjectID, Condition, ToExtend, varargin)
% The new MPP, for eyetracking 2yos. The new excitement is that
% this version has refactored the common resources for PTB,
% eyetracking, and common stimuli for easier/more economical
% iteration of experiments. 

%**************************
% Preliminaries
%**************************

%*** Parse the input
p = inputParser;
p.addRequired('SubjectID');
p.addRequired('Condition');
p.addRequired('ToExtend');
p.addParamValue('use_eyetracker', 1, @isnumeric); %use 0 for no eyetracker
p.addParamValue('experiment_name', 'MPPCREATION', @isstr);
p.addParamValue('eyetracker_name', 'Lion', @isstr); %in case you have multiple eyetrackers in the lab...
p.addParamValue('calib_version', 'Kid', @isstr); %can replace with 'Kid' for a cooler kid display. 
p.addParamValue('max_calib', 5, @isnumeric); %in case we want to NOT loop on the calibration forever.
p.addParamValue('ExtendPractice', 1, @isnumeric);

p.parse(SubjectID, Condition, ToExtend, varargin{:});
inputs = p.Results;

%*** Set the global variables
global EXPERIMENT %String for experiment name
global SUBJECT %String for subject name
global EXPFOLDER %This folder, path generated below
global DATAFOLDER %Where to save all data
global DATAFILE %File to save behavioral (non eyetracking) data
global RESOURCEFOLDER %Where to find the PTB and Tobii helper fns, and possibly your media
global USE_EYETRACKER %boolean
global TOBII %Tobii mothership object
global EYETRACKER %will be the Tobii eyetracker object
global CALIBVERSION %kid friendliness galore
global MAXCALIB %Give up after n tries
global EXPWIN %Psychtoolbox stuff
global WINDOW_PARAMS %Object for storing standard dimensions for things like movie locations and text size etc.
global KEYID %Keyboard stuff
%MPP-specific stuff 
global CONDITION %Manner, Path, Action, or Effect
global TOEXTEND %Extend or NoExtend
global EXTENDPRACTICE %ExtendPractice or NoPractice

if ~ischar(inputs.SubjectID)
    SUBJECT = num2str(inputs.SubjectID);
else
    SUBJECT = inputs.SubjectID;
end

%Make sure paths are set correctly (your system may need to update these!)
addpath(genpath('/Applications/TobiiProSDK'));
addpath(genpath('/Applications/PsychToolBox'));
addpath(genpath('/Users/snedlab/Desktop/MPP-Common-Resources'));
RESOURCEFOLDER = '/Users/snedlab/Desktop/MPP-Common-Resources';
EXPFOLDER = fileparts(which('MPP_2ET_Main.m')); %add this folder to the path too.
addpath(genpath(EXPFOLDER));
DATAFOLDER = [EXPFOLDER '/Data'];

EXPERIMENT = inputs.experiment_name;
CALIBVERSION = inputs.calib_version;
MAXCALIB = inputs.max_calib;
USE_EYETRACKER = inputs.use_eyetracker;
CONDITION = inputs.Condition;
TOEXTEND = inputs.ToExtend;
EXTENDPRACTICE = inputs.ExtendPractice;

% Validate inputs
Conditions = {'Manner', 'Path', 'Action', 'Effect'};
knownCond = strfind(Conditions, CONDITION);
k = logical(sum(~cellfun(@isempty, knownCond)));
assert(k, 'Use Manner Path Action or Effect for main exp')

ExtConditions = {'Extend', 'NoExtend'};
knownCond = strfind(ExtConditions, TOEXTEND);
k = logical(sum(~cellfun(@isempty, knownCond)));
assert(k, 'Use NoExtend or Extend for the extension (NoExtend is default)')

DATAFILE = AssignDataFile(); %will kick you out if the subjname has been used

%Do psychtoolbox preliminaries to make sure everything's ready!
%Make PTB less verbose and get basic info about your stim-presenting screen
Screen('Preference', 'Verbosity', 0);
Screen('Preference', 'SkipSyncTests',1);
Screen('Preference', 'VisualDebugLevel',0);
PsychPortAudio('Verbosity',0);

% This sets up basic info about your screen plus info specific to an
% eyetracking calibration, but should work fine if not connecting to an ET.
% Alternately, use SetCalibParams_PTB.m for a version local to the PTB
% helper folder if you're not using the Tobii-Psychtoolbox resources.
Calib=SetCalibParams('x',[0.9 0.9 0.1 0.1 0.5],'y',[0.1 0.9 0.1 0.9 0.5]);

%And set the boxes that movies and text will play during this experiment!
[WINDOW_PARAMS, KEYID] = SetSpaceParameters(Calib);  %If you wanted to change the look & feel of your exp, create a local version of SetSpaceParams
%****************************
% Connect to eye tracker
%****************************

if USE_EYETRACKER
    TOBII = EyeTrackingOperations();
    if strcmp(inputs.eyetracker_name, 'Lion')
        EYETRACKER = TOBII.get_eyetracker('tet-tcp://169.254.5.184'); 
    elseif strcmp(inputs.eyetracker_name, 'Koala')
        disp('Koala room eyetracker isnt implemented yet, go use lion');
        %EYETRACKER = TOBII.get_eyetracker('tet-tcp://169.254.92.114');
    end
    
    disp('Connected to the Tobii server, congratulations!');
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

Screen('FillRect',EXPWIN, WINDOW_PARAMS.BLACK);
Screen(EXPWIN,'Flip');

disp(strcat('Starting Experiment: ', EXPERIMENT));

%---And the experiment runs here!
Do_MPP_Exp();

%---Clean up and exit nicely
Screen('Close',EXPWIN);
clear all;

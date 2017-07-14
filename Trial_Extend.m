function [response] = Trial_Extend(trialNo)
%Play 1 trial of the MannerPath experiment.
%This is just like Trial_Main except it plays whatever hte Extend movie 
%set it, and it just plays the bias test part of each trial!
%Bias test - show M1P1 movie; take a forced choice response between M1P2
%and M2P1

global MAIN_ITEMS EXT_ITEMS ntrials RESOURCEFOLDER EXTENDCONDITION parameters TOBII EYETRACKER EXPWIN BLACK DATAFOLDER EXPERIMENT SUBJECT timeCell
    
%This is the extend version, so adjust the global trial number to index
%into the EXT_ITEMS object

trialNo = trialNo - ntrials;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Trial movies
    movietoplay_ambigVid = strcat(RESOURCEFOLDER, '/movies/', EXT_ITEMS.ambigV(trialNo));
    movietoplay_path = strcat(RESOURCEFOLDER, '/movies/', EXT_ITEMS.pBiasV(trialNo));    
    movietoplay_manner = strcat(RESOURCEFOLDER, '/movies/', EXT_ITEMS.mBiasV(trialNo));
    movietoplay_recenter = strcat(RESOURCEFOLDER, '/movies/babylaugh.mov');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUDIO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    soundtoplay_ambigAudioFuture = strcat(RESOURCEFOLDER, '/audio/', EXT_ITEMS.ambigAudioFuture(trialNo));
    soundtoplay_ambigAudioPast = strcat(RESOURCEFOLDER, '/audio/', EXT_ITEMS.ambigAudioPast(trialNo));
    soundtoplay_whichOne = strcat(RESOURCEFOLDER, '/audio/', EXT_ITEMS.whichOneAudio(trialNo));
    soundtoplay_letsFind = strcat(RESOURCEFOLDER, '/audio/aa_lets_find/', EXT_ITEMS.letsFindAudio(trialNo));
    
    %these ones are the same every time
    soundtoplay_letsWatchMore = strcat(RESOURCEFOLDER, '/audio/aa_motivation/letswatchmore.wav');
    soundtoplay_getReady = strcat(RESOURCEFOLDER, '/audio/aa_motivation/getready.wav');
    soundtoplay_goodJob = strcat(RESOURCEFOLDER, '/audio/aa_motivation/goodjob.wav');
    soundtoplay_nowLetsSee = strcat(RESOURCEFOLDER, '/audio/aa_motivation/nowletssee.wav');
    soundtoplay_wow = strcat(RESOURCEFOLDER, '/audio/aa_motivation/wow.wav');
     
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STAR IMAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%     starImage = parameters.extStars(trialNo); 
    greySquare = 'stars/grey.jpg';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAY BIAS TEST VIDEO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %START TRIAL
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Trial ' num2str(trialNo)]}; 
        disp(['Start Trial: ' num2str(trialNo)])
        
        Show_Blank;
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Extend' num2str(trialNo)]}; 
        disp(['ambigAudio_Extend' num2str(trialNo)])
        
        Play_Sound(soundtoplay_ambigAudioFuture{1}, 'toBlock');
        
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Extend ' num2str(trialNo)]}; 
        disp(['ambigVideo_Extend ' num2str(trialNo)])
        
        PlayCenterMovie(movietoplay_ambigVid{1});
        if strmatch(EXTENDCONDITION, {'Action'}) %need a mask in between or they look super weird!
            imageArray = imread(greySquare);
            rect =  parameters.centerbox;
            winPtr = parameters.scr.winPtr;   
            Screen('PutImage', winPtr , imageArray, rect );    
            Screen('flip',winPtr)
            WaitSecs(0.500);
        end
        Show_Blank;

        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Extend' num2str(trialNo)]}; 
        disp(['ambigAudio_Extend' num2str(trialNo)])
        
        Play_Sound(soundtoplay_ambigAudioPast{1}, 'toBlock');
        
        Show_Blank; 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BIAS TEST
% Play the two event movies separately, then at the same time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save gaze data for audio clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['biasAudio_Extend' num2str(trialNo)]}; 
    disp(['biasAudio_Extend' num2str(trialNo)])

    Play_Sound(soundtoplay_letsFind{1}, 'toBlock');
    Show_Blank;      
      
    %Using the human-interpretable side variables instead...
    if EXT_ITEMS.BiasManner(trialNo) == 'L'
        
        %Save gaze data for video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['left_biasVideo_Extend ' num2str(trialNo)]}; 
            disp(['left_biasVideo_Extend' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_manner{1},'');
        Show_Blank;
        
         %Save gaze data for video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['right_biasVideo_Extend ' num2str(trialNo)]}; 
            disp(['right_biasVideo_Extend' num2str(trialNo)])
        PlaySideMovies('',movietoplay_path{1});
        Show_Blank;
        
        %Save gaze data for audio
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['biasAudio_Extend ' num2str(trialNo)]}; 
            disp(['biasAudio_Extend' num2str(trialNo)])
            
        Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
        
        %Save gaze data for videos
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['biasTest_Extend ' num2str(trialNo)]}; 
        disp(['biasTest_Extend' num2str(trialNo)])
            
        PlaySideMovies(movietoplay_manner{1},movietoplay_path{1});
        
    elseif EXT_ITEMS.BiasManner(trialNo) == 'R'
        
        %Save gaze data for video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['left_biasVideo_Extend ' num2str(trialNo)]}; 
            disp(['left_biasVideo_Extend' num2str(trialNo)])
            
        PlaySideMovies(movietoplay_path{1},'');
        Show_Blank;
        
        %Save gaze data for video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['right_biasVideo_Extend ' num2str(trialNo)]}; 
            disp(['right_biasVideo_Extend' num2str(trialNo)])
            
        PlaySideMovies('',movietoplay_manner{1});
        Show_Blank;
        
        %Save gaze data for audio
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['biasAudio_Extend ' num2str(trialNo)]}; 
            disp(['biasAudio_Extend' num2str(trialNo)])
        Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
        
        %Save gaze data for videos
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['biasTest_Extend ' num2str(trialNo)]}; 
        disp(['biasTest_Extend' num2str(trialNo)])

        PlaySideMovies(movietoplay_path{1},movietoplay_manner{1});
    end
    
    WaitSecs(3.00);
    
    GazeData = EYETRACKER.get_gaze_data;
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['End_Trial ' num2str(trialNo)]};
    
    Show_Blank();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SHOW ATTENTION-GRAB CENTER
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Show_Blank;
    
    %Save gaze data for attention grab
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' num2str(trialNo)]}; 
        disp(['recenter ' num2str(trialNo)])
            
    PlayCenterMovie(movietoplay_recenter);
    WaitSecs(2.00);
    Show_Blank;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAVE THE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_trial_' num2str(trialNo)]; %description of this timeperiod
    save([DATAFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(GazeData, description);
    
    %saving timestamps
    timeTable = cell2table(timeCell(2:end,:));
    timeTable.Properties.VariableNames = timeCell(1,:);
    %And save the file!
    filename = [DATAFOLDER, '/timestamps_' EXPERIMENT '_' SUBJECT '.csv'];
    writetable(timeTable, filename);
    
end





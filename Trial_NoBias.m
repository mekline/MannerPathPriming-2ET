function [response] = Trial_NoBias(trialNo)
%Play 1 trial of the MannerPath experiment.
%Trial structure is sort of complex; it has 2 phases:
% Training - Depending on the condition, show either MnP1 or M1Pn movies
% Final test - take a forced choice response between M1P2 and M2P1 again

global parameters MAIN_ITEMS RESOURCEFOLDER CONDITION TOBII EYETRACKER EXPWIN BLACK DATAFOLDER EXPERIMENT SUBJECT timeCell

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Trial movies
    movietoplay_ambigVid = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.ambigV(trialNo));
    movietoplay_trainV1 = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.trainV1(trialNo));
    movietoplay_trainV2 = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.trainV2(trialNo));
    movietoplay_trainV3 = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.trainV3(trialNo));
    movietoplay_mTest = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.mTestV(trialNo));
    movietoplay_pTest = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.pTestV(trialNo));
    movietoplay_recenter = strcat(RESOURCEFOLDER, '/movies/babylaugh.mov');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUDIO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    soundtoplay_ambigAudioFuture = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.ambigAudioFuture(trialNo));
    soundtoplay_ambigAudioPast = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.ambigAudioPast(trialNo));
    soundtoplay_trainAudioFuture1 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioFuture1(trialNo));
    soundtoplay_trainAudioPast1 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioPast1(trialNo));
    soundtoplay_trainAudioFuture2 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioFuture2(trialNo));
    soundtoplay_trainAudioPast2 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioPast2(trialNo));
    soundtoplay_trainAudioFuture3 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioFuture3(trialNo));
    soundtoplay_trainAudioPast3 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioPast3(trialNo));
    soundtoplay_whichOne = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.whichOneAudio(trialNo));
    soundtoplay_letsFind = strcat(RESOURCEFOLDER, '/audio/aa_lets_find/', MAIN_ITEMS.letsFindAudio(trialNo));
    
    %these ones are the same every time
    soundtoplay_letsWatchMore = strcat(RESOURCEFOLDER, '/audio/aa_motivation/letswatchmore.wav');
    soundtoplay_getReady = strcat(RESOURCEFOLDER, '/audio/aa_motivation/getready.wav');
    soundtoplay_goodJob = strcat(RESOURCEFOLDER, '/audio/aa_motivation/goodjob.wav');
    soundtoplay_nowLetsSee = strcat(RESOURCEFOLDER, '/audio/aa_motivation/nowletssee.wav');
    soundtoplay_wow = strcat(RESOURCEFOLDER, '/audio/aa_motivation/wow.wav');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAY AMBIGUOUS VIDEO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %START TRIAL
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_noBias_Trial ' num2str(trialNo)]}; 
        
        Show_Blank;

        %Save gaze data for audio clip
        GazeData1 = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_noBias' num2str(trialNo)]}; 
        disp(['ambigAudio_noBias' num2str(trialNo)])

        Play_Sound(soundtoplay_ambigAudioFuture{1}, 'toBlock');
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(GazeData, GazeData1);
              
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_noBias' num2str(trialNo)]}; 
        
        PlayCenterMovie(movietoplay_ambigVid{1});
        if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
            imageArray = imread(greySquare);
            rect =  parameters.centerbox;
            winPtr = parameters.scr.winPtr;   
            Screen('PutImage', winPtr , imageArray, rect );    
            Screen('flip',winPtr)
            WaitSecs(0.500);
        end
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_noBias' num2str(trialNo)]}; 
        disp(['ambigAudio_noBias' num2str(trialNo)])
        
        Play_Sound(soundtoplay_ambigAudioPast{1}, 'toBlock');
        
        Show_Blank; 
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BIAS TEST
    % Play the two event movies; movie always plays L then R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
      
    %Using the human-interpretable side variables instead...
    MAIN_ITEMS.BiasManner(trialNo) == 'NA';
    MAIN_ITEMS.BiasPath(trialNo) == 'NA';
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3 TRAINING VIDEOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 111111111111111111111111111111111111111111111111111111111111111111111111
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    MAIN_ITEMS.trainStart(trialNo) = GetSecs;

    %Save gaze data for audio clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['trainingAudio_noBias_1 ' num2str(trialNo)]}; 
    
    Play_Sound(soundtoplay_trainAudioFuture1{1}, 'toBlock');
    
    %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
              
    
    %Save gaze data for video clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['trainingVideo_noBias_1 ' num2str(trialNo)]}; 
        
    PlayCenterMovie(movietoplay_trainV1{1}); 
    if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
        imageArray = imread(greySquare);
        rect =  parameters.centerbox;
        winPtr = parameters.scr.winPtr;   
        Screen('PutImage', winPtr , imageArray, rect );    
        Screen('flip',winPtr)
        WaitSecs(0.500);
    end
    WaitSecs(0.50);
    Show_Blank;
    
    %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
              
    
    %Save gaze data for audio clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['trainingAudio_noBias_1 ' num2str(trialNo)]}; 
        
    Play_Sound(soundtoplay_trainAudioPast1{1}, 'toBlock');

    WaitSecs(1.500);
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 2222222222222222222222222222222222222222222222222222222222222222222222222
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Save gaze data for audio clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['trainingAudio_noBias_2 ' num2str(trialNo)]}; 
        
    Play_Sound(soundtoplay_trainAudioFuture2{1}, 'toBlock');
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
    
    %Save gaze data for video clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['trainingVideo_noBias_2' num2str(trialNo)]}; 
    disp(['trainingVideo_noBias_2' num2str(trialNo)])
    
    PlayCenterMovie(movietoplay_trainV2{1});
    if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
        imageArray = imread(greySquare);
        rect =  parameters.centerbox;
        winPtr = parameters.scr.winPtr;   
        Screen('PutImage', winPtr , imageArray, rect );    
        Screen('flip',winPtr)
        WaitSecs(0.500);
    end
    WaitSecs(0.50);
    Show_Blank;
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
    
    %Save gaze data for audio clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['trainingAudio_noBias_2 ' num2str(trialNo)]}; 

    Play_Sound(soundtoplay_trainAudioPast2{1}, 'toBlock');

    WaitSecs(1.500);
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 333333333333333333333333333333333333333333333333333333333333333333333333%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Save gaze data for audio clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['trainingAudio_noBias_3 ' num2str(trialNo)]}; 
    
    Play_Sound(soundtoplay_trainAudioFuture3{1}, 'toBlock');
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
    
    %Save gaze data for video clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['trainingVideo_noBias_3 ' num2str(trialNo)]}; 
         
    PlayCenterMovie(movietoplay_trainV3{1});
    if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
        imageArray = imread(greySquare);
        rect =  parameters.centerbox;
        winPtr = parameters.scr.winPtr;   
        Screen('PutImage', winPtr , imageArray, rect );    
        Screen('flip',winPtr)
        WaitSecs(0.500);
    end
    WaitSecs(0.50);
    Show_Blank;
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
    
    %Save gaze data for audio clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['trainingAudio_noBias_3 ' num2str(trialNo)]}; 
        
    Play_Sound(soundtoplay_trainAudioPast3{1}, 'toBlock');

    MAIN_ITEMS.trainEnd(trialNo) = GetSecs;
   
    WaitSecs(1.500);
    Show_Blank;
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READY FOR THE TEST?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAY THE TEST MOVIE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    MAIN_ITEMS.finalTestStart(trialNo) = GetSecs;
    
    %Save gaze data for audio clip
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['testAudio_noBias' num2str(trialNo)]}; 
        
    Play_Sound(soundtoplay_letsFind{1}, 'toBlock');
    Show_Blank;      
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
  
    %Using the human-interpretable side variables...
    if MAIN_ITEMS.TestManner(trialNo) == 'L'
        
        %Save gaze data for left clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_noBias ' num2str(trialNo)]}; 
        
        PlaySideMovies(movietoplay_mTest{1},'');
        WaitSecs(0.50);
        Show_Blank;
        
         %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
        
        %Save gaze data for right clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_noBias ' num2str(trialNo)]}; 
        
        PlaySideMovies('',movietoplay_pTest{1});
        WaitSecs(0.50);
        Show_Blank; 
        
         %Concatenate arrays to save gaze data in all one big file
         C = horzcat(C, GazeData);
        
        %Save gaze data for both clips
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_noBias ' num2str(trialNo)]}; 
        
        PlaySideMovies(movietoplay_mTest{1},movietoplay_pTest{1});
        
         %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
        
    elseif MAIN_ITEMS.TestManner(trialNo) == 'R'
        
        %Save gaze data for left clip
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_noBias ' num2str(trialNo)]}; 
        
        PlaySideMovies(movietoplay_pTest{1},'');
        WaitSecs(0.50);
        Show_Blank;
        
         %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
        
        %Save gaze data for right clip
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_noBias ' num2str(trialNo)]}; 
        
        PlaySideMovies('',movietoplay_mTest{1});
        WaitSecs(0.50);
        Show_Blank;
        
         %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
        
        %Save gaze data for sound clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio ' num2str(trialNo)]}; 
        
        Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
        
         %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
        
        %Save gaze data for test trial
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos ' num2str(trialNo)]}; 
        
        PlaySideMovies(movietoplay_pTest{1},movietoplay_mTest{1});
        
         %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
    end
    
    WaitSecs(3.00);
    
    MAIN_ITEMS.finalTestEnd(trialNo) = GetSecs;
    
    GazeData = EYETRACKER.get_gaze_data;
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['End_NoBias_Trial ' num2str(trialNo)]};
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SHOW ATTENTION-GRAB CENTER
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Show_Blank;
    
    %Save gaze data for attention grabber
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['recenter ' num2str(trialNo)]}; 
    disp(['recenter ' num2str(trialNo)])
        
    PlayCenterMovie(movietoplay_recenter, 'ownsound', 1);
    Show_Blank;
    
    MAIN_ITEMS.finalTestEnd(trialNo) = GetSecs;
    
     %Concatenate arrays to save gaze data in all one big file
    C = horzcat(C, GazeData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAVE THE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_noBias_trial_' num2str(trialNo)]; %description of this timeperiod
    save([DATAFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(C, description);
    
    %saving timestamps
    timeTable = cell2table(timeCell(2:end,:));
    timeTable.Properties.VariableNames = timeCell(1,:);
    %And save the file!
    filename = [DATAFOLDER, '/timestamps_' EXPERIMENT '_' SUBJECT '.csv'];
    writetable(timeTable, filename);

    
    
end





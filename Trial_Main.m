function [response] = Trial_Main(trialNo)
%Play 1 trial of the MannerPath experiment.
%Trial structure is sort of complex; it has 3 phases:
% Bias test - show M1P1 movie; take a forced choice response between M1P2
% and M2P1
% Training - Depending on the condition, show either MnP1 or M1Pn movies
% Final test - take a forced choice response between M1P2 and M2P1 again

global MAIN_ITEMS CONDITION RESOURCEFOLDER  parameters TOBII EYETRACKER EXPWIN BLACK DATAFOLDER EXPERIMENT SUBJECT timeCell

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Trial movies
    movietoplay_ambigVid = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.ambigV(trialNo));
    movietoplay_path = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.pBiasV(trialNo));    
    movietoplay_manner = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.mBiasV(trialNo));
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
% STAR IMAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%     starImage = parameters.mainStars(trialNo);
%     greySquare = 'stars/grey.jpg';

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
            ['ambigAudio_Main' num2str(trialNo)]}; 
        disp(['ambigAudio_Main' num2str(trialNo)])
        
        Play_Sound(soundtoplay_ambigAudioFuture{1}, 'toBlock');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Main ' num2str(trialNo)]}; 
        disp(['ambigVideo_Main ' num2str(trialNo)])
    
        PlayCenterMovie(movietoplay_ambigVid{1});
        if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
            imageArray = imread(greySquare);
            rect =  parameters.centerbox;
            winPtr = parameters.scr.winPtr;   
            Screen('PutImage', winPtr , imageArray, rect );    
            Screen('flip',winPtr)
            WaitSecs(0.500);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Main ' num2str(trialNo)]}; 
        disp(['ambigAudio_Main ' num2str(trialNo)])
        Play_Sound(soundtoplay_ambigAudioPast{1}, 'toBlock');
        
        Show_Blank; 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BIAS TEST
    % Play the two event movies; movie always plays L then R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save gaze data for audio clip
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['biasAudio_Main' num2str(trialNo)]}; 
        disp(['biasAudio_Main ' num2str(trialNo)])
    
    Play_Sound(soundtoplay_letsFind{1}, 'toBlock');
    Show_Blank;      
      
    %Using the human-interpretable side variables instead...
    %Plays: 1 video on the left, blank, 1 video on the right, blank
    %Then both videos
    
    if MAIN_ITEMS.BiasManner(trialNo) == 'L'
        
        %Save gaze data for left video
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_biasVideo_Main ' num2str(trialNo)]}; 
        disp(['left_biasVideo_Main ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_manner{1},'');
        WaitSecs(0.50);
        Show_Blank;
        
        %Save gaze data for right video
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_biasVideo_Main' num2str(trialNo)]}; 
        disp(['right_biasVideo_Main ' num2str(trialNo)])
        PlaySideMovies('',movietoplay_path{1});
        
        WaitSecs(0.50);
        Show_Blank;
        
        %Save gaze data for audio
        GazeData = EYETRACKER.get_gaze_data; 
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['audio_biasTest_Main ' num2str(trialNo)]}; 
            disp(['audio_biasTest_Main ' num2str(trialNo)])

        Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
    
        %Saving gaze data for both videos
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['biasTest_Main ' num2str(trialNo)]}; 
        disp(['biasTest_Main ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_manner{1},movietoplay_path{1});
        
    elseif MAIN_ITEMS.BiasManner(trialNo) == 'R'
        
        %Save gaze data for left video
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_biasVideo_Main ' num2str(trialNo)]}; 
        disp(['left_biasVideo_Main ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_path{1},'');
        Show_Blank;
        
        %Save gaze data for right video
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_biasVideo_Main ' num2str(trialNo)]}; 
        disp(['right_biasVideo_Main' num2str(trialNo)])
        
        PlaySideMovies('',movietoplay_manner{1});
        Show_Blank;
        
        %Save gaze data for audio
        GazeData = EYETRACKER.get_gaze_data; 
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['audio_biasTest_Main ' num2str(trialNo)]}; 
            disp(['audio_biasTest_Main ' num2str(trialNo)])

        Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
        
        %Save gaze data for both videos
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['biasTest_Main ' num2str(trialNo)]}; 
        disp(['biasTest_Main ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_path{1},movietoplay_manner{1});
        
    end
    
    WaitSecs(3.00);
    
    Show_Blank();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3 TRAINING VIDEOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Play_Sound(soundtoplay_letsWatchMore, 'toBlock');
    Show_Blank;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 111111111111111111111111111111111111111111111111111111111111111111111111
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    MAIN_ITEMS.trainStart(trialNo) = GetSecs;
    
    %Save gaze data for audio
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_1_Main ' num2str(trialNo)]}; 
        disp(['trainingAudio_1_Main' num2str(trialNo)]);
        
    Play_Sound(soundtoplay_trainAudioFuture1{1}, 'toBlock');
    
    %Save gaze data for training
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_1_Main ' num2str(trialNo)]}; 
        disp(['trainingVideo_1_Main ' num2str(trialNo)])
        
    PlayCenterMovie(movietoplay_trainV1{1}); 
    if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
        imageArray = imread(greySquare);
        rect =  parameters.centerbox;
        winPtr = parameters.scr.winPtr;   
        Screen('PutImage', winPtr , imageArray, rect );    
        Screen('flip',winPtr)
        WaitSecs(0.500);
    end
    Show_Blank;
    
    %Save gaze data for training
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_1_Main ' num2str(trialNo)]}; 
        disp(['trainingAudio_1_Main ' num2str(trialNo)])

    Play_Sound(soundtoplay_trainAudioPast1{1}, 'toBlock');

    WaitSecs(1.500);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 2222222222222222222222222222222222222222222222222222222222222222222222222
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save gaze data for training
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_2_Main ' num2str(trialNo)]}; 
        disp(['trainingAudio_2_Main ' num2str(trialNo)])
    
    Play_Sound(soundtoplay_trainAudioFuture2{1}, 'toBlock');
    
    %Save gaze data for training
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_2_Main ' num2str(trialNo)]}; 
        disp(['trainingVideo_2_Main ' num2str(trialNo)])
    
    PlayCenterMovie(movietoplay_trainV2{1});
    if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
        imageArray = imread(greySquare);
        rect =  parameters.centerbox;
        winPtr = parameters.scr.winPtr;   
        Screen('PutImage', winPtr , imageArray, rect );    
        Screen('flip',winPtr)
        WaitSecs(0.500);
    end
    Show_Blank;
    
    %Save gaze data for training
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_2_Main ' num2str(trialNo)]}; 
        disp(['trainingAudio_2_Main ' num2str(trialNo)])
        
    Play_Sound(soundtoplay_trainAudioPast2{1}, 'toBlock');

    WaitSecs(1.500);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 333333333333333333333333333333333333333333333333333333333333333333333333%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save gaze data for training
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_3_Main ' num2str(trialNo)]}; 
        disp(['trainingAudio_3_Main ' num2str(trialNo)])
    
    Play_Sound(soundtoplay_trainAudioFuture3{1}, 'toBlock');
    
    %Save gaze data for training
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_3_Main ' num2str(trialNo)]}; 
        disp(['trainingVideo_3_Main ' num2str(trialNo)])

    PlayCenterMovie(movietoplay_trainV3{1});
    if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
        imageArray = imread(greySquare);
        rect =  parameters.centerbox;
        winPtr = parameters.scr.winPtr;   
        Screen('PutImage', winPtr , imageArray, rect );    
        Screen('flip',winPtr)
        WaitSecs(0.500);
    end
    Show_Blank;
    
    %Save gaze data for training
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_3_Main ' num2str(trialNo)]}; 
        disp(['trainingAudio_3_Main' num2str(trialNo)])

    Play_Sound(soundtoplay_trainAudioPast3{1}, 'toBlock');

    MAIN_ITEMS.trainEnd(trialNo) = GetSecs;
   
    WaitSecs(1.500);
    Show_Blank;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READY FOR THE TEST?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAY THE TEST MOVIE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    MAIN_ITEMS.finalTestStart(trialNo) = GetSecs;
    
    %Save gaze data for test
    GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Main ' num2str(trialNo)]}; 
        disp(['testAudio_Main ' num2str(trialNo)])
        
    Play_Sound(soundtoplay_letsFind{1}, 'toBlock');
    Show_Blank;      

    %Using the human-interpretable side variables...
    %Same structure as bias test
    %Plays: 1 left video, blank screen, 1 right screen, blank screen
    %Then both screens
    
    if MAIN_ITEMS.TestManner(trialNo) == 'L'
        
        %Save gaze data for test
        GazeData = EYETRACKER.get_gaze_data; 
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['left_testVideo_Main ' num2str(trialNo)]}; 
            disp(['left_testVideo_Main ' num2str(trialNo)])
            
        PlaySideMovies(movietoplay_mTest{1},'');
        WaitSecs(0.50);
        Show_Blank;
        
        %Save gaze data for test
        GazeData = EYETRACKER.get_gaze_data; 
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['right_testVideo_Main ' num2str(trialNo)]}; 
            disp(['right_testVideo_Main ' num2str(trialNo)])
            
        PlaySideMovies('',movietoplay_pTest{1});
        WaitSecs(0.50);
        Show_Blank;
        
        %Save gaze data for test audio
        GazeData = EYETRACKER.get_gaze_data; 
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['testAudio_Main ' num2str(trialNo)]}; 
            disp(['testAudio_Main ' num2str(trialNo)])
            
        Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
        
        %Saving gaze data
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Main ' num2str(trialNo)]}; 
        disp(['testVideos_Main ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_mTest{1},movietoplay_pTest{1});
        
    elseif MAIN_ITEMS.TestManner(trialNo) == 'R'
        
        %Save gaze data for test
        GazeData = EYETRACKER.get_gaze_data; 
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['left_testVideo_Main ' num2str(trialNo)]}; 
            disp(['left_testVideo_Main ' num2str(trialNo)])
            
        PlaySideMovies(movietoplay_pTest{1},'');
        Show_Blank;
        
        %Save gaze data for test
        GazeData = EYETRACKER.get_gaze_data; 
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['right_testVideo_Main ' num2str(trialNo)]}; 
            disp(['right_testVideo_Main ' num2str(trialNo)])
            
        PlaySideMovies('',movietoplay_mTest{1});
        Show_Blank;
        
        %Save gaze data for test audio
        GazeData = EYETRACKER.get_gaze_data; 
            timeCell(end+1,:) = {SUBJECT,...
                TOBII.get_system_time_stamp,...
                ['testAudio_Main ' num2str(trialNo)]}; 
            disp(['testAudio_Main ' num2str(trialNo)])
            
        Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
        
        %Save gaze data for test trial
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Main ' num2str(trialNo)]}; 
        disp(['testVideos_Main ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_pTest{1},movietoplay_mTest{1});
    end
    
    WaitSecs(3.00);
    
    GazeData = EYETRACKER.get_gaze_data;
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['End_Trial_Main ' num2str(trialNo)]};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SHOW A NICE REWARD PICTURE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
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





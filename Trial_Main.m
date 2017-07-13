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

        Show_Blank;

        Play_Sound(soundtoplay_ambigAudioFuture{1}, 'toBlock');
    
        PlayCenterMovie(movietoplay_ambigVid{1});
        if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
            imageArray = imread(greySquare);
            rect =  parameters.centerbox;
            winPtr = parameters.scr.winPtr;   
            Screen('PutImage', winPtr , imageArray, rect );    
            Screen('flip',winPtr)
            WaitSecs(0.500);
        end
        PlayCenterMovie(movietoplay_ambigVid{1});
        Show_Blank;

        Play_Sound(soundtoplay_ambigAudioPast{1}, 'toBlock');
        
        Show_Blank; 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BIAS TEST
    % Play the two event movies; movie always plays L then R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Play_Sound(soundtoplay_letsFind{1}, 'toBlock');
    Show_Blank;      
      
    %Using the human-interpretable side variables instead...
    if MAIN_ITEMS.BiasManner(trialNo) == 'L'
        PlaySideMovies(movietoplay_manner{1},'');
        Show_Blank;
        PlaySideMovies('',movietoplay_path{1});
        Show_Blank;
        
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Trial ' num2str(trialNo)]}; 
        disp(['Start Trial: ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_manner{1},movietoplay_path{1});
        
    elseif MAIN_ITEMS.BiasManner(trialNo) == 'R'
        PlaySideMovies(movietoplay_path{1},'');
        Show_Blank;
        PlaySideMovies('',movietoplay_manner{1});
        Show_Blank;
        
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Trial ' num2str(trialNo)]}; 
        disp(['Start Trial: ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_path{1},movietoplay_manner{1});
    end
        
    %And take a response
    Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
    MAIN_ITEMS.biasTestAns{trialNo} = Take_Response();
    
    WaitSecs(5.00);
    
    GazeData = EYETRACKER.get_gaze_data;
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['End_Trial ' num2str(trialNo)]};
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_trial_' num2str(trialNo)]; %description of this timeperiod
    save([DATAFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(GazeData, description);
    
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

    Play_Sound(soundtoplay_trainAudioFuture1{1}, 'toBlock');

    PlayCenterMovie(movietoplay_trainV1{1}); 
    if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
        imageArray = imread(greySquare);
        rect =  parameters.centerbox;
        winPtr = parameters.scr.winPtr;   
        Screen('PutImage', winPtr , imageArray, rect );    
        Screen('flip',winPtr)
        WaitSecs(0.500);
    end
    PlayCenterMovie(movietoplay_trainV1{1});
    Show_Blank;

    Play_Sound(soundtoplay_trainAudioPast1{1}, 'toBlock');

    WaitSecs(1.500);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 2222222222222222222222222222222222222222222222222222222222222222222222222
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Play_Sound(soundtoplay_trainAudioFuture2{1}, 'toBlock');
    
    PlayCenterMovie(movietoplay_trainV2{1});
    if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
        imageArray = imread(greySquare);
        rect =  parameters.centerbox;
        winPtr = parameters.scr.winPtr;   
        Screen('PutImage', winPtr , imageArray, rect );    
        Screen('flip',winPtr)
        WaitSecs(0.500);
    end
    PlayCenterMovie(movietoplay_trainV2{1});
    Show_Blank;

    Play_Sound(soundtoplay_trainAudioPast2{1}, 'toBlock');

    WaitSecs(1.500);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 333333333333333333333333333333333333333333333333333333333333333333333333%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Play_Sound(soundtoplay_trainAudioFuture3{1}, 'toBlock');

    PlayCenterMovie(movietoplay_trainV3{1});
    if strmatch(CONDITION, {'Action', 'Effect'}) %these ones need a mask in between or they look super weird!
        imageArray = imread(greySquare);
        rect =  parameters.centerbox;
        winPtr = parameters.scr.winPtr;   
        Screen('PutImage', winPtr , imageArray, rect );    
        Screen('flip',winPtr)
        WaitSecs(0.500);
    end
    PlayCenterMovie(movietoplay_trainV3{1});
    Show_Blank;

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

    Play_Sound(soundtoplay_letsFind{1}, 'toBlock');
    Show_Blank;      

    %Using the human-interpretable side variables...
    if MAIN_ITEMS.TestManner(trialNo) == 'L'
        PlaySideMovies(movietoplay_mTest{1},'');
        Show_Blank;
        PlaySideMovies('',movietoplay_pTest{1});
        Show_Blank;
        
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Trial ' num2str(trialNo)]}; 
        disp(['Start Trial: ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_mTest{1},movietoplay_pTest{1});
        
    elseif MAIN_ITEMS.TestManner(trialNo) == 'R'
        PlaySideMovies(movietoplay_pTest{1},'');
        Show_Blank;
        PlaySideMovies('',movietoplay_mTest{1});
        Show_Blank;
        
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Trial ' num2str(trialNo)]}; 
        disp(['Start Trial: ' num2str(trialNo)])
        
        PlaySideMovies(movietoplay_pTest{1},movietoplay_mTest{1});
    end
    
     %....and take a response
    Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
    
    WaitSecs(5.00);
    
    GazeData1 = EYETRACKER.get_gaze_data;
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['End_Trial ' num2str(trialNo)]};
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_trial_' num2str(trialNo)]; %description of this timeperiod
    save([DATAFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(GazeData, description);
    
    MAIN_ITEMS.finalTestAns{trialNo} = Take_Response();
    MAIN_ITEMS.finalTestEnd(trialNo) = GetSecs;
    
    %%%%%%%%%%%%%%%%%%%%%%
    % SHOW A NICE REWARD PICTURE
    %%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SHOW ATTENTION-GRAB CENTER
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        Show_Blank;
        PlayCenterMovie(movietoplay_recenter);
        WaitSecs(2.00);
        Show_Blank;

    
%     imageArray=imread(char(starImage));
%     rect = parameters.scr.rect;
%     winPtr = parameters.scr.winPtr;   
%     Screen('PutImage', winPtr , imageArray, rect );    
%     Screen('flip',winPtr)
%     resp1 = Take_Response(); %just moving on...
%     Show_Blank;

    
%     if resp1 == 'q'
%             Closeout_PTool();
%     end
    
    
    
    
end





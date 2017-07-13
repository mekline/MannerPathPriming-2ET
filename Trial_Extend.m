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

        Show_Blank;

        Play_Sound(soundtoplay_ambigAudioFuture{1}, 'toBlock');
    
        PlayCenterMovie(movietoplay_ambigVid{1});
        if strmatch(EXTENDCONDITION, {'Action'}) %need a mask in between or they look super weird!
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
% Play the two event movies separately, then at the same time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Play_Sound(soundtoplay_letsFind{1}, 'toBlock');
    Show_Blank;      
    
    GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Trial ' num2str(trialNo)]}; 
        disp(['Start Trial: ' num2str(trialNo)])
      
    %Using the human-interpretable side variables instead...
    if EXT_ITEMS.BiasManner(trialNo) == 'L'
        PlaySideMovies(movietoplay_manner{1},'');
        Show_Blank;
        PlaySideMovies('',movietoplay_path{1});
        Show_Blank;
        
        PlaySideMovies(movietoplay_manner{1},movietoplay_path{1});
    elseif EXT_ITEMS.BiasManner(trialNo) == 'R'
        PlaySideMovies(movietoplay_path{1},'');
        Show_Blank;
        PlaySideMovies('',movietoplay_manner{1});
        Show_Blank;
        
        PlaySideMovies(movietoplay_path{1},movietoplay_manner{1});
    end
        
    %And take a response
    Play_Sound(soundtoplay_whichOne{1}, 'toBlock');
    EXT_ITEMS.biasTestAns{trialNo} = Take_Response();
    
    WaitSecs(5.00);
    
    GazeData = EYETRACKER.get_gaze_data;
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        ['End_Trial ' num2str(trialNo)]};
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_trial_' num2str(trialNo)]; %description of this timeperiod
    save([DATAFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(GazeData, description);
    
    %Fill in values for the rest of this item...
    EXT_ITEMS.finalTestEnd(trialNo) = GetSecs;
    
    Show_Blank();
   
  
%%%%%%%%%%%%%%%%%%%%%%
% SHOW A NICE REWARD PICTURE
%%%%%%%%%%%%%%%%%%%%%%
%     imageArray=imread(char(starImage));
%     rect = parameters.scr.rect;
%     winPtr = parameters.scr.winPtr;   
%     Screen('PutImage', winPtr , imageArray, rect );    
%     Screen('flip',winPtr)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SHOW ATTENTION-GRAB CENTER
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Show_Blank;
    PlayCenterMovie(movietoplay_recenter);
    WaitSecs(2.00);
    Show_Blank;
    
    
%     if resp1 == 'q'
%             Closeout_PTool();
%     end
    
    
    
    
end





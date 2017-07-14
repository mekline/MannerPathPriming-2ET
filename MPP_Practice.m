function [response] = MPP_Practice()

global parameters RESOURCEFOLDER STARS TOBII EYETRACKER EXPWIN BLACK DATAFOLDER EXPERIMENT SUBJECT timeCell

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        % 4 TRIALS OF NOUN PRACTICE                             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%
    %FIRST PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
    
        %%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO     
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        %START TRIAL
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Trial ' ]}; 
        disp(['Start Trial: ' ])
        
        Show_Blank;
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball1.wav'), 'toBlock');
        Show_Blank;
        
        soundtoplay_letsWatchMore = strcat(RESOURCEFOLDER, '/audio/aa_motivation/letswatchmore.wav');
        movietoplay_practice_1a = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_1a.mp4');
        movietoplay_practice_1b = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_1b.mp4');
        movietoplay_practice_1c = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_1c.mp4');
        movietoplay_practice_1d = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_1d.mp4');
        movietoplay_practice_1e = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_1e.mp4');
        movietoplay_practice_1_distr = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_1_distr.mp4');
        movietoplay_recenter = strcat(RESOURCEFOLDER, '/movies/babylaugh.mov');
        Show_Blank;

        PlayCenterMovie(movietoplay_practice_1a);
        PlayCenterMovie(movietoplay_practice_1a);
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FIRST DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice_1_ball' ]}; 
        disp(['ambigAudio_Practice_1_ball' ])

        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_1_ball' ]}; 
        disp(['ambigVideo_Practice_1_ball' ])
        
        PlayCenterMovie(movietoplay_practice_1b);

        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_1_ball' ]}; 

        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_1_ball' ]}; 
        
        PlayCenterMovie(movietoplay_practice_1c);

        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_3_ball' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3_ball' ]}; 
        disp(['trainingVideo_Practice_3_ball' ])
        
        PlayCenterMovie(movietoplay_practice_1d);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        Show_Blank;
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_ball' ]}; 
        disp(['testAudio_Practice_ball' ])
        
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball2.wav'), 'toBlock');
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice_ball' ]}; 
        disp(['left_testVideo_Practice_ball' ])
        
        PlaySideMovies(movietoplay_practice_1_distr,'','caption_left','');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice_ball' ]}; 
        disp(['right_testVideo_Practice_ball' ])
        
        PlaySideMovies('',movietoplay_practice_1e,'caption_right',''); 
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_ball' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball2.wav'), 'toBlock'); 
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice_ball' ]}; 
        
        PlaySideMovies(movietoplay_practice_1_distr,movietoplay_practice_1e,'caption_left','');
        
        WaitSecs(3.00);
        
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['End_Trial ' ]};

        Show_Blank;
        
        %Save gaze data for attention grab
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' ]}; 
        disp(['recenter ' ])
        
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
   
        
    %%%%%%%%%%%%%%%%%%%%%
    %SECOND PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice_book' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/book1.wav'), 'toBlock');
        Show_Blank;

        movietoplay_practice_2a = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_2a.mp4');
        movietoplay_practice_2b = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_2b.mp4');
        movietoplay_practice_2c = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_2c.mp4');
        movietoplay_practice_2d = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_2d.mp4');
        movietoplay_practice_2e = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_2e.mp4');
        movietoplay_practice_2_distr = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_2_distr.mp4');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_book' ]}; 
        
        PlayCenterMovie(movietoplay_practice_2a);

        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FIRST DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
         %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_1_book' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/book1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_1_book' ]}; 
        
        PlayCenterMovie(movietoplay_practice_2b);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

         %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_2_book' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/book1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_2_book' ]}; 
        
        PlayCenterMovie(movietoplay_practice_2c);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
         %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_3_book' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/book1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3_book' ]}; 
        
        PlayCenterMovie(movietoplay_practice_2d);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        Show_Blank;
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_book' ]}; 
        disp(['testAudio_Practice_book' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/book2.wav'), 'toBlock');
        Show_Blank;
        
         %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice_book' ]}; 
        
        PlaySideMovies(movietoplay_practice_2e,'','caption_left','');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice_book' ]}; 
        PlaySideMovies('',movietoplay_practice_2_distr,'caption_right',''); 
        Show_Blank;
        
        %Save gaze data for test audio
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_book' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/book2.wav'), 'toBlock');    
        
        %Save gaze data for test clips
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice_book' ]}; 
        
        PlaySideMovies(movietoplay_practice_2e, movietoplay_practice_2_distr,'caption_left','');
        
        WaitSecs(3.00);
        %parameters.practice2TestAns = Take_Response();
        Show_Blank;
        
        %Show_Image(strcat(RESOURCEFOLDER, '/', STARS.practice{2}));
        
        %Take_Response();
        
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['End_Trial ' ]};

        Show_Blank;
        
        %Save gaze data for attention grab
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' ]}; 
        disp(['recenter ' ])
        
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

        
    %%%%%%%%%%%%%%%%%%%%%
    %THIRD PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice_1_bear' ]}; 
        disp(['ambigAudio_Practice_1_bear' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/bear1.wav'), 'toBlock');
        Show_Blank;

        movietoplay_practice_3a = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3a.mp4');
        movietoplay_practice_3b = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3b.mp4');
        movietoplay_practice_3c = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3c.mp4');
        movietoplay_practice_3d = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3d.mp4');
        movietoplay_practice_3e = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3e.mp4');
        movietoplay_practice_3_distr = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3_distr.mp4');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_1_bear' ]}; 
        disp(['ambigVideo_Practice_1_bear' ])

        PlayCenterMovie(movietoplay_practice_3a);
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FIRST DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_1_bear' ]}; 
        disp(['trainingAudio_Practice_1_bear' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/bear1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_1_bear' ]}; 
        disp(['trainingVideo_Practice_1_bear' ])
        
        PlayCenterMovie(movietoplay_practice_3b);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_1_bear' ]}; 
        disp(['trainingAudio_Practice_1_bear' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/bear1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_2_bear' ]}; 
        disp(['trainingVideo_Practice_2_bear' ])
    
        PlayCenterMovie(movietoplay_practice_3c);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_3_bear' ]}; 
        disp(['trainingAudioo_Practice_3_bear' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/bear1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3_bear' ]}; 
        disp(['trainingVideo_Practice_3_bear' ])
        
        PlayCenterMovie(movietoplay_practice_3d);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        Show_Blank;
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_bear' ]}; 
        disp(['testAudio_Practice_bear' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/bear2.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice_bear' ]}; 
        disp(['left_testVideo_Practice_bear' ])
        
        PlaySideMovies(movietoplay_practice_3e,'','caption_left','');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice_bear' ]}; 
        
        PlaySideMovies('',movietoplay_practice_3_distr,'caption_right',''); 
        Show_Blank;
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_bear' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/bear2.wav'), 'toBlock');    
        
        %Save gaze data for both video clips
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice_bear' ]}; 
        
        PlaySideMovies(movietoplay_practice_3e,movietoplay_practice_3_distr,'caption_left','');
        
        WaitSecs(3.00);
        
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['End_Trial ' ]};

        Show_Blank;
        
        %Save gaze data for attention grab
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' ]}; 
        disp(['recenter ' ])
        
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
        
        
    %%%%%%%%%%%%%%%%%%%%%
    %FOURTH PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice_car' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/car1.wav'), 'toBlock');
        Show_Blank;

        movietoplay_practice_4a = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_4a.mp4');
        movietoplay_practice_4b = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_4b.mp4');
        movietoplay_practice_4c = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_4c.mp4');
        movietoplay_practice_4d = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_4d.mp4');
        movietoplay_practice_4e = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_4e.mp4');
        movietoplay_practice_4_distr = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_4_distr.mp4');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_car' ]}; 

        PlayCenterMovie(movietoplay_practice_4a);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FIRST DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_1_car' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/car1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_1_car' ]}; 
        
        PlayCenterMovie(movietoplay_practice_4b);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_2_car' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/car1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_2_car' ]}; 
        
        PlayCenterMovie(movietoplay_practice_4c);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_3_car' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/car1.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3_car' ]}; 
        
        PlayCenterMovie(movietoplay_practice_4d);
        
        Show_Blank;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        Show_Blank;
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_car' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/car2.wav'), 'toBlock');
        Show_Blank;
        
        %Save gaze data for left clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice_car' ]}; 
        
        PlaySideMovies(movietoplay_practice_4e,'','caption_left','');
        Show_Blank;
        
        %Save gaze data for right clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice_car' ]}; 
        
        PlaySideMovies('',movietoplay_practice_4_distr,'caption_right',''); 
        Show_Blank;
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_car' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/car2.wav'), 'toBlock');    
        
        
        %Save gaze data for test clips
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice_car' ]}; 
        
        PlaySideMovies(movietoplay_practice_4e,movietoplay_practice_4_distr,'caption_left','');
        
        WaitSecs(3.00);

        
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['End_Trial ' ]};

        Show_Blank;
        
        %Save gaze data for attention grab
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' ]}; 
        disp(['recenter ' ])
        
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

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % END PRACTICE TRAINING                             
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
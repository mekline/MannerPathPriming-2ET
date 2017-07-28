function [response] = MPP_Practice()

global parameters WINDOW_PARAMS RESOURCEFOLDER STARS TOBII EYETRACKER EXPWIN BLACK DATAFOLDER EXPERIMENT SUBJECT timeCell

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
            ['Start_Practice_Trial ' ]}; 
        disp(['Start Trial: ' ])
        
        Show_Blank;
        
        GazeData1 = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        disp(GazeData)
        timeCell(end+1,:) = {SUBJECT,... 
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice ' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball1.wav'), 'toBlock');
        
        timeCell(end+1,:) = {SUBJECT,... 
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice End ' ]}; 
        
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

        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(GazeData, GazeData1);
        
        %save gaze data for video clip
        GazeData1 = EYETRACKER.get_gaze_data; 
        disp(GazeData1)
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice ' ]}; 
        
        PlayCenterMovie(movietoplay_practice_1a, 'ownsound', 1);
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,... 
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice ' ]}; 
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData1);
        disp(C)
        
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
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice_1_ball End' ]};  
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_1_ball' ]}; 
        disp(['ambigVideo_Practice_1_ball' ])
        
        PlayCenterMovie(movietoplay_practice_1b);
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_1_ball End' ]}; 
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_1_ball' ]}; 

        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball1.wav'), 'toBlock');
        
         timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_1_ball' ]}; 
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_1_ball' ]}; 
        
        PlayCenterMovie(movietoplay_practice_1c);
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_1_ball' ]}; 
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_3_ball' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball1.wav'), 'toBlock');
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_3_ball End' ]}; 
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3_ball' ]}; 
        disp(['trainingVideo_Practice_3_ball' ])
        
        PlayCenterMovie(movietoplay_practice_1d);
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3_ball' ]}; 
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
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
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_ball End' ]}; 
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice_ball' ]}; 
        disp(['left_testVideo_Practice_ball' ])
        
        PlaySideMovies(movietoplay_practice_1_distr,'','caption_left','');
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice_ball End' ]}; 
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice_ball' ]}; 
        disp(['right_testVideo_Practice_ball' ])
        
        PlaySideMovies('',movietoplay_practice_1e,'caption_right',''); 
        disp(WINDOW_PARAMS.RIGHTBOX)
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_ball' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/ball2.wav'), 'toBlock'); 
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice_ball' ]}; 
        
        PlaySideMovies(movietoplay_practice_1_distr,movietoplay_practice_1e,'caption_left','');
        
        [x1,y1,z1] = size(movietoplay_practice_1_distr)
        
        WaitSecs(3.00);
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['End_Practice_Trial_1 ' ]};

        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for attention grab
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' ]}; 
        disp(['recenter ' ])
        
        PlayCenterMovie(movietoplay_recenter, 'ownsound', 1);
        Show_Blank; 
        
        [x1,y1,z1] = size(movietoplay_recenter)
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAVE THE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_Practice_1']; %description of this timeperiod
    mkdir([DATAFOLDER]);
    save([DATAFOLDER '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(C, description);
   
        
    %%%%%%%%%%%%%%%%%%%%%
    %SECOND PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
        
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Practice_Trial_2 ' ]};

        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData1 = EYETRACKER.get_gaze_data;
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
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(GazeData, GazeData1);
              
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_book' ]}; 
        
        PlayCenterMovie(movietoplay_practice_2a);
        WaitSecs(0.50);

        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
        
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
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_1_book' ]}; 
        
        PlayCenterMovie(movietoplay_practice_2b);
        WaitSecs(0.50);
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
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
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_2_book' ]}; 
        
        PlayCenterMovie(movietoplay_practice_2c);
        WaitSecs(0.50);
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
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
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3_book' ]}; 
        
        PlayCenterMovie(movietoplay_practice_2d);
        WaitSecs(0.50);
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        Show_Blank;
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_book' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/book2.wav'), 'toBlock');
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
         %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice_book' ]}; 
        
        PlaySideMovies(movietoplay_practice_2e,'','caption_left','');
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice_book' ]}; 
        PlaySideMovies('',movietoplay_practice_2_distr,'caption_right',''); 
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for test audio
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_book' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/book2.wav'), 'toBlock');    
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for test clips
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice_book' ]}; 
        
        PlaySideMovies(movietoplay_practice_2e, movietoplay_practice_2_distr,'caption_left','');
        
        WaitSecs(3.00);
        %parameters.practice2TestAns = Take_Response();
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
        
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['End_Practice_Trial_2 ' ]};

        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for attention grab
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' ]}; 
        disp(['recenter ' ])
        
        PlayCenterMovie(movietoplay_recenter, 'ownsound', 1);
        Show_Blank; 
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAVE THE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_Practice_2']; %description of this timeperiod
    save([DATAFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(C, description);

        
    %%%%%%%%%%%%%%%%%%%%%
    %THIRD PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
    
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Practice_Trial_3 ' ]};

        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData1 = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice_1_cake' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/cake1.wav'), 'toBlock');
        Show_Blank;

        movietoplay_practice_3a = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3a.mp4');
        movietoplay_practice_3b = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3b.mp4');
        movietoplay_practice_3c = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3c.mp4');
        movietoplay_practice_3d = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3d.mp4');
        movietoplay_practice_3e = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3e.mp4');
        movietoplay_practice_3_distr = strcat(RESOURCEFOLDER,'/Movies_Practice/practice_3_distr.mp4');
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(GazeData, GazeData1);

        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_1_cake' ]}; 

        PlayCenterMovie(movietoplay_practice_3a);
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %FIRST DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_1_cake' ]}; 
        disp(['trainingAudio_Practice_1_cake' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/cake1.wav'), 'toBlock');
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_1_cake' ]}; 
        disp(['trainingVideo_Practice_1_cake' ])
        
        PlayCenterMovie(movietoplay_practice_3b);
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %SECOND DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_1_cake' ]}; 
        disp(['trainingAudio_Practice_1_cake' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/cake1.wav'), 'toBlock');
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_2_cake' ]}; 
        disp(['trainingVideo_Practice_2_cake' ])
    
        PlayCenterMovie(movietoplay_practice_3c);
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %THIRD DISAMBIGUATING VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_3_cake' ]}; 
        disp(['trainingAudioo_Practice_3_cake' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/cake1.wav'), 'toBlock');
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3_cake' ]}; 
        disp(['trainingVideo_Practice_3_cake' ])
        
        PlayCenterMovie(movietoplay_practice_3d);
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LEARNING TEST
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        Show_Blank;
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_cake' ]}; 
        disp(['testAudio_Practice_cake' ])
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/cake2.wav'), 'toBlock');
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice_cake' ]}; 
        disp(['left_testVideo_Practice_cake' ])
        
        PlaySideMovies(movietoplay_practice_3e,'','caption_left','');
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice_cake' ]}; 
        
        PlaySideMovies('',movietoplay_practice_3_distr,'caption_right','');
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_cake' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/cake2.wav'), 'toBlock');    
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for both video clips
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice_cake' ]}; 
        
        PlaySideMovies(movietoplay_practice_3e,movietoplay_practice_3_distr,'caption_left','');
        
        WaitSecs(3.00);
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['End__Practice_Trial_3 ' ]};

        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for attention grab
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' ]}; 
        disp(['recenter ' ])
        
        PlayCenterMovie(movietoplay_recenter, 'ownsound', 1);
        Show_Blank; 
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAVE THE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_Practice_3' ]; %description of this timeperiod
    save([DATAFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(C, description);
        
        
    %%%%%%%%%%%%%%%%%%%%%
    %FOURTH PRACTICE TRIAL
    %%%%%%%%%%%%%%%%%%%%%
        
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['Start_Practice_Trial_4 ' ]};

        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %INITIAL AMBIGUOUS VIDEO
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save gaze data for audio clip
        GazeData1 = EYETRACKER.get_gaze_data;
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
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(GazeData, GazeData1);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_car' ]}; 

        PlayCenterMovie(movietoplay_practice_4a);
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
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
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_1_car' ]}; 
        
        PlayCenterMovie(movietoplay_practice_4b);
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
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
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_2_car' ]}; 
        
        PlayCenterMovie(movietoplay_practice_4c);
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
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
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3_car' ]}; 
        
        PlayCenterMovie(movietoplay_practice_4d);
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
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
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for left clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice_car' ]}; 
        
        PlaySideMovies(movietoplay_practice_4e,'','caption_left','');
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for right clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice_car' ]}; 
        
        PlaySideMovies('',movietoplay_practice_4_distr,'caption_right',''); 
        WaitSecs(0.50);
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for audio clip
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice_car' ]}; 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/car2.wav'), 'toBlock');    
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for test clips
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice_car' ]}; 
        
        PlaySideMovies(movietoplay_practice_4e,movietoplay_practice_4_distr,'caption_left','');
        
        WaitSecs(3.00);

        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['End_Practice_Trial_4 ' ]};

        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);

        %Save gaze data for attention grab
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' ]}; 
        
        PlayCenterMovie(movietoplay_recenter, 'ownsound', 1);
        Show_Blank; 
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAVE THE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_Practice_4']; %description of this timeperiod
    save([DATAFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(C, description);

    %saving timestamps
    timeTable = cell2table(timeCell(2:end,:));
    timeTable.Properties.VariableNames = timeCell(1,:);
    %And save the file!
    filename = [DATAFOLDER, '/timestamps_' EXPERIMENT '_' SUBJECT '.csv'];
    writetable(timeTable, filename);
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % END PRACTICE TRAINING                             
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
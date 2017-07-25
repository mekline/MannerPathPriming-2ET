function [response] = MPP_Practice(trialNo)

global PRACTICE_ITEMS parameters WINDOW_PARAMS SUBJFOLDER RESOURCEFOLDER STARS TOBII EYETRACKER EXPWIN BLACK SUBJFOLDER EXPERIMENT SUBJECT timeCell

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        % 4 TRIALS OF NOUN PRACTICE                             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    movietoplay_practice_1a = strcat(RESOURCEFOLDER,'/Movies_Practice/', PRACTICE_ITEMS.ambigV(trialNo));
    movietoplay_practice_1b = strcat(RESOURCEFOLDER,'/Movies_Practice/', PRACTICE_ITEMS.trainV1(trialNo));
    movietoplay_practice_1c = strcat(RESOURCEFOLDER,'/Movies_Practice/', PRACTICE_ITEMS.trainV2(trialNo));
    movietoplay_practice_1d = strcat(RESOURCEFOLDER,'/Movies_Practice/', PRACTICE_ITEMS.trainV3trialNo));
    movietoplay_practice_1e = strcat(RESOURCEFOLDER,'/Movies_Practice/', PRACTICE_ITEMS.mTestV(trialNo));
    movietoplay_practice_1_distr = strcat(RESOURCEFOLDER,'/Movies_Practice/', PRACTICE_ITEMS.pTestV(trialNo));
    movietoplay_recenter = strcat(RESOURCEFOLDER, '/movies/babylaugh.mov');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUDIO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    soundtoplay_audio1 = strcat(RESOURCEFOLDER, '/audio/aa_motivation/', PRACTICE_ITEMS.audio1(trialNo));
    soundtoplay_audio2 = strcat(RESOURCEFOLDER, '/audio/aa_motivation', PRACTICE_ITEMS.audio2(trialNo));

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
            ['Start_Practice_Trial ' num2str(trialNo) ]}; 
        
        Show_Blank;
        
        GazeData1 = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        disp(GazeData)
        timeCell(end+1,:) = {SUBJECT,... 
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice ' num2str(trialNo) ]}; 
        
        Play_Sound(soundtoplay_audio1{1}, 'toBlock');
        
        timeCell(end+1,:) = {SUBJECT,... 
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice End ' num2str(trialNo) ]}; 
  
     
        Show_Blank;

        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(GazeData, GazeData1);
        
        %save gaze data for video clip
        GazeData1 = EYETRACKER.get_gaze_data; 
        disp(GazeData1)
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice ' num2str(trialNo) ]}; 
        
        PlayCenterMovie(movietoplay_practice_1a, 'ownsound', 1);
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,... 
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice End ' num2str(trialNo) ]}; 
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
            ['ambigAudio_Practice_1 ' num2str(trialNo) ]}; 
        
        Play_Sound(soundtoplay_audio1{1}, 'toBlock');
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigAudio_Practice_1 End ' num2str(trialNo) ]};  
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_1 ' num2str(trialNo) ]}; 
        
        PlayCenterMovie(movietoplay_practice_1b);
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['ambigVideo_Practice_1 End ' num2str(trialNo) ]}; 
        
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
            ['trainingAudio_Practice_2 ' num2str(trialNo)]}; 

        Play_Sound(soundtoplay_audio1{1}, 'toBlock');
        
         timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_2 End ' num2str(trialNo)]}; 
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_2 ' num2str(trialNo) ]}; 
        
        PlayCenterMovie(movietoplay_practice_1c);
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_2 End ' num2str(trialNo) ]}; 
        
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
            ['trainingAudio_Practice_3 ' num2str(trialNo)]}; 
        
        Play_Sound(soundtoplay_audio1{1}, 'toBlock');
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingAudio_Practice_3 End ' num2str(trialNo) ]}; 
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for ambiguous video
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3 ' num2str(trialNo) ]}; 
        
        PlayCenterMovie(movietoplay_practice_1d);
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['trainingVideo_Practice_3 End ' num2str(trialNo) ]}; 
        
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
            ['testAudio_Practice ' num2str(trialNo) ]};  
        
        Play_Sound(soundtoplay_audio2{1}, 'toBlock');
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice End ' num2str(trialNo)]}; 
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice ' num2str(trialNo)]}; 
        
        PlaySideMovies(movietoplay_practice_1_distr,'','caption_left','');
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['left_testVideo_Practice End ' num2str(trialNo) ]}; 
        
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice 'num2str(trialNo) ]}; 
        
        PlaySideMovies('',movietoplay_practice_1e,'caption_right',''); 
        WaitSecs(0.50);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['right_testVideo_Practice End ' num2str(trialNo) ]}; 
        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice ' num2str(trialNo) ]}; 
        
        Play_Sound(soundtoplay_audio2{1}, 'toBlock'); 
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testAudio_Practice End ' num2str(trialNo) ]}; 
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for video clip
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice ' num2str(trialNo) ]}; 
        
        PlaySideMovies(movietoplay_practice_1_distr,movietoplay_practice_1e,'caption_left','');
        
        WaitSecs(3.00);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['testVideos_Practice End ' num2str(trialNo) ]}; 
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        GazeData = EYETRACKER.get_gaze_data;
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['End_Practice_Trial ' num2str(trialNo) ]};

        Show_Blank;
        
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
        %Save gaze data for attention grab
        GazeData = EYETRACKER.get_gaze_data; 
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter ' ]}; 
        
        PlayCenterMovie(movietoplay_recenter, 'ownsound', 1);
        
        timeCell(end+1,:) = {SUBJECT,...
            TOBII.get_system_time_stamp,...
            ['recenter End' ]}; 
        Show_Blank; 
         
        %Concatenate arrays to save gaze data in all one big file
        C = horzcat(C, GazeData);
              
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAVE THE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_Practice_' num2str(trialNo)]; %description of this timeperiod
    mkdir([SUBJFOLDER]);
    save([SUBJFOLDER '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(C, description);
   
        
    
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAVE THE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save trial data as MAT, and add to the big CSV
    description = ['All_of_Practice_4']; %description of this timeperiod
    save([SUBJFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
    SaveGazeData(C, description);

    %saving timestamps
    timeTable = cell2table(timeCell(2:end,:));
    timeTable.Properties.VariableNames = timeCell(1,:);
    %And save the file!
    filename = [SUBJFOLDER, '/timestamps_' EXPERIMENT '_' SUBJECT '.csv'];
    writetable(timeTable, filename);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % END PRACTICE TRAINING                             
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
function [response] = Trial_Omnibus(trialNo, version)
%Play 1 trial of the MannerPath experiment.
%To reduce code and other nonsense, we are now accepting a version,
%, must be 'NoBias', 'WithBias', or 'BiasOnly' (aka Extend), and
% we promise to play the parts that are relevant for that version!
%Trial structure is sort of complex; it has 3 phases:
% Bias test - show M1P1 movie; take a forced choice response between M1P2
% and M2P1
% Training - Depending on the condition, show either MnP1 or M1Pn movies
% Final test - take a forced choice response between M1P2 and M2P1 again

    global MAIN_ITEMS CONDITION RESOURCEFOLDER EYETRACKER USE_EYETRACKER DATAFOLDER EXPERIMENT SUBJECT timeCell

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LOAD MOVIE FILENAMES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Trial movies
    movie_ambig = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.ambigV(trialNo));
    movie_path_Bias = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.pBiasV(trialNo));    
    movie_manner_Bias = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.mBiasV(trialNo));
    movie_trainV1 = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.trainV1(trialNo));
    movie_trainV2 = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.trainV2(trialNo));
    movie_trainV3 = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.trainV3(trialNo));
    movie_manner_Test = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.mTestV(trialNo));
    movie_path_Test = strcat(RESOURCEFOLDER, '/movies/', MAIN_ITEMS.pTestV(trialNo));
    movie_recenter = strcat(RESOURCEFOLDER, '/movies/babylaugh.mov');

    if strcmp(CONDITION,'Manner')
        movie_negative = movie_path_Bias;
    elseif strcmp(CONDITION,'Path')
        movie_negative = movie_manner_Bias;
    else
        print('couldnt assign a negative example');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LOAD AUDIO FILENAMES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    sound_ambigFuture = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.ambigAudioFuture(trialNo));
    sound_ambigPast = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.ambigAudioPast(trialNo));
    sound_trainFuture1 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioFuture1(trialNo));
    sound_trainPast1 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioPast1(trialNo));
    sound_trainFuture2 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioFuture2(trialNo));
    sound_trainPast2 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioPast2(trialNo));
    sound_trainFuture3 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioFuture3(trialNo));
    sound_trainPast3 = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.trainAudioPast3(trialNo));
    sound_negativeFuture = 'TO FILL';
    sound_negativePast = 'TO FILL';
    sound_whichOne = strcat(RESOURCEFOLDER, '/audio/', MAIN_ITEMS.whichOneAudio(trialNo));
    sound_letsFind = strcat(RESOURCEFOLDER, '/audio/aa_lets_find/', MAIN_ITEMS.letsFindAudio(trialNo));
    
    sound_prompt1 = 'ToFILL';
    sound_prompt2 = 'ToFILL';
    sound_prompt3 = 'ToFILL';
    
    %these ones are the same every time
    sound_lookDifferent = 'TO FILL';
    sound_look1 = 'TO FILL';
    sound_look2 = 'TO FILL';
    sound_letsWatchMore = strcat(RESOURCEFOLDER, '/audio/aa_motivation/letswatchmore.wav');
    sound_getReady = strcat(RESOURCEFOLDER, '/audio/aa_motivation/getready.wav');
    sound_goodJob = strcat(RESOURCEFOLDER, '/audio/aa_motivation/goodjob.wav');
    sound_nowLetsSee = strcat(RESOURCEFOLDER, '/audio/aa_motivation/nowletssee.wav');
    sound_wow = strcat(RESOURCEFOLDER, '/audio/aa_motivation/wow.wav');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SHOW RE-ORIENTING MOVIE (and do intitalization of GazeData so it
    % never gets skipped)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if USE_EYETRACKER
        GazeData = EYETRACKER.get_gaze_data; %dummy call to make sure we clear & collect new data
    end

    PlayCenterMovie(movie_recenter, 'ownsound', 1 ,'border', 1);
    Show_Blank;
    
    if USE_EYETRACKER
        GazeData1 = EYETRACKER.get_gaze_data; 
        C = horzcat(GazeData, GazeData1); %Concatenate to save gaze data in all one big file
    end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % AMBIGUOUS INITIAL VIDEO (All versions)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if USE_EYETRACKER
        GazeData = EYETRACKER.get_gaze_data; 
        C = horzcat(C, GazeData);
    end

    timeCell(end+1,:) = timeStamp([num2str(trialNo) '_StartTrial']); 
    Show_Blank;

    timeCell(end+1,:) = timeStamp([num2str(trialNo) '_Start_ambigAudio_Future']);         
    Play_Sound(sound_ambigFuture{1}, 'toBlock');

    timeCell(end+1,:) = timeStamp([num2str(trialNo) '_Start_ambigVideo' ]); 
    PlayCenterMovie(movie_ambig{1},'border', 1);
    WaitSecs(0.50); %This leaves the final frame onscreen


    timeCell(end+1,:) = timeStamp([num2str(trialNo) '_Start_ambigAudio_Past']);          
    Play_Sound(sound_ambigPast{1}, 'toBlock');
    Show_Blank; 

    %Grab gaze data to prevent buffer overflow, add it to the current trial
    %data object

    if USE_EYETRACKER
        GazeData = EYETRACKER.get_gaze_data; 
        C = horzcat(C, GazeData);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BIAS TEST ('WithBias', 'BiasOnly' versions)
    % Play the two event movies; movie always plays L then R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(version, 'WithBias') || strcmp(version, 'BiasOnly')
        
        timeCell(end+1,:) = timeStamp([num2str(trialNo) '_Start_lookDifferent']); 
        Text_Show('Look, now theyre different');
        %Play_Sound(sound_lookDifferent{1}, 'toBlock');
        
        Show_Blank;      

        %Using the human-interpretable side variables instead...
        %Plays: 1 video on the left, blank, 1 video on the right, blank
        %Then both videos

        if MAIN_ITEMS.BiasManner(trialNo) == 'L'

            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Bias_leftVideo']); 
            %Play_Sound(sound_look1{1});
            Text_Show('Look at That!');
            WaitSecs(0.50);
            PlaySideMovies(movie_manner_Bias{1},'','border', 1);
            WaitSecs(0.50);
            Show_Blank;

            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Bias_rightVideo']); 
            %Play_Sound(sound_look2{1});
            Text_Show('Look at That!');
            WaitSecs(0.50);
            PlaySideMovies('',movie_path_Bias{1},'border', 1);
            WaitSecs(0.50);
            Show_Blank;

            %Play_Sound(sound_prompt1{1});
            Text_Show('Wow, do you see Verbing?');
            WaitSecs(0.50);
            
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Bias_compareVideo_1']); 
            PlaySideMovies(movie_manner_Bias{1},movie_path_Bias{1},'border', 1);
            WaitSecs(3);
            Show_Blank;
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_End_Bias_compareVideo_1']); 
            
            %Play_Sound(sound_prompt2{1}, 'toBlock');
            Text_Show('Lets find Verbing!');
            WaitSecs(0.5);
            
            %Play_Sound(sound_prompt3{1});
            Text_Show('Wheres verbing look at verbing?');
            WaitSecs(0.50);
            
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Bias_compareVideo_2']); 
            PlaySideMovies(movie_manner_Bias{1},movie_path_Bias{1},'border', 1);
            WaitSecs(3);
            Show_Blank;
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_End_Bias_compareVideo_2']); 

        elseif MAIN_ITEMS.BiasManner(trialNo) == 'R'

            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Bias_leftVideo']); 
            %Play_Sound(sound_look1{1});
            Text_Show('Look at That!');
            WaitSecs(0.50);
            PlaySideMovies(movie_path_Bias{1},'','border', 1);
            WaitSecs(0.50);
            Show_Blank;

            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Bias_rightVideo']); 
            %Play_Sound(sound_look2{1});
            Text_Show('Look at That!');
            WaitSecs(0.50);
            PlaySideMovies('',movie_manner_Bias{1},'border', 1);
            WaitSecs(0.50);
            Show_Blank;

            %Play_Sound(sound_prompt1{1});
            Text_Show('Wow, do you see Verbing?');
            WaitSecs(0.50);
            
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Bias_compareVideo_1']); 
            PlaySideMovies(movie_path_Bias{1},movie_manner_Bias{1},'border', 1);
            WaitSecs(3);
            Show_Blank;
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_End_Bias_compareVideo_1']); 
            
            %Play_Sound(sound_prompt2{1}, 'toBlock');
            Text_Show('Lets find Verbing!');
            WaitSecs(0.5);
            
            %Play_Sound(sound_prompt3{1});
            Text_Show('Wheres verbing look at verbing?');
            WaitSecs(0.50);
            
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Bias_compareVideo_2']); 
            PlaySideMovies(movie_path_Bias{1},movie_manner_Bias{1},'border', 1);
            WaitSecs(3);
            Show_Blank;
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_End_Bias_compareVideo_2']); 

        end

        Show_Blank();

        %Grab gaze data to prevent buffer overflow
        if USE_EYETRACKER
            GazeData = EYETRACKER.get_gaze_data; 
            C = horzcat(C, GazeData);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PLAY TRAINING VIDEOS (Internal logic about whether to include
    % negative trial...)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~strcmp(version, 'BiasOnly')
        
        %Make array of stuff to show 
        T = table({sound_trainFuture1; sound_negativeFuture; sound_trainFuture2; sound_trainFuture3;},...
            {movie_trainV1; movie_negative; movie_trainV2; movie_trainV3},...
            {sound_trainPast1; sound_negativePast; sound_trainPast2; sound_trainPast3;},...
            'VariableNames',{'Future','Movie','Past'});

        for i=1:4
            if (i == 2) && ~strcmp(version, 'NoBias') %Skip the negative example unless this is a NoBias trial
                continue;
            end

            timeCell(end+1,:) = timeStamp(['trainingAudio_Main_' num2str(i), '_', num2str(trialNo)]);      
            Play_Sound(T.Future{i}{1}, 'toBlock'); %NOTE the curly brace nonsense for extracting strings, that's annoying

            timeCell(end+1,:) = timeStamp(['trainingVideo_Main_' num2str(i), '_', num2str(trialNo)]); 
            PlayCenterMovie(T.Movie{i}{1},'border', 1); 
            WaitSecs(0.50);
            Show_Blank;

            timeCell(end+1,:) = timeStamp(['trainingAudio_Main_' num2str(i), '_', num2str(trialNo)]);      
            Play_Sound(T.Past{i}{1}, 'toBlock');

            %Grab gaze data to prevent buffer overflow
            if USE_EYETRACKER
                GazeData = EYETRACKER.get_gaze_data; 
                C = horzcat(C, GazeData);
            end    

            WaitSecs(0.5);
        end
    end

   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PLAY THE TEST MOVIE (SAME-VERB TEST)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~strcmp(version, 'BiasOnly')

        timeCell(end+1,:) = timeStamp(['testAudio_Main ' num2str(trialNo)]);       
        Play_Sound(sound_letsFind{1}, 'toBlock');
        Show_Blank;      


        %Using the human-interpretable side variables...
        %Same structure as bias test
        %Plays: 1 left video, blank screen, 1 right screen, blank screen
        %Then both screens

        if MAIN_ITEMS.TestManner(trialNo) == 'L'
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Test_leftVideo']); 
            %Play_Sound(sound_look1{1});
            Text_Show('Look at That!');
            WaitSecs(0.50);
            PlaySideMovies(movie_manner_Test{1},'','border', 1);
            WaitSecs(0.50);
            Show_Blank;

            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Test_rightVideo']); 
            %Play_Sound(sound_look2{1});
            Text_Show('Look at That!');
            WaitSecs(0.50);
            PlaySideMovies('',movie_path_Test{1},'border', 1);
            WaitSecs(0.50);
            Show_Blank;

            %Play_Sound(sound_prompt1{1});
            Text_Show('Wow, do you see Verbing?');
            WaitSecs(0.50);
            
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Test_compareVideo_1']); 
            PlaySideMovies(movie_manner_Test{1},movie_path_Test{1},'border', 1);
            WaitSecs(3);
            Show_Blank;
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_End_Test_compareVideo_1']); 
            
            %Play_Sound(sound_prompt2{1}, 'toBlock');
            Text_Show('Lets find Verbing!');
            WaitSecs(0.5);
            
            %Play_Sound(sound_prompt2{1});
            Text_Show('Wheres verbing look at verbing?');
            WaitSecs(0.50);
            
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Test_compareVideo_2']); 
            PlaySideMovies(movie_manner_Test{1},movie_path_Test{1},'border', 1);
            WaitSecs(3);
            Show_Blank;
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_End_Test_compareVideo_2']); 


        elseif MAIN_ITEMS.TestManner(trialNo) == 'R'
            
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Test_leftVideo']); 
            %Play_Sound(sound_look1{1});
            Text_Show('Look at That!');
            WaitSecs(0.50);
            PlaySideMovies(movie_path_Test{1},'','border', 1);
            WaitSecs(0.50);
            Show_Blank;

            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Test_rightVideo']); 
            %Play_Sound(sound_look2{1});
            Text_Show('Look at That!');
            WaitSecs(0.50);
            PlaySideMovies('',movie_manner_Test{1},'border', 1);
            WaitSecs(0.50);
            Show_Blank;

            %Play_Sound(sound_prompt1{1});
            Text_Show('Wow, do you see Verbing?');
            WaitSecs(0.50);
            
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Test_compareVideo_1']); 
            PlaySideMovies(movie_path_Test{1},movie_manner_Test{1},'border', 1);
            WaitSecs(3);
            Show_Blank;
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_End_Test_compareVideo_1']); 
            
            %Play_Sound(sound_prompt2{1}, 'toBlock');
            Text_Show('Lets find Verbing!');
            WaitSecs(0.5);
            
            %Play_Sound(sound_prompt3{1});
            Text_Show('Wheres verbing look at verbing?');
            WaitSecs(0.50);
            
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_Start_Test_compareVideo_2']); 
            PlaySideMovies(movie_path_Test{1},movie_manner_Test{1},'border', 1);
            WaitSecs(3);
            Show_Blank;
            timeCell(end+1,:) = timeStamp([ num2str(trialNo) '_End_Test_compareVideo_2']); 

        end
        Show_Blank();

        %Grab gaze data for the final time!
        if USE_EYETRACKER
            GazeData = EYETRACKER.get_gaze_data; 
            C = horzcat(C, GazeData);
        end
    end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SAVE THE DATA
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Save gaze trial data as MAT, and add to the big CSV
    description = ['All_of_Main_trial_' num2str(trialNo)]; %description of this timeperiod
    
    if USE_EYETRACKER
        save([DATAFOLDER, '/gaze_' EXPERIMENT '_' SUBJECT '_' description '.mat'], 'GazeData');
        SaveGazeData(C, description);
    end
    
    %saving timestamps
    timeTable = cell2table(timeCell(2:end,:));
    timeTable.Properties.VariableNames = timeCell(1,:);
    %And save the file!
    filename = [DATAFOLDER, '/timestamps_' EXPERIMENT '_' SUBJECT '.csv'];
    writetable(timeTable, filename);
    
end





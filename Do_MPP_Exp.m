
function Do_MPP_Exp()

%We are adapting MPP to the eyetracker, very exciting!
global EXPWIN RESOURCEFOLDER

%MPP specific objects
global expStart expTime CONDITION TOEXTEND EXTENDCONDITION 
global MAIN_ITEMS EXT_ITEMS EXTENDPRACTICE ntrials 
global TOBII EYETRACKER EXPWIN BLACK DATAFOLDER EXPERIMENT 
global SUBJECT timeCell

%Some numeric versions of condition names for indexing into tables...

switch CONDITION
    case 'Manner'
        conditionno = 1;
    case 'Path'
        conditionno = 3;
    case 'Action'
        conditionno = 6;
    case 'Effect'
        conditionno = 5; %(yes #s reversed between domains for now)
end

switch TOEXTEND
    case 'NoExtend'
        toExtend = 0;
    otherwise
        toExtend = 1;
end

switch EXTENDPRACTICE
    case 'NoPractice'
        ExtendPractice = 0;
    otherwise
        ExtendPractice = 1;
end

try
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%
    %READ IN AND RANDOMIZE ALL FILES FOR THE EXPERIMENT!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    vidInfo = readtable('MPP_videos.csv');
    MAIN_ITEMS = vidInfo(vidInfo.List == conditionno,:);
    if toExtend %Assign the other-domain set! Since we don't do any learning, arbitrarily get Manner or Action
        if(conditionno == 1 || conditionno == 3) %Start with MannerPath, move to Action
            EXTENDCONDITION = 'Action';
            EXT_ITEMS = vidInfo(vidInfo.List == 6,:);
        elseif (conditionno == 5 || conditionno == 6) %Start with ActionEffect, move to Manner
            EXTENDCONDITION = 'Manner';
            EXT_ITEMS = vidInfo(vidInfo.List == 1,:);
        end
    end
    
    %Randomize the order of the items
    MAIN_ITEMS = MAIN_ITEMS(randperm(height(MAIN_ITEMS)), :);
    if toExtend
        EXT_ITEMS = EXT_ITEMS(randperm(height(EXT_ITEMS)), :);
    end
    
    
    
    %Randomize the side presentation of the items
    %(Counterbalancing note: left video always plays first, assignment is
    %to play either the M or P video first.  Remember that we use
    %manner/path as the example case, you might be showing action/effect
    %really...
    
    %verbose code for readable output!
   
    screenside = ['LR';'LR';'LR';'LR';'RL';'RL';'RL';'RL'];
    
    screenside = screenside(randperm(8),:);
    MAIN_ITEMS.BiasManner = screenside(:,1);
    MAIN_ITEMS.BiasPath = screenside(:,2);
    
    screenside = screenside(randperm(8),:);
    MAIN_ITEMS.TestManner = screenside(:,1);
    MAIN_ITEMS.TestPath = screenside(:,2);
    
    if toExtend
        screenside = screenside(randperm(8),:);
        EXT_ITEMS.BiasManner = screenside(:,1);
        EXT_ITEMS.BiasPath = screenside(:,2);
        
        screenside = screenside(randperm(8),:);
        EXT_ITEMS.TestManner = screenside(:,1);
        EXT_ITEMS.TestPath = screenside(:,2);
    end
    
    %%%%%%%%%%%%%%%%%%%%%
    % EXPERIMENT STARTS HERE
    %%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Save a header file to the data file so it will be easier to read!
   % WriteToDataFile({'header','asdf','putcolumnnameshere', 12}); %use curly braces, ANYthing could be in there!
    
    WriteToDataFile({'SubjectNo',...
        'Date',...
        'Time',...
        'VerbDomain',...
        'Condition',...
        'trialNo',...
        'itemID',...
        'verbName',...
        'verbMeaning',...
        'mannerSideBias',...
        'pathSideBias',...
        'mannerSideTest',...
        'pathSideTest',...
        'totalTime',...
        'xxxxxxxxx',...
        'expStartTime',...
        'trainingStartTime',...
        'trainingEndTime',...
        'finalTestStart',...
        'finalTestEnd',...
        'ambigVid',...
        'mBiasVid',...
        'pBiasVid',...
        'trainVid1',...
        'trainVid2',...
        'trainVid3',...
        'mTestVid',...
        'pTestVid',...
        'ambigAudioFuture',...
        'ambigAudioPast',...
        'trainAudioFuture1',...
        'trainAudioPast1',...
        'trainAudioFuture2',...
        'trainAudioPast2',...
        'trainAudioFuture3',...
        'trainAudioPast3',...
        'whichOneAudio',...
        'letsFindAudio'});
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    expStart = GetSecs;
    disp(expStart);
    
    timeCell = {'subjectID', 'system_time_stamp', 'point_description'};
    timeCell(end+1,:) = {SUBJECT,...
        TOBII.get_system_time_stamp,...
        'Experiment Start'};

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 4 TRIALS OF PRACTICE TRAINING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

    MPP_Practice();
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 4 TRIALS OF NO-BIAS TEST LEARNING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    %How many trials?
    ntrials = height(MAIN_ITEMS); %For the skeleton, play some short sample trials!
    
    Text_Show('Ready? Press space to watch the movies.');
    Take_Response();
%     
%     %And actually play the trials! Data is saved on each round to allow for
%     %partial data collection
    for i = 1:ntrials/2;
        disp(i)
        Trial_NoBias(i)
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % Write result file
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        expTrial = GetSecs;
        expTime = expTrial - expStart;
        
        Write_Trial_to_File(i, MAIN_ITEMS);

    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % N TRIALS OF WITHIN-FIELD PRIMING/VERB LEARNING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Text_Show('Ready? Press space to watch the movies.');
    Take_Response();
    
    %And actually play the trials! Data is saved on each round to allow for
    %partial data collection
    for i=5:ntrials
        Trial_Main(i)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Write result file
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        expTrial = GetSecs;
        expTime = expTrial - expStart;
        
        Write_Trial_to_File(i, MAIN_ITEMS);

    end
    
    %And do the same for the Extension trials, if we're doing that!
    for i=(ntrials+1):(2*ntrials)
        Trial_Extend(i);
        expTrial = GetSecs;
        expTime = expTrial - expStart;
        Write_Trial_to_File(i, EXT_ITEMS);
    end
    
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Cleanup & Shutdown
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Closeout_PTool();
        

catch 
    Closeout_PTool();
    psychrethrow(psychlasterror);
    
end

end

     
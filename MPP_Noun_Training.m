function [response] = MPP_Noun_Training()

global RESOURCEFOLDER STARS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        % 2 TRIALS OF NOUN TRAINING                             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%
        %FIRST NOUN TRAINING     
        %%%%%%%%%%%%%%%%%%%%%%
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/bone1.wav'), 'toBlock');
        Show_Blank;

        movietoplay_noun_2a = strcat(RESOURCEFOLDER, '/movies/2_noun_2a.mov');
        movietoplay_noun_2b = strcat(RESOURCEFOLDER, '/movies/2_noun_2b.mov');    
        movietoplay_noun_2_distr = strcat(RESOURCEFOLDER, '/movies/2_noun_2_distractor.mov');
        
        Show_Blank;

        PlayCenterMovie(movietoplay_noun_2a);

        Show_Blank;
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/bone2.wav'), 'toBlock');
        Show_Blank;
        
        PlaySideMovies(movietoplay_noun_2_distr,'');
        PlaySideMovies('',movietoplay_noun_2b); 
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/bone3.wav'), 'toBlock'); 
        
        parameters.noun1TestAns = Take_Response();
       
        Show_Blank;

        Show_Image(strcat(RESOURCEFOLDER, '/', STARS.noun{2}));
        
        Take_Response(); %spacebar to go on
        Show_Blank; 
        
        %%%%%%%%%%%%%%%%%%%%%%
        %SECOND NOUN TRAINING     
        %%%%%%%%%%%%%%%%%%%%%%  
        
        Play_Sound(strcat(RESOURCEFOLDER, '/audio/aa_nouns/glorfin1.wav'), 'toBlock');
        Show_Blank;

        movietoplay_distractor = strcat(RESOURCEFOLDER, '/movies/1_noun_1_distractor.mov');
        movietoplay_target = strcat(RESOURCEFOLDER, '/movies/1_noun_1b.mov');    
        movietoplay_sign = strcat(RESOURCEFOLDER, '/movies/1_noun_1a.mov');

        PlayCenterMovie(movietoplay_sign);
        Show_Blank;
        
        Play_Sound((strcat(RESOURCEFOLDER, 'audio/aa_nouns/glorfin2.wav')), 'toBlock');
        Show_Blank;

        PlaySideMovies(movietoplay_target,'','caption_left','WOWOWOWOW');
        PlaySideMovies('',movietoplay_distractor,'caption_right','WOWOW'); 

        Play_Sound('audio/aa_nouns/glorfin3.wav', 'toBlock');    
        
        parameters.noun2TestAns = Take_Response();
        
        Show_Blank;

        Show_Image(strcat(RESOURCEFOLDER, '/', STARS.noun{2}));
        
        Take_Response(); %spacebar to go on
        
        Show_Blank;   

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % END NOUN TRAINING                             
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
function Write_Trial_to_File(i,Items)
%Wraps up the writing of this specific experiment's info!
%
%i = OVERALL trialno (not counting warmups)
%Settings to write header, main items, and ext items

if i==0 %Header!
    WriteResultFile({'SubjectNo',...
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
        'kidResponseBias',...
        'mannerSideTest',...
        'pathSideTest',...
        'kidResponseTest',...
        'noun1Test',...
        'noun2Test',...
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
elseif i <=parameters.ntrials %It's a main item'
    WriteResultFile({parameters.subNo,...
                datestr(now,'dd-mmm-yyyy'),...
                datestr(now,'HH:MM:SS.FFF'),...
                Items.VerbDomain(i),...
                parameters.condition,...
                i,...
                Items.itemID(i),...
                Items.verbName(i),...
                Items.verbMeaning(i),...
                Items.BiasManner(i),...
                Items.BiasPath(i),...
                Items.biasTestAns(i),...
                Items.TestManner(i),...
                Items.TestPath(i),...
                Items.finalTestAns(i),...
                parameters.noun1TestAns,...
                parameters.noun2TestAns,...
                parameters.totalTime,...
                'xxxx',... %Marks a point after which the rest of the recorded values are not interesting for main analysis, but might be for humans
                parameters.expStart,...
                Items.trainStart(i),...
                Items.trainEnd(i),...
                Items.finalTestStart(i),...
                Items.finalTestEnd(i),...
                Items.ambigV(i),...
                Items.mBiasV(i),...
                Items.pBiasV(i),...
                Items.trainV1(i),...
                Items.trainV2(i),...
                Items.trainV3(i),...
                Items.mTestV(i),...
                Items.pTestV(i),...
                Items.ambigAudioFuture(i),...
                Items.ambigAudioPast(i),...
                Items.trainAudioFuture1(i),...
                Items.trainAudioPast1(i),...
                Items.trainAudioFuture2(i),...
                Items.trainAudioPast2(i),...
                Items.trainAudioFuture3(i),...
                Items.trainAudioPast3(i),...
                Items.whichOneAudio(i),...
                Items.letsFindAudio(i)});
            
else %It's an ext item!!
    j = i-parameters.ntrials;
    WriteResultFile({parameters.subNo,...
                datestr(now,'dd-mmm-yyyy'),...
                datestr(now,'HH:MM:SS.FFF'),...
                Items.VerbDomain(j),...
                parameters.condition,...
                i,...
                Items.itemID(j),...
                Items.verbName(j),...
                Items.verbMeaning(j),...
                Items.BiasManner(j),...
                Items.BiasPath(j),...
                Items.biasTestAns(j),...
                'NA',... %no test phase during extension!
                'NA',...
                'NA',...
                parameters.noun1TestAns,...
                parameters.noun2TestAns,...
                parameters.totalTime,...
                'xxxx',... %Marks a point after which the rest of the recorded values are not interesting for main analysis, but might be for humans
                parameters.expStart,...
                'NA',... %No training timing
                'NA',...
                'NA',...
                Items.finalTestEnd(j),...
                Items.ambigV(j),...
                Items.mBiasV(j),...
                Items.pBiasV(j),...
                Items.trainV1(j),...
                Items.trainV2(j),...
                Items.trainV3(j),...
                Items.mTestV(j),...
                Items.pTestV(j),...
                Items.ambigAudioFuture(j),...
                Items.ambigAudioPast(j),...
                Items.trainAudioFuture1(j),...
                Items.trainAudioPast1(j),...
                Items.trainAudioFuture2(j),...
                Items.trainAudioPast2(j),...
                Items.trainAudioFuture3(j),...
                Items.trainAudioPast3(j),...
                Items.whichOneAudio(j),...
                Items.letsFindAudio(j)});
end

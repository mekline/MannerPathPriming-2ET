function Write_Trial_to_File(i, Items)
%Wraps up the writing of this specific experiment's info!
%
%i = OVERALL trialno (not counting warmups)
%Settings to write header, main items, and ext items

global RESOURCEFOLDER MAIN_ITEMS SUBJECT CONDITION ntrials expTime expStart

if i==0 %Header!
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

elseif i <= ntrials %It's a main item
    WriteToDataFile({SUBJECT,...
                datestr(now,'dd-mmm-yyyy'),...
                datestr(now,'HH:MM:SS.FFF'),...
                Items.VerbDomain(i),...
                CONDITION,...
                i,...
                Items.itemID(i),...
                Items.verbName(i),...
                Items.verbMeaning(i),...
                Items.BiasManner(i),...
                Items.BiasPath(i),...
                Items.TestManner(i),...
                Items.TestPath(i),...
                expTime,... %expTime.totalTime,...
                'xxxx',... %Marks a point after which the rest of the recorded values are not interesting for main analysis, but might be for humans
                expStart,... %expTime.expStart,...
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
    j = i - ntrials;
    WriteToDataFile({SUBJECT,...
                datestr(now,'dd-mmm-yyyy'),...
                datestr(now,'HH:MM:SS.FFF'),...
                Items.VerbDomain(j),...
                CONDITION,...
                i,...
                Items.itemID(j),...
                Items.verbName(j),...
                Items.verbMeaning(j),...
                Items.BiasManner(j),...
                Items.BiasPath(j),...
                'NA',... %no test phase during extension!
                'NA',...
                expTime,...
                'xxxx',... %Marks a point after which the rest of the recorded values are not interesting for main analysis, but might be for humans
                expStart,...
                'NA',... %No training timing
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

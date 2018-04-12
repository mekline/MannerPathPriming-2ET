###############################
# THE SCRIPT
###############################

#
# Put description here
#

###############################
# Preliminaries
###############################
#Run these two lines the first time only to install eyetrackingR
#install.packages("devtools")
#devtools::install_github("jwdink/eyetrackingR")
#install.packages("eyetrackingR")
library("eyetrackingR")
library("plyr")
library("dplyr")
library("lme4")
library("ggplot2")
library("Matrix")
library("tidyr")
library("stringr")
library("sqldf")

#=======CUSTOM FUNS=======#
validate.names = function(df){
  rtn = df
  valid_column_names = make.names(names=names(df), unique=TRUE, allow_ = TRUE)
  names(rtn) = valid_column_names
  rtn
}

#=========================#


kids_to_process <- c('Adult_0322_1.30pm','Adult_0322_2_2pm', 
                     'Adult_0323_1030am','Adult_0323_11am_4',
                     'Adult_0323_1130am','Adult_0323_130pm',
                     'Adult_0323_2pm','Adult_0323_230pm')
myRepo = 'C:/Users/kailee/Documents/GitHub/MannerPathPriming-2ET'
analysisDir = paste(myRepo, '/Analysis/Analysis_Kailee/',sep='')
dataDir = paste(myRepo, '/Data/Kailee/',sep='')

setwd(myRepo)

###############################
# LOAD DATA
###############################

#load participantdata
pData <- read.csv('all_participants_MPP2ET.csv')

pData <- pData %>%
  filter(SubjectID %in% kids_to_process)%>%
  mutate(subjectID = SubjectID)%>%
  select(-SubjectID)

#Load data for all participants from their data folders
DatData <- data.frame(NULL)
TimestampData <- data.frame(NULL)
GazeData <- data.frame(NULL)

for(ID in pData$subjectID){
  myDataDir <- paste(dataDir, ID, '/', sep='')
  setwd(myDataDir)
  print(ID)
  
  myDatFile <- paste('data_MPPCREATION_',ID, '.dat', sep='')
  myTimestampFile <- paste('timestamps_MPPCREATION_',ID,'.csv',sep='')
  myMainGazeFiles <- list.files(path = myDataDir, full.names = TRUE, pattern = ".*\\Main_.*.csv")
  myPracticeGazeFiles <- list.files(path = myDataDir, full.names = TRUE, pattern = ".*\\Practice_.*.csv")
  
  myDatData <- read.csv(myDatFile)
  
  myTimestampData <- read.csv(myTimestampFile)
   
  myGazeData <- data.frame(NULL)
  
  for (f in myMainGazeFiles){
    thisGazeData = read.csv(f)
    thisGazeData$filename = f
    thisGazeData$phaseGaze = 'Main'
    if(nrow(myGazeData) == 0) {
      
      myGazeData = thisGazeData
      
    } else{
      myGazeData = bind_rows(myGazeData, thisGazeData)
    }
  }
  
  for (f in myPracticeGazeFiles){
    thisGazeData = read.csv(f)
    thisGazeData$filename = f
    thisGazeData$phaseGaze = 'Practice'
    myGazeData = bind_rows(myGazeData, thisGazeData)
  }
  #Add everything to the big DFs!
  if (nrow(DatData) == 0){ #special case for 1st round
    DatData = myDatData
    TimestampData = myTimestampData
    GazeData = myGazeData
  } else {
    DatData = bind_rows(DatData, myDatData)
    TimestampData = bind_rows(TimestampData, myTimestampData)
    GazeData = bind_rows(GazeData, myGazeData)
  }
}  


### AT this point you have:
#GazeData
#TimestampData

###############################
# PROCESS/RECODE DATA
###############################

TimestampData <- TimestampData %>%
  mutate(point_description = ifelse(str_count(point_description, "Practice"),
                                    point_description,
                                    paste("Main_", point_description, sep="")))%>%
  separate(point_description, c("phaseTimestamp", "trialNo", "description"), extra = 'merge', remove = FALSE)

GazeData <- GazeData %>%
  mutate(SubjectID = subjectID) %>%
  select(-SubjectID)

DatData <- DatData %>%
  select(c("SubjectNo","Date","Time","VerbDomain","Condition","trialNo","itemID" ,"verbName","verbMeaning",
           "mannerSideBias", "pathSideBias","mannerSideTest", "pathSideTest")) %>%
  mutate_if(is.factor, as.character) %>%
  mutate(subjectID = SubjectNo) %>%
  mutate(itemID = as.character(itemID))%>%
  select(-SubjectNo) %>%
  mutate(ExperimentPhase = 'Main') %>%
  mutate(targetSideBias = ifelse(Condition == 'Manner', mannerSideBias,pathSideBias)) %>%
  mutate(targetSideTest = ifelse(Condition == 'Manner', mannerSideTest, pathSideTest))
  
  
#Manually add Pratice lines to the Dat files - parameters always the same! Target on the right for trial 1, target on left for trial 2
#NOTE: This may add a trial the child didn't actually do (ie if second practice trial
#wasn't run), but this will be fine bc it won't correspond to any timestamps
pract1 <- DatData %>%
  group_by(subjectID)%>%
  summarise_all(first)%>%
  mutate(trialNo = 1, itemID = 'practice1', verbName = 'NA', ExperimentPhase = 'Practice',
         verbMeaning = 'ball', mannerSideBias = 'NA', pathSideBias = 'NA',
         mannerSideTest = 'NA', pathSideTest = 'NA', targetSideBias = 'NA', targetSideTest = 'R')

pract2 <- DatData %>%
  group_by(subjectID)%>%
  summarise_all(first)%>%
  mutate(trialNo = 2, itemID = 'practice2', verbName = 'NA', ExperimentPhase = 'Practice',
         verbMeaning = 'book', mannerSideBias = 'NA', pathSideBias = 'NA',
         mannerSideTest = 'NA', pathSideTest = 'NA', targetSideBias = 'NA', targetSideTest = 'L')

DatData <- bind_rows(DatData, pract1)  
DatData <- bind_rows(DatData, pract2)  

setwd(analysisDir)
###############################
# MERGE DATA (ahhhh!)
###############################

#Merge all subject- and trial-level data
AllSubjData <- merge(DatData, pData, by="subjectID", all.y = TRUE)

#Get start times (of the whole experiment) to normalize clock variables!
startTime <- TimestampData %>%
  group_by(subjectID) %>%
  arrange(system_time_stamp)%>%
  filter(description == 'Start')%>%
  select(subjectID, system_time_stamp)%>%
  mutate(expStartTime = system_time_stamp) %>%
  select(-system_time_stamp) %>%
  mutate('stringexpStartTime' = as.character(expStartTime))

GazeData = merge(GazeData, startTime, by=c("subjectID")) 
GazeData <- GazeData %>%
  mutate(GazeDataStringTime = as.character(system_time_stamp)) %>%
  mutate(adjusted_time = system_time_stamp - expStartTime) %>%
  select(-c(device_time_stamp, system_time_stamp, expStartTime)) %>%
  separate(description, c("x","y","z", "w", "trialNo")) %>% 
  select(-c(x,y,z,w))
  
#Reshape TimestampData
TimestampData = merge(TimestampData, startTime, by = c("subjectID"))
TimestampData <- TimestampData %>%
  mutate(TimestampDataStringTime = as.character(system_time_stamp))%>%
  mutate(adjusted_start_time = system_time_stamp - expStartTime) %>%
  select(-c(system_time_stamp, expStartTime, point_description)) %>%
  arrange(subjectID, adjusted_start_time) %>%
  mutate(phaseTimestamp = factor(phaseTimestamp, levels=c("Practice","Main")))%>%
  mutate(timeGroupings = paste(subjectID, phaseTimestamp, trialNo)) %>%
  group_by(timeGroupings) %>%
  mutate(adjusted_end_time = lead(adjusted_start_time, order_by = timeGroupings)) %>%
  mutate(next_description = lead(description, order_by = timeGroupings)) %>% #NOTE: these give nonsensical values between edge cases, watch out...
  ungroup() %>%
  select(-timeGroupings) %>%
  #Doing some cleanup on those bad edge cases
  mutate(next_description = ifelse(description == 'SameVerbTest_compareVideo2_end', 
                                  'TRIAL END', next_description)) %>%
  mutate(adjusted_end_time = ifelse(description == 'SameVerbTest_compareVideo2_end', 
                                 adjusted_start_time, adjusted_end_time)) %>%
  mutate(segment_length_in_sec = (adjusted_end_time-adjusted_start_time)/1000000) #For checking things are the right length....

#Column cleanup
TimestampData <- TimestampData %>%
  mutate(trial_sanitycheck = paste(description, next_description, sep='-TO-'))%>%
  select(-c(next_description))


#Now do a cool SQL merge to find the timestamp window that each gazepoint belongs to!
TimestampedGazeData = sqldf("select * from GazeData f1 inner join TimestampData f2 
            on (f1.adjusted_time > f2.adjusted_start_time 
            and f1.adjusted_time<= f2.adjusted_end_time
            and f1.subjectID == f2.subjectID
            and f1.PhaseGaze == f2.PhaseTimestamp
            and f1.trialNo == f2.trialNo) ")

TimestampedGazeData <- TimestampedGazeData%>%
  validate.names() %>% #(See fn at beginning of file, handles duplicated names gen'd by sqldf)
  mutate(ExperimentPhase = phaseGaze) %>%
  select("subjectID","ExperimentPhase", "trialNo","L_valid", "L_x","L_y","R_valid", "R_x", "R_y",
         "stringexpStartTime","GazeDataStringTime",
         "adjusted_time", "adjusted_start_time","adjusted_end_time",
         "segment_length_in_sec","description" )

#And merge on the Trial level data!

AllData <- merge(TimestampedGazeData, AllSubjData, by=c("subjectID", "ExperimentPhase", "trialNo"), all.y = TRUE)

#########################
# MERGE TESTS 
# (Don't skip these)
#########################

#GazeData should be larger than TimestampedGazeData,
#which should be the same number of rows as AllData, OR
#slightly fewer rows than AllData, to account for kids
#who have only one line (no gaze data).
nrow(GazeData) #53407
nrow(TimestampedGazeData) #42944
nrow(AllData) #42953


#All participants, even those who contributed NO looking data,
#should be in the dataset at this point"
length(kids_to_process)  #8 participants
length(unique(AllData$subjectID)) #8 participants 


#Similarly, all trials should be present:
nrow(DatData) #8 trials 
nrow(unique(AllData[c("subjectID", "ExperimentPhase","trialNo")])) #15 

#########################
# FORMAT for eyetrackingr package
#########################

AllData <- AllData %>%
  mutate(Trackloss = !R_valid & !L_valid)%>%
  mutate(trialNo = as.numeric(trialNo))%>%
  mutate(trialNo = ifelse(ExperimentPhase == 'Main', trialNo, trialNo-100))%>%
  mutate(Gaze_x = rowMeans(cbind(R_x, L_x), na.rm=TRUE)) %>%
  mutate(Gaze_y = rowMeans(cbind(R_y, L_y), na.rm=TRUE))
  
#Add AOIs
# LEFT- liberal
# LEFT moviebox
# RIGHT - liberal
# RIGHT moviebox
# Center moviebox
#NOTE these AOIS are in relative numbers (0,0 to 1,1), and are accurate
#for display on our 1280x1040 T60; but maybe not on yours (the PTB help
#code has some pixel-based calculations!)
aois = read.csv('aoi_t60_LionRoom_Kaileecopy.csv', stringsAsFactors = FALSE)
for (i in 1:nrow(aois)) {
  AllData = add_aoi(data=AllData, aoi_dataframe = aois[i,], 
                x_col= "Gaze_x", y_col= "Gaze_y", 
                aoi_name = aois[i,]$AOIName)}

ERData <- make_eyetrackingr_data(AllData, 
                               participant_column = "subjectID",
                               trial_column = "trialNo",
                               time_column = "adjusted_time",
                               trackloss_column = "Trackloss",
                               aoi_columns = c('Left_Box','Right_Box','Center_Box',"Left_Side","Right_Side"),
                               treat_non_aoi_looks_as_missing = FALSE)


#########################
# TESTS for eyetrackingr package (Don't skip!)
#########################

#During segments when a video is always playing on the right or left, we should see more
#looks in those regions!!!!
leftlooks = describe_data(ERData, describe_column = "Left_Box", group_columns = "description")
rightlooks = describe_data(ERData, describe_column = "Right_Box", group_columns = "description")
filter(bind_rows("Left_Box" = leftlooks, "Right_Box" = rightlooks, .id = 'AOI'), 
       description == 'SameVerbTest_left_video' | description == 'SameVerbTest_right_video')

#The descriptions of trackloss on each trial should make sense given what you know about the participants!
TL_Descriptives = trackloss_analysis(ERData)
View(TL_Descriptives)

#########################
# PLOTTING DATA (It's very exciting!)
#########################


#########################
# DATA ANALYSIS (It's also very exciting!)
#########################

########
#aggregating by subjectID to get a proportion of looks to screen by AOI, with only trial 5
trial5 <- subset(data, trialNo == "5")
data_summary <- describe_data(trial5, 
                              describe_column='Correct', group_columns=c('subjectID'))
response_window_agg_by_sub <- make_time_window_data(trial5, aois = c("Correct", "Incorrect"), summarize_by = "subjectID")

#creating plots
ggplot(data=response_window_agg_by_sub, aes(x=AOI, y=Prop)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") + 
  ylab("Proportion of looks to screen") +
  ggtitle("Path Condition") +
  theme(axis.title = element_text(size=18),
        axis.text.x  = element_text(size=18),
        axis.text.y = element_text(size=18),
        plot.title = element_text(size=18, face="bold")) +
  scale_x_discrete(breaks=c("Correct", "Incorrect"),
                   labels=c("Path", "Manner"))
ggsave("trial5_melissa_path.png")






############################
# LOOKING AT MAIN TRIALS
############################

df_111_main <- data.frame(Date=as.Date(character()),
                              File=character(), 
                              User=character(), 
                              stringsAsFactors=FALSE) 
for(file in file.names_main){
  temp <- read.csv(file, header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
  df_111_main <-rbind(df_111_main, temp)
}

#cleaning up the data to get it in the form I want
colnames(df_111_main)[which(names(df_111_main) == "description")] <- "trialNo"
df_111_main$L_valid <- as.factor(df_111_main$L_valid)
df_111_main$R_valid <- as.factor(df_111_main$R_valid)
df_111_main$system_time_stamp <- df_111_main$system_time_stamp - 1500000000000000

#defining a trackloss column
df_111_main$Trackloss_column <- as.factor(ifelse(df_111_main$L_valid == '1' & df_111_main$R_valid == '1', TRUE, 
                                         ifelse(df_111_main$L_valid == '0' & df_111_main$R_valid == '1', FALSE,
                                         ifelse(df_111_main$L_valid == '1' & df_111_main$R_valid == '0', FALSE,
                                         ifelse(df_111_main$L_valid == '0' & df_111_main$R_valid == '0', FALSE, 'Error')))))


#read in timestamps
df_timestamps <- read.csv("~/Documents/Github/MannerPathPriming-2ET/Data/Melissa_111/timestamps_MPPCREATION_Melissa_111.csv", header = TRUE, stringsAsFactors=FALSE, fileEncoding = "latin1")
df_timestamps$subjectID <- as.factor(df_timestamps$subjectID)
df_timestamps$system_time_stamp <- df_timestamps[,2] - 1500000000000000

#applying it to the dataframe for main trials
a <- lapply(df_111_main$system_time_stamp, trial_time)
df_111_main$Trial_description <- a

#averaging together L and R eyes
df_111_main$X <- rowMeans(subset(df_111_main, select = c(6, 9)), na.rm = TRUE)
df_111_main$Y <- rowMeans(subset(df_111_main, select = c(7, 10)), na.rm = TRUE)

#merging together dat_table and trials to get correctness
df_111_main$trialNo <- as.factor(ifelse(df_111_main$trialNo == "All_of_Main_trial_5", "5", 
                                 ifelse(df_111_main$trialNo == "All_of_Main_trial_6", "6",
                                 ifelse(df_111_main$trialNo == "All_of_Main_trial_7", "7",
                                 ifelse(df_111_main$trialNo == "All_of_Main_trial_8", "8", "Error")))))
df_111_main_aoi$Trackloss_column <- as.logical(df_111_main_aoi$Trackloss_column)

df_111_main <- merge(df_111_main, dat_table, by="trialNo")

#Making sure they're looking at the correct video or not
df_111_main_aoi %>%
  group_by(Condition, subjectID, trialNo) %>% 
  mutate(correctBias = ifelse(Condition == 'Path' & pathSideBias == "L" & X < 0.605 & X > 0.25 & Y > 0.1963 & Y < 0.6313, TRUE,
                   ifelse(Condition == 'Path' & pathSideBias == "R" & X < 1.250 & X > 0.67 & Y > 0.1963 & Y < 0.6313, TRUE,
                   ifelse(Condition == 'Manner' & mannerSideBias == "L" & X < 0.605 & X > 0.25 & Y > 0.1963 & Y < 0.6313, TRUE,
                   ifelse(Condition == 'Manner' & mannerSideBias == "R" & X < 1.250 & X > 0.67 & Y > 0.1963 & Y < 0.6313, TRUE, FALSE))))) %>% 
  mutate(correctTest = ifelse(Condition == 'Path' & pathSideTest == "L" & X < 0.605 & X > 0.25 & Y > 0.1963 & Y < 0.6313, TRUE,
                       ifelse(Condition == 'Path' & pathSideTest == "R" & X < 1.250 & X > 0.67 & Y > 0.1963 & Y < 0.6313, TRUE,
                       ifelse(Condition == 'Manner' & mannerSideTest == "L" & X < 0.605 & X > 0.25 & Y > 0.1963 & Y < 0.6313, TRUE,
                       ifelse(Condition == 'Manner' & mannerSideTest == "R" & X < 1.250 & X > 0.67 & Y > 0.1963 & Y < 0.6313, TRUE, FALSE))))) -> df_111_main_aoi

#adding an AOI column for Incorrect looks BIAS to screen
df_111_main_aoi$incorrectBias <- ifelse(df_111_main_aoi$correctBias == TRUE, FALSE,
                                 ifelse(df_111_main_aoi$correctBias == FALSE, TRUE, 'Error'))

df_111_main_aoi$incorrectBias <- as.logical(df_111_main_aoi$incorrectBias)

#adding an AOI column for Incorrect looks TEST to screen
df_111_main_aoi$incorrectTest <- ifelse(df_111_main_aoi$correctTest == TRUE, FALSE,
                                 ifelse(df_111_main_aoi$correctTest == FALSE, TRUE, 'Error'))

df_111_main_aoi$incorrectTest <- as.logical(df_111_main_aoi$incorrectTest)


#starting to use eyetrackingR
data <- make_eyetrackingr_data(df_111_main_aoi, 
                               participant_column = "subjectID",
                               trial_column = "trialNo",
                               time_column = "system_time_stamp",
                               trackloss_column = "Trackloss_column",
                               aoi_columns = c("correctBias", "incorrectBias", "correctTest", "incorrectTest"),
                               treat_non_aoi_looks_as_missing = TRUE
)

#aggregating by subjectID to get a proportion of looks to screen by AOI, with only trial 5
esponse_window_agg_by_sub <- make_time_window_data(data, aois = c("correctBias", "incorrectBias", "correctTest", "incorrectTest"), summarize_by = "subjectID")

#creating plots
ggplot(data=response_window_agg_by_sub, aes(x=AOI, y=Prop)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") + 
  ylab("Proportion of looks to screen") +
  ggtitle("Path Condition") +
  theme(axis.title = element_text(size=18),
        axis.text.x  = element_text(size=18),
        axis.text.y = element_text(size=18),
        plot.title = element_text(size=18, face="bold")) +
  scale_x_discrete(breaks=c("Correct", "Incorrect"),
                   labels=c("Path", "Manner"))
ggsave("melissa_path_main_trials.png")

##########################
# LOOKING AT EXTEND TRIALS
##########################

#reading in extend trial CSVs
df_111_extend <- data.frame(Date=as.Date(character()),
                          File=character(), 
                          User=character(), 
                          stringsAsFactors=FALSE) 
for(file in file.names_extend){
  temp <- read.csv(file, header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
  df_111_extend <-rbind(df_111_extend, temp)
}

#cleaning up the data to get it in the form I want
colnames(df_111_extend)[which(names(df_111_extend) == "description")] <- "trialNo"
df_111_extend$L_valid <- as.factor(df_111_extend$L_valid)
df_111_extend$R_valid <- as.factor(df_111_extend$R_valid)
df_111_extend$system_time_stamp <- df_111_extend$system_time_stamp - 1500000000000000

#defining a trackloss column
df_111_extend$Trackloss_column <- as.factor(ifelse(df_111_extend$L_valid == '1' & df_111_extend$R_valid == '1', TRUE, 
                                         ifelse(df_111_extend$L_valid == '0' & df_111_extend$R_valid == '1', FALSE,
                                         ifelse(df_111_extend$L_valid == '1' & df_111_extend$R_valid == '0', FALSE,
                                         ifelse(df_111_extend$L_valid == '0' & df_111_extend$R_valid == '0', FALSE, 'Error')))))

a <- lapply(df_111_extend$system_time_stamp, trial_time)
df_111_extend$Trial_description <- a

#averaging together L and R eyes
df_111_extend$X <- rowMeans(subset(df_111_extend, select = c(6, 9)), na.rm = TRUE)
df_111_extend$Y <- rowMeans(subset(df_111_extend, select = c(7, 10)), na.rm = TRUE)

#merging together dat_table and trials to get correctness
df_111_extend$trialNo <- as.factor(ifelse(df_111_extend$trialNo == "All_of_Extend_trial_5", "13", 
                                ifelse(df_111_extend$trialNo == "All_of_Extend_trial_6", "14",
                                ifelse(df_111_extend$trialNo == "All_of_Extend_trial_7", "7",
                                ifelse(df_111_extend$trialNo == "All_of_Extend_trial_8", "8",
                                ifelse(df_111_extend$trialNo == "All_of_Extend_trial_1", "9",
                                ifelse(df_111_extend$trialNo == "All_of_Extend_trial_2", "10",
                                ifelse(df_111_extend$trialNo == "All_of_Extend_trial_3", "11",
                                ifelse(df_111_extend$trialNo == "All_of_Extend_trial_4", "12", "Error")))))))))

df_111_extend <- merge(df_111_extend, dat_table, by="trialNo")

#Making sure they're looking at the correct video or not
subjID_aoi_extend <- read.csv("~/Documents/Github/MannerPathPriming-2ET/Analysis/subjID_aoi_extend.csv", header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
subjID_aoi_extend$trialNo <- as.factor(subjID_aoi_extend$trialNo)
df_111_extend_aoi <- add_aoi(df_111_extend, aoi_dataframe = subjID_aoi_extend, 'X', 'Y', aoi_name="Correct", x_min_col = "X_min",
                           x_max_col = "X_max", y_min_col = "Y_min", y_max_col = "Y_max")

#adding an AOI column for Incorrect looks to screen
df_111_extend_aoi$Incorrect <- ifelse(df_111_extend_aoi$Correct == TRUE, FALSE,
                                    ifelse(df_111_extend_aoi$Correct == FALSE, TRUE, 'Error'))
df_111_extend_aoi$Incorrect <- as.logical(df_111_extend_aoi$Incorrect)

#defining a trackloss column
df_111_extend_aoi$Trackloss_column <- ifelse(df_111_extend_aoi$L_valid == '1' & df_111_extend_aoi$R_valid == '1', FALSE, 
                                           ifelse(df_111_extend_aoi$L_valid == '0' & df_111_extend_aoi$R_valid == '1', TRUE,
                                                  ifelse(df_111_extend_aoi$L_valid == '1' & df_111_extend_aoi$R_valid == '0', TRUE,
                                                         ifelse(df_111_extend_aoi$L_valid == '0' & df_111_extend_aoi$R_valid == '0', TRUE, 'Error'))))
df_111_extend_aoi$Trackloss_column <- as.logical(df_111_extend_aoi$Trackloss_column)
#starting to use eyetrackingR
data <- make_eyetrackingr_data(df_111_extend_aoi, 
                               participant_column = "subjectID",
                               trial_column = "trialNo",
                               time_column = "system_time_stamp",
                               trackloss_column = "Trackloss_column",
                               aoi_columns = c("Correct", "Incorrect"),
                               treat_non_aoi_looks_as_missing = TRUE
)

#aggregating by subjectID to get a proportion of looks to screen by AOI, with only trial 5
data_summary <- describe_data(data, 
                              describe_column='Correct', group_columns=c('subjectID'))
response_window_agg_by_sub <- make_time_window_data(data, aois = c("Correct", "Incorrect"), summarize_by = "subjectID")

#creating plots
ggplot(data=response_window_agg_by_sub, aes(x=AOI, y=Prop)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") + 
  ylab("Proportion of looks to screen") +
  ggtitle("Path Condition") +
  theme(axis.title = element_text(size=18),
        axis.text.x  = element_text(size=18),
        axis.text.y = element_text(size=18),
        plot.title = element_text(size=18, face="bold")) +
  scale_x_discrete(breaks=c("Correct", "Incorrect"),
                   labels=c("Outcome", "Action"))
ggsave("extendtrials_melissa_path.png")



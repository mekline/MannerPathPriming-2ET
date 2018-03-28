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
#devtools:install_github("jwdink/eyetrackingR")
library("eyetrackingR")
library("plyr")
library("dplyr")
library("lme4")
library("ggplot2")
library("Matrix")
library("tidyr")
library("stringr")

kids_to_process <- c('Adult_0322_1.30pm','Adult_0322_2_2pm', 
                     'Adult_0323_1030am','Adult_0323_11am_4',
                     'Adult_0323_1130am','Adult_0323_130pm',
                     'Adult_0323_2pm','Adult_0323_230pm'
)

#Set your directories

myRepo = '/Users/kailee/Documents/GitHub/MannerPathPriming-2ET'
analysisDir = paste(myRepo, '/Analysis/Analysis_Kailee/',sep='')
dataDir = paste(myRepo, '/Data/Kailee/',sep='')

setwd(myRepo) 

###############################
# LOAD DATA
###############################

#load participantdata
pData <- read.csv('all_participants_MPP2ET.csv')

pData <- pData %>%
  filter(SubjectID %in% kids_to_process)

#Load data for all participants from their data folders
DatData <- data.frame(NULL)
TimestampData <- data.frame(NULL)
GazeData <- data.frame(NULL)

for(ID in pData$SubjectID){
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

###############################
# PROCESS/RECODE DATA
###############################

TimestampData <- TimestampData %>%
  mutate(system_time_stamp = system_time_stamp - 1500000000000000) %>%
  mutate(point_description = ifelse(str_count(point_description, "Practice"),
                                    point_description,
                                    paste("Main_", point_description, sep="")))%>%
  separate(point_description, c("phaseTimestamp", "trialNo", "description"), extra = 'merge', remove = FALSE)

GazeData <- GazeData %>%
  mutate(system_time_stamp = system_time_stamp - 1500000000000000)%>%
  mutate(SubjectID = subjectID) %>%
  select(-SubjectID)

DatData <- DatData %>%
  select(c("SubjectNo","Date","Time","VerbDomain","Condition","trialNo","itemID" ,"verbName","verbMeaning",
           "mannerSideBias", "pathSideBias","mannerSideTest", "pathSideTest")) %>%
  mutate_if(is.factor, as.character) %>%
  mutate(SubjectID = SubjectNo) %>%
  mutate(itemID = as.character(itemID))%>%
  select(-SubjectNo) %>%
  mutate(phaseDat = 'Main') %>%
  mutate(targetSideBias = ifelse(Condition == 'Manner', mannerSideBias,pathSideBias)) %>%
  mutate(targetSideTest = ifelse(Condition == 'Manner', mannerSideTest, pathSideTest))
  
  
#Manually add Pratice lines to the Dat files - parameters always the same! Target on the right for trial 1, target on left for trial 2
#NOTE: This may add a trial the child didn't actually do (ie if second practice trial
#wasn't run), but this will be fine bc it won't correspond to any timestamps
pract1 <- DatData %>%
  group_by(SubjectID)%>%
  summarise_all(first)%>%
  mutate(trialNo = 1, itemID = 'practice1', verbName = 'NA', phaseDat = 'Practice',
         verbMeaning = 'ball', mannerSideBias = 'NA', pathSideBias = 'NA',
         mannerSideTest = 'NA', pathSideTest = 'NA', targetSideBias = 'NA', targetSideTest = 'R')

pract2 <- DatData %>%
  group_by(SubjectID)%>%
  summarise_all(first)%>%
  mutate(trialNo = 2, itemID = 'practice2', verbName = 'NA', phaseDat = 'Practice',
         verbMeaning = 'book', mannerSideBias = 'NA', pathSideBias = 'NA',
         mannerSideTest = 'NA', pathSideTest = 'NA', targetSideBias = 'NA', targetSideTest = 'L')

DatData <- bind_rows(DatData, pract1)  
DatData <- bind_rows(DatData, pract2)  

###############################
# MERGE DATA (ahhhh!)
###############################

#Merge all subject-level data
AllSubjData <- merge(DatData, pData, by="SubjectID")

#Get start times to normalize clock variables!
startTime <- TimestampData %>%
  group_by(subjectID) %>%
  arrange(system_time_stamp)%>%
  summarize_all(first)%>%
  select(subjectID, system_time_stamp)%>%
  mutate(expStartTime = system_time_stamp) %>%
  select(-system_time_stamp)

GazeData = merge(GazeData, startTime, by=c("subjectID")) 
GazeData <- GazeData %>%
  mutate(adjusted_time = system_time_stamp - expStartTime) %>%
  select(-c(device_time_stamp, system_time_stamp, expStartTime)) %>%
  separate(description, c("x","y","z", "w", "trialNo")) %>% 
  select(-c(x,y,z,w))
  
#Reshape TimestampData
TimestampData = merge(TimestampData, startTime, by = c("subjectID"))
TimestampData <- TimestampData %>%
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
                                 NA, adjusted_end_time)) %>%
  mutate(segment_length_in_sec = (adjusted_end_time-adjusted_start_time)/1000)%>% #For checking things are the right length....
  #Column cleanup:
  mutate(trial_segment = paste(description, next_description, sep='-TO-'))%>%
  select(-c(description, next_description))

#Add labels to the GazeData!

#DATA SUBSET FOR DEVELOPING THE FUNCTION!
practiceSubjData = filter(AllSubjData, SubjectID == 'child_pilot_03202018')
practiceTimestampData = filter(TimestampData, subjectID == 'child_pilot_03202018')
practiceGazeData = filter(GazeData, subjectID == 'child_pilot_03202018', phaseGaze == 'Main', trialNo < 3)
practiceGazeDataLine = practiceGazeData[3000,]

#This function takes a timepoint and a set of TimestampData
#already known to belong to the same kid, and adds the correct timestamp column!
get_timelabel = function(gazetime, kid){
  Timestamp_series = filter(practiceTimestampData, subjectID == kid)
  Timestamp_series$between <- (gazetime > Timestamp_series$adjusted_start_time) &
                              (gazetime < Timestamp_series$adjusted_end_time)
  mylabelrow <- filter(Timestamp_series, between)
  if (nrow(mylabelrow) == 1){
    mylabel = mylabelrow$trial_segment  
  }else{
   mylabel = 'COULD NOT ASSIGN LABEL' 
  }
  return(mylabel)
}

practiceGazeData <- practiceGazeData %>%
  mutate(trial_segment = get_timelabel(adjusted_time, subjectID))

for (kid in kids_to_process){
  thisGazeData <- filter(practiceGazeData, subjectID == kid)
  if (nrow(thisGazeData) > 0){
    labels = mapply(get_label, thisGazeData$adjusted_time, kid)
  }
}

#####START HERE. 



# Still have to 
# - add in Conditions as a DV
# - differentiate looks between L and R videos
# - add in Correct or Incorrect looks to videos
# - add in end times for each trial
# - be able to read in times for both start and end of each trial (for timestamps)
#   - for presentation purposes on monday, I ignored the array of having both start and end, 
#     and just had the start of a trial


###declaring my real function####
trial_time <- function(x) {
  
  f = df_timestamps$system_time_stamp
  a = x
  maxless <- max(f[f <= a])
  # find out which value that is
  
  if(identical(maxless,character(0))){
    maxless <- max(f[f>=a])
  }
  
  y = which(f == maxless)
  z = as.character(df_timestamps$point_description[y])
  
  z1 = as.character(df_timestamps$point_description[y+1])
  z2 <- paste(z1, z, sep=",")
  
  #x <- cbind(x, newColumn = z2)
  
  return(z2)
}

#declaring my PRACTICE function
trial_time <- function(x) {
  f = df_timestamps$system_time_stamp
  a = x
  maxless <- max(f[f <= a])
  # find out which value that is
  y = which(f == maxless)
  z = as.character(df_timestamps$point_description[y])
  
  if(identical(z,character(0))) {
    y = min(which(f > a))
    z = as.character(df_timestamps$point_description[y])
  } else {
    return(z)
  }
}


#cleaning up the data to get it in the form I want
colnames(df_111_practice)[which(names(df_111_practice) == "description")] <- "trialNo"
df_111_practice$L_valid <- as.factor(df_111_practice$L_valid)
df_111_practice$R_valid <- as.factor(df_111_practice$R_valid)
df_111_practice$system_time_stamp <- df_111_practice$system_time_stamp - 1500000000000000

#defining a trackloss column
df_111_practice$Trackloss_column <- ifelse(df_111_practice$L_valid == '1' & df_111_practice$R_valid == '1', FALSE, 
                                    ifelse(df_111_practice$L_valid == '0' & df_111_practice$R_valid == '1', TRUE,
                                    ifelse(df_111_practice$L_valid == '1' & df_111_practice$R_valid == '0', TRUE,
                                    ifelse(df_111_practice$L_valid == '0' & df_111_practice$R_valid == '0', TRUE, 'Error'))))

df_111_practice$Trackloss_column <- as.logical(df_111_practice$Trackloss_column)

#read in timestamps
df_timestamps <- read.csv("~/Documents/Github/MannerPathPriming-2ET/Data/Melissa_111/timestamps_MPPCREATION_Melissa_111.csv", header = TRUE, stringsAsFactors=FALSE, fileEncoding = "latin1")
df_timestamps$subjectID <- as.factor(df_timestamps$subjectID)
df_timestamps$system_time_stamp <- df_timestamps[,2] - 1500000000000000

#applying it to the dataframe for practice trials
a <- lapply(df_111_practice$system_time_stamp, trial_time)
df_111_practice$Trial_description <- a

#averaging together L and R eyes
df_111_practice$X <- rowMeans(subset(df_111_practice, select = c(6, 9)), na.rm = TRUE)
df_111_practice$Y <- rowMeans(subset(df_111_practice, select = c(7, 10)), na.rm = TRUE)

#merging together dat_table and trials to get correctness
df_111_practice$trialNo <- as.factor(ifelse(df_111_practice$trialNo == "All_of_Practice_trial_1", "1", 
                                     ifelse(df_111_practice$trialNo == "All_of_Practice_trial_2", "2",
                                     ifelse(df_111_practice$trialNo == "All_of_Practice_trial_3", "3",
                                     ifelse(df_111_practice$trialNo == "All_of_Practice_trial_4", "4", "Error")))))

df_111_practice <- merge(df_111_practice, dat_table, by="trialNo")

#Making sure they're looking at the correct video or not
subjID_aoi <- read.csv("~/Documents/Github/MannerPathPriming-2ET/Analysis/subjID_aoi.csv", header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
subjID_aoi$trialNo <- as.factor(subjID_aoi$trialNo)
df_111_main_aoi <- add_aoi(df_111_main, aoi_dataframe = subjID_aoi, 'X', 'Y', aoi_name="Correct", x_min_col = "X_min",
                           x_max_col = "X_max", y_min_col = "Y_min", y_max_col = "Y_max")

#adding an AOI column for Incorrect looks to screen
df_111_practice$Incorrect <- ifelse(df_111_practice$Correct == TRUE, FALSE,
                             ifelse(df_111_practice$Correct == FALSE, TRUE, 'Error'))
df_111_practice$Incorrect <- as.logical(df_111_practice$Incorrect)

#starting to use eyetrackingR
data <- make_eyetrackingr_data(df_111_practice, 
                               participant_column = "subjectID",
                               trial_column = "trialNo",
                               time_column = "system_time_stamp",
                               trackloss_column = "Trackloss_column",
                               aoi_columns = c("Correct", "Incorrect"),
                               treat_non_aoi_looks_as_missing = TRUE
)

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



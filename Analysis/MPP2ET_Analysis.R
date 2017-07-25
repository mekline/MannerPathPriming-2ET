install.packages("devtools")
devtools::install_github("jwdink/eyetrackingR")
library("eyetrackingR")
library("plyr")
library("dplyr")
library("lme4")
library("ggplot2")
library("Matrix")

# This script is looking at the eyetracking data of MPP2ET. We're going to read 
# in each participant's trials one by one, append them to each specific phase
# (Practice, Main, Extend), and then append them all to a dataframe. We're going
# to loop through each participant. 

setwd('/Users/crystallee/Documents/Github/MannerPathPriming-2ET/Data/')


############################
# Getting ready
############################

# Reading in subject list
subjects <- read.csv("MPP2ET_Data.csv")

# Declaring an empty df to append to
allData <- data.frame(Date=as.Date(character()),
                              File=character(), 
                              User=character(), 
                              stringsAsFactors=FALSE) 



###declaring my real function####
trial_time1 <- function(x) {
  
  f = df_timestamps$system_time_stamp
  a = x
  maxless <- max(f[f <= a])
  # find out which value that is
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
  
  #x <- cbind(x, newColumn = z2)
  
  return(z)
}


##THIS IS WHERE THE FOR LOOP STARTS


############################
# Importing files specific to participant
############################

file.names_practice <- dir(path, pattern ="gaze_MPPCREATION_Melissa_111_All_of_Practice_.*.csv")
file.names_main <- dir(path, pattern ="gaze_MPPCREATION_Melissa_111_All_of_Main_trial_.*.csv")
file.names_extend <- dir(path, pattern ="gaze_MPPCREATION_Melissa_111_All_of_Extend_trial_.*.csv")

#read in timestamps
df_timestamps <- read.csv("~/Documents/Github/MannerPathPriming-2ET/Data/Melissa_111/timestamps_MPPCREATION_Melissa_111.csv", header = TRUE, stringsAsFactors=FALSE, fileEncoding = "latin1")
df_timestamps$subjectID <- as.factor(df_timestamps$subjectID)
df_timestamps$system_time_stamp <- df_timestamps[,2] - 1500000000000000

dat_table <- read.delim("~/Documents/Github/MannerPathPriming-2ET/Data/MPPCREATION_Melissa_111.dat", 
                        header=TRUE, sep=",")

path = '~/Documents/Github/MannerPathPriming-2ET/Data/Melissa_111'
out.file<-""

############################
# LOOKING AT PRACTICE TRIALS
############################
subjData <- data.frame(Date=as.Date(character()),
                       File=character(), 
                       User=character(), 
                       stringsAsFactors=FALSE) 

df_practice <- data.frame(Date=as.Date(character()),
                             File=character(), 
                             User=character(), 
                             stringsAsFactors=FALSE) 
for(file in file.names_practice){
  temp <- read.csv(file, header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
  df_practice <-rbind(df_practice, temp)
}


#cleaning up the data to get it in the form I want
colnames(df_practice)[which(names(df_practice) == "description")] <- "trialNo"
df_practice$L_valid <- as.factor(df_practice$L_valid)
df_practice$R_valid <- as.factor(df_practice$R_valid)
df_practice$system_time_stamp <- df_practice$system_time_stamp - 1500000000000000
df_practice$phase <- 'Practice'

#defining a trackloss column
df_practice$Trackloss_column <- ifelse(df_practice$L_valid == '1' & df_practice$R_valid == '1', FALSE, 
                                    ifelse(df_practice$L_valid == '0' & df_practice$R_valid == '1', TRUE,
                                    ifelse(df_practice$L_valid == '1' & df_practice$R_valid == '0', TRUE,
                                    ifelse(df_practice$L_valid == '0' & df_practice$R_valid == '0', TRUE, 'Error'))))

df_practice$Trackloss_column <- as.logical(df_practice$Trackloss_column)

#merging together dat_table and trials to get correctness
df_practice$trialNo <- as.factor(ifelse(df_practice$trialNo == "All_of_Practice_trial_1", "1", 
                                     ifelse(df_practice$trialNo == "All_of_Practice_trial_2", "2",
                                     ifelse(df_practice$trialNo == "All_of_Practice_trial_3", "3",
                                     ifelse(df_practice$trialNo == "All_of_Practice_trial_4", "4", "Error")))))

subjData <- rbind(subjData, df_practice)



############################
# LOOKING AT MAIN TRIALS
############################

df_main <- data.frame(Date=as.Date(character()),
                              File=character(), 
                              User=character(), 
                              stringsAsFactors=FALSE) 
for(file in file.names_main){
  temp <- read.csv(file, header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
  df_main <-rbind(df_main, temp)
}

#cleaning up the data to get it in the form I want
colnames(df_main)[which(names(df_main) == "description")] <- "trialNo"
df_main$L_valid <- as.factor(df_main$L_valid)
df_main$R_valid <- as.factor(df_main$R_valid)
df_main$system_time_stamp <- df_main$system_time_stamp - 1500000000000000
df_main$phase <- 'Main'

#defining a trackloss column
df_main$Trackloss_column <- as.factor(ifelse(df_main$L_valid == '1' & df_main$R_valid == '1', TRUE, 
                                         ifelse(df_main$L_valid == '0' & df_main$R_valid == '1', FALSE,
                                         ifelse(df_main$L_valid == '1' & df_main$R_valid == '0', FALSE,
                                         ifelse(df_main$L_valid == '0' & df_main$R_valid == '0', FALSE, 'Error')))))

df_main_aoi$Trackloss_column <- as.logical(df_main_aoi$Trackloss_column)


#merging together dat_table and trials to get correctness
df_main$trialNo <- as.factor(ifelse(df_main$trialNo == "All_of_noBias_trial_1", "1",
                             ifelse(df_main$trialNo == "All_of_noBias_trial_2", "2",
                             ifelse(df_main$trialNo == "All_of_noBias_trial_3", "3",
                             ifelse(df_main$trialNo == "All_of_noBias_trial_4", "4",
                             ifelse(df_main$trialNo == "All_of_Main_trial_5", "5", 
                             ifelse(df_main$trialNo == "All_of_Main_trial_6", "6",
                             ifelse(df_main$trialNo == "All_of_Main_trial_7", "7",
                             ifelse(df_main$trialNo == "All_of_Main_trial_8", "8", "Error")))))))))


subjData <- rbind(subjData, df_main)



##########################
# LOOKING AT EXTEND TRIALS
##########################

#reading in extend trial CSVs
df_extend <- data.frame(Date=as.Date(character()),
                          File=character(), 
                          User=character(), 
                          stringsAsFactors=FALSE) 
for(file in file.names_extend){
  temp <- read.csv(file, header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
  df_extend <-rbind(df_extend, temp)
}

#cleaning up the data to get it in the form I want
colnames(df_extend)[which(names(df_extend) == "description")] <- "trialNo"
df_extend$L_valid <- as.factor(df_extend$L_valid)
df_extend$R_valid <- as.factor(df_extend$R_valid)
df_extend$system_time_stamp <- df_extend$system_time_stamp - 1500000000000000
df_extend$phase <- 'Extend'

#defining a trackloss column
df_extend$Trackloss_column <- as.factor(ifelse(df_extend$L_valid == '1' & df_extend$R_valid == '1', TRUE, 
                                         ifelse(df_extend$L_valid == '0' & df_extend$R_valid == '1', FALSE,
                                         ifelse(df_extend$L_valid == '1' & df_extend$R_valid == '0', FALSE,
                                         ifelse(df_extend$L_valid == '0' & df_extend$R_valid == '0', FALSE, 'Error')))))


#merging together dat_table and trials to get correctness
df_extend$trialNo <- as.factor(ifelse(df_extend$trialNo == "All_of_Extend_trial_5", "13", 
                                ifelse(df_extend$trialNo == "All_of_Extend_trial_6", "14",
                                ifelse(df_extend$trialNo == "All_of_Extend_trial_7", "7",
                                ifelse(df_extend$trialNo == "All_of_Extend_trial_8", "8",
                                ifelse(df_extend$trialNo == "All_of_Extend_trial_1", "9",
                                ifelse(df_extend$trialNo == "All_of_Extend_trial_2", "10",
                                ifelse(df_extend$trialNo == "All_of_Extend_trial_3", "11",
                                ifelse(df_extend$trialNo == "All_of_Extend_trial_4", "12", "Error")))))))))


subjData <- rbind(subjData, df_extend)

############################
# THIS IS WHERE THE FOR LOOP ENDS
############################




############################
# ANALYSES TO START AFTER EXPORTING ONE GIANT-ASS DF
############################


#defining a trackloss column
allData$Trackloss_column <- ifelse(allData$L_valid == '1' & allData$R_valid == '1', FALSE, 
                                     ifelse(allData$L_valid == '0' & allData$R_valid == '1', TRUE,
                                            ifelse(allData$L_valid == '1' & allData$R_valid == '0', TRUE,
                                                   ifelse(allData$L_valid == '0' & allData$R_valid == '0', TRUE, 'Error'))))
allData$Trackloss_column <- as.logical(allData$Trackloss_column)


#Making sure they're looking at the correct video or not
allData %>%
  group_by(Condition, subjectID, trialNo) %>% 
  mutate(correctBias = ifelse(Condition == 'Path' & pathSideBias == "L" & X < 0.605 & X > 0.25 & Y > 0.1963 & Y < 0.6313, TRUE,
                              ifelse(Condition == 'Path' & pathSideBias == "R" & X < 1.250 & X > 0.67 & Y > 0.1963 & Y < 0.6313, TRUE,
                                     ifelse(Condition == 'Manner' & mannerSideBias == "L" & X < 0.605 & X > 0.25 & Y > 0.1963 & Y < 0.6313, TRUE,
                                            ifelse(Condition == 'Manner' & mannerSideBias == "R" & X < 1.250 & X > 0.67 & Y > 0.1963 & Y < 0.6313, TRUE, FALSE))))) %>% 
  mutate(correctTest = ifelse(Condition == 'Path' & pathSideTest == "L" & X < 0.605 & X > 0.25 & Y > 0.1963 & Y < 0.6313, TRUE,
                              ifelse(Condition == 'Path' & pathSideTest == "R" & X < 1.250 & X > 0.67 & Y > 0.1963 & Y < 0.6313, TRUE,
                                     ifelse(Condition == 'Manner' & mannerSideTest == "L" & X < 0.605 & X > 0.25 & Y > 0.1963 & Y < 0.6313, TRUE,
                                            ifelse(Condition == 'Manner' & mannerSideTest == "R" & X < 1.250 & X > 0.67 & Y > 0.1963 & Y < 0.6313, TRUE, FALSE))))) -> df_main_aoi

#adding an AOI column for Incorrect looks TEST to screen
allData$incorrectTest <- ifelse(allData$correctTest == TRUE, FALSE,
                                    ifelse(allData$correctTest == FALSE, TRUE, 'Error'))

allData$incorrectTest <- as.logical(allData$incorrectTest)


#applying it to the dataframe for practice trials
a <- lapply(allData$system_time_stamp, trial_time)
allData$Trial_description <- a

#averaging together L and R eyes
allData$X <- rowMeans(subset(allData, select = c(6, 9)), na.rm = TRUE)
allData$Y <- rowMeans(subset(allData, select = c(7, 10)), na.rm = TRUE)

#starting to use eyetrackingR
data <- make_eyetrackingr_data(allData, 
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



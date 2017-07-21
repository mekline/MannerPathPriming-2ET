install.packages("devtools")
devtools::install_github("jwdink/eyetrackingR")
library("eyetrackingR")
library("plyr")
library("dplyr")
library("lme4")
library("ggplot2")
library("Matrix")

# Still have to 
# - add in Conditions as a DV
# - differentiate looks between L and R videos
# - add in Correct or Incorrect looks to videos
# - add in end times for each trial
# - be able to read in times for both start and end of each trial (for timestamps)
#   - for presentation purposes on monday, I ignored the array of having both start and end, 
#     and just had the start of a trial

setwd('/Users/crystallee/Documents/Github/MannerPathPriming-2ET/Data/99')

path = '~/Documents/Github/MannerPathPriming-2ET/Data/99'
out.file<-""

#Load in practice trials
file.names <- dir(path, pattern ="gaze_MPPCREATION_99_All_of_Practice_.*.csv")
df_99_practice <- data.frame(Date=as.Date(character()),
                             File=character(), 
                             User=character(), 
                             stringsAsFactors=FALSE) 
for(file in file.names){
  temp <- read.csv(file, header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
  df_99_practice <-rbind(df_99_practice, temp)
}

#cleaning up the data to get it in the form I want
colnames(df_99_practice)[which(names(df_99_practice) == "description")] <- "Trial"
df_99_practice$L_valid <- as.factor(df_99_practice$L_valid)
df_99_practice$R_valid <- as.factor(df_99_practice$R_valid)
df_99_practice$system_time_stamp <- df_99_practice$system_time_stamp - 1500000000000000

#defining a trackloss column
df_99_practice$Trackloss_column <- as.factor(ifelse(df_99_practice$L_valid == '1' & df_99_practice$R_valid == '1', TRUE, 
                                             ifelse(df_99_practice$L_valid == '0' & df_99_practice$R_valid == '1', FALSE,
                                             ifelse(df_99_practice$L_valid == '1' & df_99_practice$R_valid == '0', FALSE,
                                             ifelse(df_99_practice$L_valid == '0' & df_99_practice$R_valid == '0', FALSE, 'Error')))))

#reading in main trial CSVs

df_99_main <- read.csv("gaze_MPPCREATION_99_All_of_Main_trials.csv", header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
#cleaning up the data to get it in the form I want
colnames(df_99_main)[which(names(df_99_main) == "description")] <- "Trial"
df_99_main$L_valid <- as.factor(df_99_main$L_valid)
df_99_main$R_valid <- as.factor(df_99_main$R_valid)
df_99_main$system_time_stamp <- df_99_main$system_time_stamp - 1500000000000000

#defining a trackloss column
df_99_main$Trackloss_column <- as.factor(ifelse(df_99_main$L_valid == '1' & df_99_main$R_valid == '1', TRUE, 
                                         ifelse(df_99_main$L_valid == '0' & df_99_main$R_valid == '1', FALSE,
                                         ifelse(df_99_main$L_valid == '1' & df_99_main$R_valid == '0', FALSE,
                                         ifelse(df_99_main$L_valid == '0' & df_99_main$R_valid == '0', FALSE, 'Error')))))


#read in timestamps
df_timestamps <- read.csv("timestamps_MPPCREATION_99.csv", header = TRUE, stringsAsFactors=FALSE, fileEncoding = "latin1")
df_timestamps$subjectID <- as.factor(df_timestamps$subjectID)
df_timestamps$system_time_stamp <- df_timestamps[,2] - 1500000000000000

# me practicing
practice1 <- df_99_main[1,]
practice2 <- df_99_main

#declaring my real function
trial_time <- function(x) {

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

#applying it to the dataframe for main trials
a <- lapply(df_99_main$system_time_stamp, trial_time)
df_99_main$Trial_description <- a

#averaging together L and R eyes
df_99_main$X <- rowMeans(subset(df_99_main, select = c(7, 10)), na.rm = TRUE)
df_99_main$Y <- rowMeans(subset(df_99_main, select = c(8, 11)), na.rm = TRUE)

#adding an AOI column for Looks to screen
df_99_main$Trial_description <- as.character(df_99_main$Trial_description)
aoi <- read.csv('~/Documents/Github/MannerPathPriming-2ET/Analysis/aoi.csv', header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
aoi <- na.omit(aoi)
df_99_main_aoi <- add_aoi(df_99_main, aoi_dataframe = aoi, 'X', 'Y', aoi_name="Looks", x_min_col = "X_min",
        x_max_col = "X_max", y_min_col = "Y_min", y_max_col = "Y_max")

#adding an AOI column for NoLooks to screen
df_99_main_aoi <- na.omit(df_99_main_aoi)
df_99_main_aoi$NoLooks <- ifelse(df_99_main_aoi$Looks == TRUE, FALSE,
                          ifelse(df_99_main_aoi$Looks == FALSE, TRUE, 'Error'))
df_99_main_aoi$NoLooks <- as.logical(df_99_main_aoi$NoLooks)

#defining a trackloss column
df_99_main_aoi$Trackloss_column <- ifelse(df_99_main_aoi$L_valid == '1' & df_99_main_aoi$R_valid == '1', FALSE, 
                                   ifelse(df_99_main_aoi$L_valid == '0' & df_99_main_aoi$R_valid == '1', TRUE,
                                   ifelse(df_99_main_aoi$L_valid == '1' & df_99_main_aoi$R_valid == '0', TRUE,
                                   ifelse(df_99_main_aoi$L_valid == '0' & df_99_main_aoi$R_valid == '0', TRUE, 'Error'))))

#starting to use eyetrackingR
data <- make_eyetrackingr_data(df_99_main_aoi, 
                               participant_column = "subjectID",
                               trial_column = "Trial",
                               time_column = "system_time_stamp",
                               trackloss_column = "Trackloss_column",
                               aoi_columns = c("Looks", "NoLooks"),
                               treat_non_aoi_looks_as_missing = TRUE
)

#attempts to subset by window, still need to figure this out
response_window <- subset_by_window(data, window_start_time = 0, rezero = TRUE, remove = FALSE)

#rezero-ing everything manually
response_window$system_time_stamp <- response_window$system_time_stamp - 479331004389

#aggregating by subjectID to get a proportion of looks to screen by AOI
response_window_agg_by_sub <- make_time_window_data(data, aois = 'Looks', summarize_by = "subjectID")

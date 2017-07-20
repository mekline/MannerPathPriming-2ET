install.packages("devtools")
devtools::install_github("jwdink/eyetrackingR")
library("eyetrackingR")
library("lme4")
library("ggplot2")
library("Matrix")
library("plyr")
data("word_recognition")

setwd('/Users/crystallee/Documents/Github/MannerPathPriming-2ET/Data/99')

path = '~/Documents/Github/MannerPathPriming-2ET/Data/99'
out.file<-""

#Load in practice trials
file.names <- dir(path, pattern ="gaze_MPPCREATION_99_All_of_Practice_.*.csv")
for(file in file.names){
  df_99_practice <-read.csv(file, header = TRUE, stringsAsFactors=FALSE, fileEncoding="latin1")
}

#cleaning up the data to get it in the form I want
colnames(df_99_practice)[which(names(df_99_practice) == "description")] <- "trial"
df_99_practice$L_valid <- as.factor(df_99_practice$L_valid)
df_99_practice$R_valid <- as.factor(df_99_practice$R_valid)

#defining a trackloss column
df_99_practice$Trackloss_column <- as.factor(ifelse(df_99_practice$L_valid == '1' & df_99_practice$R_valid == '1', '1', 
                                             ifelse(df_99_practice$L_valid == '0' & df_99_practice$R_valid == '1', '0',
                                             ifelse(df_99_practice$L_valid == '1' & df_99_practice$R_valid == '0', '0',
                                             ifelse(df_99_practice$L_valid == '0' & df_99_practice$R_valid == '0', '0', 'Error')))))
#adding an AOI column
add_aoi(df_99_practice, aoi_dataframe, x_col, y_col, aoi_name, x_min_col = "L",
        x_max_col = "R", y_min_col = "T", y_max_col = "B")

data <- make_eyetrackingr_data(df_99_practice, 
                               participant_column = "subjectID",
                               trial_column = "trial",
                               time_column = "system_time_stamp",
                               trackloss_column = "TrackLoss_column",
                               aoi_columns = c('Animate','Inanimate'),
                               treat_non_aoi_looks_as_missing = TRUE
)
# subset to response window post word-onset
response_window <- subset_by_window(data, 
                                    window_start_time = 15500, 
                                    window_end_time = 21000, 
                                    rezero = FALSE)
response_window_clean <- clean_by_trackloss(data = response_window,
                                            trial_prop_thresh = .25)

# create Target condition column
response_window_clean$Target <- as.factor( ifelse(test = grepl('(Spoon|Bottle)', response_window_clean$Trial), 
                                                  yes = 'Inanimate', 
                                                  no  = 'Animate') )
data_summary <-  describe_data(response_window_clean, 
                               describe_column='Animate', group_columns=c('Target','ParticipantName'))

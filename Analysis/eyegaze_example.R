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
file.names <- dir(path, pattern ="^g+.*.csv")
for(i in 1:length(file.names)){
  file <- read.table(file.names[i],header=TRUE, sep=";", stringsAsFactors=FALSE)
  out.file <- rbind(out.file, file)
}

write.table(out.file, file = "gaze_MPPCREATION_99.csv",sep=";", 
            row.names = FALSE, qmethod = "double",fileEncoding="windows-1252")

subj99 <- ldply( .data = list.files(pattern="gaze*.csv"),
                    .fun = read.csv,
                    header = FALSE,
                    col.names=c("subjectID", "device_time_stamp", "system_time_stamp", "description", "L_valid", "L_x", "L_y", "R_valid", "R_x", "R_y") )

data <- make_eyetrackingr_data(word_recognition, 
                               participant_column = "ParticipantName",
                               trial_column = "Trial",
                               time_column = "TimeFromTrialOnset",
                               trackloss_column = "TrackLoss",
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

#Getting and Cleaning Data - Programming Assignment:
rm(list=ls())
library(dplyr)
getwd()
setwd("C:/Users/adamr/Documents/R/Getting and Cleaning Data - Programming Assignment")

#Download the data
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, "GCD_Prog_Assign_Data.zip", method ="curl")
unzip("GCD_Prog_Assign_Data.zip")

#Reading data into R
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#1 - Merging data
X <- rbind(x_test, x_train)
Y <- rbind(y_test, y_train)
Subject <- rbind(subject_test, subject_train)
Merged_Data <- cbind(Subject, Y, X)

#2 - Extract measurements on the mean and standard deviation for each measurement.
Subset_Data <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

#3 - Descriptive activity names 
Subset_Data$code <- activity_labels[Subset_Data$code, 2] #Numbers in code column of the Subset_Data replaced with corresponding activity taken from second column of the activities variable

#4 - Descriptive variable names
names(Subset_Data)[2] = "activity"
names(Subset_Data)<-gsub("Acc", "Accelerometer", names(Subset_Data))
names(Subset_Data)<-gsub("Gyro", "Gyroscope", names(Subset_Data))
names(Subset_Data)<-gsub("BodyBody", "Body", names(Subset_Data))
names(Subset_Data)<-gsub("Mag", "Magnitude", names(Subset_Data))
names(Subset_Data)<-gsub("^t", "Time", names(Subset_Data))
names(Subset_Data)<-gsub("^f", "Frequency", names(Subset_Data))
names(Subset_Data)<-gsub("tBody", "TimeBody", names(Subset_Data))
names(Subset_Data)<-gsub("-mean()", "Mean", names(Subset_Data), ignore.case = TRUE)
names(Subset_Data)<-gsub("-std()", "STD", names(Subset_Data), ignore.case = TRUE)
names(Subset_Data)<-gsub("-freq()", "Frequency", names(Subset_Data), ignore.case = TRUE)
names(Subset_Data)<-gsub("angle", "Angle", names(Subset_Data))
names(Subset_Data)<-gsub("gravity", "Gravity", names(Subset_Data))


#5 - Average of each variable for each activity and each subject.
Data_Summary <- Subset_Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Data_Summary, "Data_Summary.txt", row.name=FALSE)

#View final data
Data_Summary

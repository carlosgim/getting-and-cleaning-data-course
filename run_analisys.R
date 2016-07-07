library(dplyr)
library(data.table)

# The purpose of this project is to demonstrate your ability to collect, 
# work with, and clean a data set. The goal is to prepare tidy data that can 
# be used for later analysis. You will be graded by your peers on a series of 
# yes/no questions related to the project. You will be required to submit: 1) 
# a tidy data set as described below, 2) a link to a Github repository with your 
# script for performing the analysis, and 3) a code book that describes the 
# variables, the data, and any transformations or work that you performed to 
# clean up the data called CodeBook.md. You should also include a README.md in 
# the repo with your scripts. This repo explains how all of the scripts work 
# and how they are connected.

# One of the most exciting areas in all of data science right now is wearable 
# computing - see for example this article . Companies like Fitbit, Nike, and 
# Jawbone Up are racing to develop the most advanced algorithms to attract new 
# users. The data linked to from the course website represent data collected 
# from the accelerometers from the Samsung Galaxy S smartphone. A full 
# description is available at the site where the data was obtained:
  
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Here are the data for the project:
  
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each 
# measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

# Activity labels
act_lab <- read.table("./UCI HAR Dataset/activity_labels.txt")
# Load features names
features <- read.table("./UCI HAR Dataset/features.txt")
# Load test observations
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
# Load test observations
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
# Subjetcs
sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
# Extract mean and sd in each measurement
std_mean_test <- select(X_test, grep("mean|std",features$V2))
std_mean_train <- select(X_train, grep("mean|std",features$V2))

# Add names
names(std_mean_test) <- features[grep("mean|std",features$V2),2]
names(std_mean_train) <- features[grep("mean|std",features$V2),2]

# Load activity labels
y_test$V2 <- act_lab[y_test$V1,2]
names(y_test) <- c("Activity", "Label")
names(sub_test) <- "subject"

y_train$V2 <- act_lab[y_train$V1,2]
names(y_train) <- c("Activity", "Label")
names(sub_train) <- "subject"

# Join
all_test <- cbind(as.data.table(sub_test), y_test, std_mean_test)
all_train <- cbind(as.data.table(sub_train), y_train, std_mean_train)

# Add train to test
all_data <- rbind(all_test, all_train)

# New tidy data frame
tidy_data <- all_data %>%
  group_by(subject,Activity) %>%
  summarise_each(funs(mean(., na.rm=TRUE)), -Label)

write.table(tidy_data,  file = "./tidy_data.txt", row.names = FALSE)


# setwd("C:/Users/aaronf/Documents/classes/data_science/getting_and_cleaning_data/gacd_course_project")
# You should create one R script called run_analysis.R that does the 
# following:
#
#  1. Merge the training and the test sets to create one data set.
#  2. Extract only the measurements on the mean and standard deviation 
#     for each measurement. 
#  3. Use descriptive activity names to name the activities in the data set
#  4. Appropriately label the data set with descriptive variable names. 
#  5. From the data set in step 4, create a second, independent tidy data 
#     set with the average of each variable for each activity and each
#     subject.
#


#  1. Merge the training and the test sets to create one data set.
#    a. rbind the "subject" test and training data into one data set.
subject_test <- read.table("test/subject_test.txt", col.names=c("subject"))
subject_train <- read.table("train/subject_train.txt", col.names=c("subject"))
subject <- rbind(subject_test, subject_train)

#    b. rbind the "activity" test and training data into one data set.
activity_test <- read.table("test/y_test.txt", col.names=c("activity"))
activity_train <- read.table("train/y_train.txt", col.names=c("activity"))
activity <- rbind(activity_test, activity_train)
#  Meanwhile, 3. Use descriptive activity names to name the activities in 
# the data set
act <- read.table("activity_labels.txt")
activities <- act$V2
activity_labels <- activities[activity$activity]

#    c. read the feature names into a vector
features <- read.table("features.txt")
X.cols <- features$V2
# X.cols <- gsub("()", "", X.cols, fixed=TRUE)
# X.cols <- gsub("-", " ", X.cols, fixed=TRUE)

#    d. rbind the "X" test and training data into one data set, labeled with
#       the feature names.
X_test <- read.table("test/X_test.txt")
X_train <- read.table("train/X_train.txt")
X <- rbind(X_test, X_train)
colnames(X) <- X.cols
#    remove duplicate columns (none of these are mean() or std())
X <- X[ !duplicated(names(X))] 
#  2. Extract only the measurements on the mean and standard deviation,
# that is:
# tBodyAcc-{mean(),std()}-{x,y,z}
# tBodyAccJerk{mean(),std()}-{x,y,z}
# tBodyGyro-{mean(),std()}-{x,y,z}
# tBodyGyroJerk-{mean(),std()}-{x,y,z}
# tGravityAcc-{mean(),std()}-{x,y,z}
# tBodyAccMag-{mean(),std()}
# tBodyAccJerkMag-{mean(),std()}
# tBodyGyroMag-{mean(),std()}
# tBodyGyroJerkMag-{mean(),std()}
# tGravityAccMag-{mean(),std()}
# 
# fBodyAcc-{mean(),std()}-{x,y,z}
# fBodyAccJerk-{mean(),std()}-{x,y,z}
# fBodyGyro-{mean(),std()}-{x,y,z}
# * fBodyGyroJerk-{mean(),std()}-{x,y,z}
# fBodyAccMag-{mean(),std()}
# fBodyAccJerkMag-{mean(),std()}
# fBodyGyroMag-{mean(),std()}
# fBodyGyroJerkMa-{mean(),std()}

# Each {x,y,z} value is 6 measurements ({mean(), std()} for {x,y.z});
# each other value is 2 measurements ({mean(), std()}.
# There are 8 {x,y,z} measurements, and 9 {mean(),std()} measurements, for
# a total of 8*6 + 9*2 = 66 retained measurements.
#
# Note that one {x,y,z} measurement is missing:
#   fBodyGyroJerk-{mean(),std()}-{x,y,z}

# Select only the mean() and std() observations.
X <- select(X, contains("mean()"), contains("std()"))

data <- cbind(subject, activity_labels, X)
# We now have a fairly tidy data frame, with 66 variables + subject, activity.
# Save some memory by deleting temp variables:
rm(list = c(
  "subject_test", "subject_train",
  "activity_test", "activity_train",
  "X_test", "X_train",
  "subject", "activity", "X",
  "features", "X.cols",
  "activities", "activity_labels", "act"
))



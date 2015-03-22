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

library(dplyr)

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
activity_label <- activities[activity$activity]

#    c. read the feature names into a vector
features <- read.table("features.txt")
X.cols <- features$V2

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
# fBodyBodyGyroJerk-{mean(),std()}-{x,y,z}
# fBodyAccMag-{mean(),std()}
# fBodyBodyAccJerkMag-{mean(),std()}
# fBodyBodyGyroMag-{mean(),std()}
# fBodyBodyGyroJerkMag-{mean(),std()}

# Each {x,y,z} value is 6 measurements ({mean(), std()} for {x,y.z});
# each other value is 2 measurements ({mean(), std()}.
# There are 8 {x,y,z} measurements, and 9 {mean(),std()} measurements, for
# a total of 8*6 + 9*2 = 66 retained measurements.
#
# Select only the mean() and std() observations.
X <- select(X, contains("mean()"), contains("std()"))

# Combine subject, activity_label and X into a data.frame.
data <- cbind(subject, activity_label, X)

# We now have a fairly tidy data frame, with 66 variables + subject, activity.

#  4. Appropriately label the data set with descriptive variable names. 
#   The first two column names seem straightforward: "subject", "activity".
#   The data measurement column names have the virtue of conciseness, but
#   they're inconvenient in R (data$tBodyAcc-mean()-Y doesn't behave
#   correctly). Therefore apply a simple transformation to the original
#   column names: remove parens, substitute underscore for dash.
names <- names(data)
names <- gsub("()", "", names, fixed=TRUE)
names <- gsub("-", "_", names, fixed=TRUE)
colnames(data) <- names

#  5. From the data set in step 4, create a second, independent tidy data 
#     set with the average of each variable for each activity and each
#     subject.

data2 <- group_by(data, subject, activity_label)
# At this point, summarize(data2, count=n()) delivers 180 rows - that's 30
# subjects, each with an entry per each of the 6 activity labels.

# Here's a handy function for generating string names for summarize():
make_means <- function(x) { sprintf("mean(%s)", x) }

# Make a list of strings, like this: "mean(tBodyAcc_mean_X)",
# "mean(tBodyAcc_mean_Y)", ...
tidy_means <- lapply(names(data)[3:length(names(data))], make_means)
tidy_names <- lapply(names(data)[3:length(names(data))], make.names)
# Use the SE version of summarize, so the list of summary vars can be passed
# in.
tidy_data <- summarize_(data2, .dots = setNames(tidy_means, tidy_names))
tidy_data_file <- "tidy_data.txt"

# Write out the data.
write.table(tidy_data, file = tidy_data_file, row.name=FALSE)

# Helpful message for the user.
cat(sprintf("Tidy data has been written to '%s'.\n", tidy_data_file))
cat(sprintf("Read it back in with:\n    t <- read.table(\"%s\", header=TRUE)\n", tidy_data_file))


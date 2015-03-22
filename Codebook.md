# Codebook for Course Project, Getting and Cleaning Data

This file explains the format of the tidy data contained in "tidy_data.txt".
For instructions on how to run the script and produce the tidy data, see
Readme.md.

## Loading the data
**tidy_data.txt** contains space-separated data. The data can be read into R as follows:

`tidy_data <- read.table("tidy_data.txt", header=TRUE)`

## Data description
`tidy_data` is a data.frame with dimensions 180 rows, 68 columns. Here's an excerpt (`tidy_data[1:7, 1:4]`):

|         | subject        | activity_label     | tBodyAcc_mean_X | tBodyAcc_mean_Y | ... |
|---------|----------------|--------------------|-----------------|-----------------|-----|
| 1       |   1            | LAYING             | 0.2215982       | -0.040513953    |...  |
| 2       |   1            | SITTING            | 0.2612376       | -0.001308288    |...  |
| 3       |   1            | STANDING           | 0.2789176       | -0.016137590    |...  |
| 4       |   1            | WALKING            | 0.2773308       | -0.017383819    |...  |
| 5       |   1            | WALKING_DOWNSTAIRS | 0.2891883       | -0.009918505    |...  |
| 6       |   1            | WALKING_UPSTAIRS   | 0.2554617       | -0.023953149    |...  |
| 7       |   2            |         LAYING     | 0.2813734       | -0.018158740    |...  |

The row ordering is as follows: for each of 30 subjects, for each of 6 activities. 66 measurement values are given for each subject/activity pair.

## Measurement naming
Only measurements consisting of mean() or std() values were retained from the original data set. That is:
* tBodyAcc-{mean(),std()}-{x,y,z}
* tBodyAccJerk{mean(),std()}-{x,y,z}
* tBodyGyro-{mean(),std()}-{x,y,z}
* tBodyGyroJerk-{mean(),std()}-{x,y,z}
* tGravityAcc-{mean(),std()}-{x,y,z}
* tBodyAccMag-{mean(),std()}
* tBodyAccJerkMag-{mean(),std()}
* tBodyGyroMag-{mean(),std()}
* tBodyGyroJerkMag-{mean(),std()}
* tGravityAccMag-{mean(),std()}
* fBodyAcc-{mean(),std()}-{x,y,z}
* fBodyAccJerk-{mean(),std()}-{x,y,z}
* fBodyGyro-{mean(),std()}-{x,y,z}
* fBodyBodyGyroJerk-{mean(),std()}-{x,y,z}
* fBodyAccMag-{mean(),std()}
* fBodyBodyAccJerkMag-{mean(),std()}
* fBodyBodyGyroMag-{mean(),std()}
* fBodyBodyGyroJerkMag-{mean(),std()}

That is, mean() and std() values for x, y and z components, and also mean() and std() values for the magnitudes of some of those values. The interpretation of the measurement names is as follows:
  * prefix 't' or 'f' means "time" or "frequency" measurement, respectively
  * "Body" measurements and "Gravity" measurements are the result of separating the original data with a low-pass filter (corner frequency 0.3 Hz). (Gravity measurements are the lower-frequency component.)
  * "Jerk" signals are derived velocity
  * "Acc" and "Gyro" are linear acceleration and angular velocity, respectively
  * "Mag" is a magnitude calculation from the original x,y,z components.

In order to retain the connection to the original data, but also come up with measurement names which are valid R identifiers, I apply this transformation:
  1. remove parentheses
  1. substitute underscore ('_') for hyphen ('-')
So for example, tBodyAcc-mean()-x becomes tBodyAcc_mean_x.

## Measurements
For each subject, for each activity, a number of measurements exist in the original data set. The tidy data set contains the average (`mean()`) value of all original data values. For example, for subject 1, and activity "LAYING", there are 50 measurements for each measurement name, in the original data set. The mean of each of those 50 values is presented in the tidy data.

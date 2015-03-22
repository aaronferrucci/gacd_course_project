# Course Project: Getting and Cleaning Data

## Overview
This README describes the Course Project for Getting and Cleaning Data, part of the Data Science specialization from Johns Hopkins University and Coursera. The goal of the project is to produce a tidy data set from a large data set of labeled sensor data. The sensor data comes smart phone accelerometers, using 30 subjects, in a range of 6 activities. More information about the data can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The computed tidy data set consists of means of each of 66 derived accelerometer measurements (themselves being mean and standard deviations of actual sensor values). For each subject, and each activity, the mean of each of the 66 measurements is computed, producing a "wide" data set, as discussed here: https://class.coursera.org/getdata-012/forum/thread?thread_id=234. More information on the theory of tidy data can be found here: http://vita.had.co.nz/papers/tidy-data.pdf

## Explanation of the script
The script, **run_analysis.R**, proceeds as follows:
  1. reads subject test and training data into a single data.frame, `subject`
  2. reads activity test and traininng data into a single data.frame, `activity_label`
    * `activity_label` numerical values are replaced with their string equivalents, as defined in **activity_labels.txt**
  3. reads measurement test and training data into a single data.frame, `X`
    1. `X` column names are taken from **features.txt**
    2. duplicate column data (none of which are mean or std values) are removed
    3. `X` data is further reduced (columns are deleted), leaving only those columns which consist of mean or standard deviation (that is, those names in **features.txt** which contain "mean()" or "std()"). There are 66 columns.
  4. constructs a data.frame, `data` containing `subject`, `activity_label` and `X` (measurement data).
  5. "Tidy" names for the measurements are now produced. Tidiness here is a qualitative judgement. I have chosen a naming scheme which is similar to that of the original data set (to simplify the job of a worker who needs to go back to the original data set), but with names which are legal in R. So, for example, "tBodyAcc-mean()-X" is transformed to "tBodyAcc_mean_X".
  6. produces the output tidy data set using `summarize_`. The `.dots` parameter to `summarize_` is used, so that columns can have the same tidy names as described in step 5, while the summarizing operation is `mean()`.
  7. Tidy data is written to **tidy_data.txt**, with headers. To read the data back into R, do:

    `t <- read.table("tidy_data.txt", header=TRUE)`

    See Codebook.md for a full description of the tidy data.  

## Steps to Reproduce
  1. **run_analysis.R** depends on `dplyr`, so if that package is not installed, do `install.packages("dplyr")`.
  1. Download the source data into an empty directory, and unzip it. Data is here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  2. You should see a subdirectory, **UCI HAR Dataset**
  1. Download **run_analysis.R** from this repo into the **UCI HAR Dataset** subdirectory. At this point, you should see this directory structure:
    * UCI HAR Dataset/
      * test/
        * Inertial Signals/
        * subject_test.txt
        * X_test.txt
        * y_test.txt
      * train/
        * Inertial Signals/
        * subject_train.txt
        * X_train.txt
        * y_train.txt
      * activity_labels.txt
      * features.txt
      * features_info.txt
      * README.txt
      * run_analysis.R
  1. Open RStudio, and `setwd()` to the **UCI HAR Dataset** directory.
  2. `source("run_analysis.R")`
  3. After the script finishes, it will have produced **tidy_data.txt**, and the RStudio environment will contain a `tbl` named `tidy_data`.
  4. The tidy data can be read back into a data.frame variable by doing

    `t <- read.table("tidy_data.txt", header=TRUE)`

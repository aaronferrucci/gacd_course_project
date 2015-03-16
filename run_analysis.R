
subject_test <- read.table("test/subject_test.txt", col.names=c("subject"))
subject_train <- read.table("train/subject_train.txt", col.names=c("subject"))
subject <- rbind(subject_test, subject_train)

activity_test <- read.table("test/y_test.txt", col.names=c("activity"))
activity_train <- read.table("train/y_train.txt", col.names=c("activity"))
activity <- rbind(activity_test, activity_train)

features <- read.table("features.txt")
X.cols <- features$V2

X_test <- read.table("test/X_test.txt", col.names=X.cols)
X_train <- read.table("train/X_train.txt", col.names=X.cols)
X <- rbind(X_test, X_train)

colnames(X) <- X.cols

data <- cbind(subject, activity, X)


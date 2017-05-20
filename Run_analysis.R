#04/05/2017 Leonardo Marques
#Download and unzip file
fname <- "UCIHARDS.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(url, fname)
unzip(fname)
# 1 - Merges the training and the test sets to create one data set.
# read train
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
sbj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
# read test
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
sbj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")


# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("UCI HAR Dataset/features.txt")
calc <- grep(".*mean.*|.*std.*", features[, 2])
calc.names <- features[calc,2]
x_train_final <- x_train[calc]
x_test_final <- x_test[calc]
# Merges data
test <- cbind(sbj_test,y_test,x_test_final)
train <- cbind(sbj_train,y_train,x_train_final)

# 3 - Uses descriptive activity names to name the activities in the data set
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
# 4 - Appropriately label the data set with descriptive variable names
all <- rbind(train,test)
calc.names <- gsub('-','',calc.names)
calc.names <- gsub('[()]','',calc.names)
colnames(all) <- c("subject", "activity", calc.names)

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
all$activity <- factor(all$activity, levels = act_labels[,1], labels = act_labels[,2])
all$subject <- as.factor(all$subject)

all.melted <- melt(all, id = c("subject", "activity"))
all.mean <- dcast(all.melted, subject + activity ~ variable, mean)

write.table(all.mean, "tidy.txt", row.names = FALSE, quote = FALSE)



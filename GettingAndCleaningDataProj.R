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
# Merges data
train <- cbind(sbj_train, x_train, y_train)
test <- cbind(sbj_test, x_test, y_test)

# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("UCI HAR Dataset/features.txt")
calc <- grep(".*mean.*|.*std.*", features[, 2])
calc.names <- features[calc,2]

# 3 - Uses descriptive activity names to name the activities in the data set
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
# all rows of the first column receives the labels from the act_labels variable.
y[,1] <- act_labels[y[,1],2]

# 4 - Appropriately label the data set with descriptive variable names
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", )

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
allData$activity <- factor(allData$activity, levels = act_labels[,1], labels = act_labels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)



# Source of data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# got in 20140514T1116PM -3GMT

# 1. Merges the training and the test sets to create one data set.

trainFile <- read.table("UCI_HAR_Dataset/train/X_train.txt")
testFile <- read.table("UCI_HAR_Dataset/test/X_test.txt")
X <- rbind(trainFile, testFile)

trainFile <- read.table("UCI_HAR_Dataset/train/subject_train.txt")
testFile <- read.table("UCI_HAR_Dataset/test/subject_test.txt")
SUBJECT <- rbind(trainFile, testFile)

trainFile <- read.table("UCI_HAR_Dataset/train/y_train.txt")
testFile <- read.table("UCI_HAR_Dataset/test/y_test.txt")
Y <- rbind(trainFile, testFile)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("UCI_HAR_Dataset/features.txt")
onlyMeanAndStd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, onlyMeanAndStd]
names(X) <- features[onlyMeanAndStd, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))  

# 3. Uses descriptive activity names to name the activities in the data set

activities <- read.table("UCI_HAR_Dataset/activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"

# 4. Appropriately labels the data set with descriptive activity names.

names(SUBJECT) <- "subject"
cleaned <- cbind(SUBJECT, Y, X)
write.table(cleaned, "full_data_set.txt")

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

uniqueSubjects = unique(SUBJECT)[,1]
numSubjects = length(unique(SUBJECT)[,1])
numActivities = length(activities[,1])
numCols = dim(cleaned)[2]
result = cleaned[1:(numSubjects*numActivities), ]

row = 1
for (subject in 1:numSubjects) {
	for (activity in 1:numActivities) {
		result[row, 1] = uniqueSubjects[subject]
		result[row, 2] = activities[activity, 2]
		tmp <- cleaned[cleaned$subject==subject & cleaned$activity==activities[activity, 2], ]
		result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
		row = row+1
	}
}
write.table(result, "tidy_data_set.txt")
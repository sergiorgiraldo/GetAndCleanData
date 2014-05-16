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
names(X) <- gsub('\\(|\\)',"", names(X), perl = TRUE)
names(X) <- gsub('\\-',"", names(X), perl = TRUE)
names(X) <- gsub('\\,',"", names(X), perl = TRUE)

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names.

activities <- read.table("UCI_HAR_Dataset/activity_labels.txt")
activities[, 2] = gsub('\\_', "", activities[, 2], perl = TRUE)
Y[,1] = activities[Y[,1], 2]
names(Y) <- paste("activity")

names(SUBJECT) <- paste("subject")

merged <- cbind(SUBJECT, Y, X)

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

uniqueSubjects = unique(SUBJECT)[,1]
numSubjects = length(uniqueSubjects)
numActivities = length(activities[,1])
numCols = dim(merged)[2]
result = merged[1:(numSubjects*numActivities), ]

index = 0
for (subject in 1:numSubjects) {
	for (activity in 1:numActivities) {
		index = index + 1
		result[index, 1] = uniqueSubjects[subject]
		result[index, 2] = activities[activity, 2]
		filtered <- merged[merged$subject==subject & merged$activity==activities[activity, 2], ]
		result[index, 3:numCols] <- colMeans(filtered[, 3:numCols])
	}
}
write.table(result, "tidy_data_set.txt", sep="\t")
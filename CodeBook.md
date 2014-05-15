# 1. merges the training and test sets to create one data set

merge train/X_train.txt with test/X_test.txt  into a 10299 x 561 data frame with instances and attributes

merge train/subject_train.txt with test/subject_test.txt into a 10299 x 1 data frame with subject IDs,

merge train/y_train.txt with test/y_test.txt into a 10299 x 1 data frame with activity IDs.

# 2.  extracts only the measurements on the mean and standard deviation for each measurement.

Read file features.txt and there are only 66 attributes which are measurements on the mean and standard deviation.

#3 uses descriptive activity names to name the activities in the data set

Read file activity_labels.txt 

#4 appropriately labels the data set with descriptive activity names. 

all attributes and activity names are converted to lower case and special characters are deleted

merges instance data frame with subject IDs data frame and activity IDs data frame. The latest data frames were generated in step #1

First column is subject ID, econd column is activity name and remaining columns are actual measurements

#5 creates a second, independent tidy data set with the average of each variable for each activity and each subject

just calculate mean on data generated in step #4

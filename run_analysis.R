# Script to process Human Activity Recognition Using Smartphones Data Set
#
# Prequisites for executing this script:
#
# 1. The Data Set needs to be downloaded to the computer that is going to execute the script.
# 2. The data has been unzipped in the same structure as contained within the dataset
# 3. The data set files all exist in folder called UCI HAR Dataset in the 
#    current working directory, otherwise the files will not be found
#
# The overall flow of the script is as follows:
#
# 1. Check for all required packages needed for this analysis and if they
#    are not installed, install them
# 2. Read the train and test data sets from files
# 3. Merge them into a single data set
# 4. Extract just the mean and standard deviation for each measurement
# 5. Apply descriptive activity names
# 6. Apply descriptive label names
# 7. Write the tidy data set to a file


# 1. Check for required packages and install if not present
if("dplyr" %in% rownames(installed.packages()) == FALSE) {install.packages("dplyr")};library(dplyr)

# 2. Read the train and test data sets from files
mainFolder <- "UCI HAR Dataset"
trainFolder <- paste(mainFolder, "/train/", sep="")
testFolder <- paste(mainFolder, "/test/", sep="")

# check if the test and train folder are present in the working directory
# and stop execution if they aren't
if (!file.exists(mainFolder)) {
  errMsg <- paste("The ", mainFolder, " is not in the working directory.")
  stop(errMsg)
}

# load the observation data for both test and train and combine it
xTrain <- read.table(paste(trainFolder, "X_train.txt", sep=""))
xTest <- read.table(paste(testFolder, "X_test.txt", sep=""))
observationData <- rbind(xTrain, xTest)

# load the activity data from both the test and train and combine it
yTrain <- read.table(paste(trainFolder, "y_train.txt", sep=""), col.names = c("activity"))
yTest <- read.table(paste(testFolder, "y_test.txt", sep=""), col.names = c("activity"))
activityData <- rbind(yTrain, yTest)

# load the subject data from both test and train and combine it
subjectTrain <- read.table(paste(trainFolder, "subject_train.txt", sep=""), col.names=c("subject"))
subjectTest <- read.table(paste(testFolder, "subject_test.txt", sep=""), col.names=c("subject"))
subjectData <- rbind(subjectTrain, subjectTest)

# load data for all of the features/measurements that exist in the observations
featuresLabels <- read.table(paste(mainFolder, "/features.txt", sep=""), col.names=c("id", "name"))
fullFeatures <- c(as.vector(featuresLabels[, "name"]))

# since we don't want all of the features/measurements, we only want mean and 
# std dev, we need to filter the list
featuresSubset <- grepl("mean|std", fullFeatures)

# with the subset of features now set we need to filter the full observation
# data set for only those values required
filteredObservationData <- observationData[, featuresSubset]

# load the activity labels so that the data will be easier to read and understand
activityLabels <- read.table(paste(mainFolder, "/activity_labels.txt", sep=""), col.names=c("id", "label"))

# merge the activity labels with the activity data on the id column
labeledActivityData <- merge(activityData, activityLabels, by.x="activity", by.y="id")

# now we don't want the id column in the final data so we don't select it
labeledActivityData <- labeledActivityData[, !(names(labeledActivityData) %in% c("id", "id"))]

# create final data set by combining everything together
finalDataset <- cbind(subjectData, labeledActivityData, filteredObservationData)

# now we need to sumamrize the data set to calculate the average of each one of the
# observations by subject

# this is missing due to time constraints

# write the data set out to a file
write.table(finalDataset, file="tidydata.txt", row.name=FALSE)





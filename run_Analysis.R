##########################################################################################################
## Coursera Getting and Cleaning Data Course Project
## Hennie de Nooijer
## 2015-06-10

# run_Analysis.R File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set.
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
##########################################################################################################

# needed libraries
library(plyr)  # for table  
library(knitr) # for creating a codebook

# Set the working directory to the correct folder D:\Certificering\Coursera Data Science Specialization (R)\3. Coursera Getting and Cleaning Data\Course Project
setwd("D:\\Certificering\\Coursera Data Science Specialization (R)\\3. Coursera Getting and Cleaning Data\\Course Project")

getwd()
list.files()

# read the data from the files into R tables
xtest       = read.table(".\\UCI HAR Dataset\\test\\X_test.txt", header = FALSE)        # X_test.txt
ytest       = read.table(".\\UCI HAR Dataset\\test\\y_test.txt", header = FALSE)        # y_test.txt
subjecttest = read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", header = FALSE)  # subject_test.txt

xtrain        = read.table(".\\UCI HAR Dataset\\train\\X_train.txt", header = FALSE)    # X_train.txt
ytrain        = read.table(".\\UCI HAR Dataset\\train\\y_train.txt", header = FALSE)    # y_train.txt
subjecttrain  = read.table("UCI HAR Dataset\\train\\subject_train.txt", header = FALSE) # subject_train.txt

features     = read.table('.\\UCI HAR Dataset\\features.txt', header = FALSE)        #import features.txt
activitytype = read.table('.\\UCI HAR Dataset\\activity_labels.txt',header = FALSE)  #import activity_labels.txt

# Research of the data.
# dim(xtest)        # 2947  561
# dim(ytest)        # 2947    1
# dim(subjecttest)  #2947     1
# dim(xtrain)       #7352   561
# dim(ytrain)       #7352     1
# dim(subjecttrain) #7352     1
# dim(features)     #561      2
# dim(activityType) #6        2
# 
# str(xtest)
# str(ytest)
# str(subjecttest)
# str(xtrain)
# str(ytrain)
# str(subjecttrain)
# str(features)
# str(activityType)

# Assigin column names to the data
colnames(xtest)         = features[,2] 
colnames(ytest)         = "activityid"
colnames(subjecttest)   = "subjectid"
colnames(xtrain)        = features[,2] 
colnames(ytrain)        = "activityid"
colnames(subjecttrain)  = "subjectid"
colnames(activitytype)  = c('activityid','activitytype')

# Create the final set by merging ytrain, subjecttrain, and xtrain
testdata = cbind(ytest,subjecttest,xtest)
trainingdata = cbind(ytrain,subjecttrain,xtrain)

# Combine training and test data to create a final data set
finaldata = rbind(trainingdata,testdata)


# Give appropriate names to the columns
names(finaldata)<-gsub("^t", "time", names(finaldata))
names(finaldata)<-gsub("^f", "frequency", names(finaldata))
names(finaldata)<-gsub("Acc", "Accelerometer", names(finaldata))
names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))


#create an average dataset
aggregatedata<-aggregate(. ~subjectid + activityid, finaldata, mean)
aggregatedata<-aggregatedata[order(aggregatedata$subjectid, aggregatedata$activityid),]
write.table(aggregatedata, file = "tidydata.txt", row.name=FALSE)

# Create a CodeBook
knit2html("codebook.md");




#set working directory to the location where the UCI HAR Dataset was unzipped
setwd('Users/John Doe/Documents/Coursera/Data Science/Gettind and cleanning data/Project/Data/UCI HAR Dataset');

# Load data from files
features     = read.table('./features.txt',header=FALSE)
activityType = read.table('./activity_labels.txt',header=FALSE) 
subjectTrain = read.table('./train/subject_train.txt',header=FALSE) 
xTrain       = read.table('./train/x_train.txt',header=FALSE) 
yTrain       = read.table('./train/y_train.txt',header=FALSE)

subjectTest = read.table('./test/subject_test.txt',header=FALSE) 
xTest       = read.table('./test/x_test.txt',header=FALSE) 
yTest       = read.table('./test/y_test.txt',header=FALSE) 


# Fix column names 
colnames(activityType)  = c('activityId','activityType')
colnames(subjectTrain)  = "subjectId"
colnames(xTrain)        = features[,2] 
colnames(yTrain)        = "activityId"
colnames(subjectTest) = "subjectId"
colnames(xTest)       = features[,2] 
colnames(yTest)       = "activityId"

1- #Merge the training and the test sets to create one data set
# create the final training set by merging yTrain, subjectTrain, and xTrain
trainingData = cbind(yTrain,subjectTrain,xTrain)

# Create the final test set by merging the xTest, yTest and subjectTest data
testData = cbind(yTest,subjectTest,xTest)

# Combine training and test data to create a final data set
finalData = rbind(trainingData,testData)

2. Extract only the measurements on the mean and standard deviation for each measurement. 
# Create a vector for the column names from the finalData
colNames  = colnames(finalData) 

# subset the desired columns
finalData <- finalData[, mean_std_features]

# correct the column names
names(finalData) <- features[mean_std_features, 2]

# 3. Use descriptive activity names to name the activities in the data set

# Merge the finalData set with the acitivityType table to include descriptive activity names
finalData = merge(finalData,activityType,by='activityId',match = "first");
;

# Updating the colNames vector to include the new column names after merge
colNames  = colnames(finalData); 

# 4. Appropriately label the data set with descriptive activity names. 

# Cleaning up the variable names
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

# Reassigning the new descriptive column names to the finalData set
colnames(finalData) = colNames;

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
finalNoActivityData = ddply(finalData, c("subjectId","activityId"), numcolwise(mean))

# Export the tidyData set 
write.table(finalNoActivityData, file = "finalNoActivityData.txt")

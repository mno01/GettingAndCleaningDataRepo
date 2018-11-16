
#Download zip file
Url1 <- c("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
download.file(Url1, destfile = "C:/Users/mno01/Desktop/Data.zip")
TechData <- unzip("C:/Users/mno01/Desktop/Data.zip")

#Parse out Training and Test data sets
TrainingSubject = read.table('UCI HAR Dataset/train/subject_train.txt',header=FALSE)
TrainingSetX = read.table('UCI HAR Dataset/train/x_train.txt',header=FALSE)
TrainingLabelsY = read.table('UCI HAR Dataset/train/y_train.txt',header=FALSE)

TestSubject = read.table('UCI HAR Dataset/test/subject_test.txt',header=FALSE)
TestSetX = read.table('UCI HAR Dataset/test/x_test.txt',header=FALSE)
TestLabelsY = read.table('UCI HAR Dataset/test/y_test.txt',header=FALSE)


#Combine Training and Test data sets
SubjectDataSet <- rbind(TrainingSubject, TestSubject)
XDataSet <- rbind(TrainingSetX, TestSetX)
YDataSet <- rbind(TrainingLabelsY, TestLabelsY)

#Filter to Features only pertaining to mean and standard deviation
Features <- read.table("UCI HAR Dataset/features.txt", header = FALSE) 
XDataSet_mean_std <- XDataSet[, grep("-(mean|std)\\(\\)", Features[, 2])] ##search for "-mean()" or "-std()" and returns values in DataSetX
names(XDataSet_mean_std) <- Features[grep("-(mean|std)\\(\\)", Features[, 2]), 2] ##rename variable names of grep() results with Feature names


#Add Activity labels to YDataSet and add rename variable to "Activity"
ActivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE) 
YDataSet[, 1] <- ActivityLabels[YDataSet[, 1], 2]  
names(YDataSet) <- "Activity" 

#Rename variable to "Subject"
names(SubjectDataSet) <- "Subject"  

#Create a Master Data Set of all datasets (SubjectDataSet, YDataSet, and XDataSet_mean_Std)
MasterDataSet <- cbind(XDataSet_mean_std, YDataSet, SubjectDataSet)

#Add meaningful column names to MasterDataSet
names(MasterDataSet) <- make.names(names(MasterDataSet)) ##Standardize name and translate invalid characters to "."

#Use Regular Expressions and gsub() to search for abbreviated strings and replace them with more descriptive names
names(MasterDataSet) <- gsub('^t', 'Time',names(MasterDataSet))  
names(MasterDataSet) <- gsub('^f', 'Frequency', names(MasterDataSet)) 
names(MasterDataSet) <- gsub('Acc', 'Acceleration', names(MasterDataSet)) 
names(MasterDataSet) <- gsub('GyroJerk', 'AngularAcceleration', names(MasterDataSet)) 
names(MasterDataSet) <- gsub('Gyro','AngularSpeed',names(MasterDataSet))
names(MasterDataSet) <- gsub('Mag', 'Magnitude', names(MasterDataSet))
names(MasterDataSet) <- gsub('\\.std',".StandardDeviation",names(MasterDataSet))
names(MasterDataSet) <- gsub('\\.mean',".Mean",names(MasterDataSet))



# Create separate tidy data set by subsetting and averaging
TidyDataSet <- aggregate(. ~Activity + Subject, MasterDataSet, mean) #splits data into subsets and computes average
write.table(TidyDataSet, file = "TidyDataSet.txt", row.name = FALSE)



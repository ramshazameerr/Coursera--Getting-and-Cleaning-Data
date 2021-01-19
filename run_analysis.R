traindata_x <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt") #loading data
traindata_y <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")


testdata_x <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
testdata_y <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

library(dplyr)
merged_X <- rbind(traindata_x, testdata_x) #merging both datasets
merged_Y <- rbind(traindata_y, testdata_y)
merged_sub <-  rbind(subject_train, subject_test)

#naming the columns with feature file
features <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
activity <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")


#extract names with mean and std in features file
selectedfeatures <- features[grepl("mean()|std()", as.character(features[,2]) ), 2]
selectedcol <- grepl("mean()|std()", as.character(features[,2]) )
selectedData_X <- merged_X[selectedcol]

#combine all data and set thier column names
all_data <- cbind(merged_sub,merged_Y , selectedData_X)
colnames(all_data ) <- c("Subject", "Activity", selectedfeatures) 
all_data$Activity <- factor(all_data$Activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#average value by activity and subject 
aggregated_data <- aggregate(all_data[, 3:ncol(all_data)], list(all_data$Activity,all_data$Subject ), mean, na.rm = TRUE)
write.table(aggregated_data, file = "tidydata.txt" ,row.name=FALSE)
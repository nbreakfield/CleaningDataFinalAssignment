#You should create one R script called run_analysis.R that does the following.

#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement.
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names.
#5.From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.

library(plyr)
library(dplyr)

test<-read.table("UCI_HAR_dataset/test/X_test.txt")
subject_test<-read.table("UCI_HAR_dataset/test/subject_test.txt")
train<-read.table("UCI_HAR_dataset/train/X_train.txt")
subject_train<-read.table("UCI_HAR_dataset/train/subject_train.txt")
activity_test<-read.table("UCI_HAR_dataset/test/y_test.txt")
activity_train<-read.table ("UCI_HAR_dataset/train/y_train.txt")
#these are all the files that will be merged

subject<-rbind(subject_test, subject_train)
colnames(subject)<-c("subject")
head(subject)
#this makes the column with the subject code for both test and train

activity<-rbind(activity_test, activity_train)
colnames(activity)<-c("activity_code")
head(activity)
#this makes the column with the activity code for both test and train

dataset<-rbind(test,train)
#this combines the test and train files into one file
              
head(dataset)
tail(dataset)
#these are just to check that things look right

features<-read.table("UCI_HAR_dataset/features.txt")
#features contains the descriptive names for each column as needed in step 4

col<-features[,2]
colnames(dataset)<-col
colnames(dataset)
# adds the feature names to each column

valid_column_names <- make.names(names=names(dataset), unique=TRUE, allow_ = TRUE)
names(dataset) <- valid_column_names
#makes column names unique so I don't get error
#data are labeled as in step 4

dataset<-cbind(subject, activity, dataset)
#combines the subject and activity columns with the rest of the dataset
#this is now the final merged dataset in step 1
#dim(dataset)
#[1] 10299   563
#just wanted to check the size

activity_labels<-read.table("UCI_HAR_dataset/activity_labels.txt")
activity_labels
colnames(activity_labels)<-c("activity_code", "activity_name")
dataset2<-merge(dataset, activity_labels, by.x="activity_code", by.y="activity_code", all.x=TRUE, all.y=FALSE)
#this adds the activity labels as a column
#this is result from step 3

head(dataset[,1:30],3)
#just to check that the column names are correct

head(dataset2)
tail(dataset2)
colnames(dataset2)
class(dataset2$activity)
dim(dataset2)
#other ways to check that everything looks right

mean_std<-select(dataset2, contains("mean"), contains("std"))
dim(mean_std)
#selects only variables with the mean and std as in step 2

activity_label<-dataset2$activity_name
tidy4<-cbind(subject, activity, activity_label, mean_std)
tidy4<-tbl_df(tidy4)
#adds back in subject, activity, activity_name to the file with mean and std to make tidy data in step 4
dim(tidy4)
#[1] 10299    89
#just to check the size - now only contains columns with mean and std in name

tidy5<-tidy4 %>%
        group_by(subject, activity_code) %>%
        select (tBodyAcc.mean...X:fBodyBodyGyroJerkMag.std..) %>% 
        summarize_each(funs(mean))
# this is the result of step 5 - means for each column grouped by subject and activity code.

dim(tidy5)
#[1] 180  88
#this is the correct size since 30 subjects x 6 activities = 180

write.table(tidy5, file="tidy5.txt", row.name=FALSE)
#write table to home directory




























        
        

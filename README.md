---
title: "Getting and Cleaning Data Final Assignment"
author: "Natalie Breakfield"
date: "May 16, 2016"
output: html_document
---
```
{library(plyr)
library(dplyr)
```
```
test<-read.table("UCI_HAR_dataset/test/X_test.txt")
subject_test<-read.table("UCI_HAR_dataset/test/subject_test.txt")
train<-read.table("UCI_HAR_dataset/train/X_train.txt")
subject_train<-read.table("UCI_HAR_dataset/train/subject_train.txt")
activity_test<-read.table("UCI_HAR_dataset/test/y_test.txt")
activity_train<-read.table ("UCI_HAR_dataset/train/y_train.txt")
```
These are all the files that will be merged.

```
subject<-rbind(subject_test, subject_train)
colnames(subject)<-c("subject")
activity<-rbind(activity_test, activity_train)
colnames(activity)<-c("activity_code")
```
These are the columns for subject and activity

```
dataset<-rbind(test,train)
features<-read.table("UCI_HAR_dataset/features.txt")
col<-features[,2]
colnames(dataset)<-col
valid_column_names <- make.names(names=names(dataset), unique=TRUE, allow_ = TRUE)
names(dataset) <- valid_column_names

```
First combines test and train files, then adds the column names as in the features file, and then makes sure the names are unique.
```
dataset<-cbind(subject, activity, dataset

```
Finally all the data are in one file with the subject and activity added for step 1 and eventually step 4.
```
activity_labels<-read.table("UCI_HAR_dataset/activity_labels.txt")
activity_labels
colnames(activity_labels)<-c("activity_code", "activity_name")
dataset2<-merge(dataset, activity_labels, by.x="activity_code", by.y="activity_code", all.x=TRUE, all.y=FALSE)

```
This adds the activity labels as in step 3.
```
mean_std<-select(dataset2, contains("mean"), contains("std"))

```
This selects only variables with the mean and std as in step 2.
```
activity_label<-dataset2$activity_name
tidy4<-cbind(subject, activity, activity_label, mean_std)
tidy4<-tbl_df(tidy4)

```
This adds back in subject, activity, activity_name to the file with mean and std to make tidy data in step 4.
```
tidy5<-tidy4 %>%
        arrange(subject) %>%
        group_by(subject, activity_label) %>%
        summarize_each(funs(mean))

```
This gives the result for step 5.
```
write.table(tidy5, file="tidy5.txt", row.name=FALSE)

```
This writes the result to a text file for submission.







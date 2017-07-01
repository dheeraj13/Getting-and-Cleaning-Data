#Read test files
xtest<- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <-read.table("UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#Read train files
xtrain <-read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <-read.table("UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Read activity labels and features files
act_lab <-read.table("UCI HAR Dataset/activity_labels.txt")
features <-read.table("UCI HAR Dataset/features.txt")

#Get features which have mean aor std in their names
mn_and_std_feat <- grep("-(mean|std)\\(\\)", features[, 2])

#combine xtest and ytest. select only columns with mean and std 
cdata <- rbind(xtest,xtrain)
data <- cdata[,mn_and_std_feat]
names(data) <- features[mn_and_std_feat, 2]

#combine ytest and ytrain. replace numeric value by corresponding activity name
act <- rbind(ytest,ytrain)
act[,1] <- act_lab[act[,1],2]
names(act) <- "Activities"

#combine sub_test and sub_train. Name column as Subject
subject <- rbind(sub_test,sub_train)
names(subject) <- "Subject"

#combine all fields
comp_data <- cbind(subject,act,data)


avg_data<- aggregate(.~Subject + Activities, comp_data,mean)
avg_data <- avg_data[order(avg_data$Subject,avg_data$Activities),]

write.table(avg_data,"tidy_set.txt",row.names = FALSE)

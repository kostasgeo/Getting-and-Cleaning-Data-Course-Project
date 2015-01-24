################
# Pre-requisites
################
# a. Set data path
filePath <- file.path("/Users/konstantinos/Dropbox/Courses/GettingAndCleaningData", "UCI HAR Dataset")
# Set list of files
filesList <- list.files(filePath, recursive = T, full.names = T)
# b. Install and load dplyr package for manipulating data frames
install.packages("dplyr") 
library(dplyr)
# b. Read files
test_labels <- read.table(file.path(filePath, "test", "y_test.txt"))
train_labels <- read.table(file.path(filePath, "train", "y_train.txt"))
test_set <- read.table(file.path(filePath, "test", "x_test.txt"))
train_set <- read.table(file.path(filePath, "train", "X_train.txt"))
test_subject <- read.table(file.path(filePath, "test", "subject_test.txt"))
train_subject <- read.table(file.path(filePath, "train", "subject_train.txt"))
################
# 1. Merge the training and the test sets to create one data set.
################
labels <- rbind(test_labels, train_labels) #activity
names(labels) <- c("labels")
set <- rbind(test_set, train_set) #features
subject <- rbind(test_subject, train_subject)
names(subject) <- c("subject")
data <- cbind(cbind(set, subject), labels)
################
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
################
# Set the variables names (set) from the 'features.txt' file (2nd column)
variablesNames <- read.table(file.path(filePath, "features.txt"), head = F)
names(set) <- variablesNames$V2
# Extract mean and std measurements
mean_std <- subset(data, select=grepl("mean|std", names(set))) 
################
# 3. Use descriptive activity names to name the activities in the data set
################
mean_std <- mutate(mean_std, labels = real_labels[labels, 2])
################
# 4. Appropriately label the data set with descriptive variable names. 
################
names(set) <- gsub("^t", "time", names(set))
names(set) <- gsub("^f", "frequency", names(set))
names(set) <- gsub("Acc", "Accelerometer", names(set))
names(set) <- gsub("Gyro", "Gyroscope", names(set))
names(set) <- gsub("Mag", "Magnitude", names(set))  
names(set) <- gsub("BodyBody", "Body", names(set)))
################
# 5. From the data set in step 4, create a second, 
# independent tidy data set with the average of 
# each variable for each activity and each subject.
################
data_means <- aggregate(data, by = list(data$subject, data$labels), FUN = mean)

# Write data set of step 5 to text file
write.table(data_means, file="data_new.txt", row.name = F)
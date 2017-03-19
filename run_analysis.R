# Course: Coursera - Data Science Specialization
# Course project: Getting and Cleaning Data
# Course participant: Mirjam Hachem

# This is the R Script run_analysis.R

# Find the README here: 
# https://github.com/MirjamHachem/datasciencecoursera/blob/master/README%20Getting%20and%20Cleaning%20Data.md

# Find the codebook here: 
# https://github.com/MirjamHachem/datasciencecoursera/blob/master/Codebook.txt


# PLEASE NOTE:
# From the description of the assignment, it was not clear to me
# whether the the tasks 3 to 5 have to be executed to the data
# set created in 1 or the dataset extracted in 2. I therefore
# applied all the operations to both datasets.

# 0. DATA IMPORT

Training_Measurements <- read.table("./UCI HAR Dataset/train/X_train.txt")
Training_Subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
Training_Activity_Numbers <- read.table("./UCI HAR Dataset/train/y_train.txt")
Test_Measurements <- read.table("./UCI HAR Dataset/test/X_test.txt")
Test_Subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
Test_Activity_Numbers <- read.table("./UCI HAR Dataset/test/y_test.txt")
Activity_Names <- read.table("./UCI HAR Dataset/activity_labels.txt")
Measurement_Names <- read.table("./UCI HAR Dataset/features.txt")


# 1. MERGING THE TRAINING AND THE TEST SET TO CREATE ONE DATASET

Combined_Measurements <- rbind(Training_Measurements, Test_Measurements)
colnames(Combined_Measurements) = Measurement_Names$V2

Combined_Subjects <- rbind(Training_Subjects, Test_Subjects)
colnames(Combined_Subjects) = "Subjects"

Combined_Numbers <- rbind(Training_Activity_Numbers, Test_Activity_Numbers)
colnames(Combined_Numbers) = "ActivityNumber"

Total_Set <- cbind(Combined_Numbers, Combined_Subjects, Combined_Measurements)


# 2. EXTRACT THE MEASUREMENTS ON THE MEAN AND THE STANDARD DEVIATION FOR EACH MEASUREMENT

Mean <- grep("mean()", names(Total_Set), value=TRUE)
Mean_Set <- Total_Set[, Mean]

SD <- grep("std()", names(Total_Set), value=TRUE)
SD_Set <- Total_Set[, SD]

Combined_Mean_SD <- cbind(Mean_Set, SD_Set)

Subset_Subject_Activity <- Total_Set[, 1:2]

Combined_Mean_SD_Subject_Activity <- cbind(Subset_Subject_Activity, Combined_Mean_SD)


# 3. USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET

# For Total_Set
colnames(Activity_Names) <- c("ActivityNumber", "ActivityName")

Total_Set_With_Names <- merge(x = Total_Set, y = Activity_Names, by = "ActivityNumber")

# Rearragne columns so that the activity names are in front
Total_Set_With_Names <- cbind(Total_Set_With_Names[, 564], Total_Set_With_Names[, -(564)])

colnames(Total_Set_With_Names)[1] <- "ActivityName"

# For Combined_Mean_SD_Subject_Activity
Combined_Mean_SD_With_Names <- merge(x=Combined_Mean_SD_Subject_Activity, y=Activity_Names, by="ActivityNumber")

# Rearragne columns so that the activity names are in front
Combined_Mean_SD_With_Names <- cbind(Combined_Mean_SD_With_Names[, 82], Combined_Mean_SD_With_Names[, -(82)])
colnames(Combined_Mean_SD_With_Names)[1] <- "ActivityName"


# 4. LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES  

# Rename the objcets Total_Set_With_Names and 
# Combined_Mean_SD_With_Names into shorter 
# object names for better readability.
Complete_Set <- Total_Set_With_Names
Extract_Set <- Combined_Mean_SD_With_Names

# Adjust variable names in Complete_Set 
names(Complete_Set) <- gsub("^t", "time", names(Complete_Set))
names(Complete_Set) <- gsub("^f", "frequency", names(Complete_Set))
names(Complete_Set) <- gsub("BodyBody", "Body", names(Complete_Set))
names(Complete_Set) <- gsub("Acc", "Accelerometer", names(Complete_Set))
names(Complete_Set) <- gsub("Gyro", "Gyroscope", names(Complete_Set))
names(Complete_Set) <- gsub("Mag", "Magnitude", names(Complete_Set))
names(Complete_Set) <- gsub("std", "sd", names(Complete_Set))
names(Complete_Set) <- gsub("arCoeff", "autoregressiveCoefficient", names(Complete_Set))
names(Complete_Set) <- gsub("maxInds", "maxIndex", names(Complete_Set))
names(Complete_Set) <- gsub("meanFreq", "meanFrequency", names(Complete_Set))
names(Complete_Set) <- gsub("bands", "interval", names(Complete_Set))

# Cleaning variable names in Complete_Set
names(Complete_Set) <- gsub("-", ".", names(Complete_Set))
names(Complete_Set) <- gsub(",", ".", names(Complete_Set))
names(Complete_Set) <- gsub("[()]", "", names(Complete_Set))

# Adjusting variable names in Extract_Set
names(Extract_Set) <- gsub("^t", "time", names(Extract_Set))
names(Extract_Set) <- gsub("^f", "frequency", names(Extract_Set))
names(Extract_Set) <- gsub("BodyBody", "Body", names(Extract_Set))
names(Extract_Set) <- gsub("Acc", "Accelerometer", names(Extract_Set))
names(Extract_Set) <- gsub("Gyro", "Gyroscope", names(Extract_Set))
names(Extract_Set) <- gsub("Mag", "Magnitude", names(Extract_Set))
names(Extract_Set) <- gsub("std", "sd", names(Extract_Set))

# Cleaning variable names in Extract_Set
names(Extract_Set) <- gsub("-", ".", names(Extract_Set))
names(Extract_Set) <- gsub("[()]", "", names(Extract_Set))


# 5. CREATE A SECOND INDEPENDENT TIDY DATASET WITH THE AVERAGE OF EACH VARIABLE FOR EACH 
#    ACTIVITY AND EACH SUBJECT

# Load the plyr package
library(plyr)

# For Complete_Set
Average_Complete_Set_Tidy <- ddply(Complete_Set, c("Subjects", "ActivityName"), numcolwise(mean))

# For Extract_Set
Average_Extract_Set_Tidy <- ddply(Extract_Set, c("Subjects", "ActivityName"), numcolwise(mean))

# Export the datasets into a text file
write.table(Average_Complete_Set_Tidy, file="TidyDataComplete.txt")
write.table(Average_Extract_Set_Tidy, file="TidyDataExtract.txt")

# In the description of the submission, it is asked to use the 
# write.table() function with row.names=FALSE. When I do this, 
# the column names are pushed down into the first row of the dataset
# and the variable names are replaced with default names V1, V2, V3 etc.
# This makes the dataset untidy again. I therefore provide both options.

write.table(Average_Complete_Set_Tidy, file="TidyDataComplete2.txt", row.names=FALSE)
write.table(Average_Extract_Set_Tidy, file="TidyDataExtract2.txt", row.names=FALSE)

# Thank you for grading my assignement! :-)

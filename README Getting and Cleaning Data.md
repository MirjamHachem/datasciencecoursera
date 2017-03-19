# Course: Coursera - Data Science Specialization
# Course project: Getting and Cleaning Data
# Course participant: Mirjam Hachem

## This is the README file for the R script run_analysis.R
# Find the R script here: 
# Find the codebook here:

## Short overview of the dataset that is used as input for this analysis
## Read codebook file for an extensive description of the study


# GET STARTED

## Download the data set here

https://d396qusza40orc.cloudfront.net
getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Follow these instructions

Unzip the file on your computer so that the name of the folder is
"UCI HAR Dataset". Put the folder in the working directory of 
your R environment.

PLEASE NOTE
From the description of the assignment, it was not clear to me
whether the the tasks 3 to 5 have to be executed to the dataset 
created in 1 or the dataset extracted in 2. I therefore
applied all the operations to both datasets.


# START WITH THE ANALYSIS HERE

# 0. DATA IMPORT

Measurements of the training set:
original file name: X_train.txt
object name: Training_Measurements
    
    Training_Measurements <- read.table("./UCI HAR Dataset/train/X_train.txt")


Subjects of the training set:
original file name: subject_train.txt
object name: Subjects_Training_Set
    
    Training_Subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")


Activity numbers of the training set:
orgiginal file name: y_train.txt
object name: Training_Activity_Numbers

    Training_Activity_Numbers <- read.table("./UCI HAR Dataset/train/y_train.txt")


Measurements of the test set:
- original file name: X_test.txt
- object name: Test_Measurements

    Test_Measurements <- read.table("./UCI HAR Dataset/test/X_test.txt")


Subjects of the test set
- original file name: subject_test.txt 
- object name: Test_Subjects

    Test_Subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")


Import the activity numbers of the test set:
- original file name: y_test.txt
- object name: Test_Activity_Numbers

    Test_Activity_Numbers <- read.table("./UCI HAR Dataset/test/y_test.txt")


List with pairings of activity numbers and activity names.
- original file name: activity_labels.txt
- object name: Activity_Names

    Activity_Names <- read.table("./UCI HAR Dataset/activity_labels.txt")


List with parings of measurement numbers and measurement names
 - original file name: features.txt
 - object name: Measurement_Names

    Measurement_Names <- read.table("./UCI HAR Dataset/features.txt")


# 1. MERGING THE TRAINING AND THE TEST SET TO CREATE ONE DATASET

Merge the sets containing training and test measurements
- using rbind() to attach the rows of the test set to the rows of the training set 
- object name: Combined_Measurements

    Combined_Measurements <- rbind(Training_Measurements, Test_Measurements)


Set the variable/column names for Combined_Measurements.

The 561 names given in Measurement_Names correspond to the 561 columns in 
Combined_Measurements. This means that we have to turn the row values of the second column of Measurement_Names into the column names of Combined_Measurements.


Look at the column names of Measurement_Names

    colnames(Measurement_Names)


Extract the row values in column V2 and set them as column names of Combined_Measurements

    colnames(Combined_Measurements) = Measurement_Names$V2


Merge the sets containing the training and test subjects
- using rbind() to attach the rows of the test 
subjects set to the rows of the training set
- object name: Combined_Subjects

    Combined_Subjects <- rbind(Training_Subjects, Test_Subjects)

Set the variable/column name of Combined_Subjects

    colnames(Combined_Subjects) = "Subjects"


Merge the sets containing the training and test activity numbers
- using rbind() to attach the rows of the set  with the test 
numbers to the rows of the set with the training numbers
- object name: Combined_Numbers

    Combined_Numbers <- rbind(Training_Activity_Numbers, Test_Activity_Numbers)

Set the variable/column name of Combined_Numbers

    colnames(Combined_Numbers) = "ActivityNumber"


Merge Combined_Measurements, Combined_Subjects, and Combined_Numbers to one data set
- using cbind() to attach the sets

    Total_Set <- cbind(Combined_Numbers, Combined_Subjects, Combined_Measurements)


# 2. EXTRACT THE MEASUREMENTS ON THE MEAN AND THE STANDARD 
#    DEVIATION FOR EACH MEASUREMENT

IMPORTANT: The columns containing the mean of the 
measurements have the string "mean()" in their 
column name. There is also the string "Mean" 
appearing in certain column names but these refer to
other measurements and are therefore excluded from 
the extraction.

Identify all column names containing the string "mean()" 
- using grep() to search the column names

    Mean <- grep("mean()", names(Total_Set), value=TRUE)


Subset the identified columns

    Mean_Set <- Total_Set[, Mean]


Identify all column names containing the string "std()"
- using grep() to search the column names

    SD <- grep("std()", names(Total_Set), value=TRUE)


Subset the identified columns

    SD_Set <- Total_Set[, SD]


Combine Mean_Set and SD_Set 

    Combined_Mean_SD <- cbind(Mean_Set, SD_Set)


Subset activity and subject numbers from Total_Set

    Subset_Subject_Activity <- Total_Set[, 1:2]


Attach activity and subject numbers to the combined set

    Combined_Mean_SD_Subject_Activity <- cbind(Subset_Subject_Activity, Combined_Mean_SD)


# 3. USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE 
#    ACTIVITIES IN THE DATA SET

In Total_Set, the activity numbers are stored in the second column. 
The pairings of activity numbers and activity names are given in 
Activity_Names. We nowhave to replace the activity numbers in 
Total_Set with the names given in Activity_Names.


Set the column names Activity_Names (V1 and V2) to 
match the column names in Total_Set

    colnames(Activity_Names) <- c("ActivityNumber", "ActivityName")


Add the activity names to Total_Set by merging Total_Set # and Activity_Names based on the variable ActivityNumber

    Total_Set_With_Names <- merge(x = Total_Set, y = Activity_Names, by = "ActivityNumber")


This operation attached the column with the activity
names to the right of the data frame. For a better 
overview, we want this column to be the first column
of the data frame. 
- using cbind() to move the column through subsetting and attaching

    Total_Set_With_Names <- cbind(Total_Set_With_Names[, 564], Total_Set_With_Names[, -(564)])


This operation changed the name of the column we moved,
so now we have to set the name to ActivityName again

    colnames(Total_Set_With_Names)[1] <- "ActivityName"


We can apply the same operations to the set containing the measurements of the mean and the standard deviation

    Combined_Mean_SD_With_Names <- merge(x=Combined_Mean_SD_Subject_Activity, y=Activity_Names, by="ActivityNumber")


Move column with activity numbers to front

    Combined_Mean_SD_With_Names <- cbind(Combined_Mean_SD_With_Names[, 82], Combined_Mean_SD_With_Names[, -(82)])


Change column name back to "ActivityNumber"

    colnames(Combined_Mean_SD_With_Names)[1] <- "ActivityName"


PLEASE NOTE: 
There is usually a more simple and elegant solution
to this movement operation using the select()
function from the dplyr package. The code would be:

dfNew <- df %>% select(LastColumnName, everything())

Unfortunately, this code cannot be applied to the above
datasets at this point for the column names contain 
invalid variable names due to the use of parentheses 
in the column names. The select() function only works in
data sets with valid variable names. If you want to use
select(), you first have to coerce the invalid variable
names to valid variable names with make.names(). 


# 4. LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES  

BEFORE WE PROCEED:

Rename the objcets Total_Set_With_Names and 
Combined_Mean_SD _With_Names into shorter 
object names for better readability.

    Complete_Set <- Total_Set_With_Names
    Extract_Set <- Combined_Mean_SD_With_Names

Look at the variable names of Complete_Set 
to see what we need to adjust

    colnames(Complete_Set)


### Meaning of partial variable names that can be made more descriptive

t = time of measurement
f = frequency of measurement
Body = body movement, appears dubble in some variables
Gravity = acceleration of gravity
Acc = measurement of accelerometer
Gyro = measurement of gyroscope
Mag = magnitude of movement
std = standard deviation
sma = signal magnitude area
iqr = interquartile range
arCoeff = autoregressive coefficients with Burg order equal to 4
maxInds = index of the frequency componen with largest magnitude
meanFreq = weigted average of the frequence components to obtain a mean frequency
bandsEnergy = energy of a frequency interval within the 64 bins of the FFT of each window


### Meaning of partial variable names that need not be changed

Jerk = sudden movement acceleration
mean = mean
mad = median absolute deviation
max = largest value in array
min - smallest value in array
sma = signal magnitude area
iqr = interquartile range
energy = energy measure, sum of the squares divided by the number of values
entropy = signal entropy
correlation = correlation coefficient between the two signals
skewness = skewness of the frequency domain signal
kurtosis = kurtosis of the requency domain signal
angle = angle between two vectors

### ADJUSTING VARIABLE NAMES

Adjust current variable names in Complete_Set to make them descriptive using gsub()

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

Cleaning the variable names from invalid and/or unnecessary symbols using gsub()

    names(Complete_Set) <- gsub("-", ".", names(Complete_Set))
    names(Complete_Set) <- gsub(",", ".", names(Complete_Set))
    names(Complete_Set) <- gsub("[()]", "", names(Complete_Set))


Making the relevant replacements for Extract_Set with the same operations


Look at the variable names of Extract_Set

    colnames(Extract_Set)


Replace the current variable names in Complete_Set with  descriptive variable names using gsub()

    names(Extract_Set) <- gsub("^t", "time", names(Extract_Set))
    names(Extract_Set) <- gsub("^f", "frequency", names(Extract_Set))
    names(Extract_Set) <- gsub("BodyBody", "Body", names(Extract_Set))
    names(Extract_Set) <- gsub("Acc", "Accelerometer", names(Extract_Set))
    names(Extract_Set) <- gsub("Gyro", "Gyroscope", names(Extract_Set))
    names(Extract_Set) <- gsub("Mag", "Magnitude", names(Extract_Set))
    names(Extract_Set) <- gsub("std", "sd", names(Extract_Set))

Cleaning the variable names from invalid and/or unnecessary symbols using gsub()

names(Extract_Set) <- gsub("-", ".", names(Extract_Set))
names(Extract_Set) <- gsub("[()]", "", names(Extract_Set))


# 5. CREATE A SECOND INDEPENDENT TIDY DATASET WITH THE AVERAGE 
#    OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT

Load the plyr package

    library(plyr)


Use the ddply() function to calculate the mean for each 
variable matched with each subject and each activity.

For Complete_Set

    Average_Complete_Set_Tidy <- ddply(Complete_Set, c("Subjects", "ActivityNameS"), numcolwise(mean))


For Extract_Set

    Average_Extract_Set_Tidy <- ddply(Extract_Set, c("Subjects", "ActivityName"), numcolwise(mean))


Export the datasets into a text file

    write.table(Average_Complete_Set_Tidy, file="TidyDataComplete.txt")
    write.table(Average_Extract_Set_Tidy, file="TidyDataExtract.txt")


In the description of the submission, it is asked to use the 
write.table() function with row.names=FALSE. When I do this, 
The column names are pushed down into the first row of the dataset
and the variable names are replaced with default names V1, V2, V3 etc.
This makes the dataset untidy again. I therefore provide both options.

   write.table(Average_Complete_Set_Tidy, file="TidyDataComplete2.txt", row.names=FALSE)
   write.table(Average_Extract_Set_Tidy, file="TidyDataExtract2.txt", row.names=FALSE)


Check whether everything was done correctly

    Check_TidyDataComplete <- read.table("./TidyDataComplete.txt")
    Check_TidyDataExtract <- read.table("./TidyDataExtract.txt")

    Check_TidyDataComplete <- read.table("./TidyDataComplete2.txt")
    Check_TidyDataExtract <- read.table("./TidyDataExtract2.txt")

Thank you for grading my assignement! :-)
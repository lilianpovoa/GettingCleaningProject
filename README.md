CONTENTS OF THIS FILE
------------------------------------
   
 * Introduction
 * Requirements
 * Running the Script
 * Script Output
 * Reading the results on R
 * How the script works
    * Getting the Data
    * Cleaning the Data
    * Summarizing the Data
 * Maintainers

INTRODUCTION
-----------------------
The run_analysis.R is a R script that read the content of data sets available in the https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and described in  the site above http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones clean up the data and summarize it in order to get the mean, by subject and activity, of the features variables that measures means and standard deviations. All the information about the result data set are described in the codebook.

REQUIREMENTS
------------
This module requires the following packages:
 * dplyr (http://cran.r-project.org/web/packages/dplyr/index.html)

RUNNING THE SCRIPT
--------------------

In order to run the script all the data used must be download from the link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and uncompressed. 
The working directory should be pointing to the directory where the data was uncompressed. Use the command setwd("<directory where the data was uncompressed>")
The script returns the resulted data frame after the cleaning and summarized process described bellow.

SCRIPT OUTPUT
------------------------

The resultant data frame are show after running the script as a table in R. The script uses the command View to print out the data. Also, the file SummarizedTrainTestData.txt containing the result is created in the working directory.

READING THE RESULS ON R
-------------------------------------------------------

In order to read the resultant data on R the following command should be used:
  read.table("SummarizedTrainTestData.txt") 
The file will be in the working directory setting before running the script


HOW THE SCRIPTS WORKS
--------------------------------------

    GETTING THE DATA
    ----------------------------

The data are divided into to folders, train and test, containgin training and testing information. Each folder contains 3 files: 1) "subject"" having one column with the subject ID information (from 1 to 30), 2) "Y" having one column with the Activity ID information (from 1 to 6), and 3) "X" containing several columns with the features measures. All files have the same number of rows.

All file are loaded separately into variables according to the kind of data set (train or test) and the type of information (X, Y or subject)

loading the training files
train.X<-read.table( "UCI HAR Dataset/train/X_train.txt")
train.Y<-read.table("UCI HAR Dataset/train/Y_train.txt")
train.subject<-read.table("UCI HAR Dataset/train/subject_train.txt")

loading the test files
test.X<-read.table("UCI HAR Dataset/test/X_test.txt")
test.Y<-read.table("UCI HAR Dataset/test/Y_test.txt")
test.subject<-read.table("UCI HAR Dataset/test/subject_test.txt")

The mail folder also contains one file that describes the activity label for each activity iD, activity_labels.txt, and another file that describes the name of each feature measured, features.txt

This files are also loaded into data frames for posterior use.

loading de labels files
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt") #all activity labels (SITTING, STADING)
features_label<-read.table("UCI HAR Dataset/features.txt") #all faeture labels


    CLEANNING THE DATA
    --------------------------------

As the information are divided into 3 different files for each kind of data, train or test, all the information of subjects, features and activities are loaded into one variable

binding the training and testing files
X<-rbind(test.X,train.X)
Y<-rbind(test.Y,train.Y)
subject<-rbind(test.subject,train.subject)

Labeling the column names of the data frames appropriately. De Y data frame contains one column called "Activity_Id", the subject one column called "Subject" and the X contains several columns, named according to te features_label data frame. The data frame activity_labels contains 2 columns, Activity_Id and Activity_Label

Giving the appropriated columns names
colnames(X)<-features_label$V2  #data.frame X contains the measurements taken from test and training data sets
the X columns names are described in the features_labels data frame
colnames(Y)<-"Activity_Id" #data.frame Y contains the activity id information from test and training data sets
colnames(subject)<-"Subject"  #data.frame subject contains the subject information from test and training data sets
colnames(activity_labels)<-c("Activity_Id","Activity_Label") #labels the

The data that will be analyzed is the features with mean and std (standard deviation) information. This features are identified in a specific vector mean_std_columns, considering the presence of the "mean" or "sdt" string in the column name

mean_std_columns<-grep("mean|std",features_label$V2,value=FALSE)

The data frame X, that contain the feature information is filtered to maintain only the columns with mean and std data, according to the mean_std_columns defined before. The resulted information is stored in FinalData data frame

FinalData<-X[,mean_std_columns] #insert in FinalData only the mean and std columns of X

The Activity_Id and Subject information are loaded from Y and subject data frames, respectively, into FinalData.

FinalData$Activity_Id<-Y$Activity_Id #insert in FinalData the activity id information
FinalData$Subject<-subject$Subject #insert in FinalData the subject information

Using the Activity_Id as an index, the Activity_Label is merged into  FinalData

FinalData<-merge(FinalData,activity_labels) #merge the data frames to change the activity id putting the activity label information

Since the Activity_Id and Activity_label contains the same information, represented by a numeral or a string, the Activity_Id was eliminated from FinalData, obtaining a TIDY data set, where each columns has a independent variable and each rom an observation

FinalData<-select(FinalData,-Activity_Id) #exclude the Activity_Id information since the data frame already contains de activity label information


    SUMMARIZING THE DATA
    -------------------------------------

The needed data about the data set is the mean of each feature that has mean or std information per Subject and Activity_label. Then the data frame is grouped by Subject and Activity_label creating the GroupedBy data frame.

analyzing the FinalData and calculating the summary of all columns that contain mean and std information
GroupedBy<-group_by(FinalData,Subject,Activity_Label) #group the data frame by Subject and Activity label

Then the grouped information is summarized with the mean of each columns that contains a feature data. Since the information is already grouped, as sow in the previous step, the resulted summary is calculated per Subject and Activity_label

Summarized<-(summarise_each(GroupedBy,funs(mean))) #summarize each column of the grouped data set. 

The resultant data frame are show after running the script as a table in R. The script uses the command View to print out the data. Also, the file SummarizedTrainTestData.txt containing the result is created in the working directory.

MAINTAINERS
----------------------
Current maintainers:
 Lilian Povoa  - lilian.povoa@gmail.com

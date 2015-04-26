library(dplyr) #loading the dplyr library for further use

# loading the training files
train.X<-read.table( "UCI HAR Dataset/train/X_train.txt")
train.Y<-read.table("UCI HAR Dataset/train/Y_train.txt")
train.subject<-read.table("UCI HAR Dataset/train/subject_train.txt")

# loading the test files
test.X<-read.table("UCI HAR Dataset/test/X_test.txt")
test.Y<-read.table("UCI HAR Dataset/test/Y_test.txt")
test.subject<-read.table("UCI HAR Dataset/test/subject_test.txt")

# loading de labels files
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt") #all activity labels (SITTING, STADING)
features_label<-read.table("UCI HAR Dataset/features.txt") #all faeture labels

# binding the training and testing files
X<-rbind(test.X,train.X)
Y<-rbind(test.Y,train.Y)
subject<-rbind(test.subject,train.subject)

# Giving the approprieted columns names
colnames(X)<-features_label$V2  #data.frame X contains the measurements taken from test and training data sets
#the X columns names are descrebet in the features_labels data frame
colnames(Y)<-"Activity_Id" #data.frame Y contains the activity id information from test and training data sets
colnames(subject)<-"Subject"  #data.frame subject contains the subject information from test and training data sets
colnames(activity_labels)<-c("Activity_Id","Activity_Label") #lables the

# creating a vector to inform which columns of X contains a mean or std value
mean_std_columns<-grep("mean|std",features_label$V2,value=FALSE)

# creating a tidy data frame FinalData for the further analysis. 
FinalData<-X[,mean_std_columns] #insert in FinalData only the mean and std columns of X
FinalData$Activity_Id<-Y$Activity_Id #insert in FinalData the activity id information
FinalData$Subject<-subject$Subject #insert in FinalData the subject information
FinalData<-merge(FinalData,activity_labels) #merge the data frames to change the activity id putting the activity label information
FinalData<-select(FinalData,-Activity_Id) #exclude the Activity_Id information since the data frame already contains de activity label information

# analysing the FinalData and calculating the summary of all columns that contain mean and std information
GroupedBy<-group_by(FinalData,Subject,Activity_Label) #group the data frame by Subject and Activity label
Summarized<-(summarise_each(GroupedBy,funs(mean))) #summarize each column of the grouped data set. 
write.table(Summarized,"SummarizedTrainTestData.txt",row.names=FALSE)
View(Summarized)

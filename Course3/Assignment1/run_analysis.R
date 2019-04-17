
##If you need to Download data
#if(!file.exists("data")){dir.create("data")}
#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl,destfile="data\\Dataset.zip")
 
##If you need to Unzip data file
#unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Loading required packages for script
library(plyr)
library(dplyr)
library(reshape2)

#Loading Files into R
path<- file.path("./data" , "UCI HAR Dataset")
trainDF<- read.table(file.path(path,"train","X_train.txt"),sep="",header=FALSE)
trainYDF<- read.table(file.path(path,"train","y_train.txt"),sep="",header=FALSE)
trainSTDF<- read.table(file.path(path,"train","subject_train.txt"),sep="",header=FALSE)
testDF<- read.table(file.path(path,"test","X_test.txt"),sep="",header=FALSE)
testYDF<- read.table(file.path(path,"test","y_test.txt"),sep="",header=FALSE)
testSTDF<- read.table(file.path(path,"test","subject_test.txt"),sep="",header=FALSE)
featDF<- read.table(file.path(path,"features.txt"),sep="",header=FALSE)


#Using features.txt file to name columns for other Datasets
names(trainDF)<- featDF$V2          
names(testDF)<- featDF$V2          


#Adding y and subject columns to primary datasets and name them appropriately
train<- cbind(trainDF, trainYDF, trainSTDF)
colnames(train)[562]<- "Activity"
colnames(train)[563]<- "Subject"

test<- cbind(testDF, testYDF, testSTDF)
colnames(test)[562]<- "Activity"
colnames(test)[563]<- "Subject"


#Combinding the train and test datasets
bound<- rbind(train, test)


#Subsetting the Mean and Standard Deviation columns
meanColumns<- grep("mean\\(\\)", names(bound), value=TRUE)
stdColumns<- grep("std\\(\\)", names(bound), value=TRUE)
dfSUB<- subset(bound, select=c("Subject", "Activity", meanColumns, stdColumns))


#Turning the activity numbers into factors and naming them accordingly
dfSUB$Activity<- as.factor(dfSUB$Activity)
dfSUB$Activity<- mapvalues(dfSUB$Activity, from=c("1","2","3","4","5","6"), 
                           to=c("walking","walkingupstairs","walkingdownstairs","sitting","standing","laying"))


#Sorting Dataset
dfSORT<-dfSUB[order(dfSUB$Subject,dfSUB$Activity),]


#Melting measurements together into 2 columns one identifying the feature calculation and the other the value
dfMELT<- melt(dfSORT, id.vars=c("Subject","Activity"), variable.name="CalculationCode")
df<- dfMELT


#Adding Domain column that notes if domain signal is time or frequency
df<- mutate(df, Domain=(grepl("^t", df$CalculationCode)))
df$Domain<- as.factor(df$Domain)
df$Domain<- mapvalues(df$Domain, from=c("TRUE","FALSE"), to=c("time","freq"))

#Adding Jerk column that notes if the measurement was a Jerk signal
df<- mutate(df, Jerk=(grepl("Jerk", df$CalculationCode)))
df$Jerk<- as.factor(df$Jerk)
df$Jerk<- mapvalues(df$Jerk, from=c("TRUE","FALSE"), to=c("jerk","NA"))


#Adding Magnitude column that notes if the magnitude was calculated
df<- mutate(df, Magnitude=(grepl("Mag", df$CalculationCode)))
df$Magnitude<- as.factor(df$Magnitude)
df$Magnitude<- mapvalues(df$Magnitude, from=c("TRUE","FALSE"), to=c("magnitude","NA"))


#Adding CalculationType column to indicate if the value is the mean or the standard deviation
df<- mutate(df, CalculationType=(grepl("mean", df$CalculationCode)))
df$CalculationType<- as.factor(df$CalculationType)
df$CalculationType<- mapvalues(df$CalculationType, from=c("TRUE","FALSE"), to=c("mean","std"))


#Adding Acceleration column that notes if acceleration signal is body, gravity, or NA
vgrep<- function(x){
    if(grepl("BodyAcc",x)){
        factor(1,labels="body")   
    } else {
        if(grepl("GravityAcc",x)){
            factor(2,labels="gravity")
        } else { factor(3,labels="NA") }
    }
}
df$Acceleration<- sapply(df$CalculationCode, FUN=vgrep)


#Adding Instrument column that notes what instrument was used for the observations
igrep<- function(x){
    if(grepl("Gyro",x)){
        factor(1,labels="gyroscope")   
    } else { factor(2,labels="accelerometer")
    }
}
df$Instrument<- sapply(df$CalculationCode, FUN=igrep)


#Adding Axial column that notes what axials were measured
axgrep<- function(x){
    if(grepl("X$",x)){
        factor(1,labels="x")   
    } else {
        if(grepl("Z$",x)){
            factor(2,labels="z")
        } else {
            if(grepl("Y$",x)){
                factor(3,labels="y")
            } else { factor(4,labels="NA") }
        }
    }
}
df$Axial<- sapply(df$CalculationCode, FUN=axgrep)


#Removing CalculationCode column and sorting other Columns
df<-df[,-3]
df<-df[c(1,2,9,8,10,7,4,5,6,3)]


#Next bit of code finds the average of each set of values for each subject-activity combination
tidyDF<- aggregate(x=df$value,
                   by=df[c("Subject","Activity","Instrument","Acceleration","Axial",
                           "CalculationType","Domain","Jerk","Magnitude")],
                   FUN=mean)


#And the final bit of code names the new column and reorders the dataset for ease of reading
colnames(tidyDF)[10]<- "Average"
tidyDF<-tidyDF[order(tidyDF$Subject, tidyDF$Activity,tidyDF$Instrument, tidyDF$Acceleration,
                     tidyDF$Axial, tidyDF$CalculationType, tidyDF$Domain, tidyDF$Jerk),]


##Following code will write the tidydata as file to your computer
#write.table(tidyDF, file = "fitbitTidy.txt",row.name=FALSE)





## If you need to grab download and unzip files
#if(!file.exists("data")){dir.create("data")}
#fileUrl <- "https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip"
#download.file(fileUrl,destfile="data\\outcome-of-care.zip")
#unzip(zipfile="./data/outcome-of-care.zip",exdir="./data")

## Load required library packages
library(dplyr)

rankall<- function(outcome,num="best"){
    ## function takes heart attack, heart failure, or pneumonia as an outcome and takes a "ranking"
    
    data<- read.csv("./data/outcome-of-care-measures.csv", colClasses="character")
    data<- data[,c(2,7,11,17,23)]
    names(data)[1]<- "Hospital"
    names(data)[3]<- "HA.rate"
    names(data)[4]<- "HF.rate"
    names(data)[5]<- "P.rate"
      ## cleaning up data to make it easy to read/reference
    
    results<- data.frame()
      ## setup dataframe to store results within
    
    states<- sort(unique(data$State))
    num.states<- length(states)
      ## create vector with state IDs in order and count how many their are for loop
    
    testing<- c("heart attack", "heart failure", "pneumonia")
    if(!sum(testing==outcome)==1) stop("Invalid Outcome Argument")
      ## makes sure outcome is a valid option
    

    for(i in 1:num.states){
        ## looping through each element within the states vector (aka going through each state)
        
        currentstate<- states[i]
        tmpdata<- data[data$State==currentstate,]
          ## when looking at a specific state, subset based on that state ID
        
        
        if(outcome=="heart failure"){
            tmpdata<- tmpdata[,-c(3,5)]
            datasort<- tmpdata[order(suppressWarnings(as.numeric(tmpdata$HF.rate)), tmpdata$Hospital, na.last=TRUE),]
        }
        
        if(outcome=="heart attack"){
            tmpdata<- tmpdata[,-c(4,5)]
            datasort<- tmpdata[order(suppressWarnings(as.numeric(tmpdata$HA.rate)), tmpdata$Hospital, na.last=TRUE),]
        }
        
        if(outcome=="pneumonia"){
            tmpdata<- tmpdata[,-c(3,4)]
            datasort<- tmpdata[order(suppressWarnings(as.numeric(tmpdata$P.rate)), tmpdata$Hospital, na.last=TRUE),]
        }
          ## subsetting and ordering data based on the outcome input
        
        rank<- num
        if(num=="best") rank<-1
        if(num=="worst") rank<-(nrow(datasort))
          ## set which rank we are looking for
        
        rankedhospital<- datasort[rank,1]
        results<- rbind(results, 
                        data.frame(hospital=rankedhospital, state=states[i]))
    } ## end of for loop
    
    results
    
}     

            

## If you need to grab download and unzip files
#if(!file.exists("data")){dir.create("data")}
#fileUrl <- "https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip"
#download.file(fileUrl,destfile="data\\outcome-of-care.zip")
#unzip(zipfile="./data/outcome-of-care.zip",exdir="./data")

## Load required library packages
library(dplyr)

best<- function(state,outcome){                                                     
    ## Takes arguments state (state ID) and outcome (heart attac, heart failure, pneumonia)
    
    base.data<- read.csv("./data/outcome-of-care-measures.csv", colClasses="character")
    states.tested<- unique(base.data$State)
      ## Look at which states have data on them
    
    if(!sum(states.tested==state)==1){                                               
        stop("Invalid State Argument")
    }
      ## Make sure given state is within dataset (sum(TRUE)==1)
    
    outcomes.tested<- c("heart attack", "heart failure", "pneumonia")                 
    if(!sum(outcomes.tested==outcome)==1){                                           
        stop("Invalid Outcome Argument")
    }
      ## Testing outcome argument to see if it is a valid option (sum(TRUE)==1)
    
    state.data<- subset(base.data, State==state)
    names(state.data)[11]<- "HA.rate"
    names(state.data)[17]<- "HF.rate"
    names(state.data)[23]<- "P.rate"
      ## Subset data to only include data from inputted state and rename columns
    
    
    iso.data<- subset(state.data, select=c("Hospital.Name","HA.rate","HF.rate","P.rate"))
      ## further subset to only include needed data
    
    if(outcome=="heart attack"){
        HA.sorted<- arrange(iso.data, suppressWarnings(as.numeric(iso.data$HA.rate)), Hospital.Name)
        answer<- HA.sorted[1,1]
    }
    if(outcome=="heart failure"){
      HF.sorted<- arrange(iso.data, suppressWarnings(as.numeric(iso.data$HF.rate)), Hospital.Name)
      answer<- HF.sorted[1,1]
    }
    if(outcome=="pneumonia"){
      P.sorted<- arrange(iso.data, suppressWarnings(as.numeric(iso.data$P.rate)), Hospital.Name)
      answer<- P.sorted[1,1]
    }
      ## based on outcome, arrange columns by the rate and then the hospital name and store top value
    
    print(answer)
}
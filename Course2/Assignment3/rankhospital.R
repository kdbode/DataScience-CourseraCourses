
## If you need to grab download and unzip files
#if(!file.exists("data")){dir.create("data")}
#fileUrl <- "https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip"
#download.file(fileUrl,destfile="data\\outcome-of-care.zip")
#unzip(zipfile="./data/outcome-of-care.zip",exdir="./data")


rankhospital<- function(state, outcome, num="best"){
  ## function takes state ID, an outcome (heart attack, heart failure, or pneumonia) and takes a "ranking"
    
    base.data<- read.csv("./data/outcome-of-care-measures.csv", colClasses="character")
    states.tested<- unique(base.data$State)
      ## Look at which states have data on them
    
    if(!sum(states.tested==state)==1){
        stop("Invalid State Argument")
    }   ## Make sure given state is within dataset (sum(TRUE)==1)
    
    outcomes.tested<- c("heart attack", "heart failure", "pneumonia")
    if(!sum(outcomes.tested==outcome)==1){
        stop("Invalid Outcome Argument")
    }   ## Testing outcome argument to see if it is a valid option (sum(TRUE)==1) 
    
    state.data<- subset(base.data, State==state)
    names(state.data)[11]<- "HA.rate"
    names(state.data)[17]<- "HF.rate"
    names(state.data)[23]<- "P.rate"
      ## Subset data to only include data from inputted state and rename columns
    
    h.rank<-num
    if(num=="best"){
        h.rank<- 1
    }   ## sets num input as a rank and if "best" sets it to rank 1
    
    
    if(outcome=="heart failure"){
        iso.data<- subset(state.data, select=c("Hospital.Name","HF.rate"))
        HF.sorted<- iso.data[order(suppressWarnings(as.numeric(iso.data$HF.rate)), iso.data$Hospital.Name, na.last=NA),]
        HF.stripped<- subset(HF.sorted, HF.rate!="Not Available")
          ## subsets to only needed columns
          ## sorts dataset by rate and hospital name and sets NAs as last
          ## subset again to remove "Not Available" rates
        
        if(num=="worst"){
            h.rank<- nrow(HF.stripped)
        }   ## if rank was set to "worst" grab the lowest numberic value in list
        
        answer<- HF.stripped[h.rank,1]
    }
 
    if(outcome=="heart attack"){
        iso.data<- subset(state.data, select=c("Hospital.Name","HA.rate"))
        HA.sorted<- iso.data[order(suppressWarnings(as.numeric(iso.data$HA.rate)), iso.data$Hospital.Name, na.last=NA),]
        HA.stripped<- subset(HA.sorted, HA.rate!="Not Available")
        if(num=="worst"){
            h.rank<- nrow(HA.stripped)
        }
        answer<- HA.stripped[h.rank,1]
    }
    
    if(outcome=="pneumonia"){
        iso.data<- subset(state.data, select=c("Hospital.Name","P.rate"))
        P.sorted<- iso.data[order(suppressWarnings(as.numeric(iso.data$P.rate)), iso.data$Hospital.Name, na.last=NA),] 
        P.stripped<- subset(P.sorted, P.rate!="Not Available")
        if(num=="worst"){
            h.rank<- nrow(P.stripped)
        }
        answer<- P.stripped[h.rank,1]
    }
    answer
}



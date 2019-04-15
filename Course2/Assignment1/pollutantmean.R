## download the source data
if(!file.exists("data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2Fspecdata.zip"
download.file(fileUrl,destfile="data\\fspecdata.zip")

## Unzip the file
unzip(zipfile="./data/fspecdata.zip",exdir="./data")

## creation of function
pollutantmean <- function(directory, pollutant, id=1:332) {
    f.poll<- vector()                   ## setup empty vector to load
    for (i in id) {                     
        
        if (i<100 && i>9) {             
            t.id<-paste("0",i,sep="")   
        }
        ## Creating temp ID so we correctly read files; this adds 0 to files 11 to 99
        
        
        if (i<10) {
            t.id<-paste("00",i,sep ="")
        }
        ## Creating temp ID so we correctly read files; this adds 00 to files 1 to 9
        
        
        if (i>99) {
            t.id<-i
        }
        ## Creating temp ID that doesn't need adjusted
        
        
        dirname<- paste(directory,"/",t.id,".csv",sep ="")
        data<- read.csv(file=dirname)
        ## setups directory so specific files are correctly loaded into R
        

        if(pollutant=="sulfate"){
            poll<- data[,2]
            poll<- poll[!is.na(poll)]
        }
        ## load column 2 into poll object and check if element is NA
        
        if(pollutant=="nitrate"){
            poll<- data[,3]
            poll<- poll[!is.na(poll)]
        }
        ## load column 3 into poll object and check if element is NA
        
        f.poll<- c(f.poll,poll)
        ## add current i value poll result to the f.poll vector
    }
    mean(f.poll)
}

## To Test run the following
## > pollutantmean("specdata", "sulfate", 1:10)
##   [1] 4.064128 
## > pollutantmean("specdata", "nitrate", 70:72)
#3   [1] 1.706047
## > pollutantmean("specdata", "nitrate", 23)
##   [1] 1.280833

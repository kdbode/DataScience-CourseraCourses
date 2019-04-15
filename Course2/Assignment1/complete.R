complete<- function(directory, m.id=1:332){
  ## function looks in given directory, and takes reads .csv files (from 1 to 332) that are requested
    
    id<- vector()
    nobs<- vector()
     ## create empty vectors to load with elements
     ## id is the monitor id and nobs is number of observations
    
    for (i in m.id) {                     
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
        
        #c2.data<- !is.na(data[,2])
        count<- sum(!is.na(data[,2]) & !is.na(data[,3]))
         ## load non-NA column 2 elements into c2.data and add them together 
        
        id<- c(m.id) 
        nobs<- c(nobs, count)
         ## setup to create dataframe, first loads monitor number into id "column"
         ## next loads previous nobs values and adds new count value to nobs "column"
    }
    c.data<- data.frame(id, nobs)
    c.data
}

## Test the following
## > complete("specdata", 1)
##       id nobs
##     1  1  117
## > complete("specdata", c(2, 4, 8, 10, 12))
##       id nobs
##     1  2 1041
##     2  4  474
##     3  8  192
##     4 10  148
##     5 12   96
## > complete("specdata", 30:25)
##       id nobs
##     1 30  932
##     2 29  711
##     3 28  475
##     4 27  338
##     5 26  586
##     6 25  463
## > complete("specdata", 3)
##       id nobs
##     1  3  243

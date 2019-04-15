corr<- function(directory, threshold=0){
  ## Requests a directory and threshold value which is vector indicatin number of completely observed observations
    
  finalcor<- vector()
  find<- list.files(directory, pattern=".csv", full.names=TRUE)
  find.l<- length(find)
   ## counts number of .csv files in in the requested directory
  
  for (i in 1:find.l) { 
    read.d<- read.csv(find[i]) 
    good<- complete.cases(read.d)
    clean.d<- read.d[good,]
      ## return vector that indicates which rows have no NA values for given file
    i.rows<- nrow(clean.d)
    if(i.rows>=threshold){
      ## checks to see if file meets the threshold requirement
        sulfate.r<- clean.d$sulfate
        nitrate.r<- clean.d$nitrate
        sncor<- cor(sulfate.r, nitrate.r)
        finalcor<- c(finalcor, sncor)
    }
  }
  finalcor
}

## test the following lines of code
## > cr <- corr("specdata", 150)
## > head(cr)
## [1] -0.01895754 -0.14051254 -0.04389737 -0.06815956 -0.12350667 -0.07588814
##
## > summary(cr)
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## -0.21057 -0.04999  0.09463  0.12525  0.26844  0.76313
##
## > cr <- corr("specdata", 400)
## > head(cr)
## [1] -0.01895754 -0.04389737 -0.06815956 -0.07588814  0.76312884 -0.15782860
##
## > summary(cr)
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## -0.17623 -0.03109  0.10021  0.13969  0.26849  0.76313
##
## > cr <- corr("specdata", 5000)
## > summary(cr)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
## 
## > length(cr)
## [1] 0
##
## > cr <- corr("specdata")
## > summary(cr)
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## -1.00000 -0.05282  0.10718  0.13684  0.27831  1.00000
##
## > length(cr)
## [1] 323


## If you Need to Download file
 #if(!file.exists("data")){dir.create("data")}
 #fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
 #download.file(fileUrl,destfile="data\\PM25.zip")

## If you need to Unzip the data file
 #unzip(zipfile="./data/PM25.zip",exdir="./data")

#Loading required packages for script
library(plyr)
library(ggplot2)

#Loading Files into R
nei <- readRDS("./data/summarySCC_PM25.rds")
scc <- readRDS("./data/Source_Classification_Code.rds")


## Question 1
 # Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base 
 # plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

q1<- nei[,c(4,6)]
   ##subset to only the columns needed 

q1.totals<- with(q1, tapply(Emissions, year, sum))
   ## find sum of Emission totals by year

q1.totals<- q1.totals/1e+06
   ## reducing values to make it easier to read on plot

png(file="Q1Plot.png", width=800, height=600, units="px")
par(mar=c(5,4,2,2),las=1)
barplot(q1.totals, 
        main="Total US PM2.5 Emissions by Year",
        xlab="Year", 
        ylab="PM2.5 in Millions of Tons", 
        ylim=c(3,8),
        xpd=FALSE)
dev.off()
  ## plot the data using ylim to make the plot easier to read


## Question 2
 # Have the total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips=="24510") from 1999 to 2008? 
 # Use the base plotting system to make a plot answering this question.

q2<- nei[nei$fips=="24510",c(4,6)]
    ## subset to only the needed rows (Baltimore City ones) and columns

q2.totals<- with(q2, tapply(Emissions, year, sum))
    ## find sum of Emission totals by year

png(file="Q2Plot.png", width=800, height=600, units="px")
par(mar=c(5,5,3,1),las=1)
barplot(q2.totals,
        main="Total PM2.5 Emissions by Year for Baltimore City, MA",
        xlab="Year", 
        ylab="PM2.5 in tons", 
        ylim=c(1500,3500),
        xpd=FALSE)
dev.off()


## Question 3
 # Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four
 # sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions
 # from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

q3<- nei[nei$fips=="24510",c(4,5,6)]
    ## subset to only needed rows and columns

q3$type<- as.factor(q3$type)
q3$year<- as.factor(q3$year)
    ## converting columns to factors to perform ddply() 

q3.totals<- ddply(q3, .(type, year), summarise, sum=sum(Emissions))
    ## create dataframe using q3 with columns (type, year, sum)
    ## summarise() is function creating the new df from given columns
    ## sum column is created using sum of Emissions based on other two columns

png(file="Q3Plot.png", width=800, height=600, units="px")
q3plot<- ggplot(q3.totals, aes(x=year, y=sum, group=type, col=type))
q3plot+geom_point(size=2)+
       geom_line(size=1)+
       ylab("PM2.5 Emissions in Tons")+
       labs(title="PM2.5 Emissions by Source Type in Baltimore City, MA", col="Source Types")
dev.off()
    ## create plot for each type using Emissions and year


## Question 4
 # Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

q4scc<- scc[grep("Coal|Lignite", scc$Short.Name),c(1,3)]
q4scc<- q4scc[grep("Comb", q4scc$Short.Name),1]
q4<- nei[nei$SCC %in% q4scc, c(4,6)]
    ## Using grep() to create vector of rows which refer to the desired emission types
    ## Lignite is "brown coal" so I grepped for it and Coal, then for Combustion
    ## Finally subset using the grep data

q4$year<- as.factor(q4$year)
q4.totals<- with(q4, tapply(Emissions, year, sum))
q4.totals<- q4.totals/1e+05
    ## convert year to factor for tapply()
    ## then use tapply() to get sum of emission totals by year
    ## reduced values of totals to make it easier to read plot

png(file="Q4Plot.png", width=800, height=600, units="px")
par(mar=c(5,5,5,2),las=1)
barplot(q4.totals,
        main="PM2.5 Emissions from Coal Combustion in the US",
        xlab="Year",
        ylab="PM2.5 in tons",
        ylim=c(3,6),
        xpd=FALSE)
abline(h=5.5, lty=2, col="blue")
dev.off()
    ## Added abline so view can see the difference in bars since the values are so close together


## Question 5
 # How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
q5scc<- scc[grep("[Vv]ehicle", scc$Short.Name),c(1,3)]
q5scc<- q5scc[grep("[Cc]oating", q5scc$Short.Name, invert=TRUE),1]
q5<- nei[nei$SCC %in% q5scc, c(1,4,6)]
    ## Using grep() to create vector of rows which refer to the desired emission types
    ## I looked for anything vehicle related, but removed surface coating which is unrelated to vehicle operation
    ## Finally subset using the grep data

q5<- q5[q5$fips=="24510", c(2,3)]
    ## subset looking just for rows for Baltimore City

q5$year<- as.factor(q5$year)
q5.totals<- with(q5, tapply(Emissions, year, sum))
  ## convert year to factor for tapply()
  ## then use tapply() to get sum of emission totals by year

png(file="Q5Plot.png", width=800, height=600, units="px")
par(mar=c(5,5,5,2),las=1)
barplot(q5.totals,
        main="PM2.5 Emissions from Motor Vehicles in Baltimore City,MA",
        xlab="Year",
        ylab="PM2.5 in tons",
        ylim=c(20,80),
        xpd=FALSE)
dev.off()


## Question 6
 # Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles 
 # County, California (fips=="06037"). Which city has seen greater changes over time in motor vehicle emissions?

q6scc<- scc[grep("[Vv]ehicle", scc$Short.Name),c(1,3)]
q6scc<- q6scc[grep("[Cc]oating", q6scc$Short.Name, invert=TRUE),1]
q6<- nei[nei$SCC %in% q6scc, c(1,4,6)]
q6<- q6[q6$fips=="24510"|q6$fips=="06037",]
    ## using same method as question5 code, but subsetting for Baltimore City and LA County

q6$year<- as.factor(q6$year)
q6.totals<- ddply(q6, .(fips, year), summarise, sum=sum(Emissions))
    ## convert year to factor for tapply()
    ## then use tapply() to get sum of emission totals by year

png(file="Q6Plot.png", width=800, height=600, units="px")
q6plot<- ggplot(q6.totals, aes(x=year, y=sum, group=fips, col=fips))
q6plot+geom_point(size=2)+
       geom_line(size=1)+
       ylab("PM2.5 Emissions in Tons")+
       xlab("Year")+
       labs(title="PM2.5 Emissions from Vehicles in Baltimore City and Los Angeles", col="Counties")+
       scale_color_discrete(breaks=c("06037","24510"),labels=c("Los Angeles","Baltimore City"))
dev.off()


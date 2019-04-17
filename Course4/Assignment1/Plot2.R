#Download file
if(!file.exists("data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="data\\powerconsumption.zip")

#Unzips the file
unzip(zipfile="./data/powerconsumption.zip",exdir="./data")

#Loading Files into R
pcDT<- read.table(file.path("./data", "household_power_consumption.txt"),sep=";",header=TRUE, na.strings="?")

#Loading required packages
library(tidyr)
library(lubridate)

#Subsetting data the Feburary 1st and 2nd of 2007
pcDT$Date<- as.Date(pcDT$Date, format="%d/%m/%Y")
pcDT<- subset(pcDT, Date >= as.Date("2007/02/01") & Date <= as.Date("2007/02/02"))

#Formatting Data for plotting
mergeDT<- unite(pcDT, Date, c(Date, Time), remove=FALSE)
mergeDT$Date<- ymd_hms(mergeDT$Date)

#Plotting to file
png(file="plot2.png", width=480, height=480, units="px")
with(mergeDT,plot(Date,Global_active_power, ylab="Global Active Power (kilowatts)", xlab="", type="l"))
dev.off()


#Download file
if(!file.exists("data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="data\\powerconsumption.zip")

#Unzips the file
unzip(zipfile="./data/powerconsumption.zip",exdir="./data")

#Loading required Packages
library(tidyr)
library(lubridate)

#Loading Files into R
pcDT<- read.table(file.path("./data", "household_power_consumption.txt"),sep=";",header=TRUE, na.strings="?")

#Subsetting data the Feburary 1st and 2nd of 2007
pcDT$Date<- as.Date(pcDT$Date, format="%d/%m/%Y")
pcDT<- subset(pcDT, Date >= as.Date("2007/02/01") & Date <= as.Date("2007/02/02"))

#Formatting Data for plotting
mergeDT<- unite(pcDT, Date, c(Date, Time), remove=FALSE)
mergeDT$Date<- ymd_hms(mergeDT$Date)

#Plotting to File
png(file="plot3.png", width=480, height=480, units="px")
plot(mergeDT$Date,mergeDT$Sub_metering_1,ylab="Energy sub metering", xlab="",type="n")
lines(mergeDT$Date,mergeDT$Sub_metering_1)
lines(mergeDT$Date,mergeDT$Sub_metering_2, col="red")
lines(mergeDT$Date,mergeDT$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black","red","blue"), lty=1)
dev.off()


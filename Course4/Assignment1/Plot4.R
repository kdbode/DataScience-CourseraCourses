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

#Setting up for four Plots
png(file="plot4.png", width=480, height=480, units="px")
par(mfrow=c(2,2))

#Creating four plots
with(mergeDT, {
    # Plot1
    plot(Date,Global_active_power, ylab="Global Active Power (kilowatts)", xlab="", type="l")
    # Plot2
    plot(Date,Voltage, xlab="datetime", type="l")
    # Plot3
    plot(Date, Sub_metering_1, ylab="Energy sub metering", xlab="",type="n")
    lines(Date,Sub_metering_1)
    lines(Date,Sub_metering_2, col="red")
    lines(Date,Sub_metering_3, col="blue")
    legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black","red","blue"), lty=1)
    #Plot4
    plot(Date,Global_reactive_power, xlab="datetime", type="l")
})


#Closing device
dev.off()


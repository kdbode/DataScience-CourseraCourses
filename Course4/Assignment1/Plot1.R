#Download file
if(!file.exists("data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="data\\powerconsumption.zip")

#Unzips the file
unzip(zipfile="./data/powerconsumption.zip",exdir="./data")

#Loading Files into R
pcDT<- read.table(file.path("./data", "household_power_consumption.txt"),sep=";",header=TRUE, na.strings="?")

#Subsetting data the Feburary 1st and 2nd of 2007
pcDT$Date<- as.Date(pcDT$Date, format="%d/%m/%Y")
pcDT<- subset(pcDT, Date >= as.Date("2007/02/01") & Date <= as.Date("2007/02/02"))

#Plot
png(file="plot1.png", width=480, height=480, units="px")
hist(pcDT$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", col="red")
dev.off()


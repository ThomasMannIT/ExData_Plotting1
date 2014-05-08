## PLOT 4
Sys.setlocale("LC_TIME", "C")
print("--- PLOT 4 ---")

## FILE Locations
fileZip <- "household_power_consumption.zip"
fileTxt <- "household_power_consumption.txt"
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## DOWNLOAD
print("DOWNLOADING ...")
if (!(file.exists(fileZip))) {
  download.file(fileUrl, fileZip, "curl", quiet = FALSE, mode = "wb", cacheOK = TRUE)
}

## UNZIP
print("UNZIPING ...")
if (!(file.exists(fileTxt))) {
  unzip(fileZip, overwrite = TRUE, junkpaths = TRUE, exdir = ".")
  download.file(fileUrl, fileZip, "curl", quiet = FALSE, mode = "wb", cacheOK = TRUE)
}

## CSV Decoding Preparation
setClass("myDate")
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y"))

csvCols <- c("myDate","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

## READ DATA, NAs are ? and ; as Seperators
print("READING CSV ...")
data <- read.csv("household_power_consumption.txt", sep = ";", dec=".", colClasses = csvCols, na.strings ="?")

print("SUBSETTING Data ...")
sel1Data <- subset(data, Date == "2007-02-01")
sel2Data <- subset(data, Date == "2007-02-02")
selData <- rbind(sel1Data,sel2Data)

weekdays <- strptime(paste(selData$Date, selData$Time), format='%Y-%m-%d %H:%M:%S')
selData <- cbind(selData, weekdays)

print("PLOTTING ...")
png(file = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")

par(mfrow = c(2, 2), mar = c(4, 4, 1, 1), oma = c(0, 0, 0, 0))

## PLOT A
with(selData, plot(weekdays, Global_active_power, type="l", col = "black", main = "",
                   xlab = "",
                   ylab = "Global Active Power"
))

## PLOT B
with(selData, plot(weekdays, Voltage, type="l", col = "black", main = "",
                   xlab = "datetime",
                   ylab = "Voltage"
))

## PLOT C

with(selData, plot(weekdays, Sub_metering_1, type="l", col = "black", main = "",
                  xlab = "",
                  ylab = "Energy sub metering"
                  ))
with(selData, lines(weekdays, Sub_metering_2, type="l", col = "red"))
with(selData, lines(weekdays, Sub_metering_3, type="l", col = "blue"))

legend("topright", lty=c(1,1,1), col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = "n")

## PLOT D
with(selData, plot(weekdays, Global_reactive_power, type="l", col = "black", main = "",
                   xlab = "datetime",
                   ylab = "Global_reactive_power"
))

print("SAVING PNG ...")
##dev.copy(png, file = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")
dev.off()
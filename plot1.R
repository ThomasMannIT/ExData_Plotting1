## PLOT 1
print("--- PLOT 1 ---")

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

print("PLOTTING ...")
png(file = "plot1.png", width = 480, height = 480, units = "px", bg = "transparent")
with(selData, hist(Global_active_power, col = "red", main = "Global Active Power",
                  xlab = "Global Active Power (kilowatts)",
                  ylab = "Frequency"))

print("SAVING PNG ...")
##dev.copy(png, file = "plot1.png", width = 480, height = 480, units = "px", bg = "transparent")
dev.off()
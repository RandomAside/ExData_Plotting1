## Step 1 - load the required libraries (and install if not there)
###############################################################################
## no pre-requisites


## Step 2 - Check if files already downloaded / unzipped, if not go get it
###############################################################################
## setting a variable for the unzipped file directory to re-use

fileDirectory = "./PowerData/"
zipFileDownloadLocation = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zippedFile = "exdata%2Fdata%2Fhousehold_power_consumption.zip"
unzippedFile = "household_power_consumption.txt"

if(!file.exists(fileDirectory)){
        dir.create(fileDirectory)
        download.file(zipFileDownloadLocation, 
                      paste0(fileDirectory, zippedFile), method = "curl")
        unzip(paste0(fileDirectory, zippedFile), 
              unzip = "internal", exdir = fileDirectory)
        
        ## clean up - remove the temp zip file....
        
        file.remove(paste0(fileDirectory, zippedFile))
}

## Step 3 - Read in power data
###############################################################################
## Deliberately setting date and time columns as character at the moment to do 
## the initial filter of the file import - converted to proper formats later.

powerData <- read.table(paste0(fileDirectory, unzippedFile), 
                        stringsAsFactors = FALSE, header = TRUE, sep = ";" , 
                        na.strings = "?",
                        colClasses = c("character","character","numeric",
                                       "numeric","numeric","numeric","numeric",
                                       "numeric","numeric"))

## Step 4 - Format the data
###############################################################################
## Format of the date in the file is %d/%m/%Y without leading zeros...
## to make it easy to subset I have left "Date" field as character...


dateLimits <- c("1/2/2007", "2/2/2007")                                              
powerDataSubset <- subset(powerData, Date %in% dateLimits)


## Step 5 - Reformat the data ready for plotting
###############################################################################
## ... then convert Separate Date and Time Columns to a single datetime
## need to wrap the data / time conversion in as.POSIXlt as otherwise is
## being saved as character

powerDataSubset$datetime <- as.POSIXlt(strftime(paste(
        as.Date(powerDataSubset$Date, "%d/%m/%Y"),powerDataSubset$Time),tz = ""))
powerDataSubset <- subset(powerDataSubset, select = c(10,3:9))

## Step 6 - Create the plot
###############################################################################
## Plot 3 (will go bottom left)

with(powerDataSubset, plot(datetime,Sub_metering_1 , type = "l",
                           ylab = "Energy sub metering", xlab = ""))
with(powerDataSubset, points(datetime ,Sub_metering_2 , type = "l" ,col= "red"))
with(powerDataSubset, points(datetime ,Sub_metering_3 , type = "l" ,col= "blue"))

legtext <- names(powerDataSubset[6:8])
legcols <- c("black", "red", "blue")
legend("topright", legend = legtext, lty= 1, col = legcols)


## Step 7 - Export the Plot as PNG
###############################################################################

dev.copy(png, "Plot3.png")
dev.off()
#Download and unpack the dataset if missing

if(!file.exists("household_power_consumption.txt")){
        message("Dataset missing in working directory. Downloading...")
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","data.zip",method="curl")
        if(!file.exists("data.zip")){
                stop("Download failed! Please retry later.")
        }
        message("Download successful! unzipping")
        unzip("data.zip")
        if(!file.exists("household_power_consumption.txt")){
                stop("Unzip failed! Please retry later.")
        }
        message("Unzip successful! Performing cleanup...")
        file.remove("data.zip")
} else{
        message("Dataset present in working directory, skipping download.")
}

#Creating custom class to parse date directly during read.table (The default parsers dates incorrectly)
setClass("customDate")
setAs("character","customDate", function(from) as.Date(from, format="%d/%m/%Y"))


#Load the dataset
#note that Time is being left as character, it isn't needed for this analysis (plot1 only) and
#there is no good way to handle only time columns in R 
#(they must be stored as Datetimes)
dataset <- read.table("household_power_consumption.txt",sep=";",header=TRUE,
                      colClasses = c("customDate","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),
                      na.strings = "?")

#subset dataset to relevant dates and columns

dataset <- dataset[dataset$Date >= as.Date("2007-02-01") &  dataset$Date <= as.Date("2007-02-02"),c("Date","Global_active_power")]

#open the file device (png file)

png(filename="plot1.png",width=480,height=480)

#generate the plot

hist(dataset$Global_active_power,breaks=15,col="red",xlab="Global Active Power (kilowatts)",main="Global Active Power")

#close the device

dev.off()
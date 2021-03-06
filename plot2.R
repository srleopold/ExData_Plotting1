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



#Load the dataset
#Date and time are being left as characters to merge them after load to create
#the x axis in the plots
dataset <- read.table("household_power_consumption.txt",sep=";",header=TRUE,
                      colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),
                      na.strings = "?")

#merge datetime columns into new datetime column

dataset$datetime <- strptime(paste(dataset$Date,dataset$Time),"%d/%m/%Y %H:%M:%S")

#subset dataset to relevant dates and columns

#note that we check that datetime is stricty less than 03/02/2007 00:00:00, 
#that is, 02/02/2007 23:59:59 or less
dataset <- dataset[dataset$datetime >= strptime("01/02/2007 00:00:00","%d/%m/%Y %H:%M:%S") &  dataset$datetime < strptime("03/02/2007 00:00:00","%d/%m/%Y %H:%M:%S"),c("datetime","Global_active_power")]

#open the file device (png file)

png(filename="plot2.png",width=480,height=480)

#generate the plot

plot(dataset$datetime,dataset$Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)")

#close the device

dev.off()
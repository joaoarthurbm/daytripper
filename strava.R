library("timeDate")
library("plyr")
library("ggplot2")

files     <- list.files(path = "logs/", pattern="*.log")
df_result <- c()

for(file in files){
  
  print(file)
  
  file_name <- paste("logs/", file, sep="")
  
  index     <- sub("-Ride.gpx.log", "", file)
  
  dff       <- read.csv(file=file_name, sep=",", header=F)
  
  colnames(dff) <- c("TIMESTAMP", "ELE", "DIST", "VEL")

  timestamp <- strptime(dff[1, 1], "%Y-%m-%dT%H:%M:%SZ")
  
  dd    <- dayOfWeek(as.timeDate(timestamp))
  day   <- as.character(dd)
  
  dff$VEL  <- dff$VEL * 3.6
  
  distance <- sum(dff$DIST) / 1000
  
  median<- median(dff$VEL)
  meann <- mean(dff$VEL)
  max   <- max(dff$VEL)
  min   <- min(dff$VEL)
  
  df_tmp <- data.frame(ID=index, DAY=day, DIST=distance, MAX=max, MIN=min, MEAN=meann, MEDIAN=median)

  df_result <- rbind(df_result, df_tmp)
}

file_name <- "logs/ride_info_all.dat"
write.table(df_result, file=file_name, row.names=FALSE)

days <- count(df_result$DAY)
colnames(days) <- c("DAY", "FREQ")

ggplot(days, aes(DAY, FREQ, fill=DAY)) + geom_bar(position="dodge", stat="identity") + scale_x_discrete(limits=c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"))

summary(df_result)
#print(df_result)

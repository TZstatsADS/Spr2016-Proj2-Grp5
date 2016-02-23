setwd("D:/Download/Chrome/yellow")
list.files()
library(data.table)
library(dplyr)
col <- c("tpep_pickup_datetime", "tpep_dropoff_datetime", "pickup_longitude", "pickup_latitude",
         "dropoff_longitude", "dropoff_latitude", 'fare_amount', 'tip_amount')
yellow <- fread('yellow.csv', header = TRUE, select = col)

Ini_longitude <- -73.9619
Ini_latitude <- 40.8075


# Choose the sample has same pickup location and dropoff location
alpha <- 0.008
# Choose the sample has pickup location around Columbia University
yellowfiltered <- filter(yellow, (((Ini_longitude - yellow$pickup_longitude) ^ 2 + (Ini_latitude - yellow$pickup_latitude) ^ 2) <= alpha^2))



write.csv(yellowfiltered,"yellowfiltered.csv")
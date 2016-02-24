setwd("D:/Download/Chrome/yellow")
list.files()
library(data.table)
library(dplyr)
col <- c("tpep_pickup_datetime", "tpep_dropoff_datetime", "pickup_longitude", "pickup_latitude",
         "dropoff_longitude", "dropoff_latitude", 'fare_amount', 'tip_amount')
yellow1 <- fread('yellow2.csv', header = TRUE, select = col)
yellow2 <- fread('yellow3.csv', header = TRUE, select = col)

yellow <- rbind(yellow1, yellow2)

intdate <- as.Date("2015-02-01 00:00:00")
enddate <- as.Date("2015-02-28 23:59:59")

Ini_longitude <- -73.9619
Ini_latitude <- 40.8075


# Choose the sample has same pickup location and dropoff location
alpha <- 0.008
# Choose the sample has pickup location around Columbia University
yellowdropoff <- filter(yellow, (((Ini_longitude - yellow$dropoff_longitude) ^ 2 + (Ini_latitude - yellow$dropoff_latitude) ^ 2) <= alpha^2))
yellowdropoff <- yellowdropoff %>%
        filter(tpep_pickup_datetime >= intdate, tpep_pickup_datetime <= enddate)


write.csv(yellowdropoff,"yellowdropoff.csv")


yellowpickup <- filter(yellow, (((Ini_longitude - yellow$pickup_longitude) ^ 2 + (Ini_latitude - yellow$pickup_latitude) ^ 2) <= alpha^2))

yellowpickup <- yellowpickup %>%
        filter(tpep_pickup_datetime >= intdate, tpep_pickup_datetime <= enddate)

write.csv(yellowpickup,"yellowpickup.csv")

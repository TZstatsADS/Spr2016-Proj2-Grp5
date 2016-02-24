library(data.table)
library(dplyr)
library(ggmap)
library(ggplot2)
library(spatstat)
yellowfiltered <- read.csv("~/GitHub/project2-group5/yellowfiltered.csv")
lat <- yellowfiltered$dropoff_latitude[yellowfiltered$dropoff_latitude > .1]
lon <- yellowfiltered$dropoff_longitude[yellowfiltered$dropoff_longitude < -.1]

km <- kmeans(cbind(lat,lon), centers = 10)
centers <- km$centers
clat <- centers['lat']
clon <- centers['lon']
df <- as.data.frame(cbind(clon, clat))
map <- get_map(location = c(lon = mean(df$lon), lat = mean(df$lat)))
plot(centers)
qmplot(centers['lat'], centers['lon'])
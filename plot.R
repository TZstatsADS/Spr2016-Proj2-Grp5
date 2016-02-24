setwd("C:/Users/ouwen/Desktop/Project2")
yellowpickup<-fread('yellowpickup.csv')
yellowdropoff<-fread('yellowdropoff.csv')

yellow <- rbind(yellowpickup, yellowdropoff)
library(ggplot2)
library(plotly)
yellownew <- yellow[c(sample(1:246816), 100),]
yellowfiltered <- yellow %>%
  filter (fare_amount >= 0, fare_amount <= 100, tip_amount <= 100)
qplot(fare_amount,  tip_amount, data = yellowfiltered)
yellow$tip_ratio <- yellow$tip_amount/yellow$fare_amount
qplot(fare_amount, tip_ratio, data=yellownew)

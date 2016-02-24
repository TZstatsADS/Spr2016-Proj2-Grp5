#import all library
library(shiny)
library(datasets)
library(leaflet)
library(data.table)
library(dplyr)

#import filtered data
setwd("C:/Users/ouwen/Downloads")
yellowdata<-fread('yellowfiltered.csv')

point = makeIcon("blue.png", 13, 13)

#began server code
shinyServer(function(input, output){
  intdate <- reactive({
    intdate <- as.POSIXct(paste(as.character(input$Day[1]), as.character(input$IntHour)), format = "%Y-%m-%d %H")
    })
  enddate <- reactive({
    enddate <- as.POSIXct(paste(as.character(input$Day[2]), as.character(input$EndHour)), format = "%Y-%m-%d %H")
  })
  
  #filter data   
  temp <- reactive({
    temp <- yellowdata %>%
      filter(tpep_pickup_datetime >= intdate(), tpep_pickup_datetime <= enddate())
  })
  
  amount <- reactive({
    amount <- input$Amount
  })

  #draw a map
  output$map <- renderLeaflet({
     leaflet(data = temp()[c(sample(1:dim(temp())[1], amount())),])%>% addTiles() %>% setView(lng=-73.9619,lat=40.8075,zoom=14)%>%
       addMarkers(~dropoff_longitude, ~dropoff_latitude, icon= point, popup = ~ as.character(paste("Fare", fare_amount, "Tip", tip_amount, "Ratio", round(tip_amount/fare_amount, 3))))
  })
})
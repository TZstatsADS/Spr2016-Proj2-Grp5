#import all library
library(shiny)
library(datasets)
library(leaflet)
library(data.table)
library(dplyr)

#import filtered data
yellowdata<-fread('yellowfiltered.csv')

#began server code
shinyServer(function(input, output){
  
  

  intdate <- reactive({
    intdate <- as.POSIXct(paste(as.character(input$Day[1]), as.character(input$IntHour)), format = "%Y-%m-%d %H")
    })
  enddate <- reactive({
    enddate <- as.POSIXct(paste(as.character(input$Day[2]), as.character(input$EndHour)), format = "%Y-%m-%d %H")
  })
  
  #experiment 1
  temp <- reactive({
  
  filter(yellowdata, intdate()<= yellowdata$tpep_pickup_datetime)
  })
  
  #yellowdata$tpep_pickup_datetime <-as.POSIXct(yellowdata$tpep_pickup_datetime, format = "%Y-%m-%d %H")
  # 
  # 
  # temp <- yellowdata[yellowdata$tpep_pickup_datetime >= intdate, ]
  #temp <- yellowdata[yellowdata$tpep_pickup_datetime >= intdate()$indate, ]
  
  
  output$map <- renderLeaflet({
     leaflet(data = temp())%>% addTiles() %>% setView(lng=-73.9619,lat=40.8075,zoom=14)%>%
       addMarkers(~dropoff_longitude, ~dropoff_latitude)

  })
})
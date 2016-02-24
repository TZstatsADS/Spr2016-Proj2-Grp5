# Import all library
library(shiny)
library(datasets)
library(leaflet)
library(data.table)
library(dplyr)

# Import filtered data
yellowdata<-fread('../data/yellowfiltered.csv')

point = makeIcon("../doc/blue.png", 13, 13)

# Begin server code
shinyServer(function(input, output){
  intdate <- reactive({
    intdate <- as.POSIXct(paste(as.character(input$Day[1]), 
                                as.character(input$IntHour)), 
                          format = "%Y-%m-%d %H")
    })
  enddate <- reactive({
    enddate <- as.POSIXct(paste(as.character(input$Day[2]), 
                                as.character(input$EndHour)), 
                          format = "%Y-%m-%d %H")
  })
  
  # Filter data   
  temp <- reactive({
    temp <- yellowdata %>% filter(tpep_pickup_datetime >= intdate(), 
                                  tpep_pickup_datetime <= enddate())
  })
  
  amount <- reactive({
    amount <- input$Amount
  })

  # Draw map
  output$map <- renderLeaflet({
     leaflet(data = temp()[c(sample(1:dim(temp())[1], amount())),]) %>% 
      addTiles() %>% 
      setView(lng = -73.971035, lat = 40.775659, zoom = 12) %>% 
      addMarkers(~dropoff_longitude, ~dropoff_latitude, 
                 icon= point, 
                 popup = ~ as.character(paste("Fare: ", fare_amount, 
                                              "Tip: ", tip_amount, 
                                              "Ratio: ", round(tip_amount/fare_amount, 3)))
                 )
  })
})
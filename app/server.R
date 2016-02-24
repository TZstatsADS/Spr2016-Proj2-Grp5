# Import all library
library(shiny)
library(datasets)
library(leaflet)
library(data.table)
library(dplyr)
library(htmltools)
library(ggplot2)

# Import filtered data
yellowpickup<-fread('../data/yellowpickup.csv')
yellowdropoff<-fread('../data/yellowdropoff.csv')

# Data manipulation for fare-tip scatterplot
yellow <- rbind(yellowpickup, yellowdropoff)
yellownew <- yellow[c(sample(1:246816), 100),]
yellowfiltered <- yellownew %>% filter (fare_amount >= 0, fare_amount <= 100, tip_amount <= 100)

point = makeIcon("../doc/blue.png", 13, 13)
alpha = 0.007

# Begin server code
shinyServer(function(input, output){
  
  # Set dates
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
  
  type <- reactive({
          type <- as.character(input$Type)
  })
  
  # Compare and filter data   
  temp <- reactive({
          if (type() == "Start"){
                          temp <- yellowpickup %>% filter(tpep_pickup_datetime >= intdate(), 
                                                          tpep_pickup_datetime <= enddate())
          }
          else {
                          temp <- yellowdropoff %>% filter(tpep_pickup_datetime >= intdate(), 
                                                           tpep_pickup_datetime <= enddate())
          }
  })
  
  amount <- reactive({
    amount <- input$Amount
  })

  # Draw map
  output$map <- renderLeaflet({
          if (type() == "Start"){
                  leaflet(data = temp()[c(sample(1:dim(temp())[1], amount())),]) %>% 
                          addTiles() %>% 
                          setView(lng = -73.971035, lat = 40.775659, zoom = 12) %>% 
                          addMarkers(~dropoff_longitude, ~dropoff_latitude, 
                                     icon= point, 
                                     popup = ~ as.character(paste("Fare: ", fare_amount, 
                                                                  "Tip: ", tip_amount, 
                                                                  "Ratio: ", round(tip_amount/fare_amount, 3)))
                          )
          }
          else{
                  leaflet(data = temp()[c(sample(1:dim(temp())[1], amount())),]) %>% 
                          addTiles() %>% 
                          setView(lng = -73.971035, lat = 40.775659, zoom = 12) %>% 
                          addMarkers(~pickup_longitude, ~pickup_latitude, 
                                     icon= point, 
                                     popup = ~ as.character(paste("Fare: ", fare_amount, 
                                                                  "Tip: ", tip_amount, 
                                                                  "Ratio: ", round(tip_amount/fare_amount, 3)))
                          )
          }

  })
  
  output$plot <- renderPlot({
    qplot(fare_amount,  tip_amount, data = yellowfiltered, 
          xlab = 'Fare Amount', ylab = 'Tip Amount'
    )
  })
})
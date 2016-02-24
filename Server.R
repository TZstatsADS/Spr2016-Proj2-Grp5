# Import all library
library(shiny)
library(datasets)
library(leaflet)
library(data.table)
library(dplyr)
library(htmltools)
library(spatstat)
# Import filtered data
yellowpickup<-fread('./yellowpickup.csv')
yellowdropoff<-fread('./yellowdropoff.csv')

point = makeIcon("./doc/blue.png", 9, 9)
alpha = 0.007
pt = makeIcon("./doc/teal.png", 16, 16)

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

#   temp <- reactive({
#     temp <- yellowpickup %>% filter(tpep_pickup_datetime >= intdate(), 
#                                   tpep_pickup_datetime <= enddate())
#   })
  
  amount <- reactive({
    amount <- input$Amount
  })

  clust_amount <- reactive({
    clust_amount <- input$ClusterCenters
  })
  # Draw map
  output$map <- renderLeaflet({
    dat = temp()[c(sample(1:dim(temp())[1], amount())),]
    km <- kmeans(cbind(dat$dropoff_latitude, dat$dropoff_longitude), centers = clust_amount())
    km_c <- km$centers
          if (type() == "Start"){
                  leaflet(data = dat) %>% 
                          addTiles() %>% 
                          setView(lng = -73.971035, lat = 40.775659, zoom = 12) %>% 
                          addMarkers(~dropoff_longitude, ~dropoff_latitude,
                                     icon= point,
                                     popup = ~ as.character(paste(" Fare: $", fare_amount,
                                                                  " Tip: $", tip_amount,
                                                                  " Percent Tip: ", 100*round(tip_amount/fare_amount, 3), "%", sep = ""))
                          ) %>%
                          addMarkers(km_c[,2], km_c[,1], icon = pt)
                            
          }
          else{
                  leaflet(data = dat) %>% 
                          addTiles() %>% 
                          setView(lng = -73.971035, lat = 40.775659, zoom = 12) %>% 
                          addMarkers(~pickup_longitude, ~pickup_latitude,
                                     icon= point,
                                     popup = ~ as.character(paste("Fare: $", fare_amount,
                                                                  "Tip: $", tip_amount,
                                                                  "Percent Tip: ", 100*round(tip_amount/fare_amount, 3), "%", sep = ""))
                          ) %>%
                          addMarkers(km_c[,2], km_c[,1], icon = pt)
          }

  })
  
#   longtitude <- reactive({
#           if ( type() == "Start"){
#           longtitude <- temp()$dropoff_longtitude
#   }
#   else {
#           longtitude <- temp()$pickup_longtitude
#   }
#   })
#           
# latitude <- reactive({
#         if ( type() == "Start"){
#                 
#                 latitude <- temp()$dropoff_latitude
#         }
#         else{
#                 
#                 latitude <- temp()$pickup_latitude
#         }
# })
# 
# showpopup <- function(eventid, lat, lng){
#         leafletProxy("map") %>% addPopups(lng, lat, "hello", layerId = eventid)
# }
# 
# observe({
#         leafletProxy("map") %>% clearPopups()
#         event <- input$map_click
#         if (is.null(event))
#                 return()
#         isolate({
#                 showpopup(event$id, event$lat, event$lng)
#         })
# })
# #  observeEvent(input$map_click, {
# #          
# #          click <- input$map_click
# #          clat <- click$lat
# #          clng <- click$lng
# #          text <- as.character(paste("love you"))
# #          
# #          leafletProxy("map") %>% 
# #                  addPopups(lng = clng, lat = clat, text, layerId = click$id)
# #  })
# #          areaselect <- filter(temp(), (((clng - longtitude()) ^ 2 + (clat - latitude()) ^ 2) <= alpha^2))
# #          
# #          tempfare <- round(mean(areaselect$fare_amount),2)
# #          temptip <- round(mean(areaselect$tip_amount),2)
# #          text <- paste("Fare:", tempfare, "Tip:", "temptip")
# 
#   # })
})
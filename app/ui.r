library(ggvis)
library(leaflet)

shinyUI(fluidPage(
        titlePanel("When Columbia Students Leave the Bubble..."),
        sidebarLayout(position = "right", 
                      sidebarPanel(
                               h4("Filter"),
                               dateRangeInput("Day", "Choose a date range in February", 
                                              start = "2015-02-14", end = "2015-02-14", 
                                              min = "2015-02-01", max = "2015-02-28"),
                               sliderInput("IntHour", "Start time (of the first date)", 0, 24, 9, step = 1),
                               sliderInput("EndHour", "End time (of the last date)", 0, 24, 24, step = 1),
                               sliderInput("Amount", "Number of trips to display", 1, 1000, 50, step =10),
                               submitButton("Submit"),
                               style = "opacity : 0.85"
                               ),
                      mainPanel(
                              leafletOutput("map", width = "150%", height = 700)
                              )
                      )
))
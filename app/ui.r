library(ggvis)
library(leaflet)
library(htmltools)

shinyUI(fluidPage(
  tags$head(
    tags$style(HTML("
                    h1 {
                    color: #000099;
                    }
                    
                    body {
                    background-color: #FFFFFF;
                    }
                    "))
    ),
  headerPanel("When Columbia Students Leave the Bubble..."),
  sidebarLayout(position = "right", 
                sidebarPanel(
                         h4("Filter"),
                         selectInput ("Type", "Does your trip start or end at CU?", c("Start","End")),
                         dateRangeInput("Day", "Choose a date range in February", 
                                        start = "2015-02-14", end = "2015-02-14", 
                                        min = "2015-02-01", max = "2015-02-28"),
                         sliderInput("IntHour", "Start time (of the first date)", 0, 24, 18, step = 1),
                         sliderInput("EndHour", "End time (of the last date)", 0, 24, 20, step = 1),
                         sliderInput("Amount", "Number of trips to display", 1, 1000, 50, step =10),
                         submitButton("Submit"),
                         style = "opacity : 0.85"
                         ),
                mainPanel(
                                leafletOutput("map", width = "150%", height = 700)
                        )
                ),
  plotOutput('plot', width = '100%', height = 1000)
))
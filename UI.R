library(ggvis)
library(leaflet)

shinyUI(fluidPage(
        titlePanel("Life, out of Campus"),
        
        sidebarLayout(position = "right",
                       sidebarPanel(
                               h4("Filter"),
                               dateRangeInput("Day", "someday in February", start = "2015-02-01", end = "2015-02-28", min = "2015-02-01", max = "2015-02-28"),
                               sliderInput("IntHour", "Hour of the first Day", 0, 24, 0, step = 1),
                               sliderInput("EndHour", "Hour of the last Day", 0, 24, 0, step =1),
                               sliderInput("Amount", "Amount of trips to display", 1, 1000, 100, step =10),
                               submitButton("Submit"),
                               style = "opacity : 0.85"
                               ),
                      mainPanel(
                              leafletOutput("map", width = "150%", height = 700)
                                )

        )
)
)
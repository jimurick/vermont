library(shiny)
library(bslib)
library(leaflet)
library(plotly)
library(tidyverse)
library(hospitalstars)

source("util.R")

df <- readRDS("www/hospital_df.Rda")

state_vec <- sort(unique(hospital_info_df$state))



ui <-
  navbarPage(
    id = "map-navbar",
    title = "Hospital ⭐ Ratings",
    theme = bs_theme(bootswatch = "flatly"),
    tabPanel(
      "Map",
      mySelectInput("state", "Choose a State",
                    choices = state_vec, selected = "VT"),
      div(style = "height: 1rem;"),
      leafletOutput("map"),
    ),
    tabPanel(
      "Plot",
      plotlyOutput("plot")
    )
  )


server <- function(input, output) {
  
  hospitals_df <- reactive({
    hospital_id_vec <-
      hospital_info_df |>
      filter(state == input$state) |>
      pull(PROVIDER_ID)
    df |>
      filter(PROVIDER_ID %in% hospital_id_vec)
  })

  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(
        providers$CartoDB.Positron, options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(
        data = hospitals_df(), lat = ~lat, lng = ~lng,
        label = ~hospital_name, popup = ~popup
      )
  })
}


shinyApp(ui = ui, server = server)

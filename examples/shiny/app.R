library(shiny)
library(bslib)
library(leaflet)
library(plotly)
library(tidyverse)
library(hospitalstars)

source("util.R")

# Initial data preparation -----------------------------------------------------

df <- readRDS("www/hospital_df.Rda")

state_choices <- sort(unique(hospital_info_df$state))
hospital_choices <- setNames(
  hospital_info_df$PROVIDER_ID, hospital_info_df$hospital_name
)
last_report_date <- max(hospitalstars::measure_info_df$report_date)
measure_info_df <- hospitalstars::measure_info_df |>
  filter(report_date == last_report_date)
measure_choices <- setNames(
  measure_info_df$measure_id,
  str_c(measure_info_df$measure_id, ': ', measure_info_df$measure_name)
)


# `ui`: the user interface -----------------------------------------------------

ui <-
  navbarPage(
    id = "map-navbar",
    title = "Hospital ⭐ Ratings",
    theme = bs_theme(bootswatch = "flatly"),
    # Include the javascript script "www/util.js" in the HTML header
    
    # The three tabs: Map, Plot and About
    tabPanel(
      "Map",
      tags$head(tags$script(type="text/javascript", src="util.js")),
      selectInput("state", "Choose a State",
                  choices = state_choices, selected = "VT") |>
        select_input_to_inline(),
      div(style = "height: 1rem;"),
      leafletOutput("map"),
    ),
    tabPanel(
      "Plot",
      selectizeInput("hospital_id", "Hospital", choices = NULL),
      selectizeInput("measure_id", "Measure", choices = measure_choices),
      plotlyOutput("plot")
    ),
    tabPanel(
      "About",
      withMathJax(), 
      includeMarkdown("About.md")
    )
  )


# `server`: defines interaction ------------------------------------------------

server <- function(input, output, session) {
  
  updateSelectizeInput(session, "hospital_id",
                       choices = hospital_choices, server = TRUE)
  
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
  
  observeEvent(input$update_hospital, {
    updateSelectizeInput(session, "hospital_id",
                         choices = hospital_choices,
                         selected = input$update_hospital, server = TRUE)
    updateTabsetPanel(session, "map-navbar", "Plot")
  })
}


shinyApp(ui = ui, server = server)

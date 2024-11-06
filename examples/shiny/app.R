library(shiny)
library(hospitalstars) # my package on github with most hospital data
library(tidyverse)     # for manipulating data and making the initial plot
library(leaflet)       # for the map
library(plotly)        # for the plot
library(markdown)      # for the "About" tab

source("util.R")       # one extra function: `select_input_to_inline`

# Default ggplot plots to the black & white theme
theme_set(theme_bw())

# Initial data preparation -----------------------------------------------------

df <- readRDS("www/hospital_df.Rda")

# Options for "Choose a State" box
state_choices <- sort(unique(hospital_info_df$state))
# Options for "Choose a Hospital" box
hospital_choices <-
  deframe(hospital_info_df[, c("hospital_name", "PROVIDER_ID")])
last_report_date <- max(hospitalstars::measure_info_df$report_date)
# One row per measure with general info about the metrics used in the ratings
measure_info_df <-
  hospitalstars::measure_info_df |>
  filter(report_date == last_report_date, !is.na(measure_group))
# Options for "Choose a Metric" box
measure_choices <- 
  measure_info_df |>
  select(measure_group, measure_id, measure_name) |>
  arrange(measure_group, measure_id) |>
  nest(measures = c(measure_id, measure_name)) |>
  mutate(measures = map(measures, ~setNames(.x$measure_id, .x$measure_name))) |>
  deframe()


# ui: the user interface -----------------------------------------------------

ui <-
  navbarPage(
    id = "map-navbar",
    title = "Hospital ⭐ Ratings",

    # The three tabs: Map, Plot and About
    tabPanel(
      title = "Map",
      # Set the favicon
      tags$head(tags$link(rel = "icon", type="image/x-icon", href = "jim.ico")),
      # CSS to make the map take up most of the vertical space
      tags$style(type = "text/css",
                 '#map {height: calc(100vh - 200px) !important;}'),
      # Include the javascript script "www/util.js" in the HTML header
      tags$head(tags$script(type="text/javascript", src="util.js")),
      selectInput("state", "Choose a State",
                  choices = state_choices, selected = "VT") |>
        # function from "util.R" to fix how this input is displayed
        select_input_to_inline(label_width = 12, select_width = 10),
      div(style = "height: 1rem;"), # put some space before the map
      leafletOutput("map"),
    ),
    tabPanel(
      title = "Plot",
      tags$h3("Hospital Scores vs Overall 5-number Summaries"),
      selectizeInput("provider_id", "Choose a Hospital", choices = NULL) |>
        # function from "util.R" to fix how this input is displayed
        select_input_to_inline(label_width = 15, select_width = 40),
      selectizeInput("measure_id", "Choose a Measure", choices = measure_choices) |>
        # function from "util.R" to fix how this input is displayed
        select_input_to_inline(label_width = 15, select_width = 40),
      div(style = "height: 1rem;"), # put some space before the plot
      plotlyOutput("plot")
    ),
    tabPanel(
      title = "About",
      # Include the CSS stylesheet "www/about.css" in the HTML header
      tags$head(tags$link(rel="stylesheet", href="about.css")),
      withMathJax(), 
      includeMarkdown("About.md")
    )
  )


# server: defines interaction ------------------------------------------------

server <- function(input, output, session) {
  
  ## Map Tab -------------------------------------------------------------------
  
  # Populate the options in the "Choose Hospital" box
  updateSelectizeInput(session, "provider_id",
                       choices = hospital_choices, server = TRUE)
  
  # The dataframe of all hospitals in the selected state
  r_hospitals_df <- reactive({
    hospital_id_vec <-
      hospital_info_df |>
      filter(state == input$state) |>
      pull(PROVIDER_ID)
    df |>
      filter(PROVIDER_ID %in% hospital_id_vec)
  })

  # Render the map with all the selected state's hospitals on it
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(
        providers$OpenStreetMap, options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(
        data = r_hospitals_df(), lat = ~lat, lng = ~lng,
        label = ~hospital_name, popup = ~popup
      )
  })

  # When a "View Data" button is clicked, the javascript function
  # `view_hospital_plots` from "www/util.js" is called. That function sets
  # input$update_hospital, which triggers this code to run.
  observeEvent(input$update_hospital, {
    updateSelectizeInput(session, "provider_id",
                         choices = hospital_choices,
                         selected = input$update_hospital, server = TRUE)
    updateTabsetPanel(session, "map-navbar", "Plot")
  })
  
  ## Plot Tab ------------------------------------------------------------------

  # Scores for the selected hospital & metric
  r_hospital_scores_df <- reactive({
    hospitalstars::historical_measure_data(
      measure_ids = input$measure_id, provider_ids = input$provider_id
    ) |>
      transmute(`Report Date` = report_date, Score = score)
  })

  # All hospitals' scores for the selected metric  
  r_all_scores_df <- reactive({
    meas_id <- input$measure_id
    hospitalstars::star_algorithm_input_df[, c("report_date", meas_id)] |>
      rename_with(~ifelse(.x == meas_id, "Score", "Report Date")) |>
      filter(!is.na(Score))
  })
  
  # General info about the selected metric, in a data.frame row
  r_measure_info <- reactive({
    measure_info_df |>
      filter(measure_id == input$measure_id)
  })
  
  output$plot <- renderPlotly({
    # Sometimes `input$provider_id` isn't set. Make sure it is:
    req(input$provider_id)
    
    title <-
      str_c(ifelse(r_measure_info()$higher_is_better, "Higher", "Lower"),
            " scores are better")
    box_color <- "#888"
    line_color <- "dodgerblue"
    
    # Make a ggplot2 plot
    p <-
      r_hospital_scores_df() |>
      ggplot(aes(`Report Date`, Score)) +
      geom_boxplot(
        data = r_all_scores_df(),
        mapping = aes(x = `Report Date`, y = Score, group = `Report Date`)
      ) +
      geom_point(color = line_color, size = 3) +
      geom_line(color = line_color, linewidth = 1.5, alpha = 0.5) +
      ggtitle(title)
    # Convert it to plotly, so it's more interactive
    p |> plotly::ggplotly()
  })
  
}

# Run the app
shinyApp(ui = ui, server = server)

#
# Journal Impact factor database
# Get the latest IF of your selected journal
#

library(shiny)
library(magrittr)
library(tidyverse)
# devtools::install_github("ricardo-bion/ggtech", dependencies=TRUE)
library(ggtech)
library(shinythemes)
library(DT)

# Import JCR database
dataset <- readRDS(file = "www/ifDatasets.RDS")
journals <- dataset$journals
years <- dataset$years
# Define UI
ui <- fluidPage(theme = shinytheme("united"),
                # Application title
                titlePanel("Find Journal Impact Factor"),
                
                fluidRow(
                  column(
                    12,
                    selectInput(
                      inputId = "select",
                      label = h3("Choose a Journal"),
                      choices = journals,
                      selected = "LANCET"
                    ),
                    verbatimTextOutput("journal_name"),
                    p("Latest Impact factor is:"),
                    verbatimTextOutput("journal_IF"),
                    
                    plotOutput("trend_img"),
                    dataTableOutput("IFtable")
                  )
                ))

# Define server
server <- function(input, output) {
  jname <- reactive({
    input$select
  })
  
  output$journal_name <- renderPrint({
    jname()
  })
  
  output$journal_IF <-
    renderPrint({
      dataset$jcr_latest %>%
        dplyr::filter(Full.Journal.Title == jname()) %>%
        dplyr::pull(Journal.Impact.Factor)
    })
  
  output$trend_img <- renderPlot({
    dat_trend <- lapply(dataset$jcrs, function(x)
      dplyr::filter(x, Full.Journal.Title == jname())) %>%
      do.call(rbind, .) %>%
      dplyr::mutate(Year = years) %>%
      dplyr::mutate(Journal.Impact.Factor = as.numeric(Journal.Impact.Factor))
    
    
    dat_trend %>%
      ggplot2::ggplot(mapping = aes(x = Year,
                                    y = Journal.Impact.Factor,
                                    group = 1)) +
      geom_point(size = 2) +
      geom_line(size = 1) +
      geom_label(
        aes(label = Journal.Impact.Factor, y = Journal.Impact.Factor),
        position = position_dodge(0.9),
        hjust = -0.2
      ) +
    ggtitle(jname()) +
      scale_y_continuous(name = "Impact factor") +
      ggtech::theme_tech(theme = "airbnb") +
      scale_fill_tech(theme = "airbnb")
  })
  
  output$IFtable <- renderDataTable({
    lapply(dataset$jcrs, function(x)
      dplyr::filter(x, Full.Journal.Title == jname())) %>%
      do.call(rbind, .) %>%
      dplyr::mutate(Year = years) %>%
      dplyr::select(Full.Journal.Title,
                    Year,
                    Total.Cites,
                    Journal.Impact.Factor)
  })
}

# Run the application
shinyApp(ui = ui, server = server)

#
# Journal Impact factor database
# Get the latest IF of your selected journal
#

library("shiny")
library("magrittr")
library("tidyverse")
library("ggpubr")

# Import JCR database
jcrfs <- list.files(path = "./www", pattern = "JCR.+csv$")
years <- stringr::str_extract(jcrfs, '\\d+')
jcrs <- lapply(jcrfs, function(x)
  read.csv(file.path("www", x)))
jcr_latest <- read.csv(file.path("www", jcrfs[length(jcrfs)]))

# List of choices for selectInput
journals <- as.list(jcr_latest$Full.Journal.Title)

# Define UI
ui <- fluidPage(# Application title
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
  output$journal_name <- renderPrint({
    input$select
  })
  
  output$journal_IF <-
    renderPrint({
      jcr_latest %>%
        dplyr::filter(Full.Journal.Title == input$select) %>%
        dplyr::pull(Journal.Impact.Factor)
    })
  
  output$trend_img <- renderPlot({
    lapply(jcrs, function(x)
      dplyr::filter(x, Full.Journal.Title == input$select)) %>%
      do.call(rbind, .) %>%
      dplyr::mutate(Year = years) %>%
      dplyr::mutate(Journal.Impact.Factor = as.numeric(Journal.Impact.Factor)) %>%
      ggplot2::ggplot(mapping = aes(x = Year,
                                    y = Journal.Impact.Factor,
                                    group = 1)) +
      geom_point(color = "Black",
                 size = 2) +
      geom_line(color = "Blue",
                size = 1) +
      ggtitle(input$select) +
      scale_y_continuous(name = "Impact factor") +
      ggpubr::theme_pubr()
  })
  
  output$IFtable <- renderDataTable({
    lapply(jcrs, function(x)
      dplyr::filter(x, Full.Journal.Title == input$select)) %>%
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

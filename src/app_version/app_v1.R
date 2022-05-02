#
# Journal Impact factor database
# Get the latest IF of your selected journal
#

library(shiny)
library("magrittr")
library("tidyverse")
jcr <- read.csv("jcr_2020.csv")

# List of choices for selectInput
journallist <- as.list(jcr$Full.Journal.Title)
# Name it
# names(journallist) <- choices$var


# Define UI for application that draws a histogram
ui <- fluidPage(# Application title
    titlePanel("Find Journal Impact Factor"),
    
    fluidRow(
        column(
            12,
            selectInput(
                inputId = "select",
                label = h3("Choose a Journal"),
                choices = journallist,
                selected = "LANCET"
            ),
            hr(),
            p("You have chose the journal below:"),
            verbatimTextOutput("journal_name"),
            
            hr(),
            p("Latest Impact factor is:"),
            verbatimTextOutput("journal_IF")
        )
    ))

# Define server logic required to draw a histogram
server <- function(input, output) {
    # You can access the value of the widget with input$select, e.g.
    output$journal_name <- renderPrint({
        input$select
    })
    
    output$journal_IF <-
        renderPrint({
            jcr %>% dplyr::filter(Full.Journal.Title == input$select) %>% dplyr::pull(Journal.Impact.Factor)
        })
}

# Run the application
shinyApp(ui = ui, server = server)

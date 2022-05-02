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
      verbatimTextOutput("journal_IF"),
      
      hr(),
      p("自1975年以来，影响因子由美国科睿唯安公司旗下的《期刊引证报告》（JCR）于每年定期发布。"),
      p("影响因子即某期刊前两年（S，T）发表的论文在统计当年（U）的被引用总次数X（前两年总被引次数）除以该期刊在前两年（S, T）内发表的论文总数Y（前两年总发文量）。这是一个国际上通行的期刊评价指标。公式为：IFU =（X(S,T) / Y(S,T)）。 "),
      
      hr(),
      p("* 以1992年为例，计算某期刊在该年的影响因子:"),
      p("X＝以1992年为基点、某期刊于1990和1991年出版论文在1992年被引用之总次数"),
      p("Y＝以1992年为基点、某期刊1990和1991年全部论文发文量的总和"),
      p("IF1992年 ＝（X(1990年,1991年) / Y(1990年,1991年)）"),
      p("Clarivate / Journal Citation Reports(https://clarivate.com/products/journal-citation-reports/)")
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

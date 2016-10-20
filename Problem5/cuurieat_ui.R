library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Track Elections"),
  fluidRow(
    column(3, wellPanel(
      textInput("text", "Text:", "text here"),
      submitButton("Submit")
    )),
    column(6,
           plotOutput("plot1", width = 400, height = 300),
           verbatimTextOutput("text")
     )
  )
))


  
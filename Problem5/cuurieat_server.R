library(shiny)
runApp("/Users/anjali/Desktop/myapp")

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  output$plot1 <- renderPlot({
    s1<-sum(grepl(input$text, tweets$text))
    t1<-sum(grepl(input$text, tweets1$text))
    x    <- tweets[1:46, 2]  # Old Faithful Geyser data
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x,col = 'blue', border = 'white')
  })
  output$text <-renderText({
    paste("Popularity count is:",x)
  })
})
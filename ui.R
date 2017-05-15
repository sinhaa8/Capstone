## Capstone: Coursera Data Science
## Final Project

library(shiny)
library(markdown)

## SHINY UI
shinyUI(
  fluidPage(
    titlePanel("Capstone project of the Coursera Data Science Specialization in cooperation with swiftkey-To Predict Word"),
    sidebarLayout(
      sidebarPanel(
       # helpText("ENTER A WORD, TEXT OR A SENTENCE TO PREVIEW NEXT WORD PREDICTION"),
      #  hr(),
        textInput("inputText", "ENTER THE TEXT / WORD / SENTENCE IN BELOW ",value = ""),
        hr(),
        h4("Please read Overview and \"How to use the Application\" to know the rules to enter in above and Navigate to \"OUPUT TAB\" to preview next word prediction", style = "color:green;"),
    #    p("1. Type some text into the text box under the \"ENTER the TEXT/WORD/SENTENCE HERE\" heading."),
     #   p("2. \"Text input\" values are restricted to only alphabetical words."),
      #  p("3. To run the application, type a phrase in the box below"),
       #  helpText("1 - AFTER THE TEXT INPUT THE PREDICT NEXT WORD WILL BE DISPLAYED.", 
        #         hr(),
         #        "2 - YOU HAVE TO ENTER A PARTIALLY TEXT /SENTENCE TO SHOW THE NEXT WORD PREDICTION.",
          #       hr(),
           #      "3 - THE FORWARD WORD IS SHOWED AT THE PREDICT NEXT WORD TEXT BOX ON THE RIGHT SIDE"),
      #  hr(),
        hr()
      ),
      mainPanel(
        tabsetPanel(type = "tabs", 
                    tabPanel(h4("Overview", style = "color:purple;"), 
                             h4("Introduction", style = "color:blue;"),
                             p("This application is developed as part of the requirement for the Coursera Data Science Capstone Course."),
                             p("The goal of the project is to build a predictive text model combined with a shiny app UI that will predict the next word as the user types a sentence similar to the way most smart phone keyboards are implemented today using the technology of Swiftkey."),
                             h4("Methodology", style = "color:blue;"),
                             p("In the fields of computational linguistics and probability, an n-gram is a contiguous sequence of n items from a given sequence of text or speech."),
                             p("I have generated from 1 to 4 gram models."),
                             h4("How to use the Application", style = "color:blue;"),
                             p("1. Type some text into the text box under the \"ENTER the TEXT/WORD/SENTENCE HERE\" heading."),
                             p("2. \"Text input\" values are restricted to only alphabetical words."),
                             p("3. To run the application, type a phrase in the box below"),
                             h4("Output", style = "color:blue;"),
                             p("4. Navigate to Output Panel to view results by clicking on the \"Output\" tab."),
                             p("5. Beneath \"THE PREDICTED NEXT WORD AT THIS BOX\", you will see the suggested predicted next word of your phrase. you are currently typing  "),
                             p("6. It also reflects what you entered along under \"WORD/TEXT/SENTENCE ENTERED \""),
                             p("7. Additional you will see which Ngram model was used to predicted the word.")),
                            
                    tabPanel(h4("Output", style = "color:purple;"),
                             
        h2("THE PREDICTED NEXT WORD AT THIS BOX", style = "color:red;"),
        verbatimTextOutput("prediction"),
        strong("WORD / TEXT / SENTENCE ENTERED:", style = "color:red;"),
        strong(code(textOutput('sentence1'))),
        br(),
        strong("USING SEARCH AT N-GRAMS TO SHOW NEXT WORD:", style = "color:red;"),
        strong(code(textOutput('sentence2'))),
        hr(),
        hr(),
        hr(),
        img(src = 'swiftkey_logo.jpg', height = 101, width = 498),
        hr(),
        hr(),
        img(src = 'coursera_logo.png', height = 122, width = 467),
        hr()
                    )
        )
      )
    )
  )
)

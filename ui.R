library(shiny)
library(leaflet)
library(shinythemes)
library(plotly)
# UI setting
shinyUI(fluidPage(theme = shinytheme("cerulean"),
  titlePanel("Factors affecting Melbourne’s housing prices"),
  navbarPage("Let's get started",
    ### Introduction page
    tabPanel('Introduction',
      fluidRow(
        h1("Welcome to Melbourne.", align="center",
           style ="font-family: 'times'; font-size: 32pt ")
      ),
             
      sidebarLayout(
        sidebarPanel(
          h1("Melbourne is considered one of the most liveable cities in the world. 
             Many people may have interests in living in Melbourne. 
             One of the most important problems to live in the city is housing price. 
             This project is going to explore the factors affecting Melbourne housing price.")
        ),
          
        
        mainPanel(
          
          img(src = "MEL.jpg")
        )
      )    
    ),
    ### Trend page
    tabPanel('Trend',
      fluidRow(
        h1("Changes in price through time", align="center",
          style ="font-family: 'times'; font-size: 32pt ")
      ),
    #line
      sidebarLayout(
        sidebarPanel(
          helpText("The line graph will show the price changes for three types of house through 2016 to 2018. "),
      
      
          dateRangeInput("date",
                     "Date range",
                     start = "2016-01-28",
                     end = "2018-10-03",
                     min = "2016-01-28",
                     max = "2018-10-03"),
      
          br(),
          br(),
          checkboxGroupInput(inputId = "Type", label = strong("Choose housing type:"),
                             choices = c("House"="h","Townhouse"="t","Unit"="u"),
                             selected = "h"),
          submitButton("Update")
        ),
        mainPanel(
          plotlyOutput("pricechange"),
          
          column(12,
               verbatimTextOutput("dateRangeText1")),
          p("In this three types, unit have the lowest price and house have the highest price.")
        )
    
    )
    ),
    ### Map page
    tabPanel('Map',
      fluidRow(
        h1("Price overview on Melbourne map.", align="center",
          style ="font-family: 'times'; font-size: 32pt ")
      ),
    # map
    
      sidebarLayout(
        sidebarPanel(
          helpText("Create housing price maps with 
                 information from 2016 to 2018."),
          
          dateRangeInput("date3",
                         "Date range",
                         start = "2016-01-28",
                         end = "2018-10-03",
                         min = "2016-01-28",
                         max = "2018-10-03"),
          
          sliderInput("range1", 
                      label = "Price Range of interest:",
                      min = 0, max = 2500000, value = c(0, 2500000)),
          submitButton("Update")
        ),
        
        mainPanel(
          leafletOutput("map"),
          column(12,
                 verbatimTextOutput("dateRangeText2"))
        )
      )
    ),
    ### Factor 1 page 
    tabPanel('Factor 1',
      fluidRow(
        h1("Relationship between distance to CBD and price", align="center",
            style ="font-family: 'times'; font-size: 32pt ")
      ),
      
      sidebarLayout(
        sidebarPanel(
          helpText("Creat scatter plot to explore the relationship between distance to CBD and housing price"),
          sliderInput("range2", 
                      label = "Distance Range of interest:",
                      min = 0, max = 30, value = c(0, 30)),
          submitButton("Update")         
          
        ),
        mainPanel(
          
          plotlyOutput(outputId = "scatterplot"),
          column(12,
                 verbatimTextOutput("dateRangeText3")),
          
          p("As shown in the figure below, it seems that there is no strong correlation between these two variables. 
            However, the regression line shows that it may have a weak negative linear relationship between these two variables. 
            It makes sense that with the increase of distance to CBD, the price decreases.",width=8)
        )
      )
    ),
    ### Factor 2 Page
    tabPanel('Factor 2',
      fluidRow(
        h1("The most popular house type in Melbourne", align="center",
          style ="font-family: 'times'; font-size: 32pt ")
      ),
      sidebarLayout(
        sidebarPanel(
          dateRangeInput("date1",
                         "Date range",
                         start = "2016-01-28",
                         end = "2018-10-03",
                         min = "2016-01-28",
                         max = "2018-10-03"),
          submitButton("Update")
        ),
        mainPanel(
          plotlyOutput("piechart"),
          column(12,
                 verbatimTextOutput("dateRangeText4")),
          p("As shown in this figure , the house takes up over 70 per cent. 
            According to the description of data, the red part ‘h’ represents the house, cottage, villa, semi and terrace. 
            The most popular house type is the house. 
            The townhouse is not very popular in Melbourne.",width=8)
        )
      )
    ),
    ### Factor 3  Page
    tabPanel('Factor 3',
      fluidRow(
        h1("The most popular suburb in Melbourne", align="center",
            style ="font-family: 'times'; font-size: 32pt ")
      ),
      sidebarLayout(
        sidebarPanel(
          sliderInput(inputId = "bins1",
                      label = "Number of bins:",
                      min = 1,
                      max = 50,
                      value = 30),
                submitButton("Update")
        ),

        mainPanel(
          plotlyOutput("barplot1"),
          column(12,
                 verbatimTextOutput("dateRangeText5")),
          p("According to this figure, the most popular suburb in Melbourne is Reservoir. 
            The top5 popular suburb is Reservoir, Bentleigh East, Richmond, Preston and Brunswick. 
            South Yarra ranked as the 9th popular suburb.",width=8)
        
        )
      )
    ),
    ### Factor 4 Page
    tabPanel('Factor 4',
             fluidRow(
               h1("Relationship between region and housing price", align="center",
                  style ="font-family: 'times'; font-size: 32pt ")
             ),
             sidebarLayout(
               sidebarPanel(
                 dateRangeInput("date2",
                                "Date range",
                                start = "2016-01-28",
                                end = "2018-10-03",
                                min = "2016-01-28",
                                max = "2018-10-03"),
                 checkboxGroupInput(inputId = "region", label = strong("Choose region name:"),
                                    choices = as.character(unique(unlist(my_data$Regionname))),
                                    selected = "Southern Metropolitan"),
                 submitButton("Update")
               ),
               
               mainPanel(
                 plotlyOutput("boxplot"),
                 column(12,
                        verbatimTextOutput("dateRangeText6")),
                 p("According to this figure, the region Southern Metropolitan has the highest median price. 
                   The price in each region is different from other regions. The median price in Southern Metropolitan is $1000,000 higher than the median price in Northern Victoria. 
                   Therefore, the categorical data ‘Regionname’ is one of the factors affecting housing price.",width=8)
                 
               )
             )
    ),
    ### other factors page
    tabPanel('Other Factors',
      fluidRow(
        h1("Other factors affecting Melbourne housing price", align="center",
           style ="font-family: 'times'; font-size: 32pt "),
        column(6,
                plotlyOutput("other1"),
                 br(),
                 plotlyOutput("other2"),
                 br(),
               ),
        column(6,
               plotlyOutput("other3"),
               br(),
               br(),
               p("There are many factors affecting Melbourne housing price.Here exploring these factors,
                 including distance to train station,distance to closest school,number of rooms and bathrooms.
                 These two distance variables have a weak negative linear relationship with price. 
                 With the increase of ‘distance_to_closest_school’ and ‘distance_to_train_station’, 
                 the housing price may decrease a little bit."),
               p("Two variables ‘Rooms’ and ‘Bathroom’ has a positive linear relationship between price. 
                 House which has 2-3 rooms and 1-2 bathroom are in the majority of all the houses.")
               )
      )

             
             
             
    ),
    ### Data page
    tabPanel("Data",
             fluidRow(column(DT::dataTableOutput("RawData"),
                             width = 12))
             
    ),
    ### Reference page
    tabPanel("References",
             
             h3("The image in the introduction part is from", a("Link", href="https://www.gostudy.com.au/australia/cities/melbourne/")),
             
             h3("Original dataset from Kaggle", a("Link", href="https://www.kaggle.com/anthonypino/melbourne-housing-market#Melbourne_housing_FULL.csv"))
    )
  )
))
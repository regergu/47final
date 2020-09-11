


#server setting
shinyServer(function(input, output) {

  #filter for line graph
  filtered <- reactive({
    x <- my_data %>%
      filter(Date >= input$date[1],
        Date <= input$date[2],
        Type == input$Type
      )

  })
  #map filter
  filter_map<- reactive({
    x <- my_data %>%
      filter(Date >= input$date3[1],
             Date <= input$date3[2],
             Price>= input$range1[1],
             Price<= input$range1[2]
      )
  })
  #scatterplot filter
  filter_scateter<- reactive({
    x <- my_data %>%
      filter(Distance >= input$range2[1],
             Distance <= input$range2[2]
             
      )
  })  
  # pie chart filter
  filter_date1<- reactive({
    x <- my_data %>%
      filter(Date >= input$date1[1],
             Date <= input$date1[2]
      )
  })
  # boxplot filter
  filter_date2<- reactive({
    x <- my_data %>%
      
      filter(Date >= input$date2[1],
             Date <= input$date2[2],
             Regionname==input$region
             )
  })

  #trend linegraph
  output$pricechange <- renderPlotly({


    d.agg<- aggregate(Price ~ Month + Year+Type, filtered(), FUN = mean) 
    d.agg$date <- as.POSIXct(paste(d.agg$Year, d.agg$Month, "01", sep = "-"))
    d.agg %>% plot_ly(x = ~date, y = ~Price,color = ~Type, 
                           type = 'scatter', mode = 'lines')
  })
  #map
  output$boxplot<-renderPlotly({

    plot_ly(filter_date2(), y = ~Price, color = ~Regionname, type = "box")
  })
  output$map<-renderLeaflet({

    pal<-colorNumeric(palette = c('white','yellow','red','dark red'),domain=filter_map()$Price)
    pal
    
    leaflet(data=filter_map()) %>% addTiles() %>% addCircleMarkers(
      ~filter_map()$Longitude,
      ~filter_map()$Latitude,
      color=~pal(Price),stroke=FALSE,fillOpacity = 0.6, radius = ~4,label = ~Price) %>% 
      addLegend(position = 'topright',pal=pal,values = ~Price,title="Housing price ")
  })
  #factor1 scatterplot
  output$scatterplot<- renderPlotly({

    p3 <- ggplot(filter_scateter(), aes(x=Distance, y=Price)) +
      geom_point() +
      geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE)
      
    ggplotly(p3)
    
  })
  #factor2 piechart
  output$piechart<-renderPlotly({
    fig <- plot_ly(type='pie', data=count(filter_date1(),Type),labels=~Type, values=~n, 
                   textinfo='label+percent',
                   insidetextorientation='radial')
    fig
    
  })  
  #factor3 barplot
  output$barplot1<- renderPlotly({

    suburb<-count(my_data,Suburb)
    suburb<- as.data.frame(suburb)
    suburb<-suburb[order(-suburb$n),]
    
    suburb<-suburb[0:input$bins1,]
    p<-ggplot(data=suburb, aes(x=Suburb,y=n,fill=Suburb)) +
      geom_bar(stat="identity")+ ylab("Count") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
    ggplotly(p)
 
  })
  #other1
  output$other1 <-renderPlotly({
    p3 <- ggplot(my_data, aes(x=distance_to_train_station, y=Price)) +
      geom_point() +ggtitle("Relationship between distance to train station and price")+
      geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE)+
      theme(plot.title = element_text(hjust = 0.5))
    
    ggplotly(p3)
  })
  #other2
  output$other2 <-renderPlotly({
    p3 <- ggplot(my_data, aes(x=distance_to_closest_school, y=Price)) +
      geom_point() +ggtitle("Relationship between distance to train station and price")+
      geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE)+
      theme(plot.title = element_text(hjust = 0.5))
    
    ggplotly(p3)
  })
  #other3
  output$other3 <-renderPlotly({
    axx <- list(title = "Rooms")
    axy <- list(title = "Bathroom")
    axz <- list(title = "Price")
    
    fig <- plot_ly(data=my_data,x = my_data$Rooms, y = my_data$Bathroom, z = my_data$Price,type = 'mesh3d') 
    fig <- fig %>% layout(title = "Relationship between number of rooms, bathroom and Price ",
                          scene = list(xaxis=axx,yaxis=axy,zaxis=axz))
    fig
  })
  output$RawData <- DT::renderDataTable(
    DT::datatable(my_data, options = list(pageLength = 25))
  )


  #text for trend
  output$dateRangeText1  <- renderText({
    paste(" Selected date range is", 
          paste(as.character(input$date), collapse = " to "),".\n",
          paste("Selected house type including:",
                paste(as.character(input$Type), collapse = " , "),".")
    )
    
  })
  # text for map
  output$dateRangeText2  <- renderText({
    paste("Selected date range is", 
          paste(as.character(input$date3), collapse = " to "),
          paste(". Selected price range is ",
                paste(as.character(input$range1), collapse = " - "))
          )

    
  })
  #text for factor1
  output$dateRangeText3  <- renderText({
    paste("Selected distance range is", 
          paste(as.character(input$range2), collapse = " to ","km.")
    )
  })
  #text for factor2
  output$dateRangeText4  <- renderText({
    paste("Selected date range is", 
          paste(as.character(input$date1), collapse = " to ",".")
    )
  })
  #text for factor3
  output$dateRangeText5  <- renderText({
    paste("Selected number of bins is", 
          paste(as.character(input$bins1),".")
    )
  })
  #text for factor4
  output$dateRangeText6  <- renderText({
    paste(" Selected date range is", 
          paste(as.character(input$date2), collapse = " to "),".\n",
          paste("Selected Region including:",
                paste(as.character(input$region), collapse = " , "),".")
    )
  })
})
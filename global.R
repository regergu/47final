library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(plotly)
#In case of xts error 
#install.packages('xts')
# read data into R
my_data <- read.csv('cleandata.csv')
my_data$Date<-as.Date(my_data$Date)
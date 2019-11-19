# -------------------------------------------------------------------------------------------
# UI in R
# -------------------------------------------------------------------------------------------
setwd("C:/Users/DariaS.ADFT/Desktop/Umetna Intelegenca/RProject")
getwd()
rm(list=ls(all=TRUE))
graphics.off()
close.screen(all = TRUE)
erase.screen()
windows.options(record=TRUE)


library(aod)
library(ggplot2)
library(doBy)
library("rio")
library(gmodels) # Load the gmodels package 

# -------------------------------------------------------------------------------------------
# Exploratory Data Analysis and Data Pre-processing 
# -------------------------------------------------------------------------------------------

#Load and preview dataset
my_data <- read.delim("podatkiSem1.txt", header = TRUE, sep = ",", dec = ".")
str(my_data)

#Exporting dataset to the .csv file
export(my_data , "my_data.csv")

#Creating the back up of the dataset
my_data_copy <-my_data


# Glob_sevanje_max
 
summaryBy(Glob_sevanje_max ~ Postaja, data = my_data_copy, na.rm =TRUE,
          FUN = list(mean, max, min, median, sd))
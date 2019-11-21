# -------------------------------------------------------------------------------------------
# UI in R
# -------------------------------------------------------------------------------------------
setwd("C:/Users/DariaS.ADFT/Desktop/Umetna Intelegenca/RProject")
#getwd()
#rm(list=ls(all=TRUE))
#graphics.off()
#close.screen(all = TRUE)
#erase.screen()
#windows.options(record=TRUE)


#library(aod)
#library(ggplot2)
#library(doBy)
library("rio")
#library(gmodels) 
library(dplyr)
library(reshape2)


# -------------------------------------------------------------------------------------------
# Exploratory Data Analysis and Data Pre-processing 
# -------------------------------------------------------------------------------------------

# Loading data 
## Loading dataset
my_data <- read.delim("podatkiSem1.txt", header = TRUE, sep = ",", dec = ".")

##Exporting dataset to the .csv file
export(my_data , "my_data.csv")

## Creating the back up of the dataset
my_data_copy <-my_data

# Creatng new variables
## Creating new variable for the year (leto)
## I reallz doubtr that it is neeed, most likelz shold be commented out 
my_data$leto <-as.integer(format(as.Date(my_data$Datum, format="%Y-%m-%d"),"%Y"))

## Creating new variable fo the month (mesec)
my_data$mesec <-as.integer(format(as.Date(my_data$Datum, format="%Y-%m-%d"),"%m"))

## Creating new variable for the season (letni_cas)
## months 12,1,2 as winter (zima)
## 3,4,5 as spring (pomlad)
## 6,7,8 as summer (poletje)
## 9, 10, 11 as autumn (jesen)

my_data <- mutate(my_data, letni_cas = ifelse(mesec %in% 1:2, "zima",
                                  ifelse(mesec %in% 3:5, "pomlad",
                                         ifelse(mesec %in% 6:8, "poletje",
                                                ifelse(mesec %in% 9:11, "jesen", "zima")))))

## Creating new variable for Glob sevanje change (Glob_sevanje_spr)
my_data$Glob_sevanje_spr <- my_data$Glob_sevanje_max - my_data$Glob_sevanje_min

## Creating new variable for Pritisk change (Pritisk_spr)
my_data$Pritisk_spr <- my_data$Pritisk_max - my_data$Pritisk_min

## Creating new variable for Vlaga change (Vlaga_spr)
my_data$Vlaga_spr <- my_data$Vlaga_max -  my_data$Vlaga_min

## Creating new variable for Temperatura_Krvavec change (Temperatura_Krvavec_spr)
my_data$Temperatura_Krvavec_spr <- my_data$Temperatura_Krvavec_max -  my_data$Temperatura_Krvavec_min

## Creating new variable for Temperatura_lokacija change (Temperatura_lokacija_spr)
my_data$Temperatura_lokacija_spr <- my_data$Temperatura_lokacija_max - my_data$Temperatura_lokacija_min


#Getting summary statistics

summary (my_data)

# Checking how much data we have on Koper and Ljubljana
location_data <-table(my_data$Postaja)
location_data 
barplot(location_data, 
        ylab="Stevilo podatkov", 
        xlab="Postaja", 
        main="Number of records for Koper and Ljubljana"
        )

pie(location_data, main="Number of records for Koper and Ljubljana")

# Avarage per month and location Glob_sevanje_mean

gs <- (my_data %>%
  group_by(Postaja, mesec) %>%
  summarize(Glob_sevanje_mean = mean(Glob_sevanje_mean, na.rm = TRUE)))
gs <- dcast(gs,  mesec ~ Postaja, value.var = "Glob_sevanje_mean")
gs

cols <- c('red','blue');
ylim <- gs[c("Koper","Ljubljana")]

barplot(
  t(gs[c("Koper","Ljubljana")]),
  beside=T,
  col="white",
  names.arg=gs$mesec,
  xlab="Month",
  ylab="Temperature",
  legend.text=c("Koper","Ljubljana"),
  args.legend=list(text.col=cols,col=cols,border=cols,bty='n')
)


# Avarage per month and location Hitrost vetra

hv <- (my_data %>%
              group_by(Postaja, mesec) %>%
              summarize(Hitrost_vetra_mean = mean(Hitrost_vetra_mean, na.rm = TRUE)))
hv <- dcast(hv,  mesec ~ Postaja, value.var = "Hitrost_vetra_mean")
hv

cols <- c('red','blue');
ylim <- hv[c("Koper","Ljubljana")]

barplot(
  t(hv[c("Koper","Ljubljana")]),
  beside=T,
  col="white",
  names.arg=postmes$mesec,
  xlab="Month",
  ylab="Wind",
  legend.text=c("Koper","Ljubljana"),
  args.legend=list(text.col=cols,col=cols,border=cols,bty='n')
)


# Avarage per month and location Sunki vetra

sv <- (my_data %>%
         group_by(Postaja, mesec) %>%
         summarize(Sunki_vetra_mean = mean(Sunki_vetra_mean, na.rm = TRUE)))
sv <- dcast(sv,  mesec ~ Postaja, value.var = "Sunki_vetra_mean")
sv

cols <- c('red','blue');
ylim <- sv[c("Koper","Ljubljana")]

barplot(
  t(sv[c("Koper","Ljubljana")]),
  beside=T,
  col="white",
  names.arg=postmes$mesec,
  xlab="Month",
  ylab="Wind",
  legend.text=c("Koper","Ljubljana"),
  args.legend=list(text.col=cols,col=cols,border=cols,bty='n')
)


# Avarage per month and location Padavine mean

p <- (my_data %>%
         group_by(Postaja, mesec) %>%
         summarize(Padavine_mean = mean(Padavine_mean, na.rm = TRUE)))
p <- dcast(p,  mesec ~ Postaja, value.var = "Padavine_mean")
p

cols <- c('red','blue');
ylim <- p[c("Koper","Ljubljana")]

barplot(
  t(p[c("Koper","Ljubljana")]),
  beside=T,
  col="white",
  names.arg=postmes$mesec,
  xlab="Month",
  ylab="Wind",
  legend.text=c("Koper","Ljubljana"),
  args.legend=list(text.col=cols,col=cols,border=cols,bty='n')
)


# Avarage per month and location Padavine sum

ps <- (my_data %>%
        group_by(Postaja, mesec) %>%
        summarize(Padavine_mean = sum(Padavine_sum, na.rm = TRUE)))
ps <- dcast(ps,  mesec ~ Postaja, value.var = "Padavine_mean")
ps

cols <- c('red','blue');
ylim <- ps[c("Koper","Ljubljana")]

barplot(
  t(ps[c("Koper","Ljubljana")]),
  beside=T,
  col="white",
  names.arg=postmes$mesec,
  xlab="Month",
  ylab="Wind",
  legend.text=c("Koper","Ljubljana"),
  args.legend=list(text.col=cols,col=cols,border=cols,bty='n')
)


# Avarage per month and location pritist

pr <- (my_data %>%
         group_by(Postaja, mesec) %>%
         summarize(Pritisk_mean = mean(Pritisk_mean, na.rm = TRUE)))
pr <- dcast(pr,  mesec ~ Postaja, value.var = "Pritisk_mean")
pr

cols <- c('red','blue');
ylim <- pr[c("Koper","Ljubljana")]

barplot(
  t(pr[c("Koper","Ljubljana")]),
  beside=T,
  col="white",
  names.arg=postmes$mesec,
  xlab="Month",
  ylab="Wind",
  legend.text=c("Koper","Ljubljana"),
  args.legend=list(text.col=cols,col=cols,border=cols,bty='n')
)



# glavna skripta za seminarsko

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz uporabimo setwd(pot)

# nalozimo knjiznice, ki jih bomo potrebovali
install.packages(c("ipred", "prodlim", "CORElearn", "e1071", "randomForest", "kernlab", "nnet"))

# nalozimo knjiznici za predelavo atributov
library(dplyr)
library(reshape2)

# nalozimo knjiynico za vizualizacijo podatkov in nastavitve za knjiznico
library(ggplot2)
options(scipen=999)  # turn-off scientific notation like 1e+48
theme_set(theme_bw())  # pre-set the bw theme
graphics.off()
close.screen(all = TRUE)
erase.screen()
windows.options(record=TRUE)

# nalozimo knjiznico za precno preverjanje
library(ipred)

# nalozimo knjiznico za grajenje odlocitvenih dreves
library(rpart)

# nalozimo knjiznico ki podpira grajenje razlicnih modelov
library(CORElearn)

# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo dataset
data <- read.table("podatkiSem1.csv", header = T, sep = ",")

# dodajanje in predelava atributov
data <- PredelavaAtributov (data)

# vizualizacija atributov
## boxplot za vse integer atributi mesec vs postaja
BoxPlot(data)
## histograma za vse integer atributi postaja
Histogram(data)
## scatterplot 
Scatterplot2(data) 

summary(data)
a <- is.na(data)


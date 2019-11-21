# glavna skripta za seminarsko

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz uporabimo setwd(pot)

# nalozimo knjiznice, ki jih bomo potrebovali
install.packages(c("ipred", "prodlim", "CORElearn", "e1071", "randomForest", "kernlab", "nnet"))

# nalozimo knjiznico za precno preverjanje
library(ipred)

# nalozimo knjiznico za grajenje odlocitvenih dreves
library(rpart)

# nalozimo knjiznico ki podpira grajenje razlicnih modelov
library(CORElearn)

# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo dataset
data <- read.table("podatkiSem1.txt", header = T, sep = ",")


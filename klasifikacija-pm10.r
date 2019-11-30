# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz. setwd("C:/git/fri-ai-assignment")

# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo funkcije za klasifikatorje
source('klasifikatorji.r')

# nalozimo vse knjiznice, ki jih bomo potrebovali
InitLibs()

# nalozimo dataset
orgData <- read.table("podatkiSem1.csv", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData


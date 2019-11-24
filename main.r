# glavna skripta za seminarsko

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz uporabimo setwd(pot)

# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo vse knjiznice, ki jih bomo potrebovali
InitLibs()

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


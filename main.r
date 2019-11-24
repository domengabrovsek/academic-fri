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

# analiza atributov
summary(data) # summary statistika
sum(is.na(data)) # analiza missing values
Correlation (data) # analiza korelacije


# vizualizacija atributov of the initial data set 
## boxplot za vse integer atributi mesec vs postaja
BoxPlot(data)
## histograma za vse integer atributi postaja
Histogram(data)
## scatterplot 
Scatterplot(data) 

# priprava koncnega dataseta
FinalData (data)

# vizualizacija atributov finalnega dataseta
## boxplot za vse integer atributi mesec vs postaja
BoxPlot(finaldata)
## histograma za vse integer atributi postaja
Histogram(finaldata)
## scatterplot 
Scatterplot(finaldata)



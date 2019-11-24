# glavna skripta za seminarsko

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz. setwd("C:/git/fri-ai-assignment")

# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo vse knjiznice, ki jih bomo potrebovali
InitLibs()

# nalozimo dataset
orgData <- read.table("podatkiSem1.csv", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData

# dodajanje in predelava atributov
data <- AddAttributes (data)

# analiza atributov
summary(data) # summary statistika
sum(is.na(data)) # analiza missing values
Correlation (data) # analiza korelacije


# vizualizacija atributov of the initial data set

## boxplot za vse integer atributi mesec vs postaja
# BoxPlot(data)

## histograma za vse integer atributi postaja
# Histogram(data)

## scatterplot 
Scatterplot(data) 

# priprava koncnega dataseta
#FinalData (data)

# vizualizacija atributov finalnega dataseta
## boxplot za vse integer atributi mesec vs postaja
#BoxPlot(finaldata)
## histograma za vse integer atributi postaja
#Histogram(finaldata)
## scatterplot 
# Scatterplot(finaldata)

# random generator seed, da bomo imeli ponovljive rezultate
set.seed(12345)

# razdelimo dataset na učno in testno množico (mogoče rabimo še validacijsko?)
selection <- sample(1:nrow(data), size = as.integer(nrow(data) * 0.7), replace = F)

train <- data[selection,]
test <- data[-selection,]

# dejanski rezultati na testni mnozici
observed <- train$O3

# vecinski razred
majorityClass <- names(which.max(table(train$O3)))

# tocnost napovedi vecinskega razreda
majorityClassifier <- sum(train$O3 == majorityClass) / length(train$O3)



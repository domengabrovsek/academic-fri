# glavna skripta za seminarsko

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz. setwd("C:/git/fri-ai-assignment")

# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo funkcije za klasifikatorje
source('klasifikatorji.r')

# nalozimo vse knjiznice, ki jih bomo potrebovali
# InitLibs()

# nalozimo dataset
orgData <- read.table("podatkiSem1.csv", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData

# dodajanje, odstranjevanje in predelava atributov
data <- PrepareAttributes (data)

# analiza atributov
# summary(data) # summary statistika
# sum(is.na(data)) # analiza missing values
# Correlation (data) # analiza korelacije

# vizualizacija atributov of the initial data set

# boxplot za vse integer atributi mesec vs postaja
# BoxPlot(data)

# histogram za vse integer atributi postaja
# Histogram(data)

## scatterplot 
# Scatterplot(data) 

# priprava koncnega dataseta
# FinalData (data)

# vizualizacija atributov finalnega dataseta
# boxplot za vse integer atributi mesec vs postaja
# BoxPlot(finaldata)
# histogram za vse integer atribute postaja
# Histogram(finaldata)
# scatterplot 
# Scatterplot(finaldata)

# random generator seed, da bomo imeli ponovljive rezultate
set.seed(12345)

# razdelimo dataset na učno in testno množico (mogoče rabimo še validacijsko?)
selection <- sample(1:nrow(data), size = as.integer(nrow(data) * 0.7), replace = F)

train <- data[selection,]
test <- data[-selection,]

# ciljna spremenljivka je O3
observed <- test$O3
observedMatrix <- model.matrix(~O3 - 1, test)

# Vecinski klasifikator - 0.6211073
mcCA <- MajorityClassifier(train)


sort(attrEval(O3 ~ ., train, "Relief"), decreasing = TRUE)

# ------------ ODLOCITVENO DREVO ------------ #

# 10-kratno precno preverjanje
dtCV <- CrossValidation(train, "tree")

# zgradimo odlocitveno drevo
dt <- CoreModel(O3 ~ ., data = train, model = "tree")
predicted <- predict(dt, test, type = "class")
predictedMatrix <- predict(dt, test, type = "prob")

# klasifikacijska tocnost
dtCA <- ClassAcc(observed, predicted)

# brierjeva mera
dtBS <- BrierScore(observedMatrix, predictedMatrix)
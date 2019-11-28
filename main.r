# glavna skripta za seminarsko

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

# dodajanje, odstranjevanje in predelava atributov
data <- PrepareAttributes (data)

# export novega dataseta z dodatnimi atributi
# export(data, "data.csv")

# analiza atributov
summary(data)
sum(is.na(data)) # analiza missing values
export(psych::describe(data), "SummaryAll.csv") # summary statistika exported
psych::describeBy(data, data$Postaja) #summary statistika za Postajo
Correlation(data) # analiza korelacije

# vizualizacija atributov of the initial data set
## boxlot za en atribut
 BoxPlotV (data)

## boxplot za mesec
 BoxPlotM(data)

## boxplot za vse integer atributi mesec vs postaja
 BoxPlotMP(data)

# histogram za vse integer atributi postaja
 HistogramPost(data)
 HistogramO3 (data)
 HistogramPM10 (data)
## scatterplot 
#Scatterplot(data) 

# analiza stevila podatkov za mesec
PodatkiZaMesec (data)

# analiza of number of data per preduction group
BarChartPCount (data)
BarChartPM10P (data) 
BarChartPM10M (data) 
BarChartO3P (data)
BarChartO3M (data)
 
# tempdir() #retrieving all png files from temp directory



## boxplot za vse integer atributi mesec vs postaja
#BoxPlot(finaldata)
## histograma za vse integer atributi postaja
 Histogram(data)
## scatterplot 
 ScatterplotP(data)
 ScatterplotO3(data)

# priprava koncnega dataseta
FinalData <- FinalData (data)
# vizualizacija atributov finalnega dataseta
 
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


# ------------ NAIVNI BAYES ------------ #

# 10-kratno precno preverjanje
crossValidationBayes <- CrossValidation(train, "bayes")

# zgradimo naivni bayesov model
nb <- CoreModel(O3 ~ ., data = train, model = "bayes")
predicted <- predict(nb, test, type = "class")
predictedMatrix <- predict(nb, test, type = "prob")

# klasifikacijska tocnost
nbCA <- ClassAcc(observed, predicted)

# brierjeva mera
nbBS <- BrierScore(observedMatrix, predictedMatrix)

# -------------- KNN ----------------- #

# 10-kratno precno preverjanje
crossValidationKNN <- CrossValidation(train, "knn")

knn <- CoreModel(O3 ~ ., data = train, model = "knn", kInNN = 5)
predicted <- predict(knn, test, type = "class")
predictedMatrix <- predict(knn, test, type = "prob")

# klasifikacijska tocnost
knnCA <- ClassAcc(observed, predicted)

# brierjeva mera
knnBS <- BrierScore(observedMatrix, predictedMatrix)

# -------------- Nakljucni gozd ----------------- #

# 10-kratno precno preverjanje
crossValidationRF <- CrossValidation(train, "rf")

rf <- CoreModel(O3 ~ ., data = train, model = "rf")
predicted <- predict(rf, test, type = "class")
predictedMatrix <- predict(rf, test, type = "prob")

# klasifikacijska tocnost
rfCA <- ClassAcc(observed, predicted)

# brierjeva mera
rfBS <- BrierScore(observedMatrix, predictedMatrix)


# -------------- SVM ----------------- #
# mypredict.generic <- function(object, newdata){predict(object, newdata, type = "class")}
# errorest(O3~., data = train, model = svm, predict = mypredict.generic)

sm <- svm(O3 ~ ., data = train, probability = T)
predicted <- predict(sm, test, type = "class")

svmCA <- ClassAcc(observed, predicted)

sm <- svm(O3 ~ ., learn, probability = T)
pred <- predict(sm, test, probability = T)
predictedMatrix <- attr(pred, "probabilities")

# v tem konkretnem primeru, vrstni red razredov (stolpcev) v matriki predMat je 
# obraten kot v matriki obsMat. 
colnames(observedMatrix)
colnames(predictedMatrix)

# Iz tega razloga zamenjemo vrstni red stolpcev v matriki predMat
smBS <- BrierScore(observedMatrix, predictedMatrix[,c(2,1)])


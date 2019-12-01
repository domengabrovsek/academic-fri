# klasifikacija za ciljno spremenljivko O3

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz. setwd("C:/git/fri-ai-assignment")

# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo funkcije za vizualizacijo
source('funkcijeViz.r')

# nalozimo funkcije za klasifikatorje
source('klasifikatorji.r')

# nalozimo vse knjiznice, ki jih bomo potrebovali
# InitLibs()

# nalozimo dataset
orgData <- read.table("podatkiSem1.txt", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData

# pripravimo nove podatke
data <- PrepareAttributes ("O3", data)

# podatki brez osamelcev
data <- FinalDataManOut(data)

# random generator seed, da bomo imeli ponovljive rezultate
set.seed(12345)

# razdelimo dataset na učno in testno množico 
selection <- sample(1:nrow(data), size = as.integer(nrow(data) * 0.7), replace = F)

train <- data[selection,]
test <- data[-selection,]

# ciljna spremenljivka je O3
observed <- test$O3
observedMatrix <- model.matrix(~O3 - 1, test)

# preverjanje koliko posamezni atribut prispeva
# sort(attrEval(O3 ~ ., train, "Relief"), decreasing = TRUE)

# Vecinski klasifikator
mc <- MajorityClassifier("O3", train)

# odlocitveno drevo
# dtCV <- CrossValidation("O3", train, "tree") # 10-kratno precno preverjanje
dt <- DecisionTree("O3", train, test)

# naivni bayesov klasifikator
# nbCV <- CrossValidation("O3", train, "bayes") # 10-kratno precno preverjanje
nb <- NaiveBayes("O3", train, test)

# k najblizjih sosedov
# knnCV <- CrossValidation("O3", train, "knn") # 10-kratno precno preverjanje
knn <- KNearestNeighbours("O3", train, test, 5)

# knnTest <- KNNTest("O3", train, test, 200)
# KnnPlot(knnTest)

# nakljucni gozd
# rfCV <- CrossValidation("O3", train, "rf") # 10-kratno precno preverjanje
rf <- RandomForest("O3", train, test)

# podporni vektorji
svm <- SupportVectors("O3", train, test)
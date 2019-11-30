# klasifikacija za ciljno spremenljivko PM10

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz. setwd("C:/git/fri-ai-assignment")

# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo funkcije za klasifikatorje
source('klasifikatorji.r')

# nalozimo vse knjiznice, ki jih bomo potrebovali
# InitLibs()

# nalozimo dataset
orgData <- read.table("podatkiSem1.txt", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData

# pripravimo podatke
data <- PrepareAttributesPM10 (data)

# random generator seed, da bomo imeli ponovljive rezultate
set.seed(12345)

# razdelimo dataset na učno in testno množico (mogoče rabimo še validacijsko?)
selection <- sample(1:nrow(data), size = as.integer(nrow(data) * 0.7), replace = F)

train <- data[selection,]
test <- data[-selection,]

# ciljna spremenljivka je PM10
observed <- test$PM10
observedMatrix <- model.matrix(~PM10 - 1, test)

# preverjanje koliko posamezni atribut prispeva
# sort(attrEval(PM10 ~ ., train, "Relief"), decreasing = TRUE)

# Vecinski klasifikator - 0.8765147
mc <- MajorityClassifier("PM10", train)
dt <- DecisionTree("PM10", train, test)
nb <- NaiveBayes("PM10", train, test)
knn <- KNearestNeighbours("PM10", train, test)
rf <- RandomForest("PM10", train, test)
svm <- SupportVectors("PM10", train, test)
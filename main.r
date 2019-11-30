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

# preverjanje koliko posamezni atribut prispeva
# sort(attrEval(O3 ~ ., train, "Relief"), decreasing = TRUE)

# ------------ ODLOCITVENO DREVO ------------ #

# 10-kratno precno preverjanje vsi elementi
dtCV <- CrossValidation(train, "tree")

# decision tree
dt <- DecisionTree(train, test)

# ------------ NAIVNI BAYES ------------ #

# 10-kratno precno preverjanje
nbCV <- CrossValidation(train, "bayes")

# naive bayes
nb <- NaiveBayes(train, test)

# -------------- KNN ----------------- #

# 10-kratno precno preverjanje
knnCV <- CrossValidation(train, "knn")

knn <- KNearestNeighbours(train, test)


# -------------- Nakljucni gozd ----------------- #

# 10-kratno precno preverjanje
rfCV <- CrossValidation(train, "rf")

rf <- RandomForest(train, test)

# -------------- SVM ----------------- #
svm <- SupportVectors(train, test)
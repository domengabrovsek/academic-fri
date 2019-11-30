# klasifikacija za ciljno spremenljivko O3

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
dtCV <- CrossValidation("O3", train, "tree")

# decision tree
dt <- DecisionTree("O3", train, test)

# ------------ NAIVNI BAYES ------------ #

# 10-kratno precno preverjanje
nbCV <- CrossValidation("O3", train, "bayes")

# naive bayes
nb <- NaiveBayes("O3", train, test)

# -------------- KNN ----------------- #

# 10-kratno precno preverjanje
knnCV <- CrossValidation("O3", train, "knn")

knn <- KNearestNeighbours("O3", train, test)


# -------------- Nakljucni gozd ----------------- #

# 10-kratno precno preverjanje
rfCV <- CrossValidation("O3", train, "rf")

rf <- RandomForest("O3", train, test)

# -------------- SVM ----------------- #
svm <- SupportVectors("O3", train, test)
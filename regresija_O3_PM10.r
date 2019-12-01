#nalozimo modele
source("regresijskiModeli.r")

# nalozimo svoje custom funkcije
source("funkcije.r")

orgData <- read.table("podatkiSem1.txt", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData

#za O3############################################
# pripravimo nove podatke
data <- PrepareAttributes ("O3", data)

# random generator seed, da bomo imeli ponovljive rezultate
set.seed(12345)

# razdelimo dataset na učno in testno množico (mogoče rabimo še validacijsko?)
selection <- sample(1:nrow(data), size = as.integer(nrow(data) * 0.7), replace = F)

train <- data[selection,]
test <- data[-selection,]

#sort(attrEval(O3 ~ ., train, "Relief"), decreasing = TRUE)
#MODELI
#ne dela
lm <-linearRegression("O3",train,test)
rg <-regressionTree("O3",train,test,300)
#ne dela
rf <-randomForestRegression("O3",train,test)
knn<-KNNRegression("O3",train,test,5)
#dela-ampak warning
svm <-SvmRegression("O3",train,test)


#za PM10###########################################
data <- PrepareAttributes ("PM10", data)

# random generator seed, da bomo imeli ponovljive rezultate
set.seed(12345)
# razdelimo dataset na učno in testno množico (mogoče rabimo še validacijsko?)
selection <- sample(1:nrow(data), size = as.integer(nrow(data) * 0.7), replace = F)

train <- data[selection,]
test <- data[-selection,]

#MODELI
#ne dela
lm <-linearRegression("PM10",train,test)

rg <-regressionTree("PM10",train,test,300)
#ne dela
rf <-randomForestRegression("PM10",train,test)

knn<-KNNRegression("PM10",train,test,5)

#dela-ampak warning
svm <-SvmRegression("PM10",train,test)
svm

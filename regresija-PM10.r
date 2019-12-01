#nalozimo modele
source("regresijskiModeli.r")

# nalozimo svoje custom funkcije
source("funkcije.r")
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
nnet<-nnetRegression("PM10",train,test)

#nalozimo modele
source("regresijskiModeli.r")

# nalozimo svoje custom funkcije
source("funkcije.r")


orgData <- read.table("podatkiSem1.txt", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData

data <-prepareDataRegression("PM10",data)
# random generator seed, da bomo imeli ponovljive rezultate
set.seed(12345)

# razdelimo dataset na učno in testno množico (mogoče rabimo še validacijsko?)
selection <- sample(1:nrow(data), size = as.integer(nrow(data) * 0.7), replace = F)

train <- data[selection,]
test <- data[-selection,]

#MODELI

lm <-linearRegression("PM10",train,test)
lm
rg <-regressionTree("PM10",train,test,300)
rg

rf <-randomForestRegression("PM10",train,test)
rf
knn<-KNNRegression("PM10",train,test,5)

#dela-ampak warning
svm <-SvmRegression("PM10",train,test)
svm
nnet<-nnetRegression("PM10",train,test)
nnet

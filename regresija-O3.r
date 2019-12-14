#nalozimo modele

source("regresijskiModeli.r")

# nalozimo svoje custom funkcije
source("funkcije.r")

orgData <- read.table("podatkiSem1.txt", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData

data <- prepareDataRegression("O3",data) 
summary(data)
# pripravimo nove podatke

# random generator seed, da bomo imeli ponovljive rezultate
set.seed(12345)

# razdelimo dataset na učno in testno množico (mogoče rabimo še validacijsko?)
selection <- sample(1:nrow(data), size = as.integer(nrow(data) * 0.7), replace = F)

train <- data[selection,]
test <- data[-selection,]

#MODELI

lm <-linearRegression("O3",train,test)
lm
rg <-regressionTree("O3",train,test,300)
rg

rf <-randomForestRegression("O3",train,test)
rf
knn<-KNNRegression("O3",train,test,5)
knn

svm <-SvmRegression("O3",train,test)
svm
nnet<-nnetRegression("O3",train,test)
nnet


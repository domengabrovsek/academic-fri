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
lm
rg <-regressionTree("O3",train,test,300)
rg
#ne dela
rf <-randomForestRegression("O3",train,test)
rf
knn<-KNNRegression("O3",train,test,5)
knn
#dela-ampak warning
svm <-SvmRegression("O3",train,test)
svm
nnet<-nnetRegression("O3",train,test)
nnet


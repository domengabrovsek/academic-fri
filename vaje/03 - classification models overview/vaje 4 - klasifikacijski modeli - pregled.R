# Prenesite datoteki "spamlearn.txt" in "spamtest.txt" v lokalno mapo. 
# To mapo nastavite kot delovno mapo okolja R. To lahko naredite s pomocjo 
# ukaza "setwd" oziroma iz menuja s klikom na File -> Change dir...

# Uporabljali bomo funkcije iz naslednjih knjiznic: ipred, prodlim, rpart, CORElearn, 
# e1071, randomForest, kernlab, in nnet. Poskrbite, da so vse knjiznice instalirane.
#
# Knjiznice instaliramo z ukazom install.packages():
#
#     install.packages(c("ipred", "prodlim", "CORElearn", "e1071", "randomForest", "kernlab", "nnet"))
#     library(pROC)
#
# Ce nimamo pravic za instalacijo v privzeto map, lahko podamo pot do 
# do neke druge mape, do katere imamo dostop:
#
#     install.packages(c("ipred", "prodlim", "CORElearn", "e1071", "randomForest", "kernlab", "nnet"), lib="pot do folderja")
#     library(ipred, lib.loc="pot do folderja")
#


learn <- read.table("spamlearn.txt", header = T)
test <- read.table("spamtest.txt", header = T)

# ciljna spremenljivka je atribut "Class"
observed <- test$Class
obsMat <- model.matrix(~Class-1, test)

# Funkcija za izracun klasifikacijske tocnosti
CA <- function(observed, predicted)
{
	t <- table(observed, predicted)

	sum(diag(t)) / sum(t)
}

# Funkcija za izracun Brierjeve mere
brier.score <- function(observedMatrix, predictedMatrix)
{
	sum((observedMatrix - predictedMatrix) ^ 2) / nrow(predictedMatrix)
}

# metoda precnega preverjanja je implementirana v knjiznici "ipred"
library(ipred)

# pomozne funkcije, ki jih potrebujemo za izvedbo precnega preverjanja
mypredict.generic <- function(object, newdata){predict(object, newdata, type = "class")}
mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}




#
#
# ODLOCITVENO DREVO
#
#

# gradnja modela s pomocjo knjiznice "rpart"

library(rpart)
dt <- rpart(Class ~ ., data = learn)
plot(dt);text(dt)
predicted <- predict(dt, test, type="class")
CA(observed, predicted)

predMat <- predict(dt, test, type = "prob")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = rpart, predict = mypredict.generic)



# gradnja modela s pomocjo knjiznice "CORElearn"

library(CORElearn)
cm.dt <- CoreModel(Class ~ ., data = learn, model="tree")
plot(cm.dt, learn)
predicted <- predict(cm.dt, test, type="class")
CA(observed, predicted)

predMat <- predict(cm.dt, test, type = "probability")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="tree")




#
#
# NAIVNI BAYESOV KLASIFIKATOR
#
#

# gradnja modela s pomocjo knjiznice "e1071"

library(e1071)

nb <- naiveBayes(Class ~ ., data = learn)
predicted <- predict(nb, test, type="class")
CA(observed, predicted)

predMat <- predict(nb, test, type = "raw")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = naiveBayes, predict = mypredict.generic)



# gradnja modela s pomocjo knjiznice "CORElearn"

library(CORElearn)
cm.nb <- CoreModel(Class ~ ., data = learn, model="bayes")
predicted <- predict(cm.nb, test, type="class")
CA(observed, predicted)

predMat <- predict(cm.nb, test, type = "probability")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="bayes")




#
#
# K-NAJBLIZJIH SOSEDOV
#
#

# gradnja modela s pomocjo knjiznice "CORElearn"

library(CORElearn)
cm.knn <- CoreModel(Class ~ ., data = learn, model="knn", kInNN = 5)
predicted <- predict(cm.knn, test, type="class")
CA(observed, predicted)

predMat <- predict(cm.knn, test, type = "probability")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="knn")




#
#
# NAKLJUCNI GOZD
#
#

# gradnja modela s pomocjo knjiznice "randomForest"

library(randomForest)

rf <- randomForest(Class ~ ., data = learn)
predicted <- predict(rf, test, type="class")
CA(observed, predicted)

predMat <- predict(rf, test, type = "prob")
brier.score(obsMat, predMat)

mypredict.rf <- function(object, newdata){predict(object, newdata, type = "class")}
errorest(Class~., data=learn, model = randomForest, predict = mypredict.generic)



# gradnja modela s pomocjo knjiznice "CORElearn"

library(CORElearn)
cm.rf <- CoreModel(Class ~ ., data = learn, model="rf")
predicted <- predict(cm.rf, test, type="class")
CA(observed, predicted)

predMat <- predict(cm.rf, test, type = "probability")
brier.score(obsMat, predMat)

errorest(Class~., data=learn, model = mymodel.coremodel, predict = mypredict.coremodel, target.model="rf")




#
#
# SVM
#
#

# gradnja modela s pomocjo knjiznice "e1071"

library(e1071)

sm <- svm(Class ~ ., data = learn)
predicted <- predict(sm, test, type="class")
CA(observed, predicted)

sm <- svm(Class ~ ., learn, probability = T)
pred <- predict(sm, test, probability = T)
predMat <- attr(pred, "probabilities")

# v tem konkretnem primeru, vrstni red razredov (stolpcev) v matriki predMat je 
# obraten kot v matriki obsMat. 
colnames(obsMat)
colnames(predMat)

# Iz tega razloga zamenjemo vrstni red stolpcev v matriki predMat
brier.score(obsMat, predMat[,c(2,1)])

errorest(Class~., data=learn, model = svm, predict = mypredict.generic)


# gradnja modela s pomocjo knjiznice "kernlab"

library(kernlab)

model.svm <- ksvm(Class ~ ., data = learn, kernel = "rbfdot")
predicted <- predict(model.svm, test, type = "response")
CA(observed, predicted)

model.svm <- ksvm(Class ~ ., data = learn, kernel = "rbfdot", prob.model = T)
predMat <- predict(model.svm, test, type = "prob")
brier.score(obsMat, predMat)

mypredict.ksvm <- function(object, newdata){predict(object, newdata, type = "response")}
errorest(Class~., data=learn, model = ksvm, predict = mypredict.ksvm)

#
#
# UMETNE NEVRONSKE MREZE
#
#

# gradnja modela s pomocjo knjiznice "nnet"

library(nnet)


# implementacija funkcije za ucenje nevronske mreze daje boljse rezultate v primeru,
# ko so ucni primeri normalizirani. 

# poiscemo zalogo vrednosti zveznih atributov
# (v nasem primeru so vsi atributi zvezni, razen ciljne spr. "Class", ki je 58. stolpec)
max_learn <- apply(learn[,-58], 2, max)
min_learn <- apply(learn[,-58], 2, min)

# skaliramo podatke
learn_scaled <- scale(learn[,-58], center = min_learn, scale = max_learn - min_learn)
learn_scaled <- data.frame(learn_scaled)
learn_scaled$Class <- learn$Class

# vse vrednosti atributov v ucni mnozici so na intervalu [0,1]
summary(learn_scaled)


# testno mnozico skaliramo na zalogo vrednosti iz ucne mnozice!
test_scaled <- scale(test[,-58], center = min_learn, scale = max_learn - min_learn)
test_scaled <- data.frame(test_scaled)
test_scaled$Class <- test$Class

# v testni mnozici ne bodo vse vrednosti na intervalu [0,1]!
summary(test_scaled)


nn <- nnet(Class ~ ., data = learn_scaled, size = 5, decay = 0.0001, maxit = 10000)
predicted <- predict(nn, test_scaled, type = "class")
CA(observed, predicted)

# v primeru binarne klasifikacije bo funkcija predict vrnila verjetnosti samo enega razreda.
# celotno matriko moramo rekonstruirati sami

pm <- predict(nn, test_scaled, type = "raw")
predMat <- cbind(1-pm, pm)
brier.score(obsMat, predMat)

mypredict.nnet <- function(object, newdata){as.factor(predict(object, newdata, type = "class"))}
errorest(Class~., data=learn_scaled, model = nnet, predict = mypredict.nnet, size = 5, decay = 0.0001, maxit = 10000)


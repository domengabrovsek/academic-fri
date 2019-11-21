########################################################################################
#
# Regresija
#
########################################################################################

# ucna mnozica
ucna <- read.table("AlgaeLearn.txt", header = T)
summary(ucna)

# neodvisna testna mnozica
testna <- read.table("AlgaeTest.txt", header = T)



#
# linearni model
#

lm.model <- lm(a1 ~ ., data = ucna)
lm.model

predicted <- predict(lm.model, testna)
head(predicted)

observed <- testna$a1
head(observed)


####################################################################
#
# Mere za ocenjevanje ucenja v regresiji
#
####################################################################

mae <- function(observed, predicted)
{
	mean(abs(observed - predicted))
}

rmae <- function(observed, predicted, mean.val) 
{  
	sum(abs(observed - predicted)) / sum(abs(observed - mean.val))
}

mse <- function(observed, predicted)
{
	mean((observed - predicted)^2)
}

rmse <- function(observed, predicted, mean.val) 
{  
	sum((observed - predicted)^2)/sum((observed - mean.val)^2)
}



mae(observed, predicted)
rmae(observed, predicted, mean(ucna$a1))




#
# regresijsko drevo
#


library(rpart)

rt.model <- rpart(a1 ~ ., ucna)
predicted <- predict(rt.model, testna)
rmae(observed, predicted, mean(ucna$a1))

plot(rt.model);text(rt.model, pretty = 0)


# nastavitve za gradnjo drevesa
rpart.control()

# zgradimo drevo z drugimi parametri
rt <- rpart(a1 ~ ., ucna, minsplit = 100)
plot(rt);text(rt, pretty = 0)


# parameter cp kontrolira rezanje drevesa
rt.model <- rpart(a1 ~ ., ucna, cp = 0)
plot(rt.model);text(rt.model, pretty = 0)


# izpisemo ocenjene napake drevesa za razlicne vrednosti parametra cp
printcp(rt.model)

# drevo porezemo z ustrezno vrednostjo cp, pri kateri je bila minimalna napaka
rt.model2 <- prune(rt.model, cp = 0.02)
plot(rt.model2);text(rt.model2, pretty = 0)
predicted <- predict(rt.model2, testna)
rmae(observed, predicted, mean(ucna$a1))



# regresijska drevesa lahko gradimo tudi s pomocjo knjiznice CORElearn
library(CORElearn)

# modelTypeReg
# type: integer, default value: 5, value range: 1, 8 
# type of models used in regression tree leaves (1=mean predicted value, 2=median predicted value, 3=linear by MSE, 4=linear by MDL, 5=linear as in M5, 6=kNN, 7=Gaussian kernel regression, 8=locally weighted linear regression).

rt.core <- CoreModel(a1 ~ ., data=ucna, model="regTree", modelTypeReg = 1)
plot(rt.core, ucna)
predicted <- predict(rt.core, testna)
rmae(observed, predicted, mean(ucna$a1))

modelEval(rt.core, testna$a1, predicted)



# preveliko drevo se prevec prilagodi podatkom in slabse napoveduje odvisno spremeljivko
rt.core2 <- CoreModel(a1 ~ ., data=ucna, model="regTree",  modelTypeReg = 1, minNodeWeightTree = 1, selectedPrunerReg = 0)
plot(rt.core2, ucna)
predicted <- predict(rt.core2, testna)
rmae(observed, predicted, mean(ucna$a1))

# drevo z linearnim modelom v listih se lahko prevec prilagodi ucnim primerom
rt.core3 <- CoreModel(a1 ~ ., data=ucna, model="regTree",  modelTypeReg = 3, selectedPrunerReg = 2)
plot(rt.core3, ucna)
predicted <- predict(rt.core3, testna)
rmae(observed, predicted, mean(ucna$a1))

# model se prilega ucnim podatkom, ker ima prevec parametrov.
# rezultat lahko izboljsamo tako, da poenostavimo model (npr. uporabimo manj atributov)

rt.core4 <- CoreModel(a1 ~ PO4 + size + mxPH, data=ucna, model="regTree", modelTypeReg = 3)
plot(rt.core4, testna)
predicted <- predict(rt.core4, testna)
rmae(observed, predicted, mean(ucna$a1))




#
# nakljucni gozd
#

library(randomForest)

rf.model <- randomForest(a1 ~ ., ucna)
predicted <- predict(rf.model, testna)
rmae(observed, predicted, mean(ucna$a1))




#
# svm
#

library(e1071)

svm.model <- svm(a1 ~ ., ucna)
predicted <- predict(svm.model, testna)
rmae(observed, predicted, mean(ucna$a1))




#
# k-najblizjih sosedov
#

library(kknn)

knn.model <- kknn(a1 ~ ., ucna, testna, k = 5)
predicted <- fitted(knn.model)
rmae(observed, predicted, mean(ucna$a1))




#
# nevronska mreza
#

library(nnet)

#
# pomembno!!! 
# za regresijo je potrebno nastaviti linout = T

# zaradi nakljucne izbire zacetnih utezi bo vsakic nekoliko drugacen rezultat
# zato je dobro, da veckrat naucimo mrezo in zadrzimo model, ki se je najboljse obnesel

#set.seed(6789)
nn.model <- nnet(a1 ~ ., ucna, size = 5, decay = 0.0001, maxit = 10000, linout = T)
predicted <- predict(nn.model, testna)
rmae(observed, predicted, mean(ucna$a1))



##################################################################
#
# Primer
#
##################################################################

cars <- read.table("auto-mpg.txt", sep=",", header=T)
summary(cars)

cars$name <- NULL

summary(cars$horsepower)

cor(cars, use="complete.obs")
symnum(cor(cars, use="complete.obs"))

plot(cars$horsepower ~ cars$displacement)



sel <- is.na(cars$horsepower)
model <- lm(horsepower ~ displacement, cars[!sel,])
abline(model)
predict(model, cars[sel,])

cars$horsepower[sel] <- predict(model, cars[sel,])

#
# lokalno utezena linearna regresija
#
# pri gradnji modela upostevamo samo ucne primere iz okolice podane tocke

model2 <- loess(horsepower ~ displacement, data = cars[!sel,], span = 0.3, degree = 1)
points(cars$displacement[!sel],model2$fit, col = "blue")

ord <- order(cars$displacement[!sel])
lines(cars$displacement[!sel][ord], model2$fit[ord], col = "red")


predict(model2, cars[sel,])



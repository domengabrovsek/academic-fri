################################################################
#
# Kombiniranje algoritmov strojnega ucenja
#
################################################################

vehicle <- read.table("vehicle.txt", sep=",", header = T)
summary(vehicle)


set.seed(8678686)
sel <- sample(1:nrow(vehicle), size=as.integer(nrow(vehicle)*0.7), replace=F)
learn <- vehicle[sel,]
test <- vehicle[-sel,]


table(learn$Class)
table(test$Class)


#install.packages("CORElearn")
library(CORElearn)
source("mojefunkcije.R")


#
# Glasovanje
#

modelDT <- CoreModel(Class ~ ., learn, model="tree")
modelNB <- CoreModel(Class ~ ., learn, model="bayes")
modelKNN <- CoreModel(Class ~ ., learn, model="knn", kInNN = 5)

predDT <- predict(modelDT, test, type = "class")
caDT <- CA(test$Class, predDT)
caDT

predNB <- predict(modelNB, test, type="class")
caNB <- CA(test$Class, predNB)
caNB

predKNN <- predict(modelKNN, test, type="class")
caKNN <- CA(test$Class, predKNN)
caKNN

# zdruzimo napovedi posameznih modelov v en podatkovni okvir
pred <- data.frame(predDT, predNB, predKNN)
pred

# testni primer klasificiramo v razred z najvec glasovi
voting <- function(predictions)
{
	res <- vector()

  	for (i in 1 : nrow(predictions))  	
	{
		vec <- unlist(predictions[i,])
    		res[i] <- names(which.max(table(vec)))
  	}

  	factor(res, levels=levels(predictions[,1]))
}

predicted <- voting(pred)
CA(test$Class, predicted)




#
# Utezeno glasovanje
#

predDT.prob <- predict(modelDT, test, type="probability")
predNB.prob <- predict(modelNB, test, type="probability")
predKNN.prob <- predict(modelKNN, test, type="probability")

# sestejemo napovedane verjetnosti s strani razlicnih modelov
pred.prob <- caDT * predDT.prob + caNB * predNB.prob + caKNN * predKNN.prob
pred.prob

# izberemo razred z najvecjo verjetnostjo
predicted <- levels(learn$Class)[apply(pred.prob, 1, which.max)]

CA(test$Class, predicted)




#
# Bagging
#

#install.packages("ipred")
library(ipred)

bag <- bagging(Class ~ ., learn, nbagg=15)
bag.pred <- predict(bag, test, type="class")
CA(test$Class, bag.pred)




#
# Nakljucni gozd je inacica bagginga
#

# install.packages("randomForest")
library(randomForest)

rf <- randomForest(Class ~ ., learn)
predicted <- predict(rf, test, type = "class")
CA(test$Class, predicted)




#
# Boosting
#

# install.packages("adabag")
library(adabag)

bm <- boosting(Class ~ ., learn)
predictions <- predict(bm, test)
names(predictions)

predicted <- predictions$class
CA(test$Class, predicted)


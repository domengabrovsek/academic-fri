# Ukazi v R-ju

# read data from csv, txt file
data <- read.table("data.txt", sep=",", header=TRUE)

# show summary of given data
summary(data)

# plotting charts
barplot(table, ylab="", main="")
pie(table, main="")

# import functions
source("funkcije.r")

# number of cases in data set
nrow(data)

# random generator seed
set.seed(12345)

# divide dataset to train/test set (70:30)
selection <- sample(1:nrow(census), size=as.integer(nrow(census) * 0.7), replace=F)

train <- data[selection,]
test <- data[-selection,]

# check table variable in test dataset
table(test$income)

# majority clasifier
sum(test$income == "Small") / length(test$income)

# import library
library(rpart)

# create decision tree
decisionTree <- rpart(income ~ ., data = train)

# plot decision tree
plot(decisionTree)
text(decisionTree, pretty = 0)

# use model to predict
observed <- test$income # real data from test set
predicted <- predict(decisionTree, test, type = "class") # model, data, type

# build table of wrong clasifications
table <- table(observed, predicted) #diagonal elements represent correct solutions

# get clasification accuracy of model
sum(diag(table) / sum(table))

# napovedane verjetnosti pripadnosti razredom (matrika)
predictedMatrix <- predict(decisionTree, test, type = "prob")

# prave verjetnosti pripadnosti razredom (1, 0)
observedMatrix <- model.matrix( ~ income-1, test)

# trivialni model - vedno napove apriorno distribucijo razredov
p0 <- table(train$income) / nrow(train)

# matrika napovedanih verjetnosti (vecinski klasifikator)
p0Matrix <- matrix(rep(p0, times = nrow(test)), nrow = nrow(test), byrow = T)
colnames(p0Matrix) <- names(p0)
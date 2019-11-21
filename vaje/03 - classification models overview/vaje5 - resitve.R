student <- read.table("student.txt", sep=",", header=T)

for (i in 30:32) 
    student[,i] <- cut(student[,i], c(-Inf, 9, 11, 13, 15, 20), labels=c("fail", "sufficient", "satisfactory", "good", "excellent"))

summary(student)

barplot(table(student$G1), xlab="Grade", ylab="Number of students", main="First period grades barplot for mathematics")
barplot(table(student$G3), xlab="Grade", ylab="Number of students", main="Final grades barplot for mathematics")

sel <- sample(1:nrow(student), size=as.integer(nrow(student)*0.7), replace=F)
learn <- student[sel,]
test <- student[-sel,]


library(CORElearn)

maj.class <- which.max(table(learn$G3))
ca.vals <- table(test$G3)[maj.class]/nrow(test)

observed <- test$G3
for (m in c("tree", "rf", "knn", "bayes"))
{
	obj <- CoreModel(G3 ~ ., learn, model=m)

	predicted <- predict(obj, test, type="class")
	tab <- table(observed, predicted)
	ca.vals <- c(ca.vals, sum(diag(tab))/sum(tab))
}

names(ca.vals) <- c("majority", "tree", "rf", "knn", "bayes")
barplot(ca.vals, xlab="models", ylab="Classification accuracy", main="Results")



library(ipred)

mymodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
mypredict <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}

cv.res <- vector()
for (m in c("tree", "rf", "knn", "bayes"))
{
	res <- errorest(G3~., data=student, model = mymodel, predict = mypredict, target.model=m)
	cv.res <- c(cv.res, 1-res$error)
}

names(cv.res) <- c("tree", "rf", "knn", "bayes")
barplot(cv.res, xlab="models", ylab="Classification accuracy", main="10-fold cross-validation results")




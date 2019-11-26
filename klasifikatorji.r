MajorityClassifier <- function(trainSet) 
{
    # vecinski razred
    majorityClass <- names(which.max(table(trainSet$O3)))

    # tocnost napovedi vecinskega klasifikatorja - 0.6211073
    majorityClassifier <- sum(trainSet$O3 == majorityClass) / length(trainSet$O3) 
}

# 10x precno preverjanje
CrossValidation <- function(myData, targetModel)
{
    mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
    mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}

    result <- errorest(O3~., data = myData, model = mymodel.coremodel, predict = mypredict.coremodel, target.model = targetModel)
    result <- 1 - result$error
}
MajorityClassifier <- function(variable, trainSet) 
{
    if(variable == "O3")
    {
        # vecinski razred
        majorityClass <- names(which.max(table(trainSet$O3)))

        # tocnost napovedi vecinskega klasifikatorja - 0.6211073
        majorityClassifier <- sum(trainSet$O3 == majorityClass) / length(trainSet$O3) 

    }
    else 
    {
        # vecinski razred
        majorityClass <- names(which.max(table(trainSet$PM10)))

        # tocnost napovedi vecinskega klasifikatorja - 0.6211073
        majorityClassifier <- sum(trainSet$PM10 == majorityClass) / length(trainSet$PM10) 
    }
}

DecisionTree <- function(variable, train, test)
{
    # zgradimo odlocitveno drevo

    # O3 ali PM10
    if(variable == "O3") { dt <- CoreModel(O3 ~ ., data = train, model = "tree") }
    else { dt <- CoreModel(PM10 ~ ., data = train, model = "tree") }

    predicted <- predict(dt, test, type = "class")
    predictedMatrix <- predict(dt, test, type = "prob")

    # klasifikacijska tocnost
    dtCA <- ClassAcc(observed, predicted)

    # brierjeva mera
    dtBS <- BrierScore(observedMatrix, predictedMatrix)

    # vrnemo klasifikacijsko tocnost in brierjevo mero
    data <- c(dtCA, dtBS)

    return (data)
}

NaiveBayes <- function(variable, train, test)
{
    # zgradimo naivni bayesov model

    # O3 ali PM10
    if(variable == "O3") { nb <- CoreModel(O3 ~ ., data = train, model = "bayes") }
    else { nb <- CoreModel(PM10 ~ ., data = train, model = "bayes") }

    predicted <- predict(nb, test, type = "class")
    predictedMatrix <- predict(nb, test, type = "prob")

    # klasifikacijska tocnost
    nbCA <- ClassAcc(observed, predicted)

    # brierjeva mera
    nbBS <- BrierScore(observedMatrix, predictedMatrix)

    data <- c(nbCA, nbBS)

    return (data)
}

KnnPlot <- function (my_data)
{
  print(
    ggplot(data= my_data, aes(x = kList, y = knn)) + 
    geom_line()
  )
}

KNNTest <- function(variable, train, test, k)
{
    knn <- c()
    kList <- c()

    for(i in 1:k)
    {
        kList[i] <- i
        knn[i] <- KNearestNeighbours(variable, train, test, i)[1]
    }

    data <- data.frame(knn, kList)

    return (data)
}

KNearestNeighbours <- function(variable, train, test, k)
{
    # zgradimo model k najblizjih sosedov

    # O3 ali PM10
    if(variable == "O3") { knn <- CoreModel(O3 ~ ., data = train, model = "knn", kInNN = k) }
    else { knn <- CoreModel(PM10 ~ ., data = train, model = "knn", kInNN = k) }

    predicted <- predict(knn, test, type = "class")
    predictedMatrix <- predict(knn, test, type = "prob")

    # klasifikacijska tocnost
    knnCA <- ClassAcc(observed, predicted)

    # brierjeva mera
    knnBS <- BrierScore(observedMatrix, predictedMatrix)

    data <- c(knnCA, knnBS)

    return (data)
}

RandomForest <- function(variable, train, test)
{
    # zgradimo model nakljucnega gozda

    # O3 ali PM10
    if(variable == "O3") { rf <- CoreModel(O3 ~ ., data = train, model = "rf") }
    else { rf <- CoreModel(PM10 ~ ., data = train, model = "rf") }

    predicted <- predict(rf, test, type = "class")
    predictedMatrix <- predict(rf, test, type = "prob")

    # klasifikacijska tocnost
    rfCA <- ClassAcc(observed, predicted)

    # brierjeva mera
    rfBS <- BrierScore(observedMatrix, predictedMatrix)

    data <- c(rfCA, rfBS)

    return (data)
}

SupportVectors <- function(variable, train, test)
{
    # zgradimo model podpornih vektorjev

    # O3 ali PM10
    if(variable == "O3") { sm <- svm(O3 ~ ., data = train) }
    else { sm <- svm(PM10 ~ ., data = train) }

    predicted <- predict(sm, test, type = "class")
    svmCA <- ClassAcc(observed, predicted)

    if(variable == "O3") { sm <- svm(O3 ~ ., data = train, probability = T) }
    else { sm <- svm(PM10 ~ ., data = train, probability = T) }

    pred <- predict(sm, test, probability = T)
    predictedMatrix <- attr(pred, "probabilities")

    # svmBS <- BrierScore(observedMatrix, predictedMatrix[,c(2,1)])

    # TODO svmBS doesn't work for some reason, check if time
    data <- c(svmCA)

    return (data)
}

# 10x precno preverjanje
CrossValidation <- function(variable, myData, targetModel)
{
    mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
    mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}

    table <- c()

    # pozenemo 10x 
    for(i in 1:10)
    {
        if(variable == "O3") { result <- errorest(O3~., data = myData, model = mymodel.coremodel, predict = mypredict.coremodel, target.model = targetModel) }
        else { result <- errorest(PM10~., data = myData, model = mymodel.coremodel, predict = mypredict.coremodel, target.model = targetModel) }

        result <- 1 - result$error
        table[i] <- result
    }

    # vrnemo min, max in povprecno vrednost vseh preverjanj
    data <- c(min(table), max(table), mean(table))

    return (data)
}
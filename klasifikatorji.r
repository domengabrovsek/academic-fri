MajorityClassifier <- function(trainSet) 
{
    # vecinski razred
    majorityClass <- names(which.max(table(trainSet$O3)))

    # tocnost napovedi vecinskega klasifikatorja - 0.6211073
    majorityClassifier <- sum(trainSet$O3 == majorityClass) / length(trainSet$O3) 
}

DecisionTree <- function(train, test)
{
    # zgradimo odlocitveno drevo
    dt <- CoreModel(O3 ~ ., data = train, model = "tree")
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

NaiveBayes <- function(train, test)
{
    # zgradimo naivni bayesov model
    nb <- CoreModel(O3 ~ ., data = train, model = "bayes")
    predicted <- predict(nb, test, type = "class")
    predictedMatrix <- predict(nb, test, type = "prob")

    # klasifikacijska tocnost
    nbCA <- ClassAcc(observed, predicted)

    # brierjeva mera
    nbBS <- BrierScore(observedMatrix, predictedMatrix)

    data <- c(nbCA, nbBS)

    return (data)
}

KNearestNeighbours <- function(train, test)
{
    knn <- CoreModel(O3 ~ ., data = train, model = "knn", kInNN = 5)
    predicted <- predict(knn, test, type = "class")
    predictedMatrix <- predict(knn, test, type = "prob")

    # klasifikacijska tocnost
    knnCA <- ClassAcc(observed, predicted)

    # brierjeva mera
    knnBS <- BrierScore(observedMatrix, predictedMatrix)

    data <- c(knnCA, knnBS)

    return (data)
}

RandomForest <- function(train, test)
{
    rf <- CoreModel(O3 ~ ., data = train, model = "rf")
    predicted <- predict(rf, test, type = "class")
    predictedMatrix <- predict(rf, test, type = "prob")

    # klasifikacijska tocnost
    rfCA <- ClassAcc(observed, predicted)

    # brierjeva mera
    rfBS <- BrierScore(observedMatrix, predictedMatrix)

    data <- c(rfCA, rfBS)

    return (data)
}

SupportVectors <- function(train, test)
{
    sm <- svm(O3 ~ ., data = train, probability = T)
    predicted <- predict(sm, test, type = "class")

    svmCA <- ClassAcc(observed, predicted)

    sm <- svm(O3 ~ ., learn, probability = T)
    pred <- predict(sm, test, probability = T)
    predictedMatrix <- attr(pred, "probabilities")

    # v tem konkretnem primeru, vrstni red razredov (stolpcev) v matriki predMat je 
    # obraten kot v matriki obsMat. 
    colnames(observedMatrix)
    colnames(predictedMatrix)

    # Iz tega razloga zamenjemo vrstni red stolpcev v matriki predMat
    svmBS <- BrierScore(observedMatrix, predictedMatrix[,c(2,1)])

    data <- c(svmCA, svmBS)

    return (data)
}

# 10x precno preverjanje
CrossValidation <- function(myData, targetModel)
{
    mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
    mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}

    table <- c()

    # pozenemo 10x 
    for(i in 1:10)
    {
        result <- errorest(O3~., data = myData, model = mymodel.coremodel, predict = mypredict.coremodel, target.model = targetModel)
        result <- 1 - result$error
        table[i] <- result
    }

    # vrnemo min, max in povprecno vrednost vseh preverjanj
    data <- c(min(table), max(table), mean(table))

    return (data)
}

CrossValidation10 <- function(myData, targetModel)
{
    mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
    mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}

    table <- c()

    # pozenemo 10x 
    for(i in 1:10)
    {
        result <- errorest(O3~leto+mesec+Vlaga_min+Vlaga_mean+Vlaga_max+Glob_sevanje_mean+Glob_sevanje_max+Glob_sevanje_spr+Temperatura_Krvavec_min+Temperatura_Krvavec_max+Sunki_vetra_max+Temperatura_lokacija_spr, data = myData, model = mymodel.coremodel, predict = mypredict.coremodel, target.model = targetModel)
        result <- 1 - result$error
        table[i] <- result
    }

    # vrnemo min, max in povprecno vrednost vseh preverjanj
    data <- c(min(table), max(table), mean(table))

    return (data)
}
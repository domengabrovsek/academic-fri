#funkcije za regresijske modele

#nalozimo svoje funkcije
source("funkcije.r")

##1.LINEARNA REGRESIJA
linearRegression <-function(variable,train,test)
{
  if(variable == "O3")
  {
    linear.model <- lm(O3 ~ ., data =train) 
    predicted <- predict(linear.model, test)
    observed <- test$O3
    rmae <-rmae(observed, predicted, mean(train$O3))
    
  }
  else 
  {
    linear.model <- lm(PM10 ~ ., data =train) 
    predicted <- predict(linear.model, test)
    observed <- test$PM10
    rmae <-rmae(observed, predicted, mean(train$PM10))
  }
  
  #ocenjevanje modela
  mae <-mae(observed, predicted)

  mse <-mse(observed,predicted)
  
  data<-c(mae,rmae,mse)
    
  return(data)
}
#2. REGRESIJSKO DREVO###################
regressionTree <-function(variable,train,test,split)
{
  if(variable == "O3")
  {
    rt.model <- rpart(O3 ~ ., train, minsplit = split)
    predicted <- predict(rt.model, test)
    observed <- test$O3
    rmae <-rmae(observed, predicted, mean(train$O3))
  
  }
  else 
  {
    rt.model <- rpart(PM10 ~ ., train, minsplit = split)
    predicted <- predict(rt.model, test)
    observed <- test$PM10
    rmae <-rmae(observed, predicted, mean(train$PM10))
  }
  
  #izrise nam drevo
  plot(rt.model);text(rt.model, pretty = 0)
  return(rmae)
}
#3.RANDOM FOREST########
randomForestRegression<-function(variable, train,test)
{
  if(variable == "O3")
  {
    rf.model <- randomForest(O3 ~ ., train)
    predicted <- predict(rf.model, train)
    observed <- test$O3
    rmae <-rmae(observed, predicted, mean(train$O3))
  }
  else 
  {
    rf.model <- randomForest(PM10 ~ ., train)
    predicted <- predict(rf.model, train)
    observed <- test$PM10
    rmae <-rmae(observed, predicted, mean(train$PM10))
  }
  return(rmae)
}

#4.k-najblizjih sosedov##########
KNNRegression<-function(variable, train,test,k)
{
  if(variable == "O3")
  {
    knn.model <- kknn(O3 ~ ., train, test, k)
    predicted <- fitted(knn.model)
    observed <- test$O3
    rmae <-rmae(observed, predicted, mean(train$O3)) 
  }
  else 
  {
    knn.model <- kknn(PM10 ~ ., train, test, k)
    predicted <- fitted(knn.model)
    observed <- test$PM10
    rmae <-rmae(observed, predicted, mean(train$PM10))
  }
  return(rmae)
}
#5. svm -######################
SvmRegression <-function(variable,train,test)
{  
  if(variable == "O3")
  {
    svm.model <- svm(O3 ~ ., train)
    predicted <- predict(svm.model, test)
    observed <- test$O3
    rmae <-rmae(observed, predicted, mean(train$O3))
  }
  else 
  {
    svm.model <- svm(PM10 ~ ., train)
    predicted <- predict(svm.model, test)
    observed <- test$PM10
    rmae <-rmae(observed, predicted, mean(train$PM10))
  }
  return(rmae)
}
#Fit Neural Networks 
nnetRegression <-function(variable, train,test)
{
  if(variable == "O3")
  {
    nn.model <- nnet(O3 ~ ., train, size = 5, decay = 0.0001, maxit = 10000, linout = T)
    predicted <- predict(nn.model, test)
    observed <-test$O3
    rmae<-rmae(observed, predicted, mean(train$O3))
    
  }
  else 
  {
    nn.model <- nnet(PM10 ~ ., train, size = 5, decay = 0.0001, maxit = 10000, linout = T)
    predicted <- predict(nn.model, test)
    observed <-test$PM10
    rmae<-rmae(observed, predicted, mean(train$PM10))
  }
  return(rmae)
}
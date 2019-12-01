# Funkcija za inicializacijo knjiznic
InitLibs <- function()
{
  # instaliramo knjiznice, ki jih bomo potrebovali
  install.packages(c("ipred", "prodlim", "CORElearn", "e1071", "randomForest", "kernlab", "nnet", "dplyr", "reshape2", "ggplot2", "Hmisc", "rio", "psych"))

  # nalozimo knjiznici za predelavo atributov
  library(dplyr)
  library(reshape2)
  
  # nalozimo knjiznivo za analizo atributov
  library(Hmisc)
  library(psych)
  
  # nalozimo knjiznivo za export podatkov
  library(rio)

  # nalozimo knjiznico za vizualizacijo podatkov
  library(ggplot2)

  # nalozimo knjiznico za precno preverjanje
  library(ipred)

  # nalozimo knjiznico za grajenje odlocitvenih dreves
  library(rpart)

  # nalozimo knjiznico ki podpira grajenje razlicnih modelov
  library(CORElearn)
  
  #nalozimo knjiznice za gradjo regresijskih modelov
  library(e1071)
  library(randomForest)
  library(kknn)
  library(nnet)
 
}

# Funkcija za izracun Brierjeve mere
BrierScore <- function(observedMatrix, predictedMatrix)
{
    sum((observedMatrix - predictedMatrix) ^ 2) / nrow(predictedMatrix)
}

# Funkcija za izracun senzitivnosti modela
Sensitivity <- function(observed, predicted)
{
	t <- table(observed, predicted)

	t[1, 1] / sum(t[1,])
}

# Funkcija za izracun specificnosti modela
Specificity <- function(observed, predicted)
{
	t <- table(observed, predicted)

	t[2, 2] / sum(t[2,])
}

# Funkcija za izracun klasifikacijsko tocnost modela
ClassAcc <- function(observed, predicted)
{
    t <- table(observed, predicted)
    sum(diag(t) / sum(t))
}

# priprava atributov
PrepareAttributes <- function(variable, data)
{
  if(variable == "O3")
  {
    classes <- cut(data$O3, c(0, 60, 120, 180, Inf), c("NIZKA","SREDNJA","VISOKA","EKSTREMNA"))
    data[, "O3"] <- classes

    data$PM10 <- NULL

    # data$leto <-as.integer(format(as.Date(data$Datum, format="%Y-%m-%d"),"%Y"))

    # # Dodajanje atributa mesec
    # data$mesec <-as.integer(format(as.Date(data$Datum, format="%Y-%m-%d"),"%m"))
    
    # # Dodajanje novih atributov
    # data <- transform(data,
    #                     #Glob_sevanje_spr (sprememba globalnega sevanja na datum)
    #                     Glob_sevanje_spr = Glob_sevanje_max - Glob_sevanje_min,
    #                     #Pritisk_spr (sprememba pritiska na datum)
    #                     Pritisk_spr = Pritisk_max - Pritisk_min,
    #                     #Vlaga_spr (sprememba vlage na datum)
    #                     Vlaga_spr = Vlaga_max -  Vlaga_min,
    #                     #Temperatura_Krvavec_spr (sprememba temperature v Krvavcu na datum)
    #                     Temperatura_Krvavec_spr = Temperatura_Krvavec_max -  Temperatura_Krvavec_min,
    #                     #Temperatura_lokacija_spr (sprememba temperature v lokaciji na datum)
    #                     Temperatura_lokacija_spr = Temperatura_lokacija_max - Temperatura_lokacija_min
    #                     )

    # meseci <- c("Januar","Februar","Marec","April","Maj","Junij","Julij","Avgust","September","Oktober","November","December")
    # stringi <- c("-01-","-02-","-03-","-04-","-05-","-06-","-07-","-08-","-09-","-10-","-11-","-12-")
    # for (i in 1:12) { data[,meseci[i]] <- assign(meseci[i],grepl(stringi[i], data$Datum))}

    # data$Pomlad <- data$Marec + data$April + data$Maj
    # data$Poletje <- data$Junij + data$Julij + data$Avgust
    # data$Jesen <- data$September + data$Oktober + data$November
    # data$Zima <- data$December + data$Januar + data$Februar

    # # Odstranimo nepotrebne atribute
    # data$Januar<-NULL
    # data$Februar<-NULL
    # data$Marec<-NULL
    # data$April<-NULL
    # data$Maj<-NULL
    # data$Junij<-NULL
    # data$Julij<-NULL
    # data$Avgust<-NULL
    # data$September<-NULL
    # data$Oktober<-NULL
    # data$November<-NULL
    # data$December<-NULL

    # # remove letni časi
    # data$Poletje <- NULL
    # data$Pomlad <- NULL
    # data$Jesen <- NULL
    # data$Zima <- NULL

    # data$Datum <- NULL
    # data$leto <- NULL

    # # remove padavine
    # data$Padavine_sum <- NULL
    # data$Padavine_mean <- NULL

    # # remove krvavec
    # data$Temperatura_Krvavec_min <- NULL
    # data$Temperatura_Krvavec_max <- NULL
    # data$Temperatura_Krvavec_mean <- NULL
    # data$Temperatura_Krvavec_spr <- NULL

    # # remove Temperatura_lokacija (max has best corelation)
    # data$Temperatura_lokacija_min <- NULL
    # data$Temperatura_lokacija_mean <- NULL

    # # remove pritisk
    # data$Pritisk_spr <- NULL
    # data$Pritisk_min <- NULL
    # data$Pritisk_max <- NULL
    # data$Pritisk_mean <- NULL

    # # remove postaja
    # data$Postaja <- NULL

    # # remove glob_sevanje
    # data$Glob_sevanje_max <- NULL
    # data$Glob_sevanje_min <- NULL
    
    # # remove vlaga
    # data$Vlaga_min <- NULL

    # # remove sunki vetra
    # data$Sunki_vetra_min <- NULL
    # data$Sunki_vetra_max <- NULL
    # data$Sunki_vetra_mean <- NULL
    # data$Sunki_vetra_spr <- NULL

    # # remove hitrost vetra
    # data$Hitrost_vetra_min <- NULL
    # data$Hitrost_vetra_spr <- NULL
  }
  else 
  {
    # odstranimo O3, ker ga napovedujemo posebej 
    orgData$O3 <- NULL

    # odstranimo negativne vrednosti PM10 (min je 0)
    index <- which(orgData[, "PM10"] < 0)
    orgData <- orgData[-index, ]

    # diskretizacija PM10
    classes <- cut(orgData$PM10, c(0, 35, Inf), c("NIZKA", "VISOKA"))
    orgData[, "PM10"] <- classes

    # # Dodamo atribut leto
    # data$leto <-as.integer(format(as.Date(data$Datum, format="%Y-%m-%d"),"%Y"))

    # # Dodajanje atributa mesec
    # data$mesec <-as.integer(format(as.Date(data$Datum, format="%Y-%m-%d"),"%m"))
    
    # # Dodajanje novih atributov
    # data <- transform(data,
    #                     #Glob_sevanje_spr (sprememba globalnega sevanja na datum)
    #                     Glob_sevanje_spr = Glob_sevanje_max - Glob_sevanje_min,
    #                     #Pritisk_spr (sprememba pritiska na datum)
    #                     Pritisk_spr = Pritisk_max - Pritisk_min,
    #                     #Vlaga_spr (sprememba vlage na datum)
    #                     Vlaga_spr = Vlaga_max -  Vlaga_min,
    #                     #Temperatura_Krvavec_spr (sprememba temperature v Krvavcu na datum)
    #                     Temperatura_Krvavec_spr = Temperatura_Krvavec_max -  Temperatura_Krvavec_min,
    #                     #Temperatura_lokacija_spr (sprememba temperature v lokaciji na datum)
    #                     Temperatura_lokacija_spr = Temperatura_lokacija_max - Temperatura_lokacija_min
    #                     )

    # meseci <- c("Januar","Februar","Marec","April","Maj","Junij","Julij","Avgust","September","Oktober","November","December")
    # stringi <- c("-01-","-02-","-03-","-04-","-05-","-06-","-07-","-08-","-09-","-10-","-11-","-12-")
    # for (i in 1:12) { data[,meseci[i]] <- assign(meseci[i],grepl(stringi[i], data$Datum))}

    # data$Pomlad <- data$Marec + data$April + data$Maj
    # data$Poletje <- data$Junij + data$Julij + data$Avgust
    # data$Jesen <- data$September + data$Oktober + data$November
    # data$Zima <- data$December + data$Januar + data$Februar

    # # Odstranimo nepotrebne atribute
    # data$Januar<-NULL
    # data$Februar<-NULL
    # data$Marec<-NULL
    # data$April<-NULL
    # data$Maj<-NULL
    # data$Junij<-NULL
    # data$Julij<-NULL
    # data$Avgust<-NULL
    # data$September<-NULL
    # data$Oktober<-NULL
    # data$November<-NULL
    # data$December<-NULL

    # # remove letni časi
    # data$Poletje <- NULL
    # data$Pomlad <- NULL
    # data$Jesen <- NULL
    # data$Zima <- NULL

    # data$Datum <- NULL
    # data$leto <- NULL

    # # remove padavine
    # data$Padavine_sum <- NULL
    # data$Padavine_mean <- NULL

    # # remove krvavec
    # # data$Temperatura_Krvavec_min <- NULL
    # # data$Temperatura_Krvavec_max <- NULL
    # # data$Temperatura_Krvavec_mean <- NULL
    # data$Temperatura_Krvavec_spr <- NULL

    # # # remove Temperatura_lokacija (max has best corelation)
    # # data$Temperatura_lokacija_min <- NULL
    # # data$Temperatura_lokacija_mean <- NULL
    # # data$Temperatura_lokacija_spr <- NULL

    # # # remove pritisk
    # data$Pritisk_spr <- NULL
    # # data$Pritisk_min <- NULL
    # # data$Pritisk_max <- NULL
    # # data$Pritisk_mean <- NULL

    # # remove postaja
    # # data$Postaja <- NULL

    # # remove glob_sevanje
    # data$Glob_sevanje_min <- NULL
    
    # # remove vlaga
    # # data$Vlaga_min <- NULL

    # # remove sunki vetra
    # data$Sunki_vetra_min <- NULL
    # data$Sunki_vetra_max <- NULL
    # data$Sunki_vetra_mean <- NULL
    # data$Sunki_vetra_spr <- NULL

    # # remove hitrost vetra
    # data$Hitrost_vetra_min <- NULL
    # data$Hitrost_vetra_max <- NULL
    # data$Hitrost_vetra_mean <- NULL
    # data$Hitrost_vetra_spr <- NULL
  }

  return (data)
}

# ZA OCENJEVANJE REGRESIJSKIH MODELOV ################

#povprecna absolutna napaka
mae <- function(observed, predicted)
{
  mean(abs(observed - predicted))
}
#relavitva povprecna absolutna napaka
rmae <- function(observed, predicted, mean.val) 
{  
  sum(abs(observed - predicted)) / sum(abs(observed - mean.val))
}


#srednja kvadratno napako

mse <- function(observed, predicted)
{
  mean((observed - predicted)^2)
}
##########################################
prepareDataRegression<-function(variable,data)
{
  
  data$Datum <-as.Date(data$Datum, format="%Y-%m-%d")
  data$Glob_sevanje_min <- NULL
  if(variable =="O3"){
    
    
    #ocenimo atribute
    #data<-head(sort(attrEval(O3 ~ ., data, "ReliefFequalK"), decreasing = TRUE))
    #odstrnimo vse atribute, le prvih sest najbolje ocenjenih
    #Glob_sevanje_max, Glob_sevanje_mean, Temperatura_lokacija_max, Temperatura_lokacija_mean ,Temperatura_lokacija_min, Datum 
    
    data$Padavine_sum <- NULL
    data$Padavine_mean <- NULL
    
    # # remove krvavec
    data$Temperatura_Krvavec_min <- NULL
    data$Temperatura_Krvavec_max <- NULL
    data$Temperatura_Krvavec_mean <- NULL
    data$Temperatura_Krvavec_spr <- NULL
    
    # # # remove pritisk
    data$Pritisk_spr <- NULL
    data$Pritisk_min <- NULL
    data$Pritisk_max <- NULL
    data$Pritisk_mean <- NULL
    
    # # remove postaja
    data$Postaja <- NULL
    data$PM10 <-NULL
    
    # # remove vlaga
    data$Vlaga_min <- NULL
    data$Vlaga_max  <-NULL
    data$Vlaga_mean <-NULL
    
    # # remove sunki vetra
    data$Sunki_vetra_min <- NULL
    data$Sunki_vetra_max <- NULL
    data$Sunki_vetra_mean <- NULL
    data$Sunki_vetra_spr <- NULL
    
    # # remove hitrost vetra
    data$Hitrost_vetra_min <- NULL
    data$Hitrost_vetra_max <- NULL
    data$Hitrost_vetra_mean <- NULL
    data$Hitrost_vetra_spr <- NULL
    return(data)
  }else{
    #ocenimo atribute
    #data<-head(sort(attrEval(O3 ~ ., data, "ReliefFequalK"), decreasing = TRUE))
    #odstrnimo vse atribute, le prvih sest najbolje ocenjenih
    #head(sort(attrEval(PM10 ~ ., data, "GainRatio"), decreasing = TRUE))
    # Temperatura_lokacija_max, Temperatura_lokacija_mean,Temperatura_lokacija_min ,O3, Padavine_sum,Padavine_mean 
    
    data$Padavine_min<-NULL
    
    # # remove krvavec
    data$Temperatura_Krvavec_min <- NULL
    data$Temperatura_Krvavec_max <- NULL
    data$Temperatura_Krvavec_mean <- NULL
    data$Temperatura_Krvavec_spr <- NULL
    
    # # # remove pritisk
    data$Pritisk_spr <- NULL
    data$Pritisk_min <- NULL
    data$Pritisk_max <- NULL
    data$Pritisk_mean <- NULL
    
    # # remove postaja
    data$Postaja <- NULL

    
    # # remove vlaga
    data$Vlaga_min <- NULL
    data$Vlaga_max  <-NULL
    data$Vlaga_mean <-NULL
    
    # # remove sunki vetra
    data$Sunki_vetra_min <- NULL
    data$Sunki_vetra_max <- NULL
    data$Sunki_vetra_mean <- NULL
    data$Sunki_vetra_spr <- NULL
    
    # # remove hitrost vetra
    data$Hitrost_vetra_min <- NULL
    data$Hitrost_vetra_max <- NULL
    data$Hitrost_vetra_mean <- NULL
    data$Hitrost_vetra_spr <- NULL
    return(data)
    
    }
  
  
}
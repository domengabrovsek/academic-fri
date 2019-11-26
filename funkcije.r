
# Funkcija za inicializacijo knjiznic
InitLibs <- function()
{
  # instaliramo knjiznice, ki jih bomo potrebovali
  install.packages(c("ipred", "prodlim", "CORElearn", "e1071", "randomForest", "kernlab", "nnet", "dplyr", "reshape2", "ggplot2", "Hmisc", "rio"))

  # nalozimo knjiznici za predelavo atributov
  library(dplyr)
  library(reshape2)
  
  # nalozimo knjiznivo za analizo atributov
  library(Hmisc)
  
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

# Funkcija za analizo korelacije
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}

Correlation <- function (my_data)
{
  intlist <- c("Glob_sevanje_max","Glob_sevanje_mean","Glob_sevanje_min","Hitrost_vetra_max","Hitrost_vetra_mean", 
              "Hitrost_vetra_min", "Sunki_vetra_max",  "Sunki_vetra_mean", "Sunki_vetra_min",  "Padavine_mean", 
              "Padavine_sum", "Pritisk_max", "Pritisk_mean", "Pritisk_min", "Vlaga_max", "Vlaga_mean", "Vlaga_min",
              "Temperatura_lokacija_max", "Temperatura_lokacija_mean","Temperatura_lokacija_min", "PM10", "O3", 
              "Glob_sevanje_spr", "Pritisk_spr", "Vlaga_spr", "Temperatura_Krvavec_spr", "Temperatura_lokacija_spr"
  )
  intdata <- my_data[ , intlist] 
  res2<-rcorr(as.matrix(intdata))
  corrd <-flattenCorrMatrix(res2$r, res2$P)
  export(corrd, "Correlation.csv")
}

# Funkcija za odstranjevanje atributov
RemoveAttributes <- function(data)
{
  data$Datum <- NULL
  data$Glob_sevanje_min <- NULL
  data$O3 <- data$O3_Class
  data$O3_Class <- NULL

  return (data)
}

# Funkcija za dodajanje in spreminjanje atributov
ModifyAttributes <- function (data)
{
  # Dodajanje razredov NIZKA, SREDNJA, VISOKA, EKSTREMNA
  classes <- cut(data$O3, c(0, 60, 120, 180, Inf), c("NIZKA","SREDNJA","VISOKA","EKSTREMNA"))
  data[, "O3_Class"] <- classes

	# Dodajanje atributa leto
	data$leto <-as.integer(format(as.Date(data$Datum, format="%Y-%m-%d"),"%Y"))

	# Dodajanje atributa mesec
	data$mesec <-as.integer(format(as.Date(data$Datum, format="%Y-%m-%d"),"%m"))
	
	# Dodaj imena mesecev
	mymonths <- factor(c("Jan","Feb","Mar",
                      "Apr","May","Jun",
                      "Jul","Aug","Sep",
                      "Oct","Nov","Dec"), 
                    levels = c("Jan","Feb","Mar",
                              "Apr","May","Jun",
                              "Jul","Aug","Sep",
                              "Oct","Nov","Dec"));
	data$Mesec_Abb <- mymonths[ data$mesec ]
	
	# Dodajanje atributa letni cas na podlagi atributa mesec
	data <- mutate(data, letni_cas = ifelse(mesec %in% 1:2, "zima",
								ifelse(mesec %in% 3:5, "pomlad",
								ifelse(mesec %in% 6:8, "poletje",
								ifelse(mesec %in% 9:11, "jesen", 
								"zima")))))
	
	# Dodajanje novih atributov
	data <- transform(data,
                      #Glob_sevanje_spr (sprememba globalnega sevanja na datum)
                      Glob_sevanje_spr = Glob_sevanje_max - Glob_sevanje_min,
                      #Pritisk_spr (sprememba pritiska na datum)
                      Pritisk_spr = Pritisk_max - Pritisk_min,
                      #Vlaga_spr (sprememba vlage na datum)
                      Vlaga_spr = Vlaga_max -  Vlaga_min,
                      #Temperatura_Krvavec_spr (sprememba temperature v Krvavcu na datum)
                      Temperatura_Krvavec_spr = Temperatura_Krvavec_max -  Temperatura_Krvavec_min,
                      #Temperatura_lokacija_spr (sprememba temperature v lokaciji na datum)
                      Temperatura_lokacija_spr = Temperatura_lokacija_max - Temperatura_lokacija_min
                      )
}

# Funkcija za boxplot
BoxPlot<- function (my_data)
{
  #code to automatically select all integer variables (will include year and month)
  #intvar <-my_data[ , unlist(lapply(my_data, is.numeric)) ]
  #intlist <- colnames(intvar)
  
  #manual and more precise creation of the var list 
  intlist <- c("Glob_sevanje_max","Glob_sevanje_mean","Glob_sevanje_min","Hitrost_vetra_max","Hitrost_vetra_mean", 
            "Hitrost_vetra_min", "Sunki_vetra_max",  "Sunki_vetra_mean", "Sunki_vetra_min",  "Padavine_mean", 
            "Padavine_sum", "Pritisk_max", "Pritisk_mean", "Pritisk_min", "Vlaga_max", "Vlaga_mean", "Vlaga_min",
            "Temperatura_lokacija_max", "Temperatura_lokacija_mean","Temperatura_lokacija_min", "PM10", "O3", 
            "Glob_sevanje_spr", "Pritisk_spr", "Vlaga_spr", "Temperatura_Krvavec_spr", "Temperatura_lokacija_spr"
                  )
  
  for (i in intlist)
    {
    print(
      ggplot(my_data, aes(x=my_data$Mesec_Abb, y=my_data[,i], fill=Postaja)) + 
        geom_boxplot(outlier.colour="red", outlier.shape=8,outlier.size=2)
      + xlab("Month")
      + ylab(i)
          )
    }
}


# Funkcija za histogram
Histogram<- function (my_data)
{
  #code to automatically select all integer variables (will include year and month)
  #intvar <-my_data[ , unlist(lapply(my_data, is.numeric)) ]
  #intlist <- colnames(intvar)
  
  #manual and more precise creation of the var list 
  intlist <- c("Glob_sevanje_max","Glob_sevanje_mean","Glob_sevanje_min","Hitrost_vetra_max","Hitrost_vetra_mean", 
              "Hitrost_vetra_min", "Sunki_vetra_max",  "Sunki_vetra_mean", "Sunki_vetra_min",  "Padavine_mean", 
              "Padavine_sum", "Pritisk_max", "Pritisk_mean", "Pritisk_min", "Vlaga_max", "Vlaga_mean", "Vlaga_min",
              "Temperatura_lokacija_max", "Temperatura_lokacija_mean","Temperatura_lokacija_min", "PM10", "O3", 
              "Glob_sevanje_spr", "Pritisk_spr", "Vlaga_spr", "Temperatura_Krvavec_spr", "Temperatura_lokacija_spr"
              )
  
  for (i in intlist)
  {
    print(
      ggplot(my_data, aes(x = my_data[,i], fill = Postaja)) +
        geom_density(alpha = .3)  #alpha used for filling the density
      + xlab(i) )
  }
}

#Funkcija za scatterplot 

Scatterplot<- function (my_data)
{  
  intlist <- c("Glob_sevanje_max","Glob_sevanje_mean","Glob_sevanje_min","Hitrost_vetra_max","Hitrost_vetra_mean", 
                "Hitrost_vetra_min", "Sunki_vetra_max",  "Sunki_vetra_mean", "Sunki_vetra_min",  "Padavine_mean", 
                "Padavine_sum", "Pritisk_max", "Pritisk_mean", "Pritisk_min", "Vlaga_max", "Vlaga_mean", "Vlaga_min",
                "Temperatura_lokacija_max", "Temperatura_lokacija_mean","Temperatura_lokacija_min", "PM10", "O3", 
                "Glob_sevanje_spr", "Pritisk_spr", "Vlaga_spr", "Temperatura_Krvavec_spr", "Temperatura_lokacija_spr"
              )
  intdata <-my_data[ , intlist]  
  for(ii in 1:(ncol(intdata)-1) )
    {
    begin <- ii + 1
    for(i in begin:ncol(intdata))
    {
      print(
        ggplot(my_data, aes(x=intdata[,ii], y=intdata[,i])) + 
          geom_point(aes(col=Postaja)) + 
          geom_smooth(method="loess", se=F) + 
          xlim(c(0, max(intdata[,ii]))) + 
          ylim(c(0, max(intdata[,i]))) + 
          labs(
            title="Scatterplot")
            + xlab(intlist[ii])
            + ylab(intlist[i])
          )
      }
    } 
}

# Funkcija za pripravo finanlnega dataseta
# FinalData <- function (data)
# {
#  finaldata
# }
# Funkcija za inicializacijo knjiznic
InitLibs <- function()
{
  # instaliramo knjiznice, ki jih bomo potrebovali
  install.packages(c("dplyr", "reshape2", "ggplot2", "Hmisc", "rio", "psych"))

  # nalozimo knjiznivo za analizo in vizualizacijo atributov
  library(dplyr)
  library(reshape2)
  library(Hmisc)
  library(psych)
  library(rio)
  library(ggplot2)
}

# Seznam integer atributov
## Code to automatically select all integer variables (will include year and month)
### IntAtr <- function (my_data) 
### { 
###   intvar <- my_data [ , unlist(lapply(my_data, is.numeric)) ]
###   intlist <- colnames(intvar)
###   return (intlist)
### }

## Manual and more precise creation of the var list 
intlist <- c("Glob_sevanje_max","Glob_sevanje_mean","Glob_sevanje_min",
             "Hitrost_vetra_max","Hitrost_vetra_mean", "Hitrost_vetra_min", 
             "Sunki_vetra_max",  "Sunki_vetra_mean", "Sunki_vetra_min",  
             "Padavine_mean", "Padavine_sum", 
             "Pritisk_max", "Pritisk_mean", "Pritisk_min", 
             "Vlaga_max", "Vlaga_mean", "Vlaga_min",
             "Temperatura_Krvavec_max", "Temperatura_Krvavec_mean","Temperatura_Krvavec_min",
             "Temperatura_lokacija_max", "Temperatura_lokacija_mean","Temperatura_lokacija_min", 
             "PM10", "O3", 
             "Glob_sevanje_spr", "Pritisk_spr", "Vlaga_spr", "Temperatura_Krvavec_spr", "Temperatura_lokacija_spr"
            )

# Funkcija za pripravo tabele korelacij
flattenCorrMatrix <- function(cormat, pmat) 
{
  ut <- upper.tri(cormat)
  data.frame (
              row = rownames(cormat)[row(cormat)[ut]],
              column = rownames(cormat)[col(cormat)[ut]],
              cor  = (cormat)[ut],
              p = pmat[ut]
              )
}

# Funkcija za analizo korelacije
Correlation <- function(my_data)
{
  intdata <- my_data[ , intlist] 
  res2 <- rcorr(as.matrix(intdata))
  corrd <- flattenCorrMatrix(res2$r, res2$P)
  export(corrd, "Correlation.csv")
}

# Funkcija za dodajanje in spreminjanje atributov
ModifyAttributes <- function (data)
{
  # Dodajanje razredov O3 NIZKA, SREDNJA, VISOKA, EKSTREMNA
  classes <- cut(data$O3, c(0, 60, 120, 180, Inf), c("NIZKA","SREDNJA","VISOKA","EKSTREMNA"))
  data[, "O3_Class"] <- classes
  
  # Dodajanje razredov PM10 NIZKA, VISOKA za PM10
  classesPM10 <- cut(data$PM10, c(-10, 35,  Inf), c("NIZKA", "VISOKA"))
  data[, "PM10_Class"] <- classesPM10
  
  # Dodajanje atributa leto
  data$leto <- as.integer(format(as.Date(data$Datum, format="%Y-%m-%d"),"%Y"))
  
  # Dodajanje atributa mesec
  data$mesec <- as.integer(format(as.Date(data$Datum, format="%Y-%m-%d"),"%m"))
  
  # Dodaj imena mesecev
  mymonths <- factor(c("Jan","Feb","Mar",
                      "Apr","May","Jun",
                      "Jul","Aug","Sep",
                      "Oct","Nov","Dec"), 
                      levels = c("Jan","Feb","Mar",
                                "Apr","May","Jun",
                                "Jul","Aug","Sep",
                                "Oct","Nov","Dec"));
  data$Mesec_Abb <- mymonths[data$mesec]
  
  # Dodajanje atributa letni cas na podlagi atributa mesec
  data <- mutate(data, letni_cas = ifelse(mesec %in% 1:2, "zima",
                                          ifelse(mesec %in% 3:5, "pomlad",
                                                ifelse(mesec %in% 6:8, "poletje",
                                                        ifelse(mesec %in% 9:11, "jesen", 
                                                              "zima")))))
  
  # Dodajanje novih atributov
  data <- transform (data,
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

# Fukcije za vizualizacijo podatkov
#Boxplot
## Funkcija za boxplot enega atributa
BoxPlotV <- function (my_data)
{
  for (i in intlist)
  {
    print(
          ggplot(data = my_data, aes(x = "", y = my_data[,i])) + 
          geom_boxplot()+
          xlab(i)+
          ylab("Value")
          )
  }
}

## Funkcija za boxplot samo meseca
BoxPlotM <- function (my_data)
{
  for (i in intlist)
  {
    print(
          ggplot(my_data, aes(x=my_data$Mesec_Abb, y=my_data[,i])) + 
          geom_boxplot(outlier.colour="red", outlier.shape=8,outlier.size=2) +
          xlab("Mesec") +
          ylab(i)
          )
  }
}

## Funkcija za boxplot mesec in postaja
BoxPlotMP <- function (my_data)
{  
  for (i in intlist)
  {
    print(
          ggplot(my_data, aes(x=my_data$Mesec_Abb, y=my_data[,i], fill=Postaja)) + 
          geom_boxplot(outlier.colour="red", outlier.shape=8,outlier.size=2) +
          xlab("Mesec") +
          ylab(i)
          )
  }
}

## Funkcija za boxplot klassa O3
BoxPlotO3Class <- function (my_data)
{  
  for (i in intlist)
  {
    print(
          ggplot(my_data, aes(x=my_data$O3_Class, y=my_data[,i])) + 
          geom_boxplot(outlier.colour="red", outlier.shape=8,outlier.size=2) +
          xlab("O3_Class") +
          ylab(i)
          )
  }
}

## Funkcija za boxplot klassa PM10
BoxPlotPM10Class <- function (my_data)
{  
  for (i in intlist)
  {
    print(
      ggplot(my_data, aes(x=my_data$PM10_Class, y=my_data[,i])) + 
        geom_boxplot(outlier.colour="red", outlier.shape=8,outlier.size=2) +
        xlab("PM10_Class") +
        ylab(i)
    )
  }
}

# Histogram
## Funkcija za histogram atributa
HistogramV <- function (my_data)
{
  for (i in intlist)
  {
    print(
          ggplot(my_data, aes(x=my_data[,i])) + 
          geom_histogram(aes(y=..density..), colour="black", fill="white", bins = 200)+
          geom_density(alpha=.2, fill="#FF6666") +
          xlab(i) 
          )
  }
}

## Funkcija za histogram Postaja
HistogramPost <- function (my_data)
{
  for (i in intlist)
  {
    print(
          ggplot(my_data, aes(x = my_data[,i], fill = Postaja)) +
          geom_density(alpha = .3) +  #alpha used for filling the density
          xlab(i) 
          )
  }
}

## Funkcija za histogram O3
HistogramO3 <- function (my_data)
{
  for (i in intlist)
  {
    print(
          # Overlaid histograms
          ggplot(my_data, aes(x=my_data[,i], color=O3_Class)) +
          geom_histogram(fill="white", alpha=0.3, position="identity", bins=200) +
          xlab(i) 
          )
  }
}

## Funkcija za histogram PM10
HistogramPM10 <- function (my_data)
{
  for (i in intlist)
  {
    print(
          # Overlaid histograms
          ggplot(my_data, aes(x=my_data[,i], color=PM10_Class)) +
          geom_histogram(fill="white", alpha=0.3, position="identity", bins=200) +
          xlab(i) 
          )
  }
}

# Scattreplot
## Funkcija za scatterplot za Postajo
ScatterplotP<- function (my_data)
{  
  intdata <- my_data[ , intlist]  
  for(ii in 1:(ncol(intdata)-1))
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
            labs(title="Scatterplot Postaja") +
            xlab(intlist[ii]) +
            ylab(intlist[i])
            )
    }
  } 
}


## Funkcija za scatterplot za skupine O3
ScatterplotO3Class <- function (my_data)
{ 
  for (i in intlist)
  {
    print(
          ggplot(my_data, aes(x=my_data[,i], y=my_data$O3)) +
          geom_point(aes( color=O3_Class)) +
          geom_smooth(method="loess", se=F) + 
          xlim(c(min(my_data[,i]), max(my_data[,i]))) + 
          ylim(c(0, max(my_data$O3))) +
          xlab(i) +
          ylab('O3')
          )     
  }
}

## Funkcija za scatterplot za skupine PM10
ScatterplotPM10Class <- function (my_data)
{  
  for (i in intlist)
  {
    print (
          ggplot(my_data, aes(x=my_data[,i], y=my_data$PM10)) +
          geom_point(aes(color=PM10_Class)) +
          geom_smooth(method="loess", se=F) + 
          xlim(c(min(my_data[,i]), max(my_data[,i]))) + 
          ylim(c(-1, 120)) +
          xlab(i) +
          ylab('PM10')
          )
  }
}

# Barcharts
## Barchart za analizo stevila podatkov za vsako grupo PM10 in mesec
BarChartPM10M <- function (my_data)
{
  datacount <- my_data %>% count(Mesec_Abb, PM10_Class)
  print (
        ggplot(data = datacount, aes(x = Mesec_Abb, y = n, fill = PM10_Class)) +
        stat_summary(
                    fun.y = sum, # adds up all observations for the month
                    geom = "bar",
                    position=position_dodge2(width = 0.9, preserve = "single")
                    ) 
          )
}

## Barchart za analizo stevila podatkov za vsako grupo PM10 in Postajo
BarChartPM10P <- function (my_data)
{
  datacount <- my_data %>% count(Postaja, PM10_Class)
  # graph by month:
  print (
        ggplot(data = datacount, aes(x = Postaja, y = n, fill = PM10_Class)) +
        stat_summary(
                    fun.y = sum, # adds up all observations for the month
                    geom = "bar",
                    position=position_dodge2(width = 0.9, preserve = "single")
                    ) 
          )
}

## Barchart za analizo stevila podatkov za vsako grupo O3 in Mesec
BarChartO3M <- function (my_data)
{
  datacount <- my_data %>% count(Mesec_Abb, O3_Class)
  # graph by month:
  print (
        ggplot(data = datacount, aes(x = Mesec_Abb, y = n, fill = O3_Class)) +
        stat_summary(
                    fun.y = sum, # adds up all observations for the month
                    geom = "bar",
                    position=position_dodge2(width = 0.9, preserve = "single")
                    ) 
          )
}

## Barchart za analizo stevila podatkov za vsako grupo O3 in postajo
BarChartO3P <- function (my_data)
{
  datacount <- my_data %>% count(Postaja, O3_Class)
  # graph by month:
  print (
    ggplot(data = datacount, aes(x = Postaja, y = n, fill = O3_Class)) +
    stat_summary(
                fun.y = sum, # adds up all observations for the month
                geom = "bar",
                position=position_dodge2(width = 0.9, preserve = "single")
                ) 
          )
}

## Barchart za stevilo atributov Postaja
CountPos <- function(my_data)
{
  print (
        ggplot(my_data, aes(x=Postaja)) +
        geom_bar(stat="count", width=0.7, fill="steelblue") +
        geom_text( stat='count',aes(label=..count..), vjust=1.6, color="white", size=5.5) 
        )
}

## Barchart za stevilo atributov Postaja
CountMes <- function(my_data)
{
  print (
    ggplot(my_data, aes(x=Mesec_Abb)) +
      geom_bar(stat="count", width=0.7, fill="steelblue") +
      geom_text( stat='count',aes(label=..count..), vjust=1.6, color="white", size=5.5) 
        )
}

## Funkcija za analizo stevila podatkov za vsak mesec
CountMesPos <- function (My_data)
{
  datacount <- My_data %>% count(Mesec_Abb, Postaja)
  print (
    ggplot(data = datacount,
           aes(x = Mesec_Abb, y = n, fill = Postaja)) +
      stat_summary(
        fun.y = sum, # adds up all observations for the month
        geom = "bar",
        position="dodge"
      ) 
  )
}

# Funkcija za pripravo finanlnega dataseta
FinalData <- function (my_data)
{
  outlierlist <- c()
  for (i in intlist)
  {
    outlierUp <- NULL
    outlierLow <- NULL
    outlierUp=quantile(my_data[,i],0.75, na.rm = TRUE)+1.5*IQR(my_data[,i],na.rm = TRUE)
    outlierLow=quantile(my_data[,i],0.25, na.rm = TRUE)-1.5*IQR(my_data[,i],na.rm = TRUE)
    index_outlier_list= which(my_data[,i] > outlierUp | my_data[,i] < outlierLow)
    if (length(index_outlier_list) != 0) 
    {
      outlierlist <- append(outlierlist, index_outlier_list, length(outlierlist) )
    } 
  }
  my_data <- my_data[-outlierlist, ]
  return (my_data)
  PMindex_outlier= which(my_data[,"PM10"] < 0)
  my_data = my_data[-PMindex_outlier, ]
  my_data$Glob_Sevanje_min <- NULL
}


# Funkcije za vizualizacijo modelov
## Knn plot CA vs stevilo nearest neighbors
KnnPlot <- function (my_data)
{
  print (
        ggplot(data= my_data, aes(x = kList, y = knn, label = kList)) + 
        geom_line() +
        geom_text(size = 3)
        )
}



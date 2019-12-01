# nalozimo svoje custom funkcije
source("funkcijeViz.r")
tempdir()

# nalozimo dataset
orgData <- read.table("podatkiSem1.csv", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData
class(data)

data <- ModifyAttributes (data)


ggplot(data = data, aes(x = "", y = data$Glob_sevanje_max)) + 
  geom_boxplot()+
  xlab("data$Glob_sevanje_max")+
  ylab("value")



BarChartPM10 <- function (my_data)
{
  datacount <- my_data %>% count(Mesec_Abb, PM10_Class)
  
  # graph by month:
  print (
          ggplot(data = datacount,
          aes(x = Mesec_Abb, y = n, fill = PM10_Class)) +
          stat_summary(fun.y = sum, # adds up all observations for the month
                 geom = "bar",
                 position=position_dodge(0.9)) 
      )
  }


BarChartPM10 (data)

class(data$Glob_sevanje_spr)

ScatterplotP<- function (my_data)
{  
  intlist <- c("Glob_sevanje_max","Glob_sevanje_mean","Glob_sevanje_min","Hitrost_vetra_max","Hitrost_vetra_mean", 
               "Hitrost_vetra_min", "Sunki_vetra_max",  "Sunki_vetra_mean", "Sunki_vetra_min",  "Padavine_mean", 
               "Padavine_sum", "Pritisk_max", "Pritisk_mean", "Pritisk_min", "Vlaga_max", "Vlaga_mean", "Vlaga_min",
               "Temperatura_lokacija_max", "Temperatura_lokacija_mean","Temperatura_lokacija_min", "PM10", "O3", 
               "Glob_sevanje_spr", "Pritisk_spr", "Vlaga_spr", "Temperatura_Krvavec_spr", "Temperatura_lokacija_spr"
  )
  for (i in intlist)
  {
    print(
      ggplot(my_data, aes(x=my_data[,i], y=my_data$O3)) + 
        geom_point(aes(col=my_data$O3_class)) + 
        geom_smooth(method="loess", se=F) + 
        xlim(c(min(my_data[,i]), max(my_data[,i]))) + 
        ylim(c(0, max(my_data$O3))) 
      + xlab(i)
      + ylab('O3')
    )
    
    
  }
}



ScatterplotO3Class<- function (my_data)
{  
  intlist <- c("Glob_sevanje_max","Glob_sevanje_mean","Glob_sevanje_min","Hitrost_vetra_max","Hitrost_vetra_mean", 
               "Hitrost_vetra_min", "Sunki_vetra_max",  "Sunki_vetra_mean", "Sunki_vetra_min",  "Padavine_mean", 
               "Padavine_sum", "Pritisk_max", "Pritisk_mean", "Pritisk_min", "Vlaga_max", "Vlaga_mean", "Vlaga_min",
               "Temperatura_lokacija_max", "Temperatura_lokacija_mean","Temperatura_lokacija_min", "PM10", "O3", 
               "Glob_sevanje_spr", "Pritisk_spr", "Vlaga_spr", "Temperatura_Krvavec_spr", "Temperatura_lokacija_spr"
  )
  for (i in intlist)
  {
    print(
      ggplot(my_data, aes(x=my_data[,i], y=my_data$O3)) +
        geom_point(aes( color=O3_Class)) +
        geom_smooth(method="loess", se=F) + 
        xlim(c(min(my_data[,i]), max(my_data[,i]))) + 
        ylim(c(0, max(my_data$O3))) 
      + xlab(i)
      + ylab('O3')
    )
    
    
  }
}

ScatterplotP (data)


print(
  ggplot(my_data, aes(x=my_data$Temperatura_lokacija_mean, y=my_data$O3)) + 
    geom_point(aes(col=my_data$O3_class)) + 
    geom_smooth(method="loess", se=F) + 
    xlim(c(min(my_data$Temperatura_Krvavec_mean), max(my_data$Temperatura_lokacija_mean))) + 
    ylim(c(0, max(my_data$O3))) 
    + xlab('Temperatura_l')
    + ylab('o3')
    )


print(
  ggplot(my_data, aes(x=my_data$Temperatura_lokacija_mean, y=my_data$PM10)) + 
    geom_point(aes(color=my_data$PM10_class)) + 
    geom_smooth(method="loess", se=F) + 
    xlim(c(min(my_data$Temperatura_Krvavec_mean), max(my_data$Temperatura_lokacija_mean))) + 
    ylim(c(min(my_data$PM10), max(my_data$PM10))) 
  + xlab('Temperatura_l')
  + ylab('PM10')
)




  print(
    ggplot(my_data, aes(x=my_data$O3_Class, y=my_data$Vlaga_mean, fill=Postaja)) + 
      geom_boxplot(outlier.colour="red", outlier.shape=8,outlier.size=2)
    + xlab("O3Class")
    + ylab("Vlaga_mean")
  )

  
  
  print(
    ggplot(my_data, aes(x=my_data$O3_Class, y=my_data$Temperatura_Krvavec_mean)) + 
      geom_boxplot(outlier.colour="red", outlier.shape=8,outlier.size=2)
    + xlab("O3Class")
    + ylab("Temperatura_Krvavec_mean")
  )
  
  BoxPlotO3Class (data)
  BoxPlotPM10Class (data)
  
  

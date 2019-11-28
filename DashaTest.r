# nalozimo svoje custom funkcije
source("funkcije.r")


# nalozimo dataset
orgData <- read.table("podatkiSem1.csv", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData
class(data)

data <- AddAttributes (data)

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

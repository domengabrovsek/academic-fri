# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo dataset
data <- read.table("podatkiSem1.csv", header = T, sep = ",")

# dodajanje in predelava atributov
data <- PredelavaAtributov (data)
library("rio")
export(data, "data.csv")

nonint <-data[ , unlist(lapply(data, is.numeric)) ]
nonibtlist <- colnames(nonint)
nonibtlist

nums <- unlist(lapply(data, is.numeric))  
nums <- dplyr::select_if(data, is.numeric)
nums <- c("Glob_sevanje_max","Glob_sevanje_mean","Glob_sevanje_min","Hitrost_vetra_max","Hitrost_vetra_mean", 
          "Hitrost_vetra_min", "Sunki_vetra_max",  "Sunki_vetra_mean", "Sunki_vetra_min",  "Padavine_mean", 
          "Padavine_sum", "Pritisk_max", "Pritisk_mean", "Pritisk_min", "Vlaga_max", "Vlaga_mean", "Vlaga_min",
          "Temperatura_lokacija_max", "Temperatura_lokacija_mean","Temperatura_lokacija_min", "PM10", "O3", 
          "Glob_sevanje_spr", "Pritisk_spr", "Vlaga_spr", "Temperatura_Krvavec_spr", "Temperatura_lokacija_spr"
)



nonint <-data[ , unlist(lapply(data, is.numeric)) ]
nonibtlist <- colnames(nonint)
for (i in nonibtlist){
  print(
    ggplot(data, aes(x=data$Mesec_Abb, y=data[,i], fill=Postaja)) + 
      geom_boxplot(outlier.colour="red", outlier.shape=8,outlier.size=2)
        + xlab("Month")
        + ylab(i)
        
        
  )
}
BoxPlot(data)






# Correlation panel
panel.cor <- function(x, y){
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- round(cor(x, y), digits=2)
  txt <- paste0("R = ", r)
  cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
# Customize upper panel
upper.panel<-function(x, y){
  points(x,y, pch = 19, col = my_cols[data$Postaja])
}
# Create the plots
pairs(data[ , unlist(lapply(data, is.numeric)) ], 
      lower.panel = panel.cor,
      upper.panel = upper.panel)








ScatterPlot (data, data$O3, data$Glob_sevanje_mean)

my_cols <- c("#00AFBB", "#E7B800", "#FC4E07")
pairs(data[,3:8], 
      col = my_cols[data$Postaja],
      lower.panel=NULL)




ggplot(data[which(data$Postaja=='Koper'), ], aes(x = Glob_sevanje_mean)) +
  geom_histogram(binwidth = .5, alpha =.5, position = "identity") +
  geom_vline(aes(xintercept = mean(Glob_sevanje_mean, na.rm = T)),
             colour = "red", linetype ="longdash", size = .8)

ggplot(data[which(data$Postaja=='Koper'), ]) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8,
               outlier.size=4)

boxplot(data[which(data$Postaja=='Koper'), "Glob_sevanje_mean"], 
        bty="n", xlab = "Loan amount", cex=0.4, main = "Boxplot of Loan amount") # For boxplot


ggplot(data, aes(x=Mesec_Abb, y=Glob_sevanje_mean, fill=Postaja)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8,
               outlier.size=2)

BoxPlot (data, data$Mesec_Abb, data$Glob_sevanje_mean)


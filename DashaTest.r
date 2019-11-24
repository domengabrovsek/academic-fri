# nalozimo svoje custom funkcije
source("funkcije.r")



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




BoxPlot (data, data$Mesec_Abb, data$Glob_sevanje_mean)









nonibtlist <- c("Glob_sevanje_max","Glob_sevanje_mean","Glob_sevanje_min","Hitrost_vetra_max","Hitrost_vetra_mean", 
                "Hitrost_vetra_min", "Sunki_vetra_max",  "Sunki_vetra_mean", "Sunki_vetra_min",  "Padavine_mean", 
                "Padavine_sum", "Pritisk_max", "Pritisk_mean", "Pritisk_min", "Vlaga_max", "Vlaga_mean", "Vlaga_min",
                "Temperatura_lokacija_max", "Temperatura_lokacija_mean","Temperatura_lokacija_min", "PM10", "O3", 
                "Glob_sevanje_spr", "Pritisk_spr", "Vlaga_spr", "Temperatura_Krvavec_spr", "Temperatura_lokacija_spr"
)

#create a dataset
#add location data
#add the curve
nonint <-data[ , unlist(lapply(data, is.numeric)) ]

for(ii in 1:(ncol(nonint)-1) ){
  begin <- ii + 1
  for(i in begin:ncol(nonint)){
    plot(x=nonint[,ii], y=nonint[,i], xlab=colnames(nonint)[ii], ylab=colnames(nonint)[i])
    Sys.sleep(1)
  }
} 





for(ii in 1:(ncol(nonint)-1) ){
  begin <- ii + 1
  for(i in begin:ncol(nonint))
  {
    print(
      ggplot(data, aes(x=nonint[,ii], y=nonint[,i])) +
        geom_point(aes(color = factor(Postaja))))
  }
} 


for(ii in 1:(ncol(nonint)-1) ){
  begin <- ii + 1
  for(i in begin:ncol(nonint))
  {
    print(
      ggplot(data, aes(x=nonint[,ii], y=nonint[,i])) + 
        geom_point(aes(col=Postaja)) + 
        geom_smooth(method="loess", se=F) + 
        xlim(c(0, max(nonint[,ii]))) + 
        ylim(c(0, max(nonint[,i]))) + 
        labs(
          title="Scatterplot",
        )
    )
  }
} 






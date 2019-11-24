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
ClassAcc <- function(correct, predicted)
{
    t <- table(correct, predicted)
    sum(diag(t) / sum(t))
}

# Funkcija za predelavo atributov
PredelavaAtributov <- function (my_data)
{
	# Dodajanje atributa leto
	my_data$leto <-as.integer(format(as.Date(my_data$Datum, format="%Y-%m-%d"),"%Y"))

	# Dodajanje atributa mesec
	my_data$mesec <-as.integer(format(as.Date(my_data$Datum, format="%Y-%m-%d"),"%m"))
	#meseci <- c("Januar","Februar","Marec","April","Maj","Junij","Julij","Avgust","September","Oktober","November","December")
	#stringi <- c("-01-","-02-","-03-","-04-","-05-","-06-","-07-","-08-","-09-","-10-","-11-","-12-")
	#for (i in 1:12) { my_data[,meseci[i]] <- assign(meseci[i],grepl(stringi[i],my_data$Datum))}

	
	#add abbreviated month name
	mymonths <- factor(c("Jan","Feb","Mar",
	                     "Apr","May","Jun",
	                     "Jul","Aug","Sep",
	                     "Oct","Nov","Dec"), 
	                   levels = c("Jan","Feb","Mar",
	                              "Apr","May","Jun",
	                              "Jul","Aug","Sep",
	                              "Oct","Nov","Dec"));
	my_data$Mesec_Abb <- mymonths[ my_data$mesec ]
	
	# Dodajanje atributa letni cas na podlagi atributa mesec
	my_data <- mutate(my_data, letni_cas = ifelse(mesec %in% 1:2, "zima",
								ifelse(mesec %in% 3:5, "pomlad",
								ifelse(mesec %in% 6:8, "poletje",
								ifelse(mesec %in% 9:11, "jesen", 
								"zima")))))
	
	# Dodajanje novih atributov
	my_data <- transform( my_data,
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


# Funkcija za histogramo
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

Scatterplot2<- function (my_data)
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

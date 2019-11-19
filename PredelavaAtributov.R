#predelava atributa datum na letne case, dni v tednu
vreme <-read.table("podatkiSem1.txt", sep=",", header = T)

#dodamo atribut leto, integer
vreme$leto <-as.integer(format(as.Date(vreme$Datum, format="%Y-%m-%d"),"%Y"))

#letni casi:String
mesec <-as.integer(format(as.Date(vreme$Datum, format="%Y-%m-%d"),"%m"))
summary(vreme)
#zima : dec, jan, feb



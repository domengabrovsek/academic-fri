#######################################################################################################################
#
# NALOGE
#
#######################################################################################################################
#
# - najprej nalozimo podatke iz datoteke "auto-mpg.txt"
#
#	cars <- read.table("auto-mpg.txt", sep=",", header=T)
#	summary(cars)
#	plot(cars$horsepower ~ cars$displacement)
#
# - dolocimo ucne primere, v katerih manjka vrednost atributa "horsepower"
#
#	sel <- is.na(cars$horsepower)
#
# - zgradite model za predikcijo vrednosti atributa "horsepower" s pomocjo vrednosti atributa "displacement" 
#   (npr. z linearno regresijo ali utezeno linearno regresijo). Pri ucenju uporabite samo tiste ucne primere, 
#   ki vsebujejo vrednost atributa "horsepower" 	
#
# - s pomocjo zgrajenega modela vstavite manjkajoce vrednosti v vektor cars$horsepower[sel] tako, da uporabite 
#   funkcijo predict na "testni" mnozici cars[sel,]
#
#######################################################################################################################
#
# - iz popravljene podatkovne mnozice "cars" odstranite atribut "name"
#
# - razdelite podatkovno mnozico na ucni in testni del: 
#   ucno mnozico naj sestavljajo vozila zgrajena pred letom 81
#   testno mnozico naj sestavljajo vozila zgrajena po letu 81
#
# - zgradite in ovrednotite razlicne regresijske modele za napovedovanja vrednosti "mpg" (miles per gallon)
#
#######################################################################################################################

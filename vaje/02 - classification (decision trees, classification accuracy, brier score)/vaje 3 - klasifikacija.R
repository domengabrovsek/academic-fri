
#
#
# UVOD V KLASIFIKACIJO
#
#

#
# Nacrt dela:
#
# - Nalozili bomo podatke iz vhodne datoteke
# - Razdelili bomo podatke na ucno in testno mnozico
# - Zgradili bomo odlocitveno drevo s pomocjo ucne mnozice
# - Kvaliteto zgrajenega drevesa bomo ocenili s pomocjo testne mnozice
#



# Prenesite datoteko "census.txt" v lokalno mapo. To mapo nastavite kot 
# delovno mapo okolja R. To lahko naredite s pomocjo ukaza "setwd" oziroma iz 
# menuja s klikom na File -> Change dir...
# 
# Na primer:
# setwd("c:\\vaje\\data\\")


# Nalozimo ucno mnozico
census <- read.table("census.txt", header = T, sep = ",")


# Povzetek o atributih v podatkovni mnozici
summary(census)


##############################################################################
#
# Primer 1
#
# Napovedovanje letnega zasluzka
# (nominalna spremenljivka "income", ki ima dve vrednosti: "Large" in "Small")
#
##############################################################################

#
# Zelimo zgraditi model, ki bo za podano osebo napovedal, v katero skupino (glede na letni zaslužek)
# se bo uvrstil.
#
# Ciljni atribut "income" je diskreten (skupina) - zato govorimo o klasifikaciji.   
#
# Zelimo preveriti, ali model zgrajen na podlagi zgodovinskih podatkov, lahko 
# uporabimo za napovedovanje novih, do sedaj nepoznanih oseb. 
#

# Koliko je ucnih primerov?
nrow(census)

# Podatke bomo nakljucno razdelili na ucno in testno mnozico v rezmerju 70:30.

# Ukaz set.seed nastavi generator nakljucnih stevil.
# Uporabimo ga takrat, ko zelimo ponovljivo sekvenco generiranih stevil.
set.seed(12345)

sel <- sample(1:nrow(census), size=as.integer(nrow(census) * 0.7), replace=F)

train <- census[sel,]
test <- census[-sel,]


# Poglejmo osnovne karakteristike ucne in testne mnozice 
# (stevilo primerov, porazdelitev ciljne spremenljivke).

nrow(train)
table(train$income)

nrow(test)
table(test$income)


#
#
# VECINSKI KLASIFIKATOR
#
# vedno klasificira v razred z najvec ucnimi primeri
#

# poglejmo pogostost posameznih razredov
table(train$income)

# v nasem primeru je vecinski razred "Small"

# Izracunajmo tocnost vecinskega klasifikatorja
# (delez pravilnih napovedi, ce bi vse testne primere klasificirali v vecinski razred)

sum(test$income == "Small") / length(test$income)



#
#
# ODLOCITVENA DREVESA
#
#

# Za gradnjo odlocitvenih dreves potrebujemo funkcijo iz knjiznice "rpart".
# Nalozimo jo
library(rpart)

# Zgradimo odlocitveno drevo
dt <- rpart(income ~ ., data = train)

#
# Prvi argument funkcije rpart je formula, ki doloca kaksen model zelimo zgraditi.
# Drugi argument predstavlja ucne primere, na podlagi katerih se bo zgradil model.
#
# Formula doloca ciljni atribut (levo od znaka "~") in atribute, ki jih model lahko 
# uporabi pri napovedovanju vrednosti ciljnega atributa (desno od znaka "~").
#
# Formula "income ~ . " oznacuje, da zelimo zgraditi model za napovedovanje 
# ciljnega atributa "income" s pomocjo vseh ostalih atributov v ucni mnozici.
#
# Ce bi, na primer, zeleli pri gradnji modela za "income" uporabiti samo 
# atribut "workclass", bi to oznacili s formulo "income ~ workclass". Ce bi pa zeleli 
# uporabiti atribute "workclass", "education" in "hours_per_week", bi to oznacili 
# s formulo "income ~ workclass + education + hours_per_week".
#


# Izpisimo nase drevo v tekstovni obliki
dt

# Izrisimo drevo (izris v dveh ukazih)
plot(dt)
text(dt, pretty = 0)

# Neznani primer klasificiramo tako, da zacnemo pri korenu drevesa in potujemo po
# ustreznih vejah do lista. V vsakem notranjem vozliscu testiramo pogoj in, ce je
# le-ta izpolnjen, nadaljujemo v levem sinu, sicer se premaknemo v desnega. 
# Listi drevesa dolocajo razred, v katerega klasificiramo neznani primer.

# Prave vrednosti testnih primerov
observed <- test$income
head(observed)

# Napovedane vrednosti modela
# Uporabimo funkcijo "predict", ki potrebuje model, testne primere in obliko, 
# v kateri naj poda svoje napovedi. Nastavitev "class" pomeni, da nas zanimajo
# samo razredi, v katere je model klasificiral testne primere.
 
predicted <- predict(dt, test, type = "class")
head(predicted)

# Zgradimo tabelo napacnih klasifikacij
tab <- table(observed, predicted)
tab

# Elementi na diagonali predstavljajo pravilno klasificirane testne primere...

# Klasifikacijska tocnost modela
sum(diag(tab)) / sum(tab)


# Lahko napisemo funkcijo za izracun klasifikacijske tocnosti
CA <- function(prave, napovedane)
{
	t <- table(prave, napovedane)

	sum(diag(t)) / sum(t)
}

# Klic funkcije za klasifikacijsko tocnost...
CA(observed, predicted)






# Druga oblika napovedi modela (nastavitev "prob") vraca verjetnosti, 
# da posamezni testni primer pripada dolocenemu razredu.

# Napovedane verjetnosti pripadnosti razredom (odgovor dobimo v obliki matrike)
predMat <- predict(dt, test, type = "prob")
head(predMat)

# Prave verjetnosti pripadnosti razredom 
# (dejanski razred ima verjetnost 1.0 ostali pa 0.0)
obsMat <- model.matrix( ~ income-1, test)
head(obsMat)

# Funkcija za izracun Brierjeve mere
brier.score <- function(observedMatrix, predictedMatrix)
{
	sum((observedMatrix - predictedMatrix) ^ 2) / nrow(predictedMatrix)
}

# Izracunajmo Brierjevo mero za napovedi nasega drevesa
brier.score(obsMat, predMat)



#
# TRIVIALNI MODEL
#
# vedno napove apriorno distribucijo razredov
#


p0 <- table(train$income)/nrow(train)
p0

p0Mat <- matrix(rep(p0, times=nrow(test)), nrow = nrow(test), byrow=T)
colnames(p0Mat) <- names(p0)
head(p0Mat)

brier.score(obsMat, p0Mat)







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

Sensitivity(observed, predicted)
Specificity(observed, predicted)



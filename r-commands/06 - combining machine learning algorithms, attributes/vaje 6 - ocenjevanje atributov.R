# Mere za ocenjevanje atributov so implementirane v paketu "CORElearn"

# Nalozimo knjiznico
#install.packages("CORElearn") 
library(CORElearn)


#
# Ocenjevanje atributov v klasifikacijskih problemih
#



#
# Primer 1
#

mr <- read.table("mushroom.txt", sep=",", header=T)
summary(mr)

barplot(table(mr$edibility), ylab="Number of species", main="Edibility of mushrooms")


# Funkcija "attrEval" oceni kvaliteto atributov glede na ciljno spremenljivko, 
# kot je doloca formula (prvi argument). Najpreprostejsa formula doloca samo 
# ciljno spremenljivko, na primer "edibility ~ .". Znak "." v formuli pomeni, da 
# bo funkcija "attrEval" ocenila vse ostale atribute v podatkovni mnozici.

# Ocenjevanje atributov z informacijskim prispevkom
sort(attrEval(edibility ~ ., mr, "InfGain"), decreasing = TRUE)

# Odlocitveno drevo z uporabo informacijskega prispevka
dt <- CoreModel(edibility ~ ., mr, model="tree", selectionEstimator="InfGain")
plot(dt, mr)


 
#
# Primer 2
#

quadrant <- read.table("quadrant.txt", sep=",", header=T)
summary(quadrant)

quadrant$Class <- as.factor(quadrant$Class)

plot(quadrant, col=quadrant$Class)
plot(quadrant$a1, quadrant$a2, col=quadrant$Class)


# Ocenjevanje atributov z informacijskim prispevkom
sort(attrEval(Class ~ ., quadrant, "InfGain"), decreasing = TRUE)

# informacijski prispevek je kratkovidna ocena
# (predvideva, da so atributi pogojno neodvisni pri podani vrednosti ciljne spremenljivke)

# Odlocitveno drevo na podlagi informacijskega prispevka je zelo slab model 
dt2 <- CoreModel(Class ~ ., quadrant, model="tree", selectionEstimator="InfGain")
plot(dt2, quadrant)


# Vse spodnje ocene so kratkovidne (ne morejo zaznati atributov v interakciji)
sort(attrEval(Class ~ ., quadrant, "InfGain"), decreasing = TRUE)
sort(attrEval(Class ~ ., quadrant, "Gini"), decreasing = TRUE)
sort(attrEval(Class ~ ., quadrant, "MDL"), decreasing = TRUE)

# Ocene, ki niso kratkovidne (Relief in ReleifF)
sort(attrEval(Class ~ ., quadrant, "Relief"), decreasing = TRUE)
sort(attrEval(Class ~ ., quadrant, "ReliefFequalK"), decreasing = TRUE)
sort(attrEval(Class ~ ., quadrant, "ReliefFexpRank"), decreasing = TRUE)

# Z ukazom ?attrEval lahko odprete dokumentacijo in pregledate seznam ostalih inacic 
# ocene ReliefF, ki so implementirane v knjiznici CORElearn

# Odlocitveno drevo na podlagi ocene Relief
dt3 <- CoreModel(Class ~ ., quadrant, model="tree", selectionEstimator = "ReliefFequalK")
plot(dt3, quadrant)

# Opazimo, da je drevo zgrajeno z oceno, ki zazna interakcijo med atributi, pravilno 
# zajelo koncept odvisne spremenljivke


#
# Primer 3
#

players <- read.table("players.txt", sep=",", header=TRUE)
summary(players)

sort(attrEval(position ~ ., players, "InfGain"), decreasing = TRUE)
sort(attrEval(position ~ ., players, "Gini"), decreasing = TRUE)

# Atribut "id" je precenjen, ceprav ne nosi nobene koristne informacije za 
# napovedovanje novih primerov

# GainRatio omili precenjevanje atributa "id"
sort(attrEval(position ~ ., players, "GainRatio"), decreasing = TRUE)

# ReliefF in MDL pravilno ocenita "id" kot nepomemben atribut
sort(attrEval(position ~ ., players, "ReliefFequalK"), decreasing = TRUE)
sort(attrEval(position ~ ., players, "MDL"), decreasing = TRUE)



#
#
# Izbira podmnozice atributov
#
#


student <- read.table("student.txt", sep=",", header=T)
student$G1 <- cut(student$G1, c(-Inf, 9, 20), labels=c("fail", "pass"))
student$G2 <- cut(student$G2, c(-Inf, 9, 20), labels=c("fail", "pass"))
student$G3 <- cut(student$G3, c(-Inf, 9, 20), labels=c("fail", "pass"))
student$studytime <- cut(student$studytime, c(-Inf, 1, 2, 3, 4), labels=c("none", "few", "hefty", "endless"))

#install.packages("ipred")
library(ipred)

# Funkciji za gradnjo modela in predikcijo, ki ju zelimo uporabiti pri precnem preverjanju  
mymodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}
mypredict <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}

# 10-kratno precno preverjanje modela, ki uporablja vse atribute v ucni mnozici
res <- errorest(studytime ~ ., data = student, model = mymodel, predict = mypredict, target.model="tree")
1-res$error


#
# Izbira ustrezne podmnozice atributov s pomocjo filter metode
#


# Ocenimo kvaliteto atributov z uporabo informacijskega prispevka
sort(attrEval(studytime ~ ., student, "ReliefFequalK"), decreasing = TRUE)

# 10-kratno precno preverjanje modela, ki uporablja samo bolje ocenjene atribute
res <- errorest(studytime ~ sex + G1 + famsup + reason + romantic + G2, data = student, model = mymodel, predict = mypredict, target.model="tree")
1-res$error

# S pravo izbiro lahko presezemo tocnost modela, ki se je ucil iz celotnega nabora atributov
res <- errorest(studytime ~ Dalc + paid + G2, data = student, model = mymodel, predict = mypredict, target.model="tree")
1-res$error


#
# Izbira ustrezne podmnozice atributov s pomocjo metode Wrapper
#

# Metoda pozresno preisce prostor podmnozic atributov in vrne lokalno optimalen model
source("wrapper.R")
wrapper(student, className="studytime", classModel="tree", folds=10)








#
# ocena kvalitete atributov pri regresijskih problemih
#
 
ucna <- read.table("AlgaeLearn.txt", header = T)
testna <- read.table("AlgaeTest.txt", header = T)

summary(ucna)


sort(attrEval(a1 ~ ., ucna, "MSEofMean"), decreasing = TRUE)
sort(attrEval(a1 ~ ., ucna, "RReliefFexpRank"), decreasing = TRUE)


# model lahko dodatno izboljsamo z izbiro ustrezne podmnozice atributov

rt.core <- CoreModel(a1 ~ ., data=ucna, model="regTree", selectionEstimatorReg="MSEofMean")
plot(rt.core, ucna)
predicted <- predict(rt.core, testna)
observed <- testna$a1

rmae <- function(observed, predicted, mean.val) 
{  
	sum(abs(observed - predicted)) / sum(abs(observed - mean.val))
}

rmae(observed, predicted, mean(ucna$a1))


rt.core2 <- CoreModel(a1 ~ Cl + PO4 + oPO4 + NH4 + Chla + NO3, data=ucna, model="regTree", selectionEstimatorReg="MSEofMean")
plot(rt.core2, ucna)
predicted <- predict(rt.core2, testna)
rmae(observed, predicted, mean(ucna$a1))


# pri izbiri podmnozice atributov si lahko pomagamo z wrapper metodo
source("wrapperReg.R")
wrapperReg(ucna, "a1", folds=10, selectionEstimatorReg="MSEofMean")

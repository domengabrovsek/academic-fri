# Prenesite datoteko "insurance.txt" v lokalno mapo. 
# To mapo nastavite kot delovno mapo okolja R. To lahko naredite s pomocjo 
# ukaza "setwd" oziroma iz menuja s klikom na File -> Change dir...

# Uporabljali bomo funkcije iz naslednjih knjiznic: ipred, prodlim, rpart ter CORElearn. 
# Poskrbite, da so vse knjiznice instalirane.
#
# Knjiznice instaliramo z ukazom install.packages():
#
#     install.packages(c("ipred", "prodlim", "CORElearn"))
#     library(pROC)
#
# Ce nimamo pravic za instalacijo v privzeto map, lahko podamo pot do 
# do neke druge mape, do katere imamo dostop:
#
#     install.packages(c("ipred", "prodlim", "CORElearn"), lib="pot do folderja")
#     library(ipred, lib.loc="pot do folderja")
#


ins <- read.table("insurance.txt", header = T, sep = ",")


CA <- function(observed, predicted)
{
	t <- table(observed, predicted)

	sum(diag(t)) / sum(t)
}

library(rpart)


#
#
# PRECNO PREVERJANJE
#
#


# metodo lahko implementiramo sami...

n <- nrow(ins)
k <- 10
bucket.id <- rep(1:k, length.out=n)
s <- sample(1:n, n, FALSE)
bucket.id <- bucket.id[s]

cv.dt <- vector()
for (i in 1:k)
{	
	print(paste("Processing fold", i))
	flush.console()

	sel <- bucket.id == i

	model.rpart <- rpart(insurance ~ ., ins[!sel,])
	predicted <- predict(model.rpart, ins[sel,], type= "class")
	observed <- ins[sel,]$insurance
	cv.dt[i] <- CA(observed, predicted)
}

cv.dt
mean(cv.dt)






# ... ali pa uporabimo funkcijo "errorest" iz knjiznice "ipred"

library(ipred)

?errorest

# funkcija "errorest" potrebuje poleg formule modela in ucnih primerov se dva vhodna parametra: 
# funkcijo za gradnjo modela ter funkcijo za generiranje napovedi tega modela.
 
# Funkcijo za generiranje napovedi napisemo tako, da klicemo obicajno funkcijo "predict" 
# s parametrom type="class", ter na ta nacin zahtevamo napovedi v obliki vektorja oznak razredov. 
mypredict <- function(object, newdata){predict(object, newdata, type = "class")}


#
# odlocitveno drevo (rpart)
#

library(rpart)

# 10-kratno precno preverjanje odlocitvenega drevsa (uporabimo celotno podatkovno mnozico!).
# Kot funkcijo za gradnjo modela uporabimo kar funkcijo "rpart", saj ne potrebujemo dodatnih parametrov. 
res <- errorest(insurance~., data=ins, model = rpart, predict = mypredict)
res

# klasifikacijska tocnost
1-res$error



# metoda "izloci enega"
res <- errorest(insurance~., data=ins, model = rpart, predict = mypredict, est.para=control.errorest(k = nrow(ins)))
res

# klasifikacijska tocnost
1-res$error



#
# odlocitveno drevo (CORElearn)
#

library(CORElearn)

# Model bomo zgradili s pomocjo funkcije "CoreModel", ki potrebuje informacijo o tem, kateri tip modela naj zgradi.
# Funkcijo za gradnjo modela napisemo tako, da klicu funkcije "CoreModel" dodamo parameter za izbiro tipa modela.
mymodel.coremodel <- function(formula, data, target.model){CoreModel(formula, data, model=target.model)}

# Funkcijo za generiranje napovedi napisemo tako, da iz dobljenih napovedi modela obdrzimo samo oznake razredov.
# Ko model vrne zahtevane napovedi, ga ne potrebujemo vec - zato ga odstranimo iz pomnilnika.
mypredict.coremodel <- function(object, newdata) {pred <- predict(object, newdata)$class; destroyModels(object); pred}

# 10-kratno precno preverjanje 
res <- errorest(insurance~., data=ins, model = mymodel.coremodel, predict = mypredict.coremodel, target.model = "tree")
1-res$error

# metoda "izloci enega"
res <- errorest(insurance~., data=ins, model = mymodel.coremodel, predict = mypredict.coremodel, target.model = "tree", est.para=control.errorest(k = nrow(ins)))
1-res$error

#
# RESITVE
#

#######################################################################################
#
# Resitev izpitne naloge:	
#
#
# a) klasifikacijska tocnost:
#
#     (300+120)/(300+0+80+120)
#     = 0.84
#
#
# b) pricakovana tocnost vecinskega klasifikatorja: 
#
#    vecinski razred je "0"     
#
#    matrika zmot vecinskega klasifikatorja:
#
#        0   1
#    --+---+---+								 
#    0 |300| 0 |
#    --+---+---+
#    1 |200| 0 |
#    --+---+---+
#
#    300/500 = 0.6
#
# c) senzitivnost ("0" je pozitivni razred)
#
#    TP/POS = 300 / 300 = 1
#
# d) specificnost ("0" je pozitivni razred)
#
#    TN/NEG = 120 / 200 = 0.6
#
#######################################################################################

#######################################################################################
#
# Resitev izpitne naloge:	
#
# a) klasifikacijska tocnost klasifikatorja:
#
#    prvi primer: nepravilna klasifikacija,              
#    drugi primer: pravilna klasifikacija,		
#    tretji primer: pravilna klasifikacija,               
#    cetrti primer: pravilna klasifikacija                            
#    peti primer: pravilna klasifikacija
                                     
#    matrika zmot:
#         C1 C2 C3 C4
#    C1    1  0  0  0
#    C2    0  2  0  0
#    C3    0  0  1  0
#    C4    1  0  0  0
#					
#    klasifikacijska tocnost = 4 / 5 = 0.8
#
#
# b) pricakovana tocnost vecinskega klasifikatorja:
#
#    vecinski razred je C2               
#
#    matrika zmot:
#         C1 C2 C3 C4
#    C1    0  1  0  0
#    C2    0  2  0  0
#    C3    0  1  0  0
#    C4    0  1  0  0 					  
#
#    klasifikacijska tocnost = 2 / 5 = 0.4
#
#
# c) povprecna Brierjeva mera:	
#	
#	 (
#     (0.00-0.65)^2 + (0.00-0.25)^2 + (0.00-0.00)^2 + (1.00-0.10)^2 + 
#     (0.00-0.20)^2 + (1.00-0.55)^2 + (0.00-0.25)^2 + (0.00-0.00)^2 + 
#     (1.00-0.75)^2 + (0.00-0.00)^2 + (0.00-0.25)^2 + (0.00-0.00)^2 + 
#     (0.00-0.25)^2 + (1.00-0.50)^2 + (0.00-0.00)^2 + (0.00-0.25)^2 +
#     (0.00-0.10)^2 + (0.00-0.10)^2 + (1.00-0.60)^2 + (0.00-0.20)^2 
#    )/5
#    = 0.464
#
########################################################################################
					   
					   
library(rpart)

CA <- function(observed, predicted)
{
	t <- table(observed, predicted)

	sum(diag(t)) / sum(t)
}

Sensitivity <- function(observed, predicted)
{
	t <- table(observed, predicted)

	t[1, 1] / sum(t[1,])
}

Specificity <- function(observed, predicted)
{
	t <- table(observed, predicted)

	t[2, 2] / sum(t[2,])
}

brier.score <- function(observedMatrix, predictedMatrix)
{
	sum((observedMatrix - predictedMatrix) ^ 2) / nrow(predictedMatrix)
}



mdata <- read.table("movies.txt", header = T, sep = ",")
for (i in 18:24)
	mdata[,i] <- as.factor(mdata[,i])

mdata$title <- NULL
mdata$budget <- NULL

learn <- mdata[mdata$year < 2004,]
test <- mdata[mdata$year >= 2004,]

learn$year <- NULL
test$year <- NULL
	
dt <- rpart(Comedy~., learn)
plot(dt)
text(dt, pretty = 0)

observed <- test$Comedy
predicted <- predict(dt, test, type="class")

CA(observed, predicted)
Sensitivity(observed, predicted)
Specificity(observed, predicted)


predMat <- predict(dt, test, type = "prob")
obsMat <- model.matrix(~Comedy-1, test)

colnames(predMat)
colnames(obsMat)

brier.score(obsMat, predMat)






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

	## Dodajanje atributa mesec
	my_data$mesec <-as.integer(format(as.Date(my_data$Datum, format="%Y-%m-%d"),"%m"))

	## dodajanje atributa letni cas na podlagi atributa mesec
	my_data <- mutate(my_data, letni_cas = ifelse(mesec %in% 1:2, "zima",
								ifelse(mesec %in% 3:5, "pomlad",
								ifelse(mesec %in% 6:8, "poletje",
								ifelse(mesec %in% 9:11, "jesen", 
								"zima")))))
}
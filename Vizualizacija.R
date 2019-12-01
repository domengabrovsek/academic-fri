# skripta za analizo in vizualizacijo podatkov

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz. setwd("C:/git/fri-ai-assignment")

# nalozimo svoje custom funkcije
source("funkcijeViz.r")

# nalozimo vse knjiznice, ki jih bomo potrebovali
InitLibsViz()

# nalozimo dataset
orgData <- read.table("podatkiSem1.csv", header = T, sep = ",")

# kopija originalnih podatkov
data <- orgData

# dodajanje, odstranjevanje in predelava atributov
data <- ModifyAttributes (data)

# export novega dataseta z dodatnimi atributi
# export(data, "data.csv")

# analiza atributov
summary(data)
sum(is.na(data)) # analiza missing values
export(psych::describe(data), "SummaryAll.csv") # summary statistika exported
psych::describeBy(data, data$Postaja) #summary statistika za Postajo
Correlation(data) # analiza korelacije



# vizualizacija atributov polnega dataseta
tempdir() # mapa, v katero bodo shranjeni vsi grafi 

# analiza stevila podatkov 
CountMesPos (data)  # stevilo podatkov za vsak mesec in postajo
CountPos (data)     # Stevilo podatkov za vsako postajo
CountMes (data)     # stevilo podatkov za vsak mesec 

## Boxplots 
BoxPlotV (data)  # boxlot za en atribut
BoxPlotM (data)  # boxplot za mesec
BoxPlotMP (data) # boxplot za vse integer atributi mesec vs postaja

# Histogram
HistogramV (data)     # histogram za en atribut
#HistogramPost (data) # histogram za atribut in postajo
HistogramO3 (data)    # histogram za skupine O3
HistogramPM10 (data)  # histogram za skupine P10

# Scatterplot
ScatterplotP(data)          # scatterplot za postaje  
ScatterplotO3Class(data)    # Scatterplot za skupine O3
ScatterplotPM10Class(data)  # Scatterplot za skupine PM10

# Analiza of number of data per preduction group
BarChartPM10P (data) 
BarChartPM10M (data) 
BarChartO3P (data)
BarChartO3M (data)
BarChartO3L (data)

# Vizualizacija klassov
BoxPlotO3Class (data)
BoxPlotPM10Class (data)

# tempdir() #retrieving all png files from temp directory






warnings()
# priprava koncnega dataseta
FinalData <- FinalData (data)
# vizualizacija atributov finalnega dataseta

# skripta za analizo in vizualizacijo podatkov

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz. setwd("C:/git/fri-ai-assignment")

# nalozimo svoje custom funkcije
source("funkcijeViz.r")

# nalozimo vse knjiznice, ki jih bomo potrebovali
InitLibsViz()

# nalozimo dataset
orgData <- read.table("podatkiSem1.txt", header = T, sep = ",")

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
CountMesPos (data)     # stevilo podatkov za vsak mesec in postajo
CountPos (data)        # Stevilo podatkov za vsako postajo
CountMes (data)        # stevilo podatkov za vsak mesec 
# BarChartPM10 (data)  # stevilo podatkov za PM klass
# BarChartPM10P (data) # stevilo podatkov za PM klass in postajo 
# BarChartPM10M (data) # stevilo podatkov za PM klass in mesec
# BarChartO3 (data)    # stevilo podatkov za O3 klass 
# BarChartO3P (data)   # stevilo podatkov za O3 klass in postajo 
# BarChartO3M (data)   # stevilo podatkov za O3 klass in mesec

## Boxplots 
BoxPlotV(data)  # boxlot za en atribut
BoxPlotM(data)  # boxplot za mesec
BoxPlotMP(data) # boxplot za vse integer atributi mesec vs postaja
BoxPlotLC(data) # boxplot za vse integer atributi mesec vs letni cas
BoxPlotL(data)  # boxplot za vse integer atributi mesec vs leto

# Histogram
HistogramV(data)     # histogram za en atribut
#HistogramPost(data) # histogram za atribut in postajo
HistogramO3(data)    # histogram za skupine O3
HistogramPM10(data)  # histogram za skupine P10

# Scatterplot
ScatterplotP(data)            # scatterplot za vse pari atributov in postaje  
ScatterplotO3Class(data)      # scatterplot za atribut O3 in skupine O3
ScatterplotO3ClassAll(data)   # scatterplot za vse atribute in skupine O3    
ScatterplotPM10Class(data)    # scatterplot za skupine PM10
ScatterplotPM10ClassAll(data) # scatterplot za vse atribute in skupine PM10

# Vizualizacija klassov
BoxPlotO3Class(data)
BoxPlotPM10Class(data)

# priprava koncnega dataseta
FinalDataIQR <- FinalDataIQR (data)
export(FinalDataIQR, "FinalDataIQR.csv")

# vizualizacija atributov finalnega dataseta
BoxPlotPM10ClassIn(FinalDataIQR)
BoxPlotO3ClassIn(FinalDataIQR)
BoxPlotMPIn(FinalDataIQR)

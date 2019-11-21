# glavna skripta za seminarsko

# predvidevamo da imamo nastavljen "working directory" in da so vse potrebne datoteke v isti mapi
# oz uporabimo setwd(pot)

# nalozimo svoje custom funkcije
source("funkcije.r")

# nalozimo dataset
data <- read.table("podatkiSem1.txt", header = T, sep = ",")
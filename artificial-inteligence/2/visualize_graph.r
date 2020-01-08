library(grid)

plotLabyrinth <- function(lab)
{
    sel <- lab[,] == -1
    lab[sel] <- rgb(0, 0, 0)		
    
    sel <- lab[,] == 0
    lab[sel] <- rgb(1, 1, 1)
    
    sel <- lab[,] == -2
    lab[sel] <- rgb(1, 0, 0)
    
    sel <- lab[,] == -3
    lab[sel] <- rgb(1, 1, 0)
    
    sel <- lab[,] == 1
    lab[sel] <- rgb(0.3, 0.3, 0.3)
    
    sel <- lab[,] == 2
    lab[sel] <- rgb(0.4, 0.4, 0.4)
    
    sel <- lab[,] == 3
    lab[sel] <- rgb(0.6, 0.6, 0.6)
    
    sel <- lab[,] == 4
    lab[sel] <- rgb(0.8, 0.8, 0.8)
    
    grid.newpage()
    grid.raster(lab, interpolate=F)
}

# set working directory
setwd('c:/git/academic-fri/artificial-inteligence/2/labyrinths/labyrinth_0.txt')

data <- read.table("labyrinth_1.txt", sep=",", header=F)
data <- as.matrix(data)
data
screen <- plotLabyrinth(data)
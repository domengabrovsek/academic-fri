import math
kateta1 = float(input('Vnesi dolzino prve katete: '))
kateta2 = float(input('Vnesi dolzino druge katete: '))
hipotenuza = float(math.sqrt((kateta1 ** 2) + (kateta2 ** 2)))
print('Dolzina hipotenuze je: ' ,hipotenuza, 'm')
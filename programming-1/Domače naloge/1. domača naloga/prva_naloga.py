import math

hitrost = float(input('Vnesi hitrost v m/s: '))
kot = float(input('Vnesi kot v stopinjah: '))
kot = math.radians(kot)
g = 9.81
razdalja = round(((hitrost**2) * ((math.sin(kot*2)))) / g, 2)
print('Razdalja je' ,razdalja, 'm.')


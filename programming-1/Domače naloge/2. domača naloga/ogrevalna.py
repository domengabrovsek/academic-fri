import random
import time

stevilo1 = random.randint(1,10)
stevilo2 = random.randint(1,10)
produkt = float(stevilo1 * stevilo2)
print('Koliko je' ,stevilo1, ' krat ', stevilo2, '?')
vnos = float(input())
if vnos == produkt:
	print('Odgovor je pravilen')
else:
	print('Odgovor je napacen.')

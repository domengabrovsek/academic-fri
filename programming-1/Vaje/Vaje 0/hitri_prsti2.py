import random
import time

stevilo1 = random.randint(1,10)
stevilo2 = random.randint(1,10)
produkt = float(stevilo1 * stevilo2)
cas1 = float(time.time())
print('Koliko je' ,stevilo1, ' krat ', stevilo2, '?')
vnos = float(input())
if vnos == produkt:
	print('Odgovor je pravilen')
else:
	print('Odgovor je napacen.')

cas2 = float(time.time())
cas3 = float(cas2 - cas1)
print('Za razmisljanje ste porabili', cas3, 'sekund')
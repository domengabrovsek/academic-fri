import random
import time
napaka = 0
tocke = 0
cas1 = float(time.time())
razlika = float(0)
while razlika < 10 and napaka == 0:
	stevilo1 = random.randint(2,10)
	stevilo2 = random.randint(2,10)
	produkt = float(stevilo1 * stevilo2)
	print('Koliko je' ,stevilo1, ' krat ', stevilo2, '?')
	vnos = float(input())
	if razlika < 10:
		if vnos == produkt:
			print('Odgovor je pravilen')
			tocke+=1
		else:
			print('Odgovor je napacen.')
			napaka = 1
		cas2 = float(time.time())
		razlika = cas2 - cas1
print('Stevilo dosezenih tock' ,tocke)
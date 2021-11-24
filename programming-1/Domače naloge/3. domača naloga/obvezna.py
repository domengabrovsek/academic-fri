zenske = [158, 166, 150, 158, 152, 160, 172, 159, 158, 162]
moski = [168, 172, 181, 166, 172, 174, 165, 169, 169, 185]
razlika = 0
najvecja = 0
for zenska, moski in zip(zenske,moski):
	razlika = abs(zenska - moski)
	if razlika > najvecja:
		najvecja = razlika
print('Najvecja razlika:',najvecja)
input()
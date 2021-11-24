'''
	OGREVALNA NALOGA
	
zenske = [158, 166, 150, 158, 152, 160, 172, 159, 158, 162]
moski = [168, 172, 181, 166, 172, 174, 165, 169, 169, 185]
razlika = 0
for zenska, moski in zip(zenske,moski):
	razlika = abs(zenska - moski)
	print(zenska, moski,razlika)

'''
'''
   OBVEZNA NALOGA  
zenske = [158, 166, 150, 158, 152, 160, 172, 159, 158, 162]
moski = [168, 172, 181, 166, 172, 174, 165, 169, 169, 185]
razlika = 0
najvecja = 0
for zenska, moski in zip(zenske,moski):
	razlika = abs(zenska - moski)
	if razlika > najvecja:
		najvecja = razlika
print('Najvecja razlika:',najvecja)

'''

# DODATNA NALOGA

zenske = [158, 166, 150, 158, 152, 160, 172, 159, 158, 162]
moski = [168, 172, 181, 166, 172, 174, 165, 169, 169, 185]
razlika = 0
premiki = 0
najmanjsa_najvecja = 100
i = 0
while i < len(moski):
	najvecja = 0
	for el_zenska, el_moski in zip(zenske,moski):
		razlika = abs(el_zenska - el_moski)
		if razlika > najvecja:
			najvecja = razlika
			
	if najmanjsa_najvecja > najvecja:
		najmanjsa_najvecja = najvecja
		premiki = i
	moski.append(moski.pop(0))
	
	i += 1
print('Najmanjso najvecjo absolutno razliko visin' ,najmanjsa_najvecja, ', dobimo po' ,premiki, 'premikih.')

'''
 ZELO DODATNA NALOGA

zenske = [158, 166, 150, 158, 152, 160, 172, 159, 158, 162]
moski = [168, 172, 181, 166, 172, 174, 165, 169, 169, 185]

zenske.sort()
moski.sort()
razlika = 0
najvecja = 0
for zenska, moski in zip(zenske,moski):
	razlika = abs(zenska - moski)
	if razlika > najvecja:
		najvecja = razlika
print('Najvecja razlika:',najvecja)

'''
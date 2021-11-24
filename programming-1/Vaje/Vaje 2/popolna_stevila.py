stevilo = int(input('Vnesi stevilo: '))
vsota = 0
for i in range(1,stevilo):
		if stevilo % i == 0:
			vsota += i	
if vsota == stevilo:
	print('Stevilo je popolno.')
else:
	print('Stevilo ni popolno.')
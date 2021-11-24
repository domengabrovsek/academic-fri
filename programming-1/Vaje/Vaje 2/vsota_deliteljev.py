stevilo = int(input('Vnesi stevilo: '))
vsota = 0
for i in range(1,stevilo+1):
		if stevilo % i == 0:
			vsota += i	
			print(i)
print('Vsota vseh deliteljev je:',vsota)

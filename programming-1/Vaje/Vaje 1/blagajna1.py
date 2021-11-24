st = int(input('Stevilo izdelkov?'))
i = 0
vsota = 0
while i < st:
	cena = float(input('Cena artikla: '))
	vsota = vsota + cena
	i+=1
print('Vsota' ,vsota, '.')
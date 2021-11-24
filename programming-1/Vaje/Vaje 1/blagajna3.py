cena = 1
vsota = 0
i = 0
while cena != 0:
	cena = float(input('Cena artikla: '))
	if cena != 0:
		vsota = vsota + cena
		i = i + 1
povp = float(vsota/i)
print('Vsota' ,vsota, '.')
print('Povprecna cena' ,povp, '.')
vnos = 1
vsota = 0
i = 0
while vnos != 0 and vsota < 100 and i < 10:
	if vnos != 0:
		vnos = int(input('Cena: '))
		vsota = vsota + vnos
		i = i + 1
print('Porabili boste:' ,vsota, 'evrov za' ,i-1, 'stvari.')
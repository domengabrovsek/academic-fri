vnos = int(input('Vnesi stevilo: '))
def izpis (stevilo):
	vsota = 0
	for i in range(1,stevilo):
		if stevilo % i == 0:
			vsota += i	
	return vsota
	
vsota_1 = izpis(vnos)

if izpis(vsota_1) == vnos:
	print('Prijatelj stevila:' ,vnos,'je' ,vsota_1,'.')
else:
	print ('Stevilo',vnos, 'nima prijateljev.')


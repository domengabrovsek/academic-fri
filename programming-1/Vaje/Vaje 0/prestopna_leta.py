leto = int(input('Vnesi leto: '))

if (leto % 4 == 0 and leto % 100 != 0) or (leto % 400 == 0):
	print('Leto je prestopno')
else:
	print('Leto ni prestopno')
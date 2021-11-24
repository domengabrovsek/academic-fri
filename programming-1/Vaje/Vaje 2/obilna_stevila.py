stevilo = int(input('Vnesi stevilo: '))
vsota = 0
max = 0
while stevilo > 0:
	for i in range(1,stevilo):
		if stevilo % i == 0:
			vsota += i	
	print(vsota)
	stevilo -= 1			
				
				
print('Najvecje obilno stevilo do' ,stevilo, ' je ' ,max, '.')

input()

#vsota deliteljev > stevilo
#prvo obilno stevilo do 1000
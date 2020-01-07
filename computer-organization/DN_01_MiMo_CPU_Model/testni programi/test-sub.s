# program za testiranja ukaze sub
# odštejemo dve števili in razliko zapišemo v pomnilnik
# razliko manjših števil vpišemo na lokacijo 0x40
# razliko večjih števil vpišemo na lokacijo 0x41

        # 0000 0000 0000 0001 (1)
main:	li r0, 0x0001 

        # 0000 0000 0000 0011 (2)
        li r1, 0x0002 

        # 0011 1010 0111 1011 (14971)
        li r2, 0x3A7B 

        # 1001 0011 1101 1111 (37855)
		li r3, 0x93DF 
        
        # odštevanje manjših števil
        # 0x0002 - 0x0001 = 0x0001 (1)
        sub r4, r1, r0 
		sw r4, 0x40

		# odštevanje večjih števil
		# 0x93DF - 0x3A7B = 0x5964 (22884)
		sub r4, r3, r2
		sw r4, 0x41
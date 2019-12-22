# program za testiranja ukaze rem
# delimo dve števili in ostanek zapišemo v pomnilnik
# rezultat manjših števil vpišemo na lokacijo 0x40
# rezultat večjih števil vpišemo na lokacijo 0x41

        # 0000 0000 0000 0010 (2)
main:	li r0, 0x0002 

        # 0000 0000 0000 0011 (3)
        li r1, 0x0003 

        # 0000 0000 1101 0100 (212)
        li r2, 0x00D4

        # 0000 0001 0010 1110 (64326)
		li r3, 0xFB46 
        
        # deljenje manjših števil
        # 0x0003 % 0x0002 = 0x0001 (1)
        rem r4, r1, r0 
		sw r4, 0x40

		# deljenje večjih števil
		# 0xFB46 % 0x00D4 = 0x005A (90)
		rem r4, r3, r2
		sw r4, 0x41
# program za testiranja ukaze mul
# zmnožimo dve števili in zmnožek zapišemo v pomnilnik
# zmnožek manjših števil vpišemo na lokacijo 0x40
# zmnožek večjih števil vpišemo na lokacijo 0x41

        # 0000 0000 0000 0001 (1)
main:	li r0, 0x0001 

        # 0000 0000 0000 0011 (2)
        li r1, 0x0002 

        # 0000 0000 1101 0101 (213)
        li r2, 0x00D5 

        # 0000 0001 0010 1110 (302)
		li r3, 0x012E 
        
        # množenje manjših števil
        # 0x0002 * 0x0001 = 0x0002 (2)
        mul r4, r1, r0 
		sw r4, 0x40

		# množenje večjih števil
		# 0x012E * 0x00D5 = 0xFB46 (64326)
		mul r4, r3, r2
		sw r4, 0x41
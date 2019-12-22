# program za testiranja ukaze add
# seštejemo dve števili in vsoto zapišemo v pomnilnik
# vsoto manjših števil vpišemo na lokacijo 0x40
# vsoto večjih števil vpišemo na lokacijo 0x41

        # 0000 0000 0000 0001 (1)
main:	li r0, 0x0001 

        # 0000 0000 0000 0011 (2)
        li r1, 0x0002 

        # 0011 1010 0111 1011 (14971)
        li r2, 0x3A7B 

        # 1001 0011 1101 1111 (37855)
		li r3, 0x93DF 
        
        # seštevanje manjših števil
        # 0x0002 + 0x0001 = 0x0003 (3)
        add r4, r1, r0 
		sw r4, 0x40

		# seštevanje večjih števil
		# 0x93DF + 0x3A7B = 0xCE5A (52826)
		add r4, r3, r2
		sw r4, 0x41
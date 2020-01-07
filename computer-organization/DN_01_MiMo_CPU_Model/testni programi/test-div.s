# program za testiranja ukaze div
# delimo dve števili in rezultat zapišemo v pomnilnik
# rezultat manjših števil vpišemo na lokacijo 0x40
# rezultat večjih števil vpišemo na lokacijo 0x41

        # 0000 0000 0000 0001 (1)
main:	li r0, 0x0001 

        # 0000 0000 0000 0011 (2)
        li r1, 0x0002 

        # 0000 0000 1101 0101 (213)
        li r2, 0x00D5 

        # 0000 0001 0010 1110 (64326)
		li r3, 0xFB46 
        
        # množenje manjših števil
        # 0x0002 / 0x0001 = 0x0002 (2)
        div r4, r1, r0 
		sw r4, 0x40

		# množenje večjih števil
		# 0xFB46 / 0x00D5 = 0x012E (302)
		div r4, r3, r2
		sw r4, 0x41
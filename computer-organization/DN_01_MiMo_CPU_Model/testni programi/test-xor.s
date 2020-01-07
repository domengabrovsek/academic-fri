# program za testiranja ukaza xor

    # 0011 1010 0111 1011
    li r0, 0x3A7B 

    # 1001 0011 1101 1111 
		li r1, 0x93DF 

    # 0011 1010 0111 1011
    # 1001 0011 1101 1111

    # 1010 1001 1010 0100 (0xa9a4)
		xor r2, r0, r1
		sw r4, 0x40
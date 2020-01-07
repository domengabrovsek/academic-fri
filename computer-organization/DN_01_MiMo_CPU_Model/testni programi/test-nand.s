# program za testiranja ukaza nand

    # 0011 1010 0111 1011
    li r0, 0x3A7B 

    # 1001 0011 1101 1111 
		li r1, 0x93DF 

    # 0011 1010 0111 1011
    # 1001 0011 1101 1111

    # 1110 1101 1010 0100 (0xEDA4)
		nand r2, r0, r1
		sw r4, 0x40
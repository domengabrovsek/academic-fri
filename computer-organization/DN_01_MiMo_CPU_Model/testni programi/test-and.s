# program za testiranja ukaza and

    # 0011 1010 0111 1011
    li r0, 0x3A7B 

    # 1001 0011 1101 1111 
		li r1, 0x93DF 

    # 0011 1010 0111 1011
    # 1001 0011 1101 1111

    # 0001 0010 0101 1011 (0x125B)
		and r2, r0, r1
		sw r4, 0x40
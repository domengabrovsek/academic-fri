# program za testiranja ukaza lsl

# 0011 1010 0111 1011
li r0, 0x3A7B 

# shiftamo za 3 bite v levo
li r1, 0x0003

# 1101 0011 1101 1000 (0xD3D8)
lsl r2, r0, r1
sw r4, 0x40
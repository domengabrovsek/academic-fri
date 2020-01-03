# program za testiranja ukaza ror

# 0011 1010 0111 1011
li r0, 0x3A7B 

# rotiramo za 3 bite v desno
li r1, 0x0003

# 0110 0111 0100 1111 (0x674F)
ror r2, r0, r1
sw r4, 0x40
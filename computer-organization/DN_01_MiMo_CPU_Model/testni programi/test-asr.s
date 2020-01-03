# program za testiranja ukaza asr

# 0011 1010 0111 1011
li r0, 0x3A7B 

# shiftamo za 3 bite v desno
li r1, 0x0003

# 0000 0111 0100 1111 (0x074F)
asr r2, r0, r1
sw r4, 0x40
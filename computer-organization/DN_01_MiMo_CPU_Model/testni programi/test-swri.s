# program za testiranja ukaza swri

main: li r0, 10 # ustavitveni pogoj zanke
      li r1, 0x40 # naslov kjer zacnemo pisati
      li r2, 1 # stevec za zanko
      li r4, 0 # odmik za swri

      swri r4, r1, r4

loop: swri r4, r1, r4
      sub r0, r0, r2
      add r4, r4, r2
      jnez r0, loop

# rezultat v RAM-u po šestih iteracijah
# 0000 7e00 0000 7e01 0040 7e02 0001 7e03 0000 950c 0280 00a4 5000 0008 0000 0000 0000
# 0010 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
# 0020 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
# 0030 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
# 0040 0000 0001 0002 0003 0004 0005 0006 0000 0000 0000 0000 0000 0000 0000 0000 0000

# zanima na samo vrstica kamor smo vpisovali vrednosti
# 0040 0000 0001 0002 0003 0004 0005 0006 0000 0000 0000 0000 0000 0000 0000 0000 0000
          .text
tabela:   .hword 1,2,3,4,5,-1,-2,-3,-4,-5, 0
          .align
          .global __start
__start:  
         adr r0, tabela @ preberem, tabelo
         mov r1, #11 @ stevilo elementov (stevec zanke)
         bl podprogram
__end:    b __end         

podprogram:     
         mov r2, #0     @ stevec negativnih stevil
         mov r3, #0     @ vsota negativnih stevil
         
zanka:
         ldrsh r4, [r0]    @ preberem element iz tabele
         cmp r4, #0        @ primerjam stevilo in 0, ce je stevilo manjse je negativno
         addlt r2, r2, #1  @ povecam stevec negativnih stevil
         addlt r3, r3, r4  @ povecam vsoto negativnih stevil
         add r0, r0, #2    @ premaknem kazalec na naslednji element v tabeli
         subs r1, r1, #1   @ zmanjsam stevec od zanke, ko bo 0 koncamo
         bne zanka
         
         mov r0, r3 @ premaknem vsoto negativnih stevil v r0
         mov r1, r2 @ premaknem stevec negativnih stevil v r1
         
         mov pc, lr @ shranim lr nazaj v pc (vrnitev iz podprograma) 





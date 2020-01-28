# naloga

# 1. Zaporedni vmesnik enote 'debug unit' na mikrokrmilniku AT91SAM9260 s kablom povežite z zaporednim vmesnikom na računalniku PC. V zbirnem jeziku za ARM9 napišite naslednje podprograme:
#
# a) DEBUG_INIT, ki zaporedni vmesnik enote 'debug unit' nastavi na hitrost 115200 baudov in prenos brez bita parnosti. Podprogram naj tudi omogoči oddajnik in sprejemnik vmesnika (TX, RX). Upoštevajte, da znaša frekvenca ure MCK 48MHz, zato hitrosti natančno na 115200 baudov ni mogoče nastaviti, odstopanje pa je dovolj majhno, da ne moti pravilnega prenosa podatkov.
#
# b) RCV_DEBUG, ki v neskončni zanki čaka, da sprejemnik sprejme znak, ki ga preko terminala pošljete z računalnika PC. Sprejet znak naj podprogram vrne v registru R0. Uporabite kar terminal, ki je vgrajen v okolje WinIDEA. (Nastavite: hitrost prenosa 115200 baudov, 8 podatkovnih bitov, 1 stop bit, brez parnosti).
#
# c) SND_DEBUG, ki v neskončni zanki čaka, da je oddajnik pripravljen na oddajo, nato pošlje znak v smeri ploščica -> računalnik PC. Znak, ki ga pošlje, dobi podprogram v registru R0.
#
# Vsi podprogramu naj ohranijo vrednosti registrov razen registra R0 pri podprogramih RCV_DEBUG in SND_DEBUG. Napišite tudi kratek glavni program, da preizkusite delovanje podprogramov. Po inicializaciji enote 'debug' v zanki izmenično kličete podprograma RCV_DEBUG in SND_DEBUG ter tako računalniku PC vračate znake, ki jih od njega sprejmete (echo).
#
#
# 2. Napišite podprogram, za sprejemanje niza znakov z preko enote DBGU. Podprogram ima dva parametra: v r0 naj bo naslov, kamor se bo niz shranil, v r1 pa število znakov, ki jih želimo sprejeti. Podprogram naj sprejeti niz zaključi z ničlo - rezultat naj bo z ničlo zaključen niz.
#
#
# 3. Napišite podprogram, za pošiljanje niza znakov z preko enote DBGU. Podprogram v r0 dobi naslov z ničlo zaključenega niza, ki ga želimo poslati.

# program

.global _main
/* main program */
_main:

/* user code here */
      bl DEBUG_INIT

      adr r0,Testni
      bl SNDS_DEBUG

      adr r0,Received
      mov r1,#10
      bl RCVS_DEBUG

LOOP: bl RCV_DEBUG
      bl SND_DEBUG
      b LOOP

/* end user code */

_wait_for_ever:
  b _wait_for_ever

DEBUG_INIT:
      stmfd r13!, {r0, r1, r14}
      ldr r0, =DBGU_BASE
@      mov r1, #26        @  BR=115200
      mov r1, #156        @  BR=19200
      str r1, [r0, #DBGU_BRGR]
      mov r1, #(1 << 11)
      str r1, [r0, #DBGU_MR]
      mov r1, #0b1010000
      str r1, [r0, #DBGU_CR]
      ldmfd r13!, {r0, r1, pc}

RCV_DEBUG:
      stmfd r13!, {r1, r14}
      ldr r1, =DBGU_BASE
RCVD_LP:
      ldr r0, [r1, #DBGU_SR]
      tst r0, #1
      beq RCVD_LP
      ldr r0, [r1, #DBGU_RHR]
      ldmfd r13!, {r1, pc}

SND_DEBUG:
      stmfd r13!, {r1, r2, r14}
      ldr r1, =DBGU_BASE
SNDD_LP:
      ldr r2, [r1, #DBGU_SR]
      tst r2, #(1 << 1)
      beq SNDD_LP
      str r0, [r1, #DBGU_THR]
      ldmfd r13!, {r1, r2, pc}

RCVS_DEBUG:
      stmfd r13!, {r1, r2, r14}
      mov r2, r0
RCVSD_LP:
      bl RCV_DEBUG
      strb r0, [r2], #1
      subs r1, r1, #1
      bne RCVSD_LP
      mov r0, #0
      strb r0, [r2]
      ldmfd r13!, {r1, r2, pc}

SNDS_DEBUG:
      stmfd r13!, {r2, r14}
      mov r2, r0
SNDSD_LP:
      ldrb r0, [r2], #1
      cmp r0, #0
      beq SNDD_END
      bl SND_DEBUG
      b SNDSD_LP
SNDD_END:
      ldmfd r13!, {r2, pc} 


/* constants */
Testni:  .asciz "DBGU Test [First type 10 characters and then one by one - echo]:\n"
Received: .asciz "                                                                      "

          .align

_Lstack_end:
  .long __STACK_END__

.end
.equ PMC_BASE,  0xFFFFFC00  /* (PMC) Base Address */
.equ PMC_PCER, 	0x10  		  /* Peripheral Clock Enable Register */
.equ CKGR_MOR,	0x20        /* (CKGR) Main Oscillator Register */
.equ CKGR_PLLAR,0x28        /* (CKGR) PLL A Register */
.equ PMC_MCKR,  0x30        /* (PMC) Master Clock Register */
.equ PMC_SR,	  0x68        /* (PMC) Status Register */

# registri za DBGU
.equ DBGU_BASE, 0xFFFFF200	/* Debug Unit Base Address */
.equ DBGU_CR,   0x00 		    /* DBGU Control Register */
.equ DBGU_MR,   0x04  	    /* DBGU Mode Register*/
.equ DBGU_IER,  0x08	      /* DBGU Interrupt Enable Register*/
.equ DBGU_IDR,  0x0C	      /* DBGU Interrupt Disable Register */
.equ DBGU_IMR,  0x10        /* DBGU Interrupt Mask Register */
.equ DBGU_SR,   0x14	      /* DBGU Status Register */
.equ DBGU_RHR,  0x18		    /* DBGU Receive Holding Register */
.equ DBGU_THR,  0x1C		    /* DBGU Transmit Holding Register */
.equ DBGU_BRGR, 0x20		    /* DBGU Baud Rate Generator Register */

# registri za PIO
.equ PIOA_BASE, 0xFFFFF400  /* Zacetek registrov za vrata A - PIOA */
.equ PIOB_BASE, 0xFFFFF600  /* Zacetek registrov za vrata B - PIOB */
.equ PIOC_BASE, 0xFFFFF800  /* Zacetek registrov za vrata C - PIOC */

.equ PIO_PER,  0x00
.equ PIO_OER,  0x10
.equ PIO_SODR, 0x30
.equ PIO_CODR, 0x34

# registri za TC0
.equ TC0_BASE, 	0xFFFA0000	/* TC0 Channel Base Address */
.equ TC_CCR, 	  0x00  		  /* TC0 Channel Control Register */
.equ TC_CMR, 	  0x04	  	  /* TC0 Channel Mode Register*/
.equ TC_CV,    	0x10		    /* TC0 Counter Value */
.equ TC_RA,    	0x14		    /* TC0 Register A */
.equ TC_RB,    	0x18		    /* TC0 Register B */
.equ TC_RC,    	0x1C		    /* TC0 Register C */
.equ TC_SR,    	0x20		    /* TC0 Status Register */
.equ TC_IER,   	0x24		    /* TC0 Interrupt Enable Register*/
.equ TC_IDR,   	0x28		    /* TC0 Interrupt Disable Register */
.equ TC_IMR,  	0x2C		    /* TC0 Interrupt Mask Register */

.text

# morsejeva abeceda
morse_code_address:
  .ascii ".-"     @ A
  .byte 0,0,0,0
  .ascii "-..."   @ B
  .byte 0,0
  .ascii "-.-."   @ C
  .byte 0,0
  .ascii "-.."    @ D
  .byte 0,0,0
  .ascii "."      @ E
  .byte 0,0,0,0,0
  .ascii "..-."   @ F
  .byte 0,0
  .ascii "--."    @ G
  .byte 0,0,0
  .ascii "...."   @ H
  .byte 0,0
  .ascii ".."     @ I
  .byte 0,0,0,0
  .ascii ".---"   @ J
  .byte 0,0
  .ascii "-.-"    @ K
  .byte 0,0,0
  .ascii ".-.."   @ L
  .byte 0,0
  .ascii "--"     @ M
  .byte 0,0,0,0
  .ascii "-."     @ N
  .byte 0,0,0,0
  .ascii "---"    @ O
  .byte 0,0,0
  .ascii ".--."   @ P
  .byte 0,0
  .ascii "--.-"   @ Q
  .byte 0,0
  .ascii ".-."    @ R
  .byte 0,0,0
  .ascii "..."    @ S
  .byte 0,0,0
  .ascii "-"      @ T
  .byte 0,0,0,0,0
  .ascii "..-"    @ U
  .byte 0,0,0
  .ascii "...-"   @ V
  .byte 0,0   
  .ascii ".--"    @ W
  .byte 0,0,0
  .ascii "-..-"   @ X
  .byte 0,0
  .ascii "-.--"   @ G
  .byte 0,0 
  .ascii "--.."   @ Z
  .byte 0,0

letters:   .space 100

.align
.code 32

.global _error
_error:
  b _error

.global	_start
_start:

/* select system mode 
  CPSR[4:0]	Mode
  --------------
  10000	  User
  10001	  FIQ
  10010	  IRQ
  10011	  SVC
  10111	  Abort
  11011	  Undef
  11111	  System  
*/

  mrs r0, cpsr
  bic r0, r0, #0x1F   /* clear mode flags */  
  orr r0, r0, #0xDF   /* set supervisor mode + DISABLE IRQ, FIQ*/
  msr cpsr, r0     
  
  /* init stack */
  ldr sp,_Lstack_end

  /* setup system clocks */
  ldr r1, =PMC_BASE

  ldr r0, = 0x0F01
  str r0, [r1,#CKGR_MOR]

osc_lp:
  ldr r0, [r1,#PMC_SR]
  tst r0, #0x01
  beq osc_lp
  
  mov r0, #0x01
  str r0, [r1,#PMC_MCKR]

  ldr r0, =0x2000bf00 | ( 124 << 16) | 12  /* 18,432 MHz * 125 / 12 */
  str r0, [r1,#CKGR_PLLAR]

pll_lp:
  ldr r0, [r1,#PMC_SR]
  tst r0, #0x02
  beq pll_lp

  /* MCK = PCK/4 */
  ldr r0, =0x0202
  str r0, [r1,#PMC_MCKR]

mck_lp:
  ldr r0, [r1,#PMC_SR]
  tst r0, #0x08
  beq mck_lp

  /* Enable caches */
  mrc p15, 0, r0, c1, c0, 0 
  orr r0, r0, #(0x1 <<12) 
  orr r0, r0, #(0x1 <<2)
  mcr p15, 0, r0, c1, c0, 0 

.global _main

# glavni program
_main:

# inicializacija naprav
bl INIT_IO
bl INIT_TC0
bl INIT_DBGU

# glavna zanka v programu
MAIN_LOOP:
  adr r0, letters
  bl RECEIVE
  bl XWORD

  /*  
    
  test algoritma za GETMCODE

  adr r1, morse_code_address @ 32 (0x20)

  # v register r0 shranimo konstanto 'E'
  mov r0, #'E' @ 69 (0x45)

  # v register r2 shranimo konstanto 'A'
  mov r2, #'A' @ 65 (0x41)

  # v register r4 shranimo konstanto 6, za mnozenje
  mov r4, #6

  sub r3, r0, r2 @ 69 - 65 = 4
  mul r0, r3, r4 @ 4 * 6 = 24 (0x18)
  add r0, r0, r1 @ 32 (0x20) + 24 (0x18) = 56 (0x38)

  # ascii vrednosti crk
  # A 41
  # B 42
  # C 43
  # D 44
  # E 45

  # naslovi crk decimalno
  # A 32-37
  # B 38-43
  # C 44-49
  # D 50-55
  # E 56-62

  */  

  b MAIN_LOOP

# konec glavnega programa

_wait_for_ever:
  b _wait_for_ever

# podprogrami

# inicializacija za PIO (parallel input/output)
INIT_IO: 
  # r13 = sp, r14 = lr 

  # shranimo na sklad vse registre r0-r12
  stmfd sp!, {r0-r12, lr} 

  # v register r0 nalozimo naslov baznega registra za PIO
  ldr r0, =PIOC_BASE

  # v register r1 nalozimo konstanto 2 (prvi bit za PIO_PER)
  mov r1, #2

  # nastavimo bit 1 v registru PIO_PER (omogoci digitalni vhod/izhod)
  str r1, [r1, #PIO_PER]

  # omogoci izhod v b1 (PORTB)
  str r1, [r0, #PIO_OER]

  # nastavi stanje izhoda na 1 (ugasnjena LED dioda)
  str r1, [r0, #PIO_SODR]

  # vrnitev iz podprograma
  ldmfd sp!, {r0-r12, pc}

# inicializacija za TC0 casovnik
INIT_TC0:
  # shranimo na sklad vse registre r0-r3
  stmfd sp!, {r0-r3, lr}

  # prizgemo TMC za TC0
  ldr r0, =PMC_BASE

  # omogocimo urin signal za TC0 z vpisom 1 v bit 17 v register PMC_PCER
  mov r1, #0b1 << 17
  str r1, [r0, #PMC_PCER]

  # bazni register za TC0
  # MCK/128, RC=375 (1ms)
  ldr r0, =TC0_BASE

  # nastavimo WAVE nacin (generator signalov), WAVE=1, WAVESEL=10
  mov r1, #0b110 << 13
  
  # izbira frekvence stetja, MCK = 48 MHz, inicializiramo TC0 s MCK/128
  mov r2, #0b011
  add r1, r1, r2
  str r1, [r0, #TC_CMR]
  
  # RC=375 (1ms)
  ldr r1, =375
  str r1, [r0, #TC_RC]
  
  # omogocimo in sprozimo uro z vpisom
  # 1 v CLKEN (bit 0 v TC_CCRx)  
  # 1 v SWTRG (bit 2 v TC_CCRx) 
  mov r1, #0b101
  str r1, [r0, #TC_CCR]
  
  # vrnitev iz podprograma
  ldmfd sp!, {r0-r3, pc}

# inicializacija za DBGU
# 1. nastavi nacin delovanja (normal mode) in parnost z vpisom v DBGR_MR
# 2. nastavi hitrost prenosa z vpisom v DBGU_BRGR, formula: MCK[Hz] / (16 * BAUD_RATE)
# 3. omogoci oddajnik/sprejemnik z vpisom 1 v bita TXEN/RXEN v DBGU_CR
INIT_DBGU:
  # shranimo na sklad vse registre r0, r1, r2
  stmfd sp!, {r0-r2, lr} 

  # v register r0 shranimo naslov baznega registra za DBGU
  ldr r0, =DBGU_BASE
  
  # nastavimo normal mode in brez paritete v DBGU_MR
  ldr r1, =1 << 11
  str r1, [r0, #DBGU_MR]
  
  # nastavimo hitrost prenosa z vpisom v BRGR 
  # mov r1, #26  @ BR = 115200
  # mov r1, #156 @ BR = 19200
  # mov r1, #312 @ BR = 9600
  mov r1, #312
  str r1, [r0, #DBGU_BRGR]
  
  # omogocimo sprejemnik z vpisom 1 v bit 4 v registru DBGU_CR 
  # RXEN (oddajnik) - bit 4
  # TXEN (sprejemnik) - bit 6 (ne potrebujemo)
  mov r1, #1 << 4
  str r1, [r0, #DBGU_CR]  
  
  # vrnitev iz podprograma
  ldmfd sp!, {r0-r2, pc}

# prizgemo led diodo
LED_ON:

  # shranimo na sklad vse registre r0-r12
  stmfd sp!, {r0-r12, lr}

  # bazni register za PIO
  ldr r0, =PIOC_BASE

  # TODO komentarji
  mov r1, #2
  str r1, [r0, #PIO_CODR]

  # vrnitev iz podprograma
  ldmfd sp!, {r0-r12, pc}

# ugasnemo led diodo
LED_OFF:
  # shranimo na sklad vse registre r0-r12
  stmfd sp!, {r0-r12, lr}

  # bazni register za PIO
  ldr r0, =PIOC_BASE

  # ugasnemo led diodo
  mov r1, #2      
  str r1, [r0, #PIO_SODR]

  # vrnitev iz podprograma
  ldmfd sp!, {r0-r12, pc}

# zakasnitev za simulacijo utripanja led diode
# preko r0 sprejmemo parameter za dolzino zakasnitve
DELAY:
  # shranimo na sklad vse registre r1-r12
  stmfd sp!, {r0, r2, r3, lr}

  # v register r0 shranimo bazni register od casovnika
  ldr r0, = TC0_BASE

  # zastavica CPCS
  mov r2, #1 << 4

DELAY_LOOP:
  ldr r3, [r0, #TC_SR]

  # preveri zastavico CPCS v TC_SR
  tst r3, r2

  beq DELAY_LOOP

  # pocakamo kolikor milisekund je podano v registru r1
  subs r1, r1, #1
  bne DELAY_LOOP
  
  # vrnitev iz podprograma
  ldmfd sp!, {r0, r2, r3, pc}
  
# prek r0 prejme kazalec na zacetek prostora za shranjevanje podatkov 
RECEIVE:
  # shranimo na sklad vse registre r0, r1, r2, r3
  stmfd sp!, {r0-r3, lr}

  # odmik, ki ga bomo uporabili za shranjevanje znakov
  mov r1, #0 

READ:
  # sprejem znaka preko DBGU
  # znak dobimo v register r2
  bl RCV_DBGU
  
  # shrani znak v rezerviran prostor
  strb r2, [r0, r1] 

  # preveri ce je znak carriage return (enter, ascii = 13)
  cmp r2, #13

  # ce je enter, koncamo branje
  beq END_READ

  # ce ni enter, povecamo odmik za 1 ...
  add r1, r1, #1

  # ...in nadaljujemo z branjem
  b READ
  
END_READ:
  # v registru r2 imamo prebran znak (enter, ascii = 13)
  # ker mora biti niz koncan z 0, 13 zamenjamo z 0
  mov r2, #0 

  # zapisemo vrednost v pomnilnik, v registru r1 hranimo odmik, 
  # katerega povecujemo ob vsakem prebranem znaku (razen enter)
  strb r2, [r0, r1]

  # vrnitev iz podprograma
  ldmfd sp!, {r0-r3, pc}

# sprejem znaka preko DBGU
RCV_DBGU:
  # shranimo na sklad registra r0 in r1
  stmfd sp!, {r0-r1, lr}

  # v r0 shranimo naslov baznega registra za DBGU
  ldr r0, =DBGU_BASE

RCVD_LP:

  # ob sprejemu znaka se postavi bit 0 (RXRDY) v DBGU_SR, preberemo ga v register r2
  ldr r2, [r0, #DBGU_SR]

  # pogledamo ce je bit RXRDY postavljen
  tst r2, #1

  # ce ni postavljen, cakamo
  beq RCVD_LP

  # ce je postavljen, preberemo znak iz spodnjih 8 bitov v DBGU_RHR
  ldr r2, [r0, #DBGU_RHR]   

  # vrnitev iz podprograma, v registru r2 je prebran znak
  ldmfd sp!, {r0-r1, pc}

# v registru r0 sprejmemo znak "." ali "-"
# glede na poslan znak ustrezno prizgemo/ugasnemo led diodo
XMCHAR:

  # shranimo na sklad register r1
  stmfd sp!, {r1, lr}

  # preverimo ce je poslan znak "."
  cmp r0, #'.'

  # ce je poslan znak "." nastavimo dolzino zakasnitve na 150ms
  moveq r1, #150

  # zanasamo se na to, da smo res poslali samo "." oz "-"
  # ce je poslan znak "-" nastavimo dolzino zakasnitve na 300ms
  movne r1, #300

  # prizgemo led diodo
  bl LED_ON

  # pocakamo (zakasnitev)
  bl DELAY

  # ugasnemo led diodo
  bl LED_OFF

  # nastavimo zakasnitev na 150ms
  mov r1, #150

  # pocakamo (zakasnitev)
  bl DELAY

  # vrnitev iz podprograma
  ldmfd sp!, {r1, pc}

# v registru r0 dobimo kazalec na niz iz tabele morsejeve abecede,
# ki vsebuje znake "." ali "-"
# beremo znak po znak in klicemo podprogram XMCHAR
XMCODE:
  # shranimo na sklad registre r0, r1, r2
  stmfd sp!, {r0-r2, lr}

  # v register r1 si shranimo kazalec na niz
  mov r1, r0

# beremo znak po znak
XMCODE_LOOP:

  # preberemo niz in ga shranimo v register r0
  ldrb r0, [r1], #1

  # preverimo ce je prebran znak 0
  cmp r0, #0

  # ce je prebran znak 0 skocimo na END_XMCODE
  beq END_XMCODE

  # ce je prebran katerikoli drug znak skocimo na XMCHAR
  bl XMCHAR

  # beremo dalje
  b XMCODE_LOOP

END_XMCODE:
  # v register r1 zapisemo konstanto 300 (koliko milisekund bo trajala zakasnitev)
  mov r1, #300

  # ugasnemo led diodo
  bl LED_OFF

  # pocakamo 300 milisekund
  bl DELAY

  # vrnitev iz podprograma
  ldmfd sp!, {r0-r2, pc}

# v registru r0 sprejmemo ascii znak velike tiskane crke (A-Z, 65-90)
# izracunamo naslov podanega znaka v tabeli morsejeve abecede
# vrnemo kazalec na niz morsejeve abecede, ki ustreza crki v registru r0
# (bolj podroben opis algoritma je podan na zacetku programa)
GETMCODE:
  # shranimo na sklad registra r1, r2, r3, r4
  stmfd sp!, {r1-r4, lr}

  # v register r1 preberemo zacetni naslov tabele, ki vsebuje morsejevo abecedo
  adr r1, morse_code_address 

  # v register r2 shranimo konstanto 'A'
  mov r2, #'A'

  # v register r3 si shranimo konstanto 6, ki jo potrebujemo za
  # racunanje naslovov v tabeli morsejeve abecede
  mov r3, #6

  # odstejemo 41 od prebranega znaka in shranimo v register r4
  sub r4, r0, r2

  # mnozimo razliko, ki smo jo dobili v prejsnjem koraku z konstanto 6
  mul r4, r4, r3

  # sestejemo zacetni naslov tabele in produkt iz prejsnjega koraka
  # da dobimo naslov trenutnega znaka v tabeli, katerega zapisemo v register r0
  add r0, r4, r1

  # poklicemo podprogram XMCODE
  bl XMCODE

  # vrnitev iz podprograma
  ldmfd sp!, {r1-r4, pc}

# v registru r0 sprejmemo kazalec na niz velikih crk zakljucen z 0
# klicemo GETMCODE crko po crko
# ko naletimo na 0, pocakamo 1s in koncamo
XWORD:
  # shranimo na sklad registra r0, r1
  stmfd sp!, {r0-r1, lr}

  # v r1 si shranimo kazalec na niz
  mov r1, r0

# beremo crko po crko dokler ne naletimo na konec niza (znak 0)
XWORD_LOOP:

  # v register r0 preberemo crko
  ldrb r0, [r1], #1 

  # preverimo ce smo prebrali znak 0
  cmp r0, #0

  # ce smo prebrali znak 0 koncamo
  beq XWORD_END

  # ce smo prebrali katerikoli drug znak, moramo najti ustrezno morsejevo kodo v tabeli
  bl GETMCODE

  # beremo dalje
  b XWORD_LOOP 
  
# koncamo z branjem
XWORD_END:   
  # nastavimo zakasnitev na 1s (1000ms)
  mov r1, #1000

  # pocakamo (zakasnitev)
  bl DELAY

  # vrnitev iz podprograma
  ldmfd sp!, {r0-r1, pc}

_Lstack_end:
  .long __STACK_END__

.end

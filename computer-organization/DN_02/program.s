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

# zacetni naslov
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

source:   .space 100

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

main_loop:
  @ adr r0, source
  @ bl receive
  @ bl xword

  bl LED_ON
  mov r0, #500
  bl DELAY
  bl LED_OFF
  mov r0, #500
  bl DELAY

  b main_loop

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

# inicializacija za TC0
INIT_TC0:
  # shranimo na sklad vse registre r0-r3
  stmfd sp!, {r0-r3,lr}

  # bazni register
  ldr r0, =PMC_BASE

  # omogocimo urin signal za TC0 z vpisom 1 v bit 17 v register PMC_PCER
  mov r1, #0b1 << 17
  str r1, [r0, #PMC_PCER]
  ldr r0,=TC0_BASE

  # nastavi WAVE nacin (generator signalov), WAVE=1, WAVESEL=10
  mov r1,#0b110 << 13
  
  # izbira frekvence stetja, MCK = 48 MHz, inicializiraj TC0 s MCK/128
  mov r2, #0b011
  add r1, r1, r2
  str r1, [r0, #TC_CMR]
  
  # 1ms ==> RC=375
  ldr r1, =375
  str r1, [r0,#TC_RC]
  
  # omogoci in sprozi uro z vpisom
  # 1 v CLKEN (bit 0 v TC_CCRx)  
  # 1 v SWTRG (bit 2 v TC_CCRx) 
  mov r1, #0b101
  str r1, [r0, #TC_CCR]
  
  # vrnitev iz podprograma
  ldmfd sp!, {r0-r3, pc}

# inicializacija za DBGU
INIT_DBGU:
  # shranimo na sklad vse registre r0-r2
  stmfd sp!, {r0-r2, lr} 

  # bazni register za DBGU napravo
  ldr r0, =DBGU_BASE
  
  # nastavi normal mode in brez paritete v DBGU_MR
  ldr r1, =1 << 11
  str r1, [r0, #DBGU_MR]
  
  # nastavi hitrost prenosa z vpisom v BRGR nastavi na 9600 boudov (CD=9600)
  # izracuaj po formuli MCK=48MHz, MCK(Hz)/(16*CD) = 9600 boudov
  mov r1,#312
  str r1,[r0,#DBGU_BRGR]
  
  # omogoci sprejemnik z vpisom 1 v bit RXEN
  # v registru DBGU_CR (za oba)
  mov r1, #1 << 4   @samo RXEN(b4)
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

  # TODO komentarji
  mov r1, #2      
  str r1, [r0, #PIO_SODR]

  # vrnitev iz podprograma
  ldmfd sp!, {r0-r12, pc}

# zakasnitev za simulacijo utripanja led diode
# preko r0 sprejmemo parameter za dolzino zakasnitve
DELAY:
  # shranimo na sklad vse registre r1-r12
  stmfd sp!, {r1-r12, lr}

  # zanka za zakasnitev
  ldr r2, loop_delay
  loop1:
    mov r1, r2
    loop:
      subs r1, #1
      bne loop
    subs r0, #1
    bne loop1
  
  # vrnitev iz podprograma
  ldmfd sp!, {r1-r12, pc}
  
# prek r0 prejme kazalec na zacetek prostora za shranjevanje podatkov 
RECEIVE:
  # shranimo na sklad vse registre r1-r3
  stmfd sp!, {r0-r3, lr}
  mov r1,#0 @ odmik

read:
  bl RCV_DBGU
  @ prek r2 dobi znak
  strb r2,[r0,r1] @shrani znak v rez. prostor
  cmp r2,#13
  beq end_read
  add r1,r1,#1
  b read
  
end_read:
  mov r2,#0 @ znak carriage return (ascii=13) nadomsti z 0
  strb r2,[r0,r1]
  ldmfd sp!,{r0-r3,pc}

RCV_DBGU:
  stmfd sp!,{r0-r1,lr}
  ldr r0, =DBGU_BASE
  mov r1, #1 @ bit 0 (RXRDY) 

check_receive_ready:
  ldr r2,[r0,#DBGU_SR]
  tst r2,r1
  beq check_receive_ready
  ldr r2, [r0, #DBGU_RHR]   
  ldmfd sp!, {r0-r1, pc}

# dobi parameter v registru r0 (parameter je lahko . ali -)
# glede na parameter odda signal ustrezne dolzine
XMCHAR:
  stmfd sp!,{r1,lr}
  cmp r0,#'.'
  moveq r1,#150
  movne r1,#300
  bl LED_ON
  bl DELAY
  mov r1,#150
  bl LED_OFF
  bl DELAY
  ldmfd sp!,{r1,pc}

# v r0 dobi kazalec z 0 zakljucen niz ki vsebuje samo znake '.' ali '-'
# poslje znak po znak podprogramu XMCHAR 
XMCODE:
  stmfd sp!,{r0-r2,lr}
  mov r1,r0
loop_xmcode:
  ldrb r0,[r1],#1
  cmp r0,#0
  beq  END_XMCODE
  bl  XMCHAR
  b loop_xmcode

END_XMCODE:
  mov r1,#150
  bl LED_OFF
  bl DELAY
  ldmfd sp!, {r0-r2, pc}

# v r0 dobi ascii znak velike tiskane crke 'A'-'Z' 
# V r0 nato dobi kazalec na zacetek niza, kjer se nahaja ustrezno zaporedje znakov v Morsejevi abecedi
GETMCODE:  
  stmfd sp!,{r1-r5,lr}
  adr r1, morse_code_address  @ zacetni naslov
  mov r2, #'A'
  sub r3, r0, r2
  mov r4, r3, lsl #2
  mov r5, r3, lsl #1
  add r0, r5, r4
  add r0, r0, r1
  bl XMCODE
  ldmfd sp!, {r1-r5, pc}

# v R0 dobi kazalec na niz velikih crk zakljucen z 0
XWORD:
  stmfd sp!,{r0-r1,lr}
  mov r1,r0
loop_xword:
  ldrb r0,[r1],#1 
  cmp r0,#0
  beq end_xword
  bl GETMCODE
  b loop_xword 
  
end_xword:    
  ldmfd sp!,{r0-r1,pc}

/* konstante */
loop_delay: .word 48000
delay_ms: .word 100

_Lstack_end:
  .long __STACK_END__

.end

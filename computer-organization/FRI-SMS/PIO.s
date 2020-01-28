# naloga

# Napišite podprogram INIT_IO v zbirnem jeziku za ARM9, ki bo priključek PIO_PC1 mikrokrmilnika AT91SAM9260 na modulu FRI-SMS ustrezno nastavil tako, da boste lahko preko njega prižigali in ugašali oranžno LED diodo. Priključek orientirajte izhodno. Nato izhod postavite v stanje 1. Pri delu si pomagajte prosojnicami.
# Napišite podprogram LED_ON, ki prižge LED diodo.
# Napišite podprogram LED_OFF, ki ugasne LED diodo.
# V zbirnem jeziku za ARM9 napišite podprogram DELAY, ki s pomočjo programske zanke izvaja zakasnitev za N milisekund. Parameter N naj podprogram dobi v registru R0. Podprogram mora ohraniti vrednost vseh registrov razen R0. Izračunajte koliko urinih period traja en obhod zanke (upoštevajte kontrolne nevarnosti pri skoku). Frekvenca ure je 192 MHz..
# Vsi podprogrami morajo ohraniti vrednosti registrov. Podprograme preizkusite tudi s primernim glavnim programom.

# program

.equ PMC_BASE,  0xFFFFFC00  /* (PMC) Base Address */
.equ CKGR_MOR,	0x20        /* (CKGR) Main Oscillator Register */
.equ CKGR_PLLAR,0x28        /* (CKGR) PLL A Register */
.equ PMC_MCKR,  0x30        /* (PMC) Master Clock Register */
.equ PMC_SR,	  0x68        /* (PMC) Status Register */

/* registers for DBGU */
.equ DBGU_BASE, 0xFFFFF200	/* Debug Unit Base Address */
.equ DBGU_CR, 0x00  		/* DBGU Control Register */
.equ DBGU_MR, 0x04	  	/* DBGU Mode Register*/
.equ DBGU_IER, 0x08		/* DBGU Interrupt Enable Register*/
.equ DBGU_IDR, 0x0C		/* DBGU Interrupt Disable Register */
.equ DBGU_IMR, 0x10		/* DBGU Interrupt Mask Register */
.equ DBGU_SR,   0x14		/* DBGU Status Register */
.equ DBGU_RHR, 0x18		/* DBGU Receive Holding Register */
.equ DBGU_THR, 0x1C		/* DBGU Transmit Holding Register */
.equ DBGU_BRGR, 0x20		/* DBGU Baud Rate Generator Register */

/* registers for PIO */
.equ PIOA_BASE, 0xFFFFF400 /* Zacetek registrov za vrata A - PIOA */
.equ PIOB_BASE, 0xFFFFF600 /* Zacetek registrov za vrata B - PIOB */
.equ PIOC_BASE, 0xFFFFF800 /* Zacetek registrov za vrata C - PIOC */

.equ PIO_PER, 0x00
.equ PIO_OER, 0x10
.equ PIO_SODR, 0x30
.equ PIO_CODR, 0x34

.text
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

/* main program */
_main:

bl init_io
main_loop:
  bl led_on
  mov r0, #500
  bl delay
  bl led_off
  mov r0, #500
  bl delay
  b main_loop

/* end of main program */

_wait_for_ever:
  b _wait_for_ever

# subroutines

init_io: 
  # r13 = sp, r14 = lr 
  stmfd sp!, {r0-r12, lr} 
  ldr r0, =PIOC_BASE
  mov r1, #1 << 1
  str r1, [r1, #PIO_PER]
  str r1, [r0, #PIO_OER]
  str r1, [r0, #PIO_SODR]
  ldmfd sp!, {r0-r12, pc}

led_on:
  # r13 = sp, r14 = lr 
  stmfd sp!, {r0-r12, lr}
  ldr r0, =PIOC_BASE
  mov r1, #1 << 1      
  str r1, [r0, #PIO_CODR]
  ldmfd sp!, {r0-r12, pc}

led_off:
  # r13 = sp, r14 = lr 
  stmfd sp!, {r0-r12, lr}
  ldr r0, =PIOC_BASE
  mov r1, #1 << 1       
  str r1, [r0, #PIO_SODR]
  ldmfd sp!, {r0-r12, pc}

delay:
  stmfd sp!, {r1-r12, lr}
  ldr r2, loop_delay
  loop1:
    mov r1, r2
    loop:
      subs r1, #1
      bne loop
    subs r0, #1
    bne loop1
  ldmfd sp!, {r1-r12, pc}
  
/* end of subroutines */

/* constants */
loop_delay: .word 48000

/* end of constants */

_Lstack_end:
  .long __STACK_END__

.end

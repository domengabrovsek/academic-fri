# naloga

# 1. Napišite podprogram INIT_TC0 za inicializacijo časovnika TC0, ki časovnik nastavi kot generator valnih oblik (waveform mode). Izberite najpočasnejšo uro, ki še dovoljuje dolžino intervala dolgo natančno eno milisekundo in ustrezno nastavite vrednost registra RC. Števec naj deluje tako, da šteje do vrednosti, določene z vrednostjo RC, nato naj se ponastavi na 0 in ponovno prične s štetjem. Podprogram mora ohraniti vrednost vseh registrov.

# 2. Napišite podprogram za zakasnitev DELAY_TC0, ki bo imel enako funkcijo kot podprogram DELAY iz naloge s PIO krmilnikom in LED diodo. Za merjenje milisekundnega intervala uporabite časovnik TC0. V zanki berite statusni register časovnika in preverjajte ustrezno zastavico. Zanka naj teče, dokler se zastavica ne postavi na 1. Zakasnilno zanko ponovite toliko krat, kot to določa parameter N. Vrednost parametra N dobi podprogram v registru R0. Podprogram mora ohraniti vrednost vseh registrov razen R0.

# 3. Napišite tudi kratek glavni program, ki naj kliče vse ustrezne podprograme, tako da bo LED dioda utripala s frekvenco natančno 1Hz. Za zakasnitev uporabite podprogram DELAY_TC0. LED diodo prižigajte in ugašajte s pomočjo podprogramov LED_OFF in LED_ON iz nalog 6. in 7. Za navodila pri delu glejte prosojnice in tovarniško listino za AT91SAM9260!

# program

.global _main
/* main program */
_main:
  .equ PMC_BASE, 0xFFFFFC00      /* Power Manag. Controller Base Addr.*/
  .equ PMC_PCER, 0x10                  /* Peripheral Clock Enable Register */
  .equ PIOC_BASE, 0xFFFFF800
  .equ PIO_PER, 0x00
  .equ PIO_OER, 0x10
  .equ PIO_SODR, 0x30
  .equ PIO_CODR, 0x34

  .equ TC0_BASE, 0xFFFA0000 /* TC0 Channel Registers */
  .equ TC_IMR, 0x02C                /* TC0 Interrupt Mask Register */
  .equ TC_IER, 0x24                    /* TC0 Interrupt Enable Register*/
  .equ TC_RC, 0x1C                    /* TC0 Register C */
  .equ TC_RA, 0x14                    /* TC0 Register A */
  .equ TC_CMR, 0x04                /* TC0 Channel Mode Register (Capture Mode / Waveform Mode */
  .equ TC_IDR, 0x28                  /* TC0 Interrupt Disable Register */
  .equ TC_SR, 0x20                    /* TC0 Status Register */
  .equ TC_RB, 0x18                    /* TC0 Register B */
  .equ TC_CV, 0x10                    /* TC0 Counter Value */
  .equ TC_CCR, 0x00                  /* TC0 Channel Control Register */

/* user code here */
  bl INIT_IO
  bl INIT_TC0

LOOP:    bl LED_ON
  ldr r0,=500
  bl DELAY_TC0

  bl LED_OFF
  ldr r0,=500
  bl DELAY_TC0

  b  LOOP

/* end user code */

_wait_for_ever:
  b _wait_for_ever

INIT_IO:
  stmfd r13!, {r0, r2, r14}
  ldr r2, =PIOC_BASE
  mov r0, #1 << 1
  str r0, [r2, #PIO_PER]
  str r0, [r2, #PIO_OER]
  ldmfd r13!, {r0, r2, pc}

LED_ON:
  stmfd r13!, {r0, r2, r14}
  ldr r2, =PIOC_BASE
  mov r0, #1 << 1
  str r0, [r2, #PIO_CODR]
  ldmfd r13!, {r0, r2, pc}

LED_OFF:
  stmfd r13!, {r0, r2, r14}
  ldr r2, =PIOC_BASE
  mov r0, #1 << 1
  str r0, [r2, #PIO_SODR]
  ldmfd r13!, {r0, r2, pc} 

INIT_TC0:
  stmfd r13!, {r0, r2, r14}
  ldr r2, =PMC_BASE    /*Enable PMC for TC0 */
  mov r0, #(1 << 17)
  str r0, [r2,#PMC_PCER]

  /*Initialize TC0 MCK/128, RC=375 (1ms) */
  ldr r2, =TC0_BASE
  mov r0, #0b110 << 13 /*WAVE=1, WAVSEL= 10*/
  add r0, r0, #0b011            /* MCK/128 */
  str r0, [r2, #TC_CMR]
  ldr r0, =375                      /* 1 ms at 48 Mhz */
  str r0, [r2, #TC_RC]
  mov r0, #0b0101      /*TC_CLKEN,TC_SWTRG*/
  str r0, [r2, #TC_CCR]
  ldmfd r13!, {r0, r2, r15}

DELAY_TC0:
  stmfd r13!, {r1, r2, r14}
  ldr r2, =TC0_BASE

DLP_TC0:  ldr r1, [r2, #TC_SR]
  tst r1, #1 << 4                              /* CPCS Flag ?*/
  beq DLP_TC0

  subs r0, r0, #1
  bne DLP_TC0
  ldmfd r13!, {r1, r2, r15}


/* constants */

          .align
_Lstack_end:
  .long __STACK_END__

.end
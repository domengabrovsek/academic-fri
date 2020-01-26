# naloga

# Enoto DBGU uporabljajte tako, da bo znake sprejemala in oddajala s pomočjo DMA prenosov. Osnovne nastavitve ostanejo enake kot v 4.6 (podprogram DEBUG_INIT). Pri tem napišite naslednje podprograme:
# 
# - Podprogram RCV_DMA, ki nastavi DMA krmilnik tako, da je pripravljen na sprejem naslednjih N znakov. Naslov polja, v katerega naj se znaki zapisujejo, naj dobi podprogram v registru R0, vrednost parametra N pa naj se prenese v podprogram preko registra R1. Parameter N ima lahko vrednost med 1 in 80. Če je vrednost parametra večja oziroma manjša, jo omejite na navedeni interval.
# 
# - Podprogram SND_DMA, ki nastavi DMA krmilnik tako, da je pripravljen na oddajo znakov. Naslov niza naj se prenese v podprogram preko registra R0, dolžina niza pa preko registra R1.
# 
# - Podprogram CHANGE, ki zamenja velike in male črke v nizu znakov. Naslov izvornega niza dobi podprogram v registru R0, naslov ponornega niza v registru R1, dolžino obeh nizov pa v registru R2.
# 
# V glavnem programu po začetnih nastavitvah (DEBUG_INIT) pokličite podprogram RCV_DMA, nato pa v zanki čakajte, da se DMA prenos zaključi (zastavica ENDRX). S klicem podprograma CHANGE zamenjajte velike in male črke v sprejetem nizu. Rezultat pošljite s pomočjo SND_DMA.

# program

.global _main
/* main program */
_main:
/* user code */
/* inicializacija debug unit-a */
    bl DEBUG_INIT

zanka:
/* sproži sprejemanje preko DMA */
    ldr r0, =niz1
    ldr r1, =STRING_LENGTH
    bl RCV_DMA 

    ldr r0,=DBGU_BASE

/* pocakaj na zastavico ENDRX */
z1: ldr r1, [r0, #DBGU_SR]
    tst r1, #1 << 3
    beq z1

/* zamenjaj velikost crk */
    ldr r0, =niz1
    ldr r1, =niz2
    ldr r2, =STRING_LENGTH
    bl CHANGE 

/* sproži oddajanje preko DMA */
    ldr r0, =niz2
    ldr r1, =STRING_LENGTH
    bl SND_DMA   

/* pocakaj na zastavico ENDTX */
z2: ldr r1, [r0, #DBGU_SR]
    tst r1, #1 << 4
    beq z2

    b zanka

_wait_for_ever:
    b _wait_for_ever


RCV_DMA:
    stmed r13!, {r2-r3,r14}
    ldr r2,=DBGU_BASE
    add r0,r0,#0x200000
    str r0,[r2,#DBGU_RPR]    /* kazalec na niz1*/
    cmp r1, #1
    movlo r1, #1
    cmp r1, #80
    movhi r1, #80
    str r1,[r2,#DBGU_RCR]
    mov r3,#1                /* omogoci sprejemanje - RXTEN*/
    str r3,[r2,#DBGU_PTCR]

    ldmed r13!, {r2-r3,pc}


SND_DMA:
    stmed r13!, {r2-r3,r14}
    ldr r2,=DBGU_BASE
    add r0,r0,#0x200000
    str r0,[r2,#DBGU_TPR]    /* kazalec na niz1*/
    str r1,[r2,#DBGU_TCR]
    mov r3,#1<<8            /*omogoci oddajanje - TXTEN*/
    str r3,[r2,#DBGU_PTCR]

    ldmed r13!, {r2-r3,pc}


CHANGE: 
    stmed r13!, {r1-r4,r14}

ch_zanka:   
    ldrb r4, [r0], #1     

    bic r3, r4, #0b100000

    cmp r3, #'A'
    blo pisi
    cmp r3, #'Z'
    bhi pisi
    eor r4, r4, #0b100000    /*veliko crko spremeni v majhno*/

pisi:
    strb r4, [r1], #1  /* shranimo v niz2*/ 

    subs r2, r2, #1
    bne ch_zanka     

    ldmed r13!, {r1-r4,pc}


/* end user code */

/* variables here */
  .equ STRING_LENGTH, 10

niz1: .space STRING_LENGTH
niz2: .space STRING_LENGTH

/* end variables */
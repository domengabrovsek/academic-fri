# ARM 

## Pravila
- uporablja se pravilo tankega konca
- ukazu dodamo "s" da postavi zastavice
## Registri
- R0 - R12
- R13 (SP) - Stack Pointer
- R14 (LR) - Link Register
- R15 (PC) - Program Counter
- CPSR - Current Program Status Register

## Zastavice
- (N)egative - bit 31 je 0/1
- Z(ero) - vsi biti so 0
- (C)arry - rezultat povzroči carry
- o(V)erflow - rezultat povzroči overflow

## Spremenljivke

```
s1:     .byte 1 @ 8 bitna spremenljivka
s2:     .byte 1,2,3,4,5 @ 8 bitna tabela
s3:     .word 1 @ 32 bitna spremenljivka
s4:     .hword 1 @ 16 bitna spremenljivka
s5:     .space 4 @ rezervivaj 4 bajte
s6:     .asiz "beseda"
s7:     .ascii "beseda"
```

## Labele
- poimenovanje spremenljivk (pomnilniška lokacija)
- poimenovanje ukazov (vrstic) za skoke

## Psevdoukazi
```
.text - določanje vrste pomnilniških odsekov
.data - določanje vrste pomnilniških odsekov
.align - poravnava vsebine (deljivo s 4)
.space - rezervacija pomnilnika
.byte - 8 bitna spremenljivka
.hword - 16 bitna
.word - 32 bitna
.end - konec prevajanja

```

## Ukazi

```
load
- ldr(s) r1, s1 @ s1 naloz v r1
- ldr(s)h
- ldr(s)b, r1, [r2]
store
- str(s)
- str(s)h
- str(s)b r0, [r1]
aritmetični ukazi
- add r0, r1, r2 @ r0 <- r1 + r2
- sub r0, r1, r2 @ r0 <- r1 - r2
- rsb r0, r1, r2 @ r0 <- r2 – r1
logični ukazi
- and r0, r1, r2 @ r0 <- r1 AND r2
- orr r0, r1, r2 @ r0 <- r1 OR r2
- eor r0, r1, r2 @ r0 <- r1 XOR r2
- bic r0, r1, r2 @ r0 <- r1 AND NOT r2
prenos med registri
- mov r0, r2 @ r0 <- r2
- mvn r0, r2 @ r0 <- NOT r2
primerjave
- cmp r1, r2 @ set CPSR flags on r1 - r2
- cmn r1, r2 @ set CPSR flags on r1 + r2
- tst r1, r2 @ set CPSR flags on r1 AND r2
- teq r1, r2 @ set CPSR flags on r1 XOR r2
pogojni skoki
- b(pogoj) oznaka 
- npr: bne zanka
```

## Pogoji

```
zastavice
- cs (carry set)
- cc (carry not set)
- mi (negative)
- pl (positive or zero)
- vs (overflow)
- vc (no overflow)
oboje
- eq (=)
- ne (!=)
predznačena
- ge (>=)
- lt (<)
- gt (>)
- le (<=)
nepredznačena
- hs (>=)
- lo (<)
- hi (>)
- ls (<=)
```

## Naslavljanje

- posredno naslavljanje brez odmika
```
ldr r0, [r1]; r0 <- mem32[r1] 
```
- posredno naslavljanje z takojšnjim odmikom
```
ldr r0, [r1, #10]; r0 <- mem32[r1+10]
str r0, [r1, #10]; mem32[r1+10] <- r0
```
- takojšnje naslavljanje
```
# takojšnji operand = 8 bitno število
mov r1, #3
add r2, r3, #32
sub r2, r3, #1
```
- neposredno registrsko naslavljanje
```
and r2, r3, r4
sub r4, r3, r2
mov r1, r4
```
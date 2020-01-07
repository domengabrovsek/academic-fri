# Opis mikroukazov

## addrsel

16 bitno naslovno vodilo, ki lahko vrednost (naslov) pridobi iz štirih različnih virov, vir izberemo glede na to kako določimo 'addrsel'. Naslov pove iz katere pomnilniške besedu iz RAM-a beremo.

### addrsel=pc

Preko multiplekserja na naslovno vodilo pošljemo vrednost (naslov) iz programskega števca.

### addrsel=imm

Preko multiplekserja na naslovno vodilo pošljemo vrednost (naslov) iz takojšnjega operanda.

### addrsel=alu

 Preko multiplekserja na naslovno vodilo pošljemo vrednost (naslov) iz izhoda aritmetično-logične enote

### addrsel=sreg

Indirektno naslavljanje preko sreg registra, ki vsebuje kazalec na lokacijo v pomnilniku.

---

## aluop

 Aritmetično logična enota sprejme dva 16-bitna operanda in vrne 16-bitni rezultat. Prvi vhod pride iz registra sreg, drugi pa je lahko register treg, takojšnji register, konstanta 0, konstanta 1, odvisno kaj izberemo pri 'op2sel'. Izhod iz ALE lahko zapišemo nazaj na podatkovno vodilo, uporabimo kot naslov ali zapišemo nazaj v registre. Prav tako lahko postavi Z(ero), C(arry) in N(egative) zastavice. Na voljo imamo 16 različnih operacij katere določimo s tem da nastavimo 'aluop'.

Operacije:

- aluop=add  (seštevanje)
- aluop=sub  (odštevanje)
- aluop=mul  (množenje)
- aluop=div  (deljenje)
- aluop=rem  (ostanek pri deljenju)
- aluop=and  (in)
- aluop=or   (ali)
- aluop=xor  (ekskluzivni ali)
- aluop=nand (negirani in)
- aluop=nor  (negirani ali)
- aluop=not  (negacija)
- aluop=lsl  (logični pomik v levo)
- aluop=lsr  (logični pomik v desno)
- aluop=asr  (aritmetični pomik v desno)
- aluop=rol  (rotacija v levo)
- aluop=ror  (rotacija v desno)

Izhodi:

- C(arry) - samo pri seštevanju in odštevanju
- N(egative) - najbolj pomembni bit pri rezultatu
- Z(ero) - izračuna se tako, da nad vsemi biti rezultata izvede operacijo OR in obrne vse bit, če so vsi biti 0 potem se postavi zastavica
- 16-bitni rezultat izbrane operacije

---

## op2sel

Določa kaj bo na drugem vhodu za aritmetično-logično enoto. Na voljo imamo štiri možnosti:

- op2sel=treg (vhod beremo iz registra 'treg')
- op2sel=imm (vhod beremo iz takojšnjega registra)
- op2sel=0 (vhod je konstanta 0)
- op2sel=1 (vhod je konstanta 1)

---

## regsrc

Določa kaj bo vir za 'regval', na voljo imamo štiri možnosti:

- regsrc=dbus (beremo iz podatkovnega vodila)
- regsrc=imm (beremo iz takojšnjega registra)
- regsrc=aluout (beremo iz izhoda aritmetično-logične enote)
- regsrc=sreg (beremo iz 'sreg' registra)
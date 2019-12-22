# Procesor MiMo

## Sestava

- 16-bitno naslovno vodilo
- 16-bitno podatkovno vodilo
- 8 splošnih 16-bitnih registrov
- ALE, ki podpira 16 različnih operacij
- ukazni register
- takojšnji register
- ukazi so 16-bitni

## Ukaz

- 7-bitna operacijska koda (MSB)
- 3-bitni t-register (ponavadi drugi operand za ALE)
- 3-bitni s-register (ponavadi prvi operand za ALE)
- 3-bitni d-register (LSB, ponavadi izhod od ALE)

Dodatni ukazi so 32-bitni, kjer je prvih 16 bitov enakih kot zgoraj, drugih 16 bitov pa je 16-bitna vrednost.

## Pomnilnik

- RAM drži 2^16 besed, ki so 16-bitne.
- Naslovno vodilo kontroliramo s pomočjo multiplekserja, ki je povezan na programski števec.
- Podatkovno vodilo je povezano z:
  - takojšnjim registrom
  - ukaznim registrom
  - multiplekserjom, ki je povezan s splošnimi registri
- Dva izhoda iz splošnih registrov gresta kot vhod v ALE

## Splošni registri

- Imamo 8 16-bitnih splošnih registrov
- 'dsel', 'tsel' in 'ssel' kontrolne linije določajo kateri izmed osmih registrov bo postal d|s|t register.
- d-register se ponavadi uporablja za shranjevanje izhoda ALE
- s-register in t-register se uporabljata za vhod v ALE
- v 'regval' pišemo takrat, ko imamo prižgano eno izmed dwrite|swrite|twrite linij
- vhod za 'regval' določimo z uporabo 'regsrc' linije

## Takojšnji register

- 16-bitni takojšnji register ni viden programerju
- ponavadi vsebuje drugih 16 bitov pri 32-bitnih ukazih
- uporabi se takrat ko prižgemo imload=1

## Ukazni register

- 16-bitni ukazni register se uporabi takrat, ko prižgemo irload=1
- 16-bitni ukaz razbije na 7-bitno operacijsko kodo in 3x 3-bitne kontrolne linije dsel|ssel|tsel
- bit splitter 16 -> (7,3,3,3)

## Programski števec

- 16-bitni register, ki se napolni ko prižgemo pcload=1
- nova vrednost se izbere glede na kontrolno linijo pcsel
  - pc|imm|pc+imm|sreg

## Podatkovno vodilo

- Podatki -> RAM -> IM, IR, Registri
- Če prižgemo kontrolno linijo datawrite=1, lahko pišemo v RAM, kontrolna linija 'datasel' izbere kaj bomo pisali
  - trenutno vrednost programskega števca
  - d-register
  - t-register
  - izhod ALE
- d-register uporabimo za ukaze kot so 'store word'

## Naslovno vodilo

- 16-bitno naslovno vodilo pridobi vrednost iz enega od štirih vhodov, ki jih kontrolira 'addrsel' kontrolna linija
  - pc, imm, ale, sreg

## Kontrolne linije

- aluop
- op2sel
- datawrite
- addrsel
- pcsel
- pcload
- dwrite
- irload
- imload
- regsrc
- cond
- indexsel
- datasel
- swrite
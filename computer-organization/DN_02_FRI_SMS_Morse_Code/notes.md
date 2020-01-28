# OR Zapiski

## PIO (Parallel input/output)

### Registri z informacijo o stanju

- PSR (PIO Status Register): 1 - digitalni vhod/izhod, 0 - naprava AB
- OSR (Output Status Register): 1 - izhod omogočen / 0 vhod omogočen
- ODSR (Output Data Status Register): stanje izhoda 1 / 0
- MDSR (Multiple Drive Status Register):
  - 1: open drain
  - 2: totem pole
- PUSR (Pull Up Status Register): uporabne za vhode
  - 1: omogočen
  - 2: onemogočen

### Registri za nastavitve delovanja

- PER (PIO Enable Register):
  - 1: nastavi kot digialni vhod/izhod
  - 0: ni spremembe delovanja
- PDR (PIO Disable Register):
  - 1: nastavi kot napravo AB
  - 0: ni spremembe delovanja
- OER (Output Enable Register):
  - 1: nastavi kot izhod
  - 0: ni spremembe delovanja
- ODR (Output Disable Register):
  - 1: onemogočen izhod (dela kot vhod)
  - 0: ni spremembe delovanja
- SODR (Set Output Data Register):
  - 1: nastavi stanje izhoda na 1
  - 0: ni spremembe delovanja
- CODR (Clear Output Data Register):
  - 1: nastavi stanje izhoda na 0
  - 0: ni spremembe delovanja

### Spreminjanje bitov v registrih

- en statusni register
- dva pomožna registra za postavljanje/brisanje bitov
- koraki za krmiljenje izhoda
  - PER = 1
  - OER = 1
  - SODR/CODR = 1/0
# Navodila za uporabo

Datoteko bezier.html odpremo v brskalniku, ob nalaganju dokumenta se naložijo vse potrebne funkcije za delovanje programa.

## Dodajanje točk in risanje krivulj

S klikom na katerokoli mesto na platnu označenem z mrežo, dodamo na platno točko. Ko je dodanih dovolj točk, se izriše krivulja. Posamezne točke lahko poljubno premikamo z miško (drag and drop). Ko prestavimo miško na točko, ki je na voljo za premik se bo kazalec miške spremenil in s tem nakazal, da se točko lahko zagrabi in premakne.

## Sprememba barve krivulje

Ko je krivulja narisana, ji lahko spremenimo barvo s pritiskom na "color picker". Ob spremembi barve se bo v konzolo izpisala stara in nova barva krivulje.

## Brisanje krivulj

S pritiskom na tipko "delete" se izbriše zadnja narisana krivulja, vedno se briše samo zadnja krivulja in to samo takrat ko je na voljo dovolj točk. Npr. če imamo na platnu 6 točk, se bo ob poskusu brisanja krivulje v konzolo izpisalo sporočilo, da brisanje ni možno. Brisanje je možno samo takrat, ko so vse točke na platnu del vsaj ene krivulje.

## Dvojni klik z miško

Ob dvojnem kliku se ponastavi celotno platno. (uporabljeno predvsem za testiranje)

## Dodatne informacije

- Levo spodajo se v realnem času izpisujejo:
  - koordinate miške na platnu
  - število dodanih točk in krivulj.
- Točke so označene s številkami v vrstnem redu v katerem so bile dodane
- Interpolirane in aproksimirane točke so ustrezne označene (krogec, kvadratek)

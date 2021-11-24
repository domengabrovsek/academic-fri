import collections
knjiga = {
     "Ana":
         ["pometanje stopnic", "jezikanje", "kuhanje kosila", "pretep z bratom", "pometanje stopnic", "kuhanje kosila"],
     "Benjamin":
         ["brisanje mize", "jezikanje", "prepisana naloga", "pretep s sestro"],
     "Cilka":
         [],
     "Dani":
         ["prepir z mamo", "kuhanje kosila", "kuhanje kosila"],
     "Eva":
         ["pretep z bratom", "nenarejena naloga"],
     "Franc":
         ["pomivanje posode", "brisanje mize", "pometanje stopnic",
          "kuhanje kosila", "kuhanje kosila", "pometanje stopnic"],
     "Greta":
         ["pometanje stopnic", "jezikanje"],
     "Helga":
         ["pometanje stopnic", "jezikanje", "kuhanje kosila", "prepir z mamo", "pometanje stopnic", "kuhanje kosila"],
 }


tockovalnik = {
    'pometanje stopnic': 3,
    'kuhanje kosila': 5,
    'pomivanje posode': 3,
    'brisanje mize': 1,
    'pretep z bratom': -3,
    'pretep s sestro': -3,
    'prepir z mamo': -5,
    'nenarejena naloga': -4,
    'prepisana naloga': -7,
    'jezikanje': -4
}
zelje = {
    'zvezek',
    'lok za violino',
    'barvice'
}
cena = {
    'sanke': 20,
    'zvezek': 5,
    'lok za violino': 30,
    'barvice': 7,
    'bomboni': 3
}


def oceni(dela):
    return sum([tockovalnik[el] for el in dela])

def povzetek_knjige(stran):
    return {ime: oceni(vrednost) for ime, vrednost in stran.items()}

def izberi(dela,spisek):
    return {darila for darila,cene in cena.items() if darila in spisek and cene < oceni(dela)}

def strosek(dela,spisek):
    return sum([cene for darila,cene in cena.items() if darila in izberi(dela,spisek)])

def najpridnejsi_otrok(knjiga):
    return ([el for el,vr in povzetek_knjige(knjiga).items() if vr == max(povzetek_knjige(knjiga).values())])

def poreden(dela):
    return any([True if vr <= -5 and el in dela else False for el,vr in tockovalnik.items()])

def obdarovani(knjiga):
    return {ime for ime,vrednost in knjiga.items() if poreden(vrednost) == False}


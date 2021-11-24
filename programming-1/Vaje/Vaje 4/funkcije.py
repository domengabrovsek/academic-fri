def najdaljsa(s):
    najdaljsa = ''
    besede = s.split()
    for beseda in besede:
        if len(beseda) > len(najdaljsa):
            najdaljsa = beseda
    return najdaljsa

def podobnost(s1,s2):
    podobnost = 0
    for ena,dva in zip(s1,s2):
        if ena == dva:
            podobnost += 1
    return podobnost

def sumljive(s):
     besede = s.split()
     sumljive = []
     i = 0
     for beseda in besede:
         if 'a' in beseda and 'u' in beseda:
             sumljive.append(beseda)
     return sumljive

def vsi(xs):
    for el in xs:
        if el == False:
            return False
    return True

def vsaj_eden(xs):
    for el in xs:
        if el == True:
            return True
    return False

def domine(xs):
    for el in range(0,len(xs)-1):
        if xs[el][1] != xs[el+1][0]:
            return False
    return True

def vsota_seznamov(xss):
    vsote = []
    vsota = 0
    for seznam in xss:
        for st in seznam:
            vsota += st
        vsote.append(vsota)
        vsota = 0
    return vsote


def najvecji_podseznam(xss):
    vsota = 0
    najvecji = 0
    for seznam in xss:
        for st in seznam:
            vsota += st
        if vsota > najvecji:
            najvecji = vsota
            naj_seznam = seznam
        vsota = 0
    return naj_seznam

def mrange(start,faktor,dolzina):
    izpis = start
    seznam = []
    for i in range(dolzina):
        seznam.append(izpis)
        izpis *= faktor
    return seznam

def cezar(s):
    kljuc = 3
    sifra = ""
    for beseda in s:
        for crka in beseda:
            if crka == ' ':
                sifra += (crka)
            else:
                sifra += (chr(ord(crka) + kljuc))
    return sifra

def slikaj(f,xs):
    seznam = []
    for el in xs:
        seznam.append(f(el))
    return seznam

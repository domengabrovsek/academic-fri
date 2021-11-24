from math import sqrt
from collections import defaultdict

otroci = [(0, 0), (1, 0), (0, 1), (0, 5), (0, 6), (0, 7), (5, 0), (5, 1), (5, 2)]

def razdalja(s,t):
    return abs(sqrt(sum([((s[x]-t[x])**2) for x in range(0,len(t))])))

def najblizji(x,s):
    return min([t for t,r in {terka: razdalja(terka,x) for terka in list(s)}.items() if r == min({terka: razdalja(terka,x) for terka in list(s)}.values())])

def pop_razdalja(x,s):
    return sum([razdalja(terka,x) for terka in list(s)]) / len([razdalja(terka,x) for terka in list(s)])

def center(s):
    return min([t for t,r in {x: pop_razdalja(x,list(s)) for x in list(s)}.items() if r == min({x: pop_razdalja(x,list(s)) for x in list(s)}.values())])

def tezisce(s):
    return tuple([sum([terka[n] for terka in s]) / len([terka[n] for terka in s]) for n in range(0,len(list(s)[0]))])

def razdeli(xs,s):
    slovar = {center: set() for center in xs}
    for otrok in s:
        slovar[najblizji(otrok,xs)].add(otrok)
    return slovar

def poisci_centre(ss):
    return {center(mnozica) for mnozica in ss}

def nacrtuj(s,k):
    nov_center = star_center = {otrok for otrok,st in zip(s,range(0,k))}
    while True:
        star_center = nov_center
        slovar = razdeli(star_center,s)
        nov_center = poisci_centre(slovar.values())
        if star_center == nov_center:
            break
    return slovar

import os
import collections
seznam = ["cilka","ema","dani","ana","berta"]

def preberi_datoteko(ime):
    file = open(os.getcwd()+"\\pisma\\" + ime + ".txt")
    s = file.readlines()
    mnozica = set()
    [mnozica.add(el.strip()) for el in s]
    return mnozica

def pisci():
    imena = set()
    for el in os.listdir(os.getcwd() + "\\pisma\\"):
        imena.add(el.strip(".txt"))
    return imena

def zelje(imena):
    slovar = collections.defaultdict(int)
    for ime in imena:
        slovar[ime] = preberi_datoteko(ime)
    return slovar

def prestej_stvari(spiski):
    seznam = []
    for el in spiski.values():
        for x in el:
            seznam.append(x)
    return collections.Counter(seznam)

def izpisi_stvari(stvari):
    for stvar,st in stvari.items():
        print ("{stvar:.<20}{st}".format(stvar=stvar,st=st))

def podobnosti(imena):
    s = []
    p = []
    x = 0
    k = 1
    for ime,vrednosti in zelje(imena).items():
        s.append([ime,vrednosti])
    for i in range(0,len(s)-1):
        x+=1
        for j in range(x,len(s)):
            enako = 0
            otrok1 = s[i][0]
            otrok2 = s[j][0]
            zelje1 = s[i][1]
            zelje2 = s[j][1]
            for stvar in zelje1:
                if stvar in zelje2:
                    enako += 1
            podoben = enako / (len(zelje1) + len(zelje2) - enako)
            p.append((podoben, (s[i][0], s[j][0])))
            p = sorted(p, reverse = True)
    for el in p:
        if k < 3:
            if el[1][0] > el[1][1]:
               print("{:>10} : {:<10}{:>.2}".format(el[1][1], el[1][0], el[0]))
            else:
                print("{:>10} : {:<10}{:>.2}".format(el[1][0], el[1][1], el[0]))
        if k >= 3 and el[0] == p[2][0]:
            if el[1][0] > el[1][1]:
                print("{:>10} : {:<10}{:>.2}".format(el[1][1], el[1][0], el[0]))
            else:
                print("{:>10} : {:<10}{:>.2}".format(el[1][0], el[1][1], el[0]))
        k += 1



from random import randint

def dopolni(polje,visina):
    for x in range(len(polje)):
        for y in range((visina-len(polje[x]))):
            polje[x].append(randint(1,5))

def izpisi(polje):
    s = ""
    for y in range(-1,len(polje[0])*-1-1,-1):
        for x in range(len(polje)):
            if len(polje[x]) > 1:
                s += "".join(str(polje[x][y]))
            elif len(polje[x]) == 1:
                s+= "".join(str(polje[x][0]))
        s+="\n"
    return s

def pobrisi_barvo(barva,polje):
    for x in range(len(polje)-1,-1,-1):
        for y in range(len(polje[0])-1,-1,-1):
            if polje[x][y] == barva:
                del polje[x][y]

def pobrisi_pot(pot,polje):
    for x,y in reversed(sorted(pot)):
        del polje[x][y]

def preveri_pot(pot,polje):
    seznam = []

    # pot je dolga vsaj 2 točki
    if len(pot) >= 2:
        seznam.append(True)
    else:
        seznam.append(False)

    #v vsakem koraku gre pot gor,dol,levo ali desno
    temp = []
    for n in range(len(pot)-1):
        if pot[n+1][0] == pot[n][0]+1 and pot[n+1][1] == pot[n][1]: #premik v desno
            temp.append(True)
        elif pot[n+1][0] == pot[n][0]-1 and pot[n+1][1] == pot[n][1]: #premik v levo
            temp.append(True)
        elif pot[n+1][1] == pot[n][1]+1 and pot[n+1][0] == pot[n][0]: #premik gor
            temp.append(True)
        elif pot[n+1][1] == pot[n][1]-1 and pot[n+1][0] == pot[n][0]: #premik dol
            temp.append(True)
        else:
            temp.append(False)
    seznam.append(all(temp))

    #nobeno polje se ne ponovi, izjema prvo polje enako zadnjemu
    if sorted(list(set(pot))) != sorted(pot):
        if pot[0] == pot[-1] and sorted(list(set(pot[1:-1]))) == sorted(pot[1:-1]):
            seznam.append(True)
        else:
            seznam.append(False)
    else:
        seznam.append(True)

    #celotna pot se nahaja znotraj polja
    meja_x = len(polje) - 1
    meja_y = len(polje[0]) - 1
    for x,y in pot:
        if x > meja_x or x < 0 or y > meja_y or y < 0:
            seznam.append(False)
            break
    else:
        seznam.append(True)

    # pot teče prek točk iste barve
    if all(seznam) == True:
        barva = polje[pot[0][0]][pot[0][1]]
        for x,y in pot:
            if polje[x][y] != barva:
                seznam.append(False)
                break
        else:
            seznam.append(True)

    return all(seznam)

def pot_iz_koordinat(opis):
    x = int(opis[0])
    y = int(opis[1])
    seznam = [(x,y)]

    for n in opis[2:]:
        if n == "L":
            x-=1
        elif n == "R":
            x+=1
        elif n == "U":
            y+=1
        elif n == "D":
            y-=1
        seznam.append((x,y))
    return(seznam)

def ni_sosednjih(polje):
    for x in range(len(polje)):
        for y in range(len(polje[0])):
            seznam = [(x,y+1),(x,y-1),(x+1,y),(x-1,y)]
            for m,n in seznam:
                if m >= 0 and n >= 0 and m < len(polje) and n < len(polje[0]):
                    if polje[x][y] == polje[m][n]:
                        return False
    else:
        return True

def igra():
    n = 6 # stevilo polj
    polje = [[] for i in range(n)]
    dopolni(polje,n)
    while ni_sosednjih(polje) == False:    # dokler so sosednje točke različnih barv, se igra izvaja
        print(izpisi(polje))
        opis = input("Vnesi pot:")
        pot = pot_iz_koordinat(opis)
        if preveri_pot(pot,polje) == False:
            print("Neveljavna pot")
        else:
            #print(polje[pot[0][0]][pot[0][1]])   izpise katero barvo mora pobrisat
            pobrisi_pot(pot,polje)
            #pobrisi_barvo(polje[pot[0][0]][pot[0][1]],polje)   ne dela, index out of range ????
            dopolni(polje,n)
    print("Konec igre, ni več sosednjih pik iste barve")

igra()

imena = ['Ana', 'Berta']
teze = [55,60]
visine = [165,153]
xs = ['Maja','Janja','Sabina','Ina','Jasna']

def naj(xs):
    max = xs[0]
    for el in xs:
        if el > max:
            max = el
    return max

def naj_abs(xs):
    max = xs[0]
    for el in xs:
        if abs(el) > abs(max):
            max = el
    return max

def ostevilci(xs):
    seznam = []
    i = 0
    for el in xs:
        seznam.append((i,el))
        print(i)
        i += 1
    return seznam

def palindrom(s):
    if s[::-1] == s:
        return True
    else:
        return False

def palindromska_stevila():
    max = 0
    for i in range(380,1000):
        for j in range(380,1000):
            x = str(i*j)
            if str(x[0]) == str(x[5]) and str(x[1]) == str(x[4]) and str(x[2]) == str(x[3]):
                if int(x) > int(max):
                    max = x
    return max

def bmi(osebe):
    seznam_bmi = []
    for el in osebe:
        seznam_bmi.append( ( el[0],el[1]/((el[2]/100) **2) ) )
    return seznam_bmi

def bmi_2(imena, teze, visine):
    bmi = []
    seznam = []
    for el_teze,el_visine in zip(teze,visine):
        bmi.append(el_teze / (el_visine/100) ** 2)
    for el_imena,el_bmi in zip(imena,bmi):
        seznam.append((el_imena,el_bmi))
    return seznam

def inverzije(xs):
    inv = 0
    for j in range(len(xs)):
        for i in range(len(xs)):
            if xs[j] > xs[i] and j < i:
                inv += 1
    print (inv)

def an_ban_pet_podgan(xs):
    izs = 0
    x = len(xs)
    i = 0
    while i <= x:
        if len(xs) == 1:
            break
        izs += 1

        if izs == 12:
            izs = 0
            del(xs[i])
            i = 0
        i+=1
        if i == len(xs):
            i = 0
    for el in xs:
        print(el)
    return

def nekineki(xs):
    for i in range(len(xs)):
        if len(xs) == 1:
            break
        del(xs[12%len(xs)])
    for el in xs:
        print (el)
    return


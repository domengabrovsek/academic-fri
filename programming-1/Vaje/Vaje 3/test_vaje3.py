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
    return int(max)


def bmi(osebe):
    seznam_bmi = []
    for el in osebe:
        seznam_bmi.append( ( el[0],el[1]/((el[2]/100) **2) ) )
    return seznam_bmi

def bmi2(imena, teze, visine):
    bmi = []
    seznam = []
    for el_teze,el_visine in zip(teze,visine):
        bmi.append(el_teze / (el_visine/100) ** 2)
    for el_imena,el_bmi in zip(imena,bmi):
        seznam.append((el_imena,el_bmi))
    return seznam

def prastevila(n):
    cnt = 0
    for j in range(2, n):
        for i in range(2, int(math.sqrt(j)) + 1):
            if j % i == 0:
                break
        else:
            cnt += 1
    return cnt

def inverzije(xs):
    inv = 0
    for j in range(len(xs)):
        for i in range(len(xs)):
            if xs[j] > xs[i] and j < i:
                inv += 1
    return inv

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

def an_ban_pet_podgan(xs):
    i = 0
    for j in range(len(xs) - 1):
        i = (i + 10) % len(xs)
        xs.pop(i)
    return xs[0]


### ^^^ Naloge rešujte nad tem komentarjem. ^^^ ###

import unittest
import math

class TestVaje(unittest.TestCase):
    def test_naj(self):
        in_out = [
            ([1], 1),
            ([-1], -1),
            ([5, 1, -6, -7, 2], 5),
            ([1, -6, -7, 2, 5], 5),
            ([-5, -1, -6, -7, -2], -1),
            ([1, 2, 5, 6, 10, 2, 3, 4, 9, 9], 10),
            ([-10**10, -10**9], -10**9),
        ]
        for i, o in in_out:
            self.assertEqual(naj(i), o)

    def test_naj_abs(self):
        in_out = [
            ([1], 1),
            ([-1], -1),
            ([10, 12, 9], 12),
            ([0, 0, 0, 0, 0], 0),
            ([5, 1, -6, -7, 2], -7),
            ([1, -6, 5, 2, -7], -7),
            ([-5, -1, -6, -7, -2], -7),
            ([100, 1, 5, 3, -90, 3], 100),
            ([-100, 1, 5, 3, -90, 3], -100),
            ([-10**10, -10**9], -10**10),
            ([1, 2, 5, 6, 10, 2, 3, 4, 9, 9], 10),
            ([1, 2, 5, 6, -10, 2, 3, 4, 9, 9], -10),
        ]
        for i, o in in_out:
            self.assertEqual(naj_abs(i), o)
    
    def test_ostevilci(self):
        in_out = [
            ([], []),
            ([1], [(0, 1)]),
            ([5, 1, 4, 2, 3], [(0, 5), (1, 1), (2, 4), (3, 2), (4, 3)]),
        ]
        for i, o in in_out:
            self.assertEqual(ostevilci(i), o)

    def test_bmi(self):
        in_out = [
            ([], []),
            ([('Ana', 55, 165), ('Berta', 60, 153)],
                [('Ana', 20.202020202020204), ('Berta', 25.63116749967961)]),
            ([('Ana', 55, 165), ('Berta', 60, 153), ('Cilka', 70, 183)],
                [('Ana', 20.202020202020204), ('Berta', 25.63116749967961), ('Cilka', 20.902385858042937)]),
        ]
        for i, o in in_out:
            for (nu, bu), (n, b) in zip(bmi(i), o):
                self.assertEqual(nu, n)
                self.assertAlmostEqual(bu, b)

    def test_bmi2(self):
        in_out = [
            (([], [], []), []),
            ((['Ana', 'Berta'], [55, 60], [165, 153]),
                [('Ana', 20.202020202020204), ('Berta', 25.63116749967961)]),
            ((['Ana', 'Berta', 'Cilka'], [55, 60, 70], [165, 153, 183]),
                [('Ana', 20.202020202020204), ('Berta', 25.63116749967961), ('Cilka', 20.902385858042937)]),
        ]
        for i, o in in_out:
            for (nu, bu), (n, b) in zip(bmi2(*i), o):
                self.assertEqual(nu, n)
                self.assertAlmostEqual(bu, b)

    def test_prastevila(self):
        in_out = [
            (10, 4),
            (11, 4),
            (12, 5),
            (50, 15),
            (100, 25),
            (1000, 168),
        ]
        for i, o in in_out:
            self.assertEqual(prastevila(i), o)

#    def test_prastevila_hard(self):
#        'Težji testi za nalogo praštevila'
#
#        in_out = [
#            (10**6, 78498),
#            (10**7, 664579),
#        ]
#        for i, o in in_out:
#            self.assertEqual(prastevila(i), o)

    def test_palindrom(self):
        in_out = [
            ('', True),
            ('a', True),
            ('aa', True),
            ('ab', False),
            ('aba', True),
            ('abc', False),
            ('abcdefedcba', True),
            ('abcdefgedcba', False),
            ('pericarezeracirep', True),
            ('perica', False),
        ]
        for i, o in in_out:
            self.assertEqual(palindrom(i), o)

    def test_palindromska_stevila(self):
        self.assertEqual(palindromska_stevila(), 906609)

    def test_inverzije(self):
        in_out = [
            ([], 0),
            ([1], 0),
            ([1, 2], 0),
            ([2, 1], 1),
            ([3, 2, 1], 3),
            ([4, 3, 2, 1], 6),
            ([5, 4, 3, 2, 1], 10),
            ([1, 4, 3, 5, 2], 4),
            ([10, 3, 9, 2, 22, 42, 0, 88, 66], 12),
        ]
        for i, o in in_out:
            self.assertEqual(inverzije(i), o)

    def test_an_ban_pet_podgan(self):
        in_out = [
            (["Maja"], "Maja"),
            (["Maja", "Janja", "Sabina"], "Maja"),
            (["Maja", "Janja", "Sabina", "Ina"], "Ina"),
            (["Maja", "Janja", "Sabina", "Ina", "Jasna"], "Jasna"),
            (["Maja", "Janja", "Sabina", "Ina", "Jasna", "Mojca"], "Ina"),
            (["Maja", "Janja", "Sabina", "Ina", "Jasna", "Mojca", "Tina"], "Maja"),
        ]
        for i, o in in_out:
            self.assertEqual(an_ban_pet_podgan(i), o)
        
if __name__ == '__main__':
    unittest.main(verbosity=2)

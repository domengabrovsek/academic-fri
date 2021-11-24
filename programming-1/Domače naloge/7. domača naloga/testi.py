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

import unittest
import os
import sys
import io
import collections


class TestMiklavz(unittest.TestCase):
    cwd = os.getcwd()

    @classmethod
    def setUpClass(cls):
        cls.unmake_franc()

    @classmethod
    def make_franc(cls):
        open(os.path.join(cls.cwd, "pisma/franc.txt"), "wt")

    @classmethod
    def unmake_franc(cls):
        try:
            os.remove(os.path.join(cls.cwd, "pisma/franc.txt"))
        except IOError:
            pass

    def test_preberi_datoteko(self):
        self.assertSetEqual(preberi_datoteko("ana"),
                            {'sanke', 'zvezek', 'pero'})
        try:
            self.make_franc()
            self.assertSetEqual(preberi_datoteko("franc"), set())
        finally:
            self.unmake_franc()

    def test_pisci(self):
        self.assertSetEqual(
            pisci(),
            {"ana", "berta", "cilka", "dani", "ema"})
        self.assertSetEqual(
            pisci(),
            {"ana", "berta", "cilka", "dani", "ema"})
        try:
            self.make_franc()
            self.assertSetEqual(
                pisci(),
                {"ana", "berta", "cilka", "dani", "ema", "franc"})
        finally:
            self.unmake_franc()
        self.assertSetEqual(
            pisci(),
            {"ana", "berta", "cilka", "dani", "ema"})

    def test_zelje(self):
        self.assertDictEqual(
            zelje(["ana"]),
            {"ana": {'sanke', 'pero', 'zvezek'}})
        self.assertDictEqual(
            zelje(["cilka", "ema"]),
            {'cilka': {'notni zvezek', 'lok za violino'},
             'ema': {'copati', 'glavnik'}}
        )
        self.assertDictEqual(
            zelje(["ana", "berta", "cilka", "dani", "ema"]),
            {'ana': {'sanke', 'pero', 'zvezek'},
             'berta': {'copati', 'zvezek'},
             'cilka': {'notni zvezek', 'lok za violino'},
             'dani': {'zvezek', 'orglice', 'glavnik'},
             'ema': {'copati', 'glavnik'}
             }
        )
        try:
            self.make_franc()
            self.assertDictEqual(zelje(["franc"]), {"franc": set()})
            self.assertDictEqual(
                zelje(["ana", "berta", "cilka", "dani", "ema"]),
                {'ana': {'sanke', 'pero', 'zvezek'},
                 'berta': {'copati', 'zvezek'},
                 'cilka': {'notni zvezek', 'lok za violino'},
                 'dani': {'zvezek', 'orglice', 'glavnik'},
                 'ema': {'copati', 'glavnik'}
                 }
            )
        finally:
            self.unmake_franc()

    def test_prestej_stvari(self):
        self.assertDictEqual(
            prestej_stvari({'ana': {'sanke', 'pero', 'zvezek'},
                            'berta': {'copati', 'zvezek'},
                            'cilka': {'notni zvezek', 'lok za violino'},
                            'dani': {'zvezek', 'orglice', 'glavnik'},
                            'ema': {'copati', 'glavnik'}
                            }),
            {'zvezek': 3, 'glavnik': 2, 'copati': 2, 'pero': 1,
             'notni zvezek': 1, 'sanke': 1, 'lok za violino': 1, 'orglice': 1}
        )
        self.assertDictEqual(
            prestej_stvari({'ana': {'sanke', 'pero', 'zvezek'},
                            'cilka': {'notni zvezek', 'lok za violino'},
                            'dani': {'zvezek', 'orglice', 'glavnik'}
                            }),
            {'zvezek': 2, 'glavnik': 1, 'pero': 1,
             'notni zvezek': 1, 'sanke': 1, 'lok za violino': 1, 'orglice': 1}
        )
        self.assertDictEqual(
            prestej_stvari({'ana': {'sanke', 'pero', 'zvezek'},
                            'cilka': {'notni zvezek', 'lok za violino'},
                            'dani': {'zvezek', 'orglice', 'glavnik'},
                            'franc': set()
                            }),
            {'zvezek': 2, 'glavnik': 1, 'pero': 1,
             'notni zvezek': 1, 'sanke': 1, 'lok za violino': 1, 'orglice': 1}
        )
        self.assertDictEqual(
            prestej_stvari({'ana': {'sanke', 'pero', 'zvezek'},
                            'franc': set()
                            }),
            {'pero': 1, 'sanke': 1, 'zvezek': 1}
        )
        self.assertDictEqual(
            prestej_stvari({'ana': {'sanke', 'pero', 'zvezek'},
                            }),
            {'pero': 1, 'sanke': 1, 'zvezek': 1}
        )
        self.assertDictEqual(
            prestej_stvari({'franc': set()}), {})
        self.assertDictEqual(
            prestej_stvari({}), {})

    def test_izpisi_stvari(self):
        try:
            stdout = sys.stdout

            sys.stdout = io.StringIO()
            izpisi_stvari({'zvezek': 3, 'glavnik': 2, 'pero': 1,
                           'notni zvezek': 1, 'sanke': 1, 'lok za violino': 1,
                           'orglice': 1, 'copati': 2})
            self.assertSetEqual(
                set(sys.stdout.getvalue().splitlines()),
                {"notni zvezek........1", "sanke...............1",
                 "orglice.............1", "glavnik.............2",
                 "lok za violino......1", "copati..............2",
                 "zvezek..............3", "pero................1"})

            sys.stdout = io.StringIO()
            izpisi_stvari({'zvezek': 3, 'glavnik': 2})
            self.assertSetEqual(
                set(sys.stdout.getvalue().splitlines()),
                {"glavnik.............2", "zvezek..............3"})

        finally:
            sys.stdout = stdout

    def test_podobnosti(self):
        try:
            stdout = sys.stdout

            sys.stdout = io.StringIO()
            podobnosti(["ana", "berta", "cilka", "dani", "ema"])
            self.assertSetEqual(
                set(sys.stdout.getvalue().splitlines()),
                {"     berta : ema       0.33",
                 "      dani : ema       0.25",
                 "     berta : dani      0.25",
                 "       ana : berta     0.25"})

            sys.stdout = io.StringIO()
            podobnosti(["ana", "berta", "dani", "ema"])
            self.assertSetEqual(
                set(sys.stdout.getvalue().splitlines()),
                {"     berta : ema       0.33",
                 "      dani : ema       0.25",
                 "     berta : dani      0.25",
                 "       ana : berta     0.25"})

            sys.stdout = io.StringIO()
            podobnosti(["berta", "dani", "ema"])
            self.assertSetEqual(
                set(sys.stdout.getvalue().splitlines()),
                {"     berta : ema       0.33",
                 "      dani : ema       0.25",
                 "     berta : dani      0.25"})

        finally:
            sys.stdout = stdout


if __name__ == "__main__":
    unittest.main()

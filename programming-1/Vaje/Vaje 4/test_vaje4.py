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
    if all(xs):
        return True
    return False

def vsaj_eden(xs):
    if any(xs):
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
    naj_seznam = [0]

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
    cipher = ''
    for c in s:
        if 'a' <= c <= 'w':
            cipher += chr(ord(c) + 3)
        elif 'x' <= c <= 'z':
            cipher += chr(ord(c) - 23)
        else:
            cipher += c
    return cipher

def slikaj(f,xs):
    seznam = []
    for el in xs:
        seznam.append(f(el))
    return seznam




### ^^^ Naloge rešujte nad tem komentarjem. ^^^ ###

import unittest

def fail_msg(args):
    return 'Failed on input: {}'.format(repr(args))

class TestVaje4(unittest.TestCase):
    def test_najdaljsa(self):
        in_out = [
            ('beseda', 'beseda'),
            ('an ban', 'ban'),
            ('an ban pet podgan', 'podgan'),
            ('an ban pet podgan stiri misi', 'podgan'),
            ('ta clanek je lepo napisan', 'napisan'),
            ('123456 12345 1234 123 12 1', '123456'),
            ('12345 123456 12345 1234 123 12 1', '123456'),
            ('1234 12345 123456 12345 1234 123 12 1', '123456'),
        ]

        for i, o in in_out:
            self.assertEqual(najdaljsa(i), o, fail_msg(i))

    def test_podobnost(self):
        in_out = [
            (('sobota', 'robot'), 4),
            (('', 'robot'), 0),
            (('sobota', ''), 0),
            (('', ''), 0),
            (('a', 'b'), 0),
            (('a', 'a'), 1),
            (('aaa', 'a'), 1),
            (('amper', 'amonijak'), 2),
            (('1000 let', 'tisoc let'), 0),
            (('hamming distance', 'haming  distance'), 12)
        ]
        
        for i, o in in_out:
            self.assertEqual(podobnost(*i), o, fail_msg(i))
            self.assertEqual(podobnost(*i[::-1]), o, fail_msg(i))
            
            

    def test_sumljive(self):
        in_out = [
            ('', []),
            ('aa uu', []),
            ('aa uu au', ['au']),
            ('muha', ['muha']),
            ('Muha pa je rekla: "Tale juha se je pa res prilegla, najlepša huala," in odletela.',
             ['Muha', 'juha', 'huala,"']),
            ('ameba nima aja in uja, ampak samo a', ['uja,']),
        ]

        for i, o in in_out:
            self.assertListEqual(sumljive(i), o, fail_msg(i))

    def test_vsi(self):
        in_out = [
            ([True, True, False], False),
            ([True, True], True),
            ([1, 2, 3, 0], False),
            (['foo', 42, True], True),
            (['foo', '', 42, True], False),
            (['foo', 0.0, 42, True], False),
            (['foo', None, 42, True], False),
            (['foo', (), 42, True], False),
            (['foo', [], 42, True], False),
            ([], True),
        ]

        for i, o in in_out:
            f = self.assertTrue if o else self.assertFalse
            f(vsi(i), fail_msg(i))

    def test_vsaj_eden(self):
        in_out = [
            ([2, 3, 0], True),
            ([], False),
            ([True, False, False], True),
            ([False, False], False),
            (['foo', 42, True], True),
            ([False, 0, 0.0, '', None, (), []], False),
            ([False, 0, 0.42, '', None, (), []], True),
            ([False, 0, 0.0, '', None, (), [42]], True),
        ]

        for i, o in in_out:
            f = self.assertTrue if o else self.assertFalse
            f(vsaj_eden(i), fail_msg(i))

    def test_domine(self):
        in_out = [
            ([], True),
            ([(2, 4), (4, 4)], True),
            ([(2, 4), (4, 4), (4, 2)], True),
            ([(2, 4), (4, 4), (4, 2), (2, 9), (9, 1)], True),
            ([(2, 4), (4, 3), (4, 2), (2, 9), (9, 1)], False),
            ([(3, 6), (6, 6), (6, 1), (1, 0)], True),
            ([(3, 6), (6, 6), (2, 3)], False),
        ]

        for i, o in in_out:
            f = self.assertTrue if o else self.assertFalse
            f(domine(i), fail_msg(i))

    def test_vsota_seznamov(self):
        in_out = [
            ([], []),
            ([[]], [0]),
            ([[0]], [0]),
            ([[1, 2]], [3]),
            ([[1, 2], [], [0]], [3, 0, 0]),
            ([[2, 4, 1], [3, 1], [], [8, 2], [1, 1, 1, 1]], [7, 4, 0, 10, 4]),
            ([[5, 3, 6, 3], [1, 2, 3, 4], [5, -1, 0]], [17, 10, 4]),
        ]

        for i, o in in_out:
            self.assertEqual(vsota_seznamov(i), o, fail_msg(i))

    def test_najvecji_podseznam(self):
        in_out = [
            ([[0]], [0]),
            ([[1, 2]], [1, 2]),
            ([[1, 2], [], [0]], [1, 2]),
            ([[2, 4, 1], [3, 1], [], [8, 2], [1, 1, 1, 1]], [8, 2]),
            ([[5, 3, 6, 3], [1, 2, 3, 4], [5, -1, 0]], [5, 3, 6, 3]),
        ]

        for i, o in in_out:
            self.assertEqual(najvecji_podseznam(i), o, fail_msg(i))

    def test_cezar(self):
        in_out = [
            ('', ''),
            ('a', 'd'),
            ('aa', 'dd'),
            ('ab', 'de'),
            ('z', 'c'),
            ('xyz', 'abc'),
            (' ', ' '),
            ('a  a', 'd  d'),
            ('julij cezar je seveda uporabljal cezarjevo sifro',
             'mxolm fhcdu mh vhyhgd xsrudeomdo fhcdumhyr vliur'),
            ('the quick brown fox jumps over the lazy dog',
             'wkh txlfn eurzq ira mxpsv ryhu wkh odcb grj'),
        ]

        for i, o in in_out:
            self.assertEqual(cezar(i), o, fail_msg(i))

    def test_mrange(self):
        in_out = [
            ((32, 2, 0), []),
            ((32, 2, 1), [32]),
            ((32, 2, 2), [32, 64]),
            ((42, -1, 5), [42, -42, 42, -42, 42]),
            ((7, 4, 7), [7, 28, 112, 448, 1792, 7168, 28672]),
        ]

        for i, o in in_out:
            self.assertListEqual(mrange(*i), o, fail_msg(i))

    def test_slikaj(self):
        in_out = [
            ((abs, [-5, 8, -3, -1, 3]), [5, 8, 3, 1, 3]),
            ((len, 'Daydream delusion limousine eyelash'.split()), [8, 8, 9, 7]),
            ((int, '1 3 5 42'.split()), [1, 3, 5, 42]),
        ]

        for i, o in in_out:
            self.assertListEqual(slikaj(*i), o, fail_msg(i))

if __name__ == '__main__':
    unittest.main(verbosity=2)

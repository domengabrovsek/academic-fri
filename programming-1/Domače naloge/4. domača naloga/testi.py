def zamenjaj(s,a,b):
	s[a],s[b] = s[b],s[a]

def preuredi(s,menjave):
    i = 0
    while i < len(menjave):
        zamenjaj(s,menjave[i][0],menjave[i][1])
        i+=1

def urejen(s):
    a = list(s)
    s.sort()
    if a == s:
        return True
    else:
        return False

def ureja(s,menjave):
    preuredi(s,menjave)
    a = urejen(s)
    return a

def nacrt (s):
    x = s[:]
    menjave = []
    for i in range(len(x)):
        for k in range(len(x) - 1, i, -1):
            if(x[k] < x[k - 1]):
                zamenjaj(x,k,k-1)
                menjave.append((k,k-1))
    return menjave

import unittest
import random


class TestMenjave(unittest.TestCase):
    def test_zamenjaj(self):
        s = ["Ana", "Berta", "Cilka", "Dani", "Ema"]
        zamenjaj(s, 2, 3)
        self.assertEqual(s, ["Ana", "Berta", "Dani", "Cilka", "Ema"])
        zamenjaj(s, 0, 3)
        self.assertEqual(s, ["Cilka", "Berta", "Dani", "Ana", "Ema"])
        zamenjaj(s, 0, 1)
        self.assertEqual(s, ["Berta", "Cilka", "Dani", "Ana", "Ema"])

    def test_preuredi(self):
        s = ["Ana", "Berta", "Cilka", "Dani", "Ema"]
        menjave = [(2, 3), (0, 3), (0, 1)]
        preuredi(s, menjave)
        self.assertEqual(s, ["Berta", "Cilka", "Dani", "Ana", "Ema"])

    def test_urejen(self):
        self.assertTrue(urejen([1, 2, 3, 4]))
        self.assertTrue(urejen([1, 2, 3]))
        self.assertTrue(urejen([1, 2]))
        self.assertTrue(urejen([1]))
        self.assertTrue(urejen([]))
        self.assertTrue(urejen(list(range(100))))

        self.assertFalse(urejen([2, 1, 3, 4]))
        self.assertFalse(urejen([1, 3, 2, 4]))
        self.assertFalse(urejen([1, 2, 4, 3]))
        self.assertFalse(urejen([2, 1, 3]))
        self.assertFalse(urejen([1, 3, 2]))
        self.assertFalse(urejen([3, 1]))

    def test_ureja(self):
        s = ["Berta", "Cilka", "Dani", "Ana", "Ema"]
        self.assertTrue(ureja(s[:], [(0, 1), (0, 3), (2, 3)]))
        self.assertFalse(ureja(s[:], [(0, 1), (0, 3)]))

    def test_nacrt(self):
        for i in range(200):
            t = [random.randint(1, 100) for _ in range(10)]
            v = t[:]
            n = nacrt(t)
            self.assertEqual(t, v)
            self.assertTrue(ureja(t, n), "Nacrt ne deluje za seznam " + str(t))

        t = [3, 4, 4, 2, 1, 5, 2, 3, 2, 2]
        n = nacrt(t)
        self.assertTrue(ureja(t, n), "Nacrt ne deluje za seznam " + str(t))

if __name__ == '__main__':
    unittest.main()
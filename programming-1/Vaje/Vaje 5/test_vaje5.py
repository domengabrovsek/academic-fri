family = [('bob', 'mary'), ('bob', 'tom'), ('bob', 'judy'), ('alice', 'mary'),
    ('alice', 'tom'), ('alice', 'judy'), ('renee', 'rob'), ('renee', 'bob'),
    ('sid', 'rob'), ('sid', 'bob'), ('tom', 'ken'), ('ken', 'suzan'), ('rob', 'jim')]

def family_tree(family):
    slovar = collections.defaultdict(list)
    for parent,child in family:
        slovar[parent].append(child)
    return slovar

def children(tree,name):
    return family_tree(family)[name]

def grandchildren(tree,name):
    parents = children(family_tree,name)
    s = []
    for parent in parents:
        for child in(children(family_tree,parent)):
            s.append(child)
    return s

def najpogostejse(s):
    seznam = ()
    znak = collections.Counter(s)
    beseda = collections.Counter(s.split())
    return (max(beseda,key=beseda.get), str((max(znak,key=znak.get))))

# iz resitev
def freq(xs):
    hist = {}
    for x in xs:
        if x not in hist:
            hist[x] = 0
        hist[x] += 1
    return hist

def max_sorted(f):
    xs = []
    for k, v in f.items():
        xs.append((-v, k))
    xs.sort()

    ys = []
    for k, v in xs:
        ys.append(v)
    return ys

def najpogostejse_urejene(s):
    return max_sorted(freq(s.split())), max_sorted(freq(s))


def nasledniki(txt):
    words = txt.split()
    freq = collections.defaultdict(list)
    for word, next_word in zip(words, words[1:]):
        freq[word].append(next_word)
    return freq

def successors(tree, name):
    names = []
    for child in children(tree, name):
        names.append(child)
        names.extend(successors(tree, child))
    return names

def tekst(freq, besed):
    words = []
    all_words = list(freq.keys())
    word = random.choice(all_words)
    for i in range(besed):
        words.append(word)
        word = random.choice(freq.get(word, all_words))
    return ' '.join(words)

def sifriraj(niz, kljuc):
    return ''.join(chr(ord(c) ^ (kljuc // 256**(i % 2) % 256)) for i, c in enumerate(niz))

def sifra(niz):
    # Zgradimo množico vseh angleških besed.
    words = set()
    with open('Usr.Dict.Words') as f:
        for word in f:
            words.add(word.strip())

    # Sprehodimo se po vseh možnih ključih.
    for k in range(65536):
        plain = sifriraj(niz, k)
        for w in plain.split():
            if w not in words:
                break
        else:
            return plain


import unittest
import collections
import random

class TestNaloge5(unittest.TestCase):
    def setUp(self):
        self.tree = {
            'alice': ['mary', 'tom', 'judy'],
            'bob': ['mary', 'tom', 'judy'],
            'ken': ['suzan'],
            'renee': ['rob', 'bob'],
            'rob': ['jim'],
            'sid': ['rob', 'bob'],
            'tom': ['ken']}

    def assertDictCounterEqual(self, first, second, msg=None):
        def dict_counter(d):
            d_copy = dict(d)
            for k, v in d_copy.items():
                d_copy[k] = collections.Counter(v)
            return d_copy
        self.assertDictEqual(dict_counter(first), dict_counter(second), msg)

    def test_family_tree(self):
        family = [
        ('bob', 'mary'),
        ('bob', 'tom'),
        ('bob', 'judy'),
        ('alice', 'mary'),
        ('alice', 'tom'),
        ('alice', 'judy'),
        ('renee', 'rob'),
        ('renee', 'bob'),
        ('sid', 'rob'),
        ('sid', 'bob'),
        ('tom', 'ken'),
        ('ken', 'suzan'),
        ('rob', 'jim')]
        self.assertDictCounterEqual(family_tree(family), self.tree)

    def test_children(self):
        self.assertCountEqual(children(self.tree, 'alice'), ['mary', 'tom', 'judy'])
        self.assertCountEqual(children(self.tree, 'mary'), [])
        self.assertCountEqual(children(self.tree, 'renee'), ['bob', 'rob'])
        self.assertCountEqual(children(self.tree, 'rob'), ['jim'])
        self.assertCountEqual(children(self.tree, 'suzan'), [])

    def test_grandchildren(self):
        self.assertCountEqual(grandchildren(self.tree, 'alice'), ['ken'])
        self.assertCountEqual(grandchildren(self.tree, 'bob'), ['ken'])
        self.assertCountEqual(grandchildren(self.tree, 'ken'), [])
        self.assertCountEqual(grandchildren(self.tree, 'mary'), [])
        self.assertCountEqual(grandchildren(self.tree, 'renee'), ['jim', 'mary', 'tom', 'judy'])
        self.assertCountEqual(grandchildren(self.tree, 'sid'), ['jim', 'mary', 'tom', 'judy'])
        self.assertCountEqual(grandchildren(self.tree, 'tom'), ['suzan'])

    def test_successors(self):
        self.assertCountEqual(successors(self.tree, 'tom'), ['ken', 'suzan'])
        self.assertCountEqual(successors(self.tree, 'sid'), 
            ['rob', 'bob', 'jim', 'mary', 'tom', 'judy', 'ken', 'suzan'])
        self.assertCountEqual(successors(self.tree, 'suzan'), [])
        self.assertCountEqual(successors(self.tree, 'ken'), ['suzan'])
        self.assertCountEqual(successors(self.tree, 'rob'), ['jim'])

    def test_najpogostejse(self):
        self.assertEqual(najpogostejse('a'), ('a', 'a'))
        self.assertEqual(najpogostejse('aa bb aa'), ('aa', 'a'))
        self.assertEqual(najpogostejse('in to in ono in to smo mi'), ('in', ' '))
        self.assertEqual(najpogostejse('abc abc abc abacbca'), ('abc', 'a'))
        self.assertEqual(najpogostejse('abc abc abc abacbcb'), ('abc', 'b'))
        self.assertEqual(najpogostejse('abc abc abc abacbcc'), ('abc', 'c'))

    def test_najpogostejse_urejene(self):
        self.assertEqual(najpogostejse_urejene('a'), (['a'], ['a']))
        self.assertEqual(najpogostejse_urejene('aa bb aa'), (['aa', 'bb'], ['a', ' ', 'b']))
        self.assertEqual(najpogostejse_urejene('in to in ono in to smo mi'), 
            (['in', 'to', 'mi', 'ono', 'smo'], [' ', 'o', 'i', 'n', 'm', 't', 's']))
        self.assertEqual(najpogostejse_urejene('abc abc abc abacbca'),
            (['abc', 'abacbca'], ['a', 'b', 'c', ' ']))
        self.assertEqual(najpogostejse_urejene('abc abc abc abacbcb'),
            (['abc', 'abacbcb'], ['b', 'a', 'c', ' ']))
        self.assertEqual(najpogostejse_urejene('abc abc abc abacbcc'),
            (['abc', 'abacbcc'], ['c', 'a', 'b', ' ']))

    def test_sifra(self):
        self.assertEqual(sifra('\x19\x14\x1c]\x19\x0f\x14\t\x13\x18\t]\x12\x0e[\n\x1a\t\x18\x15\x12\x13\x1c'),
            'big brother is watching')
        self.assertEqual(sifra('\xe1d\xe0q\xe5r\xf7b\xe0i'), 'strawberry')

    def test_nasledniki(self):
        self.assertDictCounterEqual(nasledniki('in in in in'), {'in': ['in', 'in', 'in']})
        self.assertDictCounterEqual(nasledniki('in to in ono in to smo mi'), 
            {'smo': ['mi'], 'to': ['in', 'smo'], 'ono': ['in'], 'in': ['to', 'ono', 'to']})
        self.assertDictCounterEqual(nasledniki('danes je lep dan danes sije sonce'),
            {'lep': ['dan'], 'je': ['lep'], 'dan': ['danes'], 'danes': ['je', 'sije'], 'sije': ['sonce']})

    def test_tekst(self):
        self.assertEqual(tekst({'in': ['in', 'in']}, 3), 'in in in')

if __name__ == '__main__':
    unittest.main(verbosity=2)

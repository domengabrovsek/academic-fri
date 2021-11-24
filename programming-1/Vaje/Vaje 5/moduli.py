family = [('bob', 'mary'), ('bob', 'tom'), ('bob', 'judy'), ('alice', 'mary'), 
    ('alice', 'tom'), ('alice', 'judy'), ('renee', 'rob'), ('renee', 'bob'), 
    ('sid', 'rob'), ('sid', 'bob'), ('tom', 'ken'), ('ken', 'suzan'), ('rob', 'jim')]
from collections import defaultdict,Counter

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
niz = "in to in ono in to smo mi"

def najpogostejse(s):
    seznam = ()
    znak = Counter(s)
    beseda = Counter(s.split())
    return (max(beseda,key=beseda.get), str((max(znak,key=znak.get))))

def nasledniki(txt):
    tekst = defaultdict(list)
    for b in txt.split():
        tekst[b] = txt.split()
    return tekst

print(nasledniki(niz))

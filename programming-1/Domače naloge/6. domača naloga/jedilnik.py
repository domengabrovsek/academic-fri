def ena_jed(jed,jedcev):
    nov = {}
    for key,value in zip(jedi[jed].keys(),jedi[jed].values()):
        nov[key] = value * jedcev
    return nov

def nakup(obroki):
    nov = collections.defaultdict(int)
    for obrok,st in obroki:
        for key,value in zip(jedi[obrok].keys(),jedi[obrok].values()):
            nov[key] = nov[key] + value * st
    return nov

def obrokov(jed,zaloga):
    min = 100
    nov = collections.defaultdict(int)
    for key,value in zip(zaloga.keys(),zaloga.values()):
        if key in jedi[jed].keys():
            nov[key] = value
    for key1,key2 in zip(sorted(nov.keys()),sorted(jedi[jed].keys())):
        st = nov[key1] // jedi[jed][key2]
        if st < min:
            min = st
    if len(nov) < len(jedi[jed]):
        min = 0
    return min

def prazni(obroki,zaloga):
    nov = collections.defaultdict(int)

    for key in zaloga.keys():
        nov[key] = 0

    for keys in nakup(obroki).keys():
        nov[keys] = nakup(obroki)[keys]

    for key1,key2 in zip(sorted(nov.keys()),sorted(zaloga.keys())):
        zaloga[key2] = zaloga[key2] - nov[key1]
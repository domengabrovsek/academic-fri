def najdaljsa(s):
    return max(s.split(), key=len)

def podobnost(s1,s2):
    return sum([ena == dva for ena,dva in zip(s1,s2)])

def sumljive(s):
    return [b for b in s.split() if "a" in beseda and "u" in beseda]

def domine(xs):
    return vsi([xs[el][1] == xs[el+1][0] for el in range(0,len(xs)-1)])
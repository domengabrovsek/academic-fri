x = [2,5,3,4,6,8,7,6,4,2,45,3,2,1,2,4,23,90]
s = ["Ema", "Berta", "Dani", "Cilka", "Ana"]
menjave = [(2,3),(0,3)]

def zamenjaj(s,a,b):
	s[a],s[b] = s[b],s[a]

def preuredi(s,menjave):
    for i in range(len(s)):
        zamenjaj(s,menjave[i][0],menjave[i][1])

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




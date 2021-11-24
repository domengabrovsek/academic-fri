morse = {
'A': '.-',
'B': '-...',
'C': '-.-.',
'D': '-..',
'E': '.',
'F': '..-.',
'G': '--.',
'H': '....',
'I': '..',
'J': '.---',
'K': '-.-',
'L': '.-..',
'M': '--',
'N': '-.',
'O': '---',
'P': '.--.',
'Q': '--.-',
'R': '.-.',
'S': '...',
'T': '-',
'U': '..-',
'V': '...-',
'W': '.--',
'X': '-..-',
'Y': '-.--',
'Z': '--..',
'1': '.----',
'2': '..---',
'3': '...--',
'4': '....-',
'5': '.....',
'6': '-....',
'7': '--...',
'8': '---..',
'9': '----.',
'0': '-----'
}

xs = [183, 168, 175, 176, 192, 180]

def vsota_kvadratov():
    return sum([el**2 for el in range(100)])

def vsota_palindrom():
    return sum([el**2 for el in range(1000) if str(el) == str(el)[::-1]])

def subs(niz,polozaj):
    return "".join([niz[int(el)] for el in polozaj])


def mean(xs):
    return sum([x for x in xs]) /len(xs)

def txt2morse(niz,morse):







#funkcija za odvod, osnovne operacije +, -, /, *, a^b, sin, cos, exp, log
# poljski zapis 1 + 1 -> [1,1,+], 2^3 -> [2,3,^]
# poljski zapis funkcije sin(3,14) -> [3.14, 'sin'], e^2.5 -> [2.5,'exp']
# funkcija je v obliki seznama [arg1, arg2, ..., argn, fun]
# fun = (+, -, /, *, a^b, sin, cos, exp, log)
# arg = število, X, seznam [arg, ..., fun]


def odvod(f):


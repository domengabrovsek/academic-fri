import risar
from random import randint

for i in range(100):
    x0, y0 = randint(0, risar.maxX), randint(0, risar.maxY)
    x1, y1 = randint(0, risar.maxX), randint(0, risar.maxY)
    barva = risar.barva(randint(0, 255), randint(0, 255), randint(0, 255))
    sirina = randint(2, 20)
    risar.crta(x0, y0, x1, y1, barva, sirina)
    risar.stoj()
from math import *
import unittest

import risar


class Turtle:
    def __init__(self):
        self.x = risar.maxX / 2
        self.y = risar.maxY / 2
        self.angle = 0
        self.pen_active = True
        self.pause = 0
        self.body = risar.krog(0, 0, 5, risar.zelena, 3)
        self.head = risar.krog(0, 0, 2, risar.zelena, 3)
        self.update()

    def square(self,a):
        for i in range(4):
            self.forward(a)
            self.left()

    def undo(self):
        



    def update(self):
        phi = radians(90 - self.angle)
        self.body.setPos(self.x, self.y)
        self.head.setPos(self.x + 5 * cos(phi), self.y + 5 * sin(phi))
        risar.obnovi()
        if self.pause:
            self.wait(self.pause)

    def forward(self, a):
        phi = radians(90 - self.angle)
        nx = self.x + a * cos(phi)
        ny = self.y + a * sin(phi)
        if self.pen_active:
            crta = risar.crta(self.x, self.y, nx, ny)
        self.x = nx
        self.y = ny
        self.update()

    def turn(self, phi):
        self.angle += phi
        self.update()

    def backward(self, a):
        self.forward(-a)

    def left(self):
        self.turn(-90)

    def right(self):
        self.turn(90)

    def fly(self, x, y, angle):
        self.x = x
        self.y = y
        self.angle = angle
        self.update()

    def pen_up(self):
        self.pen_active = False

    def pen_down(self):
        self.pen_active = True

    def wait(self, s):
        risar.cakaj(s)

    def hide(self):
        self.body.hide()
        self.head.hide()

    def show(self):
        self.body.show()
        self.head.show()

    def set_pause(self, s):
        self.pause = s

    def no_pause(self):
        self.set_pause(0)


def z_crta(x1, y1, x2, y2, *args):
    x0, y0 = risar.maxX / 2, risar.maxY / 2
    crta = stara_crta(x1, y1, x2, y2, *args)
    tups = (x1 - x0, y1 - y0), (x2 - x0, y2 - y0)
    crta.setData(42, min(tups) + max(tups))
    return crta

stara_crta = risar.crta
risar.crta = z_crta
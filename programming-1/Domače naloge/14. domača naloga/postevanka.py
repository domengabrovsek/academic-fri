from PyQt4 import QtGui, QtCore, uic
from random import randint

class Postevanka:
    def __init__(self):
        self.beep = QtGui.QSound("beep.wav")
        self.gong = QtGui.QSound("gong.wav")
        self.dlg = uic.loadUi("dialog.ui")
        self.timer = QtCore.QTimer()

        #ustvarjanje datoteke in prikaz rekordov
        self.file = open("rekordi.txt","a")
        self.file.close()
        self.seznam = []
        self.urejen = []
        self.file = open("rekordi.txt","r")
        self.seznam = self.file.readlines()
        for self.x in self.seznam:
            self.urejen.append(int(self.x.strip()))
        if len(self.urejen) > 0:
            self.dlg.mesto1.setText(str(sorted(self.urejen)[-1]))
            if len(self.urejen) > 1:
                self.dlg.mesto2.setText(str(sorted(self.urejen)[-2]))
            if len(self.urejen) > 2:
                self.dlg.mesto3.setText(str(sorted(self.urejen)[-3]))
            if len(self.urejen) > 3:
                self.dlg.mesto4.setText(str(sorted(self.urejen)[-4]))
            if len(self.urejen) > 4:
                self.dlg.mesto5.setText(str(sorted(self.urejen)[-5]))

        self.sekunda = int(self.dlg.cas.text())
        self.timer.timeout.connect(self.odstevaj) #timer
        self.dlg.vnos.returnPressed.connect(self.odgovor) #če je pritisnjen enter
        self.dlg.vnos.setEnabled(False)
        self.dlg.zacni.clicked.connect(self.zacni) #gumb zacni
        self.dlg.show()

    #funkcija za zapis posameznega rekorda
    def rekordi(self):
        self.file = open("rekordi.txt","a")
        self.file.write(self.dlg.tocke.text())
        self.file.write("\n")

    #generiranje in prikaz računov
    def random(self):
        self.x = randint(1,9)
        self.y = randint(1,9)
        self.dlg.racun.setText(str(self.x) + " x " + str(self.y))
        self.t1 = self.sekunda #t1 - t2 = 3 sekunde

    #funkcija za odštevanje časa + sound
    def odstevaj(self):
        self.sekunda = int(self.dlg.cas.text())
        if self.sekunda > 0:
            self.sekunda -= 1
            self.dlg.cas.setText(str(self.sekunda))
            if self.sekunda <= 5:
                self.beep.play()
                if self.sekunda == 0:
                    self.gong.play()
            self.t2 = self.sekunda
            if self.t1 - self.t2 == 3: #če uporabnik ne poda odgovora v 3 sekundah se spremeni račun
                self.random()
        else:
            self.timer.stop()
            self.rekordi()
            QtGui.QMessageBox.about(self.dlg, "Game Over", "Zmanjalo vam je časa, konec igre.")
            self.dlg.vnos.setEnabled(False)
            self.dlg.zacni.setEnabled(True)

    #funkcija za preverjanje rezultatov + točke
    def odgovor(self):
        self.tocke = int(self.dlg.tocke.text())
        self.odgovor = self.dlg.vnos.text()
        if self.odgovor == str(self.x * self.y): #če je pravilen odgovor
            self.tocke += 1
            self.dlg.tocke.setText(str(self.tocke))
            self.dlg.vnos.clear()
            self.random()
        else: #če ni pravilen odgovor
            self.dlg.vnos.clear()
            self.timer.stop()
            QtGui.QMessageBox.about(self.dlg, "Game Over", "Napačen odgovor, konec igre.")
            self.rekordi()
            self.dlg.vnos.setEnabled(False)
            self.dlg.zacni.setEnabled(True)

    def zacni(self):
        self.dlg.vnos.setEnabled(True)
        self.dlg.zacni.setEnabled(False)
        self.dlg.zacni.setDefault(False)
        self.dlg.cas.setText("30")
        self.random()
        self.t1 = int(self.dlg.cas.text()) #t1 - t2 = 3
        self.timer.start(1000)
        self.dlg.tocke.setText("0")

app = QtGui.QApplication([])
postevanka = Postevanka()
app.exec()
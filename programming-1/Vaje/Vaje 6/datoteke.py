import os
import collections
def izpis():
    f = open(os.getcwd() + "\\podatki.txt" , encoding="utf8")
    for el in f.readlines():
        print (el.strip("\n"))
def izpis_2():
    seznam = []
    f = open(os.getcwd() + "\\podatki.txt", encoding ="utf8")
    for el in f.readlines():
        el = el.strip("\n")
        seznam.append((el.split(";")[0], el.split(";")[1], el.split(";")[2]))
    return seznam

def izpis_3(seznam):
    for kraj,vreme,temp in seznam:
        print("Kraj: {kraj}, Vreme: {vreme}, Temperatura: {temp}°C".format(kraj=kraj,vreme=vreme,temp=temp))

def izpis_4(seznam):
    print(" Kraj{x:<11} Vreme{x:<8} Temperatura(°C)\n {x:-<44}".format(x=""))
    for kraj,vreme,temp in seznam:
        print(" {kraj:<15}{vreme:<25}{temp:>}".format(kraj=kraj,vreme=vreme,temp=float(temp)))

def izpis_5(seznam):
    print(" Kraj{x:<11} Vreme{x:<8} Temperatura(°F)\n {x:-<44}".format(x=""))
    for kraj,vreme,temp in seznam:
        print(" {kraj:<15}{vreme:<25}{temp:>.1f}".format(kraj=kraj,vreme=vreme,temp=float(temp)*9/5 + 32))

def izpis_6(seznam):
    print(" Kraj{x:<11} Vreme{x:<8} Temperatura(°F)\n {x:-<44}".format(x=""))
    for kraj,vreme,temp in seznam:
        print(" {kraj:.<15}{vreme:.<25}{temp:>.1f}".format(kraj=kraj,vreme=vreme,temp=float(temp)*9/5 + 32))

def izpis_7(seznam):
    print(" Kraj{x:<11} Vreme{x:<12} Temperatura°F (°C)\n {x:-<51}".format(x=""))
    for kraj,vreme,temp in seznam:
        print(" {kraj:.<15}{vreme:.<25}{temp:>.1f} ({celz})".format(kraj=kraj,vreme=vreme,temp=float(temp)*9/5 + 32,celz=float(temp)))

def write_file(seznam):
    f = open(os.getcwd() + "\\vreme.txt" , mode="wt" , encoding="utf8")
    f.write(" Kraj{x:<11} Vreme{x:<12} Temperatura°F (°C)\n {x:-<51}".format(x=""))
    for kraj,vreme,temp in seznam:
        f.write(" {kraj:.<15}{vreme:.<25}{temp:>.1f} ({celz})".format(kraj=kraj,vreme=vreme,temp=float(temp)*9/5 + 32,celz=float(temp)))

# write_file(izpis_2())

def najdaljsa_beseda(s):
    max = 0
    besede = ""
    for el in s.split(" "):
        if len(el) > max:
            max = len(el)
    for el in s.split(" "):
        if len(el) == max:
            besede = besede + el + ","
    print (besede[:-1])

def plagiator():
    # Napišite program, ki ugotovi v katerih dveh datotekah se ponovi vsaj 1000 znakov.
    seznam = []
    for i in range(0,10):
        file = open(os.getcwd() + "\\datoteke\\" + str(i) + ".txt")
        seznam.append(file.read())
    for el in seznam:
        print (collections.Counter(el.strip(" ")))

plagiator()
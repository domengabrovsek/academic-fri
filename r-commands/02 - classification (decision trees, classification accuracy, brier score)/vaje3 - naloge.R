######################################################################################################
#
# IZPITNA NALOGA
#
# Klasifikator je bil testiran na dvorazrednem problemu in dosegel na testni mnozici naslednjo 
# matriko napak:
#
# +-----------------------+-----+-----+
# | Pravi \ Napov. razred |     |     |
# | razred \              |   0 |   1 |
# +-----------------------+-----+-----+
# | 0                     | 300 |   0 | 
# +-----------------------+-----+-----+
# | 1                     |  80 | 120 |
# +-----------------------+-----+-----+         
# 
# Izracunaj:
# 
# a) klasifikacijsko tocnost klasifikatorja
#
# b) pricakovano tocnost vecinskega klasifikatorja 
#    (predpostavi, da vecinski razred v testni mnozici je vecinski tudi v ucni mnozici)
#
# c) senzitivnost klasifikatorja
# 
# d) specificnost klasifikatorja
#
######################################################################################################

######################################################################################################
#
# IZPITNA NALOGA
#
# Klasifikator je na 4-razrednem problemu klasificiral pet testnih primerov. 
# V spodnji tabeli je podana napovedana verjetnostna distribucija po stirih razredih za vsakega od 
# petih testnih primerov:
#	             
# Pravi razred  | Napov. verjetnosti:  C1    C2    C3    C4
# --------------+------------------------------------------
#            C4 |                    0.65  0.25  0.00  0.10
#            C2 |                    0.20  0.55  0.25  0.00
#            C1 |                    0.75  0.00  0.25  0.00
#            C2 |                    0.25  0.50  0.00  0.25
#            C3 |                    0.10  0.10  0.60  0.20
#
# Predpostavi, da je verjetnostna distribucija po razredih v testni mnozici enaka 
# distribuciji v ucni mnozici. Izracunaj:
# 
# a) klasifikacijsko tocnost klasifikatorja 
# 
# b) pricakovano tocnost vecinskega klasifikatorja 
#   
# c) povprecno Brierjevo mero
#
######################################################################################################

#########################################################################################
#
# PRAKTICNE NALOGE
#
#########################################################################################
#
# Na podlagi podatkovne mnozice "movies.txt" zgradite model za
# napovedovanje, ali je dolocen film komedija ali ne.
#
# 1. Nalozite podatke o filmih iz vhodne datoteke "movies.txt"
#
# 2. Faktorizirajte atribute "Action", "Animation", "Comedy", "Drama", "Documentary", 
#    "Romance" in "Short"
#
# 3. POMEMBNO: 
#    - Iz podatkovne mnozice odstranite atribut "title" (neuporaben za generalizacijo)
#    - Iz podatkovne mnozice odstranite atribut "budget" (manjkajoce vrednosti)
#	
# 4. Razdelite podatkovno mnozico na ucni in testni del. Ucno mnozico naj predstavljajo 
#    filmi posneti pred letom 2004. Testno mnozico naj predstavljajo filmi posneti leta 
#    2004 in pozneje
#
# 5. Zgradite odlocitveno drevo na podlagi ucne mnozice 
# 
# 6. Ocenite kvaliteto naucenega modela na testni mnozici 
#    (klasifikacijska tocnost, senzitivnost, specificnost, Brierjeva mera)
#
#########################################################################################

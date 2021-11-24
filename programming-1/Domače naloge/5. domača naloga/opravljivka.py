besedilo = <"""Na vratih sta se prva pojavila Ana in Peter, menda "slučajno". Peter se je sicer več vrtel okrog Nives.
            Kasneje sta Ana in Peter skupaj sedela na klopci, vendar je bil zraven tudi Benjamin. Benjamin in Ana sta skupaj pila čaj.
            Peter in Tina sta tudi pila čaj. Peter in Ana pravzaprav tisti večer sploh nista bila več skupaj. Nives in Peter pa. Ja, Nives in Peter.
            Tina je bila kasneje ob ribniku takrat kot Benjamin, le na drugi strani. Sicer pa je Tina prejšnji teden rekla Nives, da ima Benjamin lep čop.
            Benjamin definitivno nima lepega čopa. Tone ga ima. Ampak Tone hodi z Nives. Kura. Ana in Tone bi bila za skupaj.
            Ne pa Tone in Nives."""

def poisci_imena(stavek):
    seznam = stavek.split()
    nov = []
    for beseda in seznam:
        if beseda[0].isupper():
            if beseda[-1] == ',':
                nov.append(beseda[:-1])
            else:
                nov.append(beseda)
    return nov

def poisci_pare(besedilo):
    pari = []
    stavki = besedilo.split(".")

    for stavek in stavki:
        par = poisci_imena(stavek)
        if len(par) == 2:
            pari.append(par)
        elif len(par) == 3:
            pari.append(par[1:])
    for el in pari:
        el.sort()
    return pari

def prestej_pare(besedilo):
    seznam_terk = []
    pari =  poisci_pare(besedilo)
    for par in pari:
        if (pari.count(par),par) not in seznam_terk:
            seznam_terk.append((pari.count(par),par))
    return seznam_terk

def razporedi(besedilo):
    pari = sorted(prestej_pare(besedilo),reverse=True)
    spremni = []
    zasedeni = []
    for el in pari:
        print(el[1])
        if el[1][0] not in zasedeni and el[1][1] not in zasedeni:
            spremni.append([el[1][0],el[1][1]])
            zasedeni.append(el[1][0])
            zasedeni.append(el[1][1])
    return spremni


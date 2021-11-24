otroci = {
    "Adam": ["Matjaž", "Cilka", "Daniel", "Erik"],
    "Aleksander": [],
    "Alenka": [],
    "Barbara": [],
    "Cilka": [],
    "Daniel": ["Elizabeta", "Hans"],
    "Erik": [],
    "Elizabeta": ["Ludvik", "Jurij", "Barbara", "Herman", "Mihael"],
    "Franc": [],
    "Herman": ["Margareta"],
    "Hans": [],
    "Jožef": ["Alenka", "Aleksander", "Petra"],
    "Jurij": ["Franc", "Jožef"],
    "Ludvik": [],
    "Margareta": [],
    "Matjaž": ["Viljem"],
    "Mihael": [],
    "Petra": [],
    "Tadeja": [],
    "Viljem": ["Tadeja"],
}

starost = {
    "Adam": 111, "Matjaž": 90, "Cilka": 88, "Daniel": 85, "Erik": 83,
    "Viljem": 58, "Tadeja": 20, "Elizabeta": 67, "Hans": 64, "Ludvik": 50,
    "Jurij": 49, "Barbara": 45, "Herman": 39, "Mihael": 32, "Franc": 30,
    "Jožef": 29, "Margareta": 10, "Alenka": 5, "Aleksander": 7, "Petra": 9}


def najmlajsi_clan(oseba):
    if len(otroci[oseba]) == 0:
        return (starost[oseba],oseba)
    else:
        najmanj = (starost[oseba],otroci[oseba])
        for otrok in otroci[oseba]:
            koliko = najmlajsi_clan(otrok)
            if koliko < najmanj:
                najmanj = koliko
        return najmanj

def mlajsi_od(oseba,n):
    mlajsi = set()
    for otrok in otroci[oseba]:
        if starost[otrok] < n:
            mlajsi.add(otrok)
        mlajsi = mlajsi.union(mlajsi_od(otrok,n))
    if starost[oseba] < n:
        mlajsi.add(oseba)
    return mlajsi


def naj_izmenicna_starost(oseba):
    najvecja = 0
    for otrok in otroci[oseba]:
        globina = naj_izmenicna_starost(otrok)
        if globina > najvecja and starost[otrok]%2 != starost[oseba]%2:
            najvecja = globina
    return najvecja + 1

print(naj_izmenicna_starost("Adam"))

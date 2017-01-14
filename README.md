# ChatDB #
## Avtorja: ##
* ### Domen Gabrovek (63140059) ###
* ### Simon Kovač (63140121) ###

## Zaslonska slika registracije / prijavnega zaslona: ##

![Screenshot_4.png](https://bitbucket.org/repo/Rdznax/images/1258969560-Screenshot_4.png)

## Zaslonska slika uporabniškega vmesnika: ##

![Screenshot_5.png](https://bitbucket.org/repo/Rdznax/images/1175728416-Screenshot_5.png)


## Kratek opis delovanja: ##

Aplikacija omogoča registracijo novega uporabnika, ki se lahko prijavi v aplikacijo in se sodeluje v pogovoru z ostalimi prijavljenimi uporabniki. Vsi uporabniki so shranjeni v podatkovni bazi. Pri registraciji mora vsak uporabniki vnesti svoje uporabniško ime (username), ime, priimek in geslo. Za prijavo v aplikacijo uporabi username in geslo. Ko se posamezni uporabniki prijavi se ustvari seja, ki je aktivna vse dokler se uporabnik ne odjavi iz aplikacije. Seja se izbriše tudi če ugasnemo aplikacijo. Seznam trenutno prijavljenih uporabnikov se hrani v aplikacijski spremenljivki, tako da vsi prijavljeni uporabniki lahko vidijo, kdo je poleg njih še prisoten.

## Kratek opis tezav pri izdelovanju ##

Tezave sva imela predvsem pri povezovanju aplikacije in podatkovne baze in pa pri sestavljanju "query stringov". Čeprav aplikacije vsebuje samo preproste SELECT in INSERT stavke za komunikacijo z bazo, nama je to povzročalo kar nekaj težav, saj se poizvedbe niso pravilno izvajale. Na koncu sva težave rešila s pomočjo uporabe stack overflowa in pa dokumentacije od .NET frameworka.

## Kratek opis moznih izboljsav: ##

- preprečevanje podvojenih uporabnikov v podatkovni bazi
- timestampi za vsako sporočilo, prijavljenega uporabnika, registriranega uporabnika

## Opis nalog, ki jih je izvedel posamezni student: ##

Domen Gabrovšek
- registracija / prijava GUI
- kreiranje bitbucket / GIT repozitorija
- preverjanje ustreznosti gesel in podatkov pri registraciji / prijavi

Simon Kovač
- kreiranje podatkovne baze
- povezava podatkovne baze in aplikacije

Skupinsko delo
- sql poizvedbe za shranjevanje/branje podatkov iz baze
- debugging in troubleshooting delovanja aplikacije


## Seznam dveh uporabnikov, ki sta shranjena v bazi in se lahko prijavita v aplikacijo: ##

username : password
administrator : ADMIN123!
test : TEST123!
# ServiceChat #
## Avtorja: ##
* ### Domen Gabrovek (63140059) ###
* ### Simon Kovač (63140121) ###

## Zaslonska slika administratorskega vmesnika: ##
![admin-panel.jpeg](https://bitbucket.org/repo/ExydLG/images/3714767854-admin-panel.jpeg)

## Zaslonska slika mobilne aplikacije ##
TODO

## Kratek opis delovanja: ##

Nadgradnja aplikacije ChatDB. Aplikacija je gostovana na spletni strani http://servicechat3.somee.com/Login.aspx. Vsebuje podatkovno bazo v kateri so shranjeni vsi registrirani uporabniki in vsi njihovi pogovori. Prav tako vsebuje mobilno aplikacijo, ki z spletno aplikacijo oz. podatkovno bazo komunicira s pomočjo REST storitev. Poleg vseh funkcionalnosti ChatDB, vsebuje tudi administratorsko ploščo, ki omogoča prijavo administratorju. Le ta lahko vidi za vsakega uporabnika, koliko sporočil je poslal in ali ima uporabnik administratorske pravice. Lahko mu pravice dodeli ali vzame, prav tako pa lahko uporabnika in vsa njegova sporočila zbriše. V podatkovni bazi sedaj hranimo podatek o tem ali ima uporabnik administratorske pravice in čas/datum za vsako sposlano sporočilo. 
[Optional] TODO Android App

## Kratek opis tezav pri izdelovanju ##

Tezave sva imela predvsem pri vzpostavitvi spletnih storitev in objavljanjem celotne aplikacije na spletni strani www.somee.com. Nekaj manjših težav, ki so se veliko ponavljale je bilo s sintakso in izvedbo poizvedb na bazi. To sva rešila s pomočje funkcije String.Format(), ki omogoča lepše formatiranje nizov za boljšo preglednost. Preprost problem, ki pa nama je vzel kar nekaj časa je bil, ko sva ročno vnašala uporabnike v bazo za namen testiranja. Prišlo je do tega, da je v hash funkcijo MD5 prišel presledek preveč, kar pomeni naslednje:

MD5(Geslo.01)  -> 775d9180bbd7d8354d13116c385e37e8
MD5(Geslo.01 ) -> b8b97a066f3f6731a03e386913ecd8c2

Presledek je bilo zelo težko najti, saj nama napaka oz. "stack trace" ni povedal nič uporabnega. Na koncu sva težave rešila s pomočjo "debuggerja", prosojnic na učilnici, stack overflowa in .NET dokumentacije. 

## Kratek opis moznih izboljsav: ##

- preprečevanje podvojenih uporabnikov v podatkovni bazi
- registracija samo z emailom
- blokiranje izbrisanih uporabnikov glede na IP, email ...
- možnost privatnega pogovora (uporabnik odpre pogovor samo za določene uporabnike)
- možnost pošiljanja slik, videov ... 
- možnost integracije z raznimi storitvami (Google services ...?)

## Opis nalog, ki jih je izvedel posamezni student: ##

**Domen Gabrovšek**
* izdelava računa in spletne strani na www.somee.com
* objava celotne aplikacije na www.somee.com, uvoz podatkovne baze
* nadgradnja uporabniškega vmesnika (gumb za prijavo administratorja + logika)
* izdelava administratorske plošče (GUI + logika)
* implementacija REST storitev
* kreiranje bitbucket / GIT repozitorija
* nadgradnja podatkovne baze (dodaten stolpec za preverjanje administratorskih pravic, dodaten stolpec za beleženje časa poslanega sporočila)

**Simon Kovač**
* izdelava Android odjemalca
* povezava Android odjemalca, REST storitev in spletne aplikacije

## Slika podatkovnega modela ##
![baza.png](https://bitbucket.org/repo/ExydLG/images/1394966401-baza.png)

## Opis podatkovnega modela ##

Podatkovni model vsebuje dve tabeli
- Uporabnik
- Pogovor

V tabeli Uporabnik se hranijo podatki o registriranih uporabnikih in sicer: uporabniški ime, ime, priimek in MD5 izvleček gesla. 
V tabeli Pogovor se hranijo podatki o vseh poslanih sporočilih in sicer: id sporočila, vsebina sporočila, pošiljatelj sporočila in čas poslanega sporočila.

Podatkovni model je narejen tako, da vsak uporabnik lahko pošlje več sporočil medtem ko eno sporočilo ne mora pripadati več kot le enemu uporabniku.
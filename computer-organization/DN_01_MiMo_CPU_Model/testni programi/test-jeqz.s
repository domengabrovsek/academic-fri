# program za testiranje ukaza jeqz (jump if equal to zero)

# r0 je vsota
# r1 je korak
# r2 je ustavitveni pogoj zanke

main:	li r0, 0
      li r1, 1
      li r2, 8

      # povecamo vsoto
loop: add r0, r0, r1

      # primerjamo r2 in r0
      # dokler je r0 manj od r2 bo and vrnil 0 in skocil na loop
      and r4, r0, r2

			# če je rezultat 0, potem nadaljujemo zanko
			jeqz r4, loop

# na koncu shranimo 15 v r6
li r6, 15
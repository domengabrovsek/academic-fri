# testni program za testiranje ukazov: add, sub, mul, div, rem, and, or, xor, nand, nor, not

# registri r0-r4 so uporabljeni za testiranje posameznih ukazov

main:	li	r0, 0x3A7B # 0011 1010 0111 1011 (14971)
		li	r1, 0x93DF # 1001 0011 1101 1111 (37855)

		# and
		and r4, r1, r2
		sw r4, 0x45

		# or
		or r4, r1, r2
		sw r4, 0x46

		# xor
		xor r4, r1, r2
		sw r4, 0x47

		# nand
		nand r4, r1, r2
		sw r4, 0x48

		# nor
		nor r4, r1, r2
		sw r4, 0x49

		# not
		# not r4, r1
		# sw r4, 0x50

		# lsl
		lsl r4, r2, r0
		sw r4, 0x4b // 6

		# lsr
		lsr r4, r2, r0
		sw r4, 0x4c // 1

		# asr
		lsr r4, r2, r0
		sw r4, 0x4d

		# rol
		rol r4, r2, r0
		sw r4, 0x4e

		# ror
		ror r4, r2, r0
		sw r4, 0x4f
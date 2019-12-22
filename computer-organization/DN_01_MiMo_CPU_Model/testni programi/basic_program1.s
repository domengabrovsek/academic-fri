# This program uses the instructions defined in the
# basic_microcode.def file. It counts down to 0 from 2
# and stores -1 in memory location 16.
# (c) GPL3 Warren Toomey, 2012
#

# registri r0-r3 so uporabljeni za testiranje posameznih ukazov
main:	li	r0, 1
		li	r1, 2
		li	r2, 3
		li	r3, -1

		# r0 - r3 -> r0 (0)
		add r0, r0, r3

		# if r0 == 0 then write r1 to 0x128
		jeqz r0, z
		
# zero
z:		sw r1, 128
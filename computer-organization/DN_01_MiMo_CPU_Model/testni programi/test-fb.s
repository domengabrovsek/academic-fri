main:	li r0, 32768
      li r1, 16384
      li r2, 8192
      li r3, 4096
      li r4, 2048
      li r5, 1024
      li r6, 512
      li r7, 256
      
      # 1. vrstica
      sw r0, 16384

      # 2. vrstica
      sw r1, 16385

      # 3. vrstica
      sw r2, 16386

      # 4. vrstica
      sw r3, 16387

      # 5. vrstica
      sw r4, 16388

      # 6. vrstica
      sw r5, 16389

      # 7. vrstica
      sw r6, 16390

      # 6. vrstica
      sw r7, 16391

# RAM - 000

# FB - 010
# 16384 - 0100 0000 0000 0000
# 16385 - 0100 0000 0000 0001
# 16386 - 0100 0000 0000 0010
# 16387 - 0100 0000 0000 0011
# 16388 - 0100 0000 0000 0100
# 16389 - 0100 0000 0000 0101
# 16390 - 0100 0000 0000 0110
# 16391 - 0100 0000 0000 0111

# TTY - 100
# 32768 - 1000 0000 0000 0000
# Versión lenta (sin tabla) - CRC-32 Estándar

.section .text
.global crc32_asm

crc32_asm:
    li t0, 0xFFFFFFFF      # Inicialización estándar
    beqz a1, fin
    add t4, a0, a1
lazo1:
    lbu t1, 0(a0)          # Carga byte de entrada (a0)
    addi a0, a0, 1         # Avanza puntero
    xor t0, t0, t1         # XOR con el byte actual
    li t2, 8               # Procesa 8 bits por byte
lazo2:
    srli t3, t0, 1         # Desplaza derecha 1 bit (LSB-first)
    andi t4, t0, 1         # Aísla el bit menos significativo (LSB)
    beqz t4, no_xor         # Si LSB es 0, salta
    li   t5, 0xEDB88320    # Polinomio revertido CRC-32 estándar
    xor  t3, t3, t5        # Aplica polinomio
no_xor:
    mv t0, t3              # Actualiza registro CRC
    addi t2, t2, -1        # Decrementa contador de bits
    bnez t2, lazo2     # Procesa los 8 bits
    addi a1, a1, -1        # Decrementa contador de bytes
    bnez a1, lazo1          # Siguiente byte
fin:
    not a0, t0             # Invierte bits finales
    ret
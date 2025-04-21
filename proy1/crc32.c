

#include "crc32.h"
#include <stdio.h>
#include <string.h>

void calculate_crc() {
    uint8_t buffer[31];
    printf("proy1 > CRC32\n");
    fgets((char*)buffer, 30, stdin);
    
    // Eliminar salto de línea
    size_t len = strlen((char*)buffer);
    if(len > 0 && buffer[len-1] == '\n')
        buffer[--len] = '\0';
    
    uint32_t result = crc32_asm(buffer, len);
    printf("%08x\n", result);
}
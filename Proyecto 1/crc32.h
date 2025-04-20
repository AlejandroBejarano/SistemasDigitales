


#ifndef CRC32_H
#define CRC32_H

#include <stdint.h>

// Declaración de la función que calculará el CRC32 en ensamblador
extern unsigned int crc32_asm(const unsigned char *data, unsigned int length);

// Función para obtener entrada y mostrar resultado
void calculate_and_display_crc32(void);

#endif
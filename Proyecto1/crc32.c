#include <stdint.h>  // Para uint8_t y uint32_t

// Tabla CRC32 pre-calculada (puedes generar o usar una fija como ejemplo)
static uint32_t crc32_table[256];

// Inicialización de la tabla CRC32 (esto sería necesario si no estás usando una tabla pre-calculada)
void crc32_init() {
    uint32_t poly = 0xedb88320;  // Polinomio estándar CRC32

    for (uint32_t i = 0; i < 256; i++) {
        uint32_t crc = i;
        for (uint32_t j = 8; j > 0; j--) {
            if (crc & 1)
                crc = (crc >> 1) ^ poly;
            else
                crc >>= 1;
        }
        crc32_table[i] = crc;
    }
}

// Función CRC32
uint32_t crc32j(uint8_t *data, uint32_t length) {
    uint32_t crc = 0xFFFFFFFF;  // Valor inicial CRC
    for (uint32_t i = 0; i < length; i++) {
        uint8_t byte = data[i];
        crc = (crc >> 8) ^ crc32_table[(crc ^ byte) & 0xFF];
    }
    return ~crc;  // Invertir los bits antes de retornar
}

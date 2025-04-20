# Proyecto 1: Implementación de CRC32 para textos de entrada
## EL3310 - Diseño de Sistemas Digitales
## Escuela de Ingeniería Electrónica

## Introducción 

El proyecto consiste en generar un código de detección de errores CRC32 (Comprobación de Redundancia Cíclica de 32 bits), el cual es usado para detectar cambios accidentales o errores en los datos durante la transmisión o el almacenamiento, para ello, se empleó el lenguaje ensamblador para RV32I, donde la idea es implementar el proyecto en un SoC (sistema en chip), creado con LiteX, en el cual se configura para que tenga un núcleo de RISC-V.

## Entorno de trabajo

Para el caso de los integrantes del proyecto, se trabajó con un subsistema de Windows para Linux (WSL), en donde se utilizó la distribución de Ubuntu 22.04 LTS, donde se instaló LiteX para la creación de SoC, con posibilidad de desplegar en una FPGA.


## Estructura de Archivos y sus Funciones
### crc32.h

Su función es ser el Header file, quiere decir que es un archivo de encabezado o archivo de cabecera, es un fichero que contiene principalmente declaraciones e interfaces, y no el cuerpo de las funciones.
Su función principal, es el permitir que múltiples unidades de compilación como módulos .c, .cpp o .asm, compartan información sobre tipos de datos, constantes y prototipos de funciones sin repetir código.
Declara dos funciones para calcular CRC-32: una en ensamblador (crc32_asm) que hace el cálculo real, y otra en C (calculate_and_display_crc32) que interactúa con el usuario. Las líneas iniciales evitan errores al incluir el archivo múltiples veces

```bash
#ifndef CRC32_H
#define CRC32_H

#include <stdint.h>

uint32_t crc32_asm(const uint8_t *data, uint32_t length, uint32_t crc);

#enddif
```

`uint32_t`, es un tipo de retorno, la función devuelve un entero sin signo de 32 bits, que es el resultante del CRC-32 tras procesar los datos.
`crc32_asm`, es el nombre de la función, asm por que está escrito en ensamblador, a nivel de linker (linker es un enlazador, conecta o enlaza todos los pedazos del programa, puede ser código, bibliotecas, ASM, con el que se forma un ejecutable final), será el símbolo que conecta la llamada desde C con la rutina en ASM.
`const uint8_t *data`, es un puntero a los datos  sobre los que se calcula el CRC, además "uint8_t", es un estándar para "byte" (8 bits), el "const" indica que la función no modificará el contenido de ese buffer (bloque de memoria que contiene datos).

`uint32_t length` es el número de bytes en el buffer "data" que deben procesarse.

`uint32_t crc` valor inicial del CRC, hace un cálculo incremental.

CRC significa Cyclic Redundancy Check, es un algoritmo que genera un valor de verificación para detectar errores en datos transmitidos o almacenados.


Lo que hace en conjunto es recorrer `length` bytes desde la dirección `data`. Para cada byte, actualiza al registro CRC de 32 bits según el polinomio CRC-32 (se basa en operaciones matemáticas con polinomios binarios). Devuelve el nuevo CRC tras procesar todo el bloque.

Al declarar algo en el header, otros módulos de C/C++ saben cómo llamar a `crc32_asm`, que parámetros dar y qué esperar, pero la implementación (cuerpo de la función) estará en un archivo .S o .asm.


### crc32.c
Este código en C implementa una interfaz para calcular y mostrar el CRC-32 de una cadena ingresada por el usuario:
Donde primero se declara una tabla de 256 entradas la cual se precalcula para acelerar el proceso del cálculo del CRC.
Después, se inicializa la tabla `crc32_table` con valores precalculados para cada byte por medio del `poly`, que es un polinomio estándar de CRC32.

```bash
#include <stdint.h>  

static uint32_t crc32_table[256];


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


```
En este primer bucle lo que hace es recorrer cada posible valor de byte (i) y luego aplica el algoritmo del CRC 8 veces porque va bit a bit, para al final guardarlo en la tabla que se inicializó.

```bash

// Función CRC32
uint32_t crc32j(uint8_t *data, uint32_t length) {
    uint32_t crc = 0xFFFFFFFF;  // Valor inicial CRC
    for (uint32_t i = 0; i < length; i++) {
        uint8_t byte = data[i];
        crc = (crc >> 8) ^ crc32_table[(crc ^ byte) & 0xFF];
    }
    return ~crc;  // Invertir los bits antes de retornar
}

```
En el segundo bucle lo que realiza es el cálculo del arreglo `data` de un tamaño `lengt`, además de iniciar el crc con el valor `0xFFFFFFFF`
Después recorre cada byte del arreglo y calcula un nuevo crc donde `crc>>8` elimina los 8 bits menos significativos y crc ^ byte` combina el byte actual con el crc previo y `& 0xFF` obtiene el byte menos significativo para después acceder a la tabla `crc32_table[...]` y por último `return ~crc;` que invierte el resultado final como parte del proceso para el CRC32.



### Makefile

Nombras los archivos objeto que se van a generar de la compilacion de los codigos fuente

```bash
OBJECTS=" crc32.o crc32_asm.o main.c crt0.o"
```

### crc32_asm.S
Este código implementa el cálculo CRC-32 estándar (polinomio 0xEDB88320) en ensamblador RISC-V mediante un procesamiento bit a bit sin tabla de consulta: inicializa el CRC en 0xFFFFFFFF, luego por cada byte del mensaje realiza un XOR y procesa sus 8 bits individualmente - aplicando el polinomio con XOR cuando el bit menos significativo es 1 y desplazando a la derecha - para finalmente invertir todos los bits (NOT) y obtener el resultado [1]. 


```bash
# Versión lenta (sin tabla) - CRC-32 Estándar

    li t0, 0xFFFFFFFF      # Inicialización estándar
    beqz a1, fin
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
```

A este código se le realizaron pruebas en RARS para una rápida comprobación de su funcionamiento, esto se observa en: 



A este código se le realizaron pruebas en RARS para una rápida comprobación de su funcionamiento, esto se observa en las siguientes imagenes:
![Rars1](proy1/Fotos/rars1.png)


Para realizar la comprobación se utilizó la palabra `hola` que en hexadecimal es `616c6f68`, esta se colocó en el data segment en RARS, que es una sección de "memoria" del programa.

![Rars2](proy1/Fotos/rars2.png)

Al escribir la palabra `hola` en "memoria" del programa, y identificando la dirección, está se escribió en el registro `a0`, y en el registro `a1` se le agrega la longitud de la palabra.

![Rars3](proy1/Fotos/rars3.png)


![Rars4](proy1/Fotos/rars4.png)

Al correr el código en el registro `ao` se observó el resultado final.

![Rars5](proy1/Fotos/rars5.png)

Además se utilizó la página `https://emn178.github.io/online-tools/crc/`, para realizar una comparación de resultados.

![Rarsprueb](proy1/Fotos/pruebaasm.png)




### Para compilar

Desde terminal en la carpeta `proy1`:
```bash
make clean
```
Para limpiar builds anteriores

```bash
./proy1.py --build-path=../build/sim
```
Para compilar un nuevo binario.

Ejecutar en Litex:
```bash
litex_sim --integrated-main-ram-size=0x10000 --cpu-type=vexriscv --ram-init=./proy1/proy1.bin
```

Si se crea un archivo de pruebas ejemplo: `prueba_crc.c`, se pueden hacer pruebas en C antes de Litex





## Referencias

[1] "CRC-32," Rosetta Code. [En línea]. Disponible en: https://rosettacode.org/wiki/CRC-32.

[2] D. A. Patterson and J. L. Hennessy, Computer Organization and Design RISC-V Edition: The Hardware/Software Interface, 2nd ed. Cambridge, MA, USA: Morgan Kaufmann, 2020.

[3] S. Harris and D. Harris, Digital Design and Computer Architecture: RISC-V Edition, 2nd ed. Cambridge, MA, USA: Morgan Kaufmann, 2022.

[4] Y. N. Patt and S. J. Patel, Introduction to Computing Systems: From Bits & Gates to C & Beyond, 3rd ed. New York, NY, USA: McGraw-Hill Education, 2019.

[5] D. Patterson and A. Waterman, Guía Práctica de RISC-V: El Atlas de una Arquitectura Abierta, 1st ed., ver. 1.0.5, transl. A. Lemus and E. Corpeño. RISC-V International, Jul. 2019.
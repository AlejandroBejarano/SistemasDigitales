PACKAGES=libc libcompiler_rt libbase libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata bios
PACKAGE_DIRS=/home/alejandrobejaro24/litex/litex/litex/soc/software/libc /home/alejandrobejaro24/litex/litex/litex/soc/software/libcompiler_rt /home/alejandrobejaro24/litex/litex/litex/soc/software/libbase /home/alejandrobejaro24/litex/litex/litex/soc/software/libfatfs /home/alejandrobejaro24/litex/litex/litex/soc/software/liblitespi /home/alejandrobejaro24/litex/litex/litex/soc/software/liblitedram /home/alejandrobejaro24/litex/litex/litex/soc/software/libliteeth /home/alejandrobejaro24/litex/litex/litex/soc/software/liblitesdcard /home/alejandrobejaro24/litex/litex/litex/soc/software/liblitesata /home/alejandrobejaro24/litex/litex/litex/soc/software/bios
LIBS=libc libcompiler_rt libbase libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata
TRIPLE=riscv64-unknown-elf
CPU=vexriscv
CPUFAMILY=riscv
CPUFLAGS=-march=rv32i2p0_m     -mabi=ilp32 -D__vexriscv__
CPUENDIANNESS=little
CLANG=0
CPU_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/cores/cpu/vexriscv
SOC_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc
PICOLIBC_DIRECTORY=/home/alejandrobejaro24/litex/pythondata-software-picolibc/pythondata_software_picolibc/data
PICOLIBC_FORMAT=integer
COMPILER_RT_DIRECTORY=/home/alejandrobejaro24/litex/pythondata-software-compiler_rt/pythondata_software_compiler_rt/data
export BUILDINC_DIRECTORY
BUILDINC_DIRECTORY=/home/alejandrobejaro24/SistemasDigitales-3/build/sim/software/include
LIBC_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/libc
LIBCOMPILER_RT_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/libcompiler_rt
LIBBASE_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/libbase
LIBFATFS_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/libfatfs
LIBLITESPI_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/liblitespi
LIBLITEDRAM_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/liblitedram
LIBLITEETH_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/libliteeth
LIBLITESDCARD_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/liblitesdcard
LIBLITESATA_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/liblitesata
BIOS_DIRECTORY=/home/alejandrobejaro24/litex/litex/litex/soc/software/bios
LTO=0
BIOS_CONSOLE_FULL=1
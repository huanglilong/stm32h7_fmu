set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Toolchain
set(COMPILER_PREFIX "arm-none-eabi")

# find arm-none-eabi binary
execute_process(
    COMMAND which ${COMPILER_PREFIX}-gcc
    OUTPUT_VARIABLE TOOLCHAIN_GCC_PATH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
# extract toolchain path
get_filename_component(TOOLCHAIN_PATH ${TOOLCHAIN_GCC_PATH} DIRECTORY)
message(STATUS "Toolchain path: ${TOOLCHAIN_PATH}")

# cmake-format: off
find_program(CMAKE_C_COMPILER NAMES ${COMPILER_PREFIX}-gcc HINTS ${TOOLCHAIN_BIN_PATH})
find_program(CMAKE_CXX_COMPILER NAMES ${COMPILER_PREFIX}-g++ HINTS ${TOOLCHAIN_BIN_PATH})
find_program(CMAKE_AR NAMES ${COMPILER_PREFIX}-ar HINTS ${TOOLCHAIN_BIN_PATH})
find_program(CMAKE_RANLIB NAMES ${COMPILER_PREFIX}-ranlib HINTS ${TOOLCHAIN_BIN_PATH})
find_program(CMAKE_LINKER NAMES ${COMPILER_PREFIX}-ld HINTS ${TOOLCHAIN_BIN_PATH})
find_program(CMAKE_ASM_COMPILER NAMES ${COMPILER_PREFIX}-gcc HINTS ${TOOLCHAIN_BIN_PATH})
find_program(CMAKE_OBJCOPY NAMES ${COMPILER_PREFIX}-objcopy HINTS ${TOOLCHAIN_BIN_PATH})
find_program(CMAKE_OBJDUMP NAMES ${COMPILER_PREFIX}-objdump HINTS ${TOOLCHAIN_BIN_PATH})
find_program(CMAKE_SIZE NAMES ${COMPILER_PREFIX}-size HINTS ${TOOLCHAIN_BIN_PATH})

# https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cmake-toolchains-7
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# STM32H743, Cortex-M7 with DP-FPU
set(CPU_FLAGS     "-mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard" CACHE STRING "" FORCE)
set(AC_HW_FLAGS   "${CPU_FLAGS} -pipe -isystem ${NUTTX_PATH}/include" CACHE STRING "" FORCE)

# find gcc library
execute_process(
    COMMAND ${CMAKE_C_COMPILER} -mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard -print-file-name=libgcc.a
    OUTPUT_VARIABLE LIBGCC
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
get_filename_component(LIBGCC_PATH ${LIBGCC} DIRECTORY)
message(STATUS "Library gcc path: ${LIBGCC_PATH}")

# linker flags
set(MCU_LINKER_SCRIPT "-T${NUTTX_PATH}/scripts/flash.ld")
set(AC_LINKER_FLAGS   "--entry=__start -nostdlib -nostdinc++ -L ${LIBGCC_PATH} ${MCU_LINKER_SCRIPT}")

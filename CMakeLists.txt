# ref: https://github.com/PX4/PX4-Autopilot
# ref: https://nuttx.apache.org/docs/latest/guides/cpp_cmake.html
cmake_minimum_required(VERSION 3.16)

# default board config
set(NUTTX_BOARD_CONFIG "fmu-h743vi" CACHE STRING "" FORCE)
message(STATUS "Board config: ${NUTTX_BOARD_CONFIG}")

# Nuttx Path
set(NUTTX_SRC_PATH "${CMAKE_SOURCE_DIR}/nuttx/nuttx" CACHE STRING "" FORCE)
set(NUTTX_EXPORT_PATH "${CMAKE_BINARY_DIR}/nuttx-export-10.4.0" CACHE STRING "" FORCE)

# Toolchain
set(CMAKE_TOOLCHAIN_FILE cmake/toolchain_arm_none_eabi.cmake)

# linker flags
set(MCU_LINKER_SCRIPT "${NUTTX_EXPORT_PATH}/scripts/flash.ld")

# Project
project(fmu_nuttx C CXX ASM)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Build Nuttx for external board configs
add_subdirectory(nuttx ${CMAKE_BINARY_DIR}/nuttx)
link_directories(${NUTTX_EXPORT_PATH}/libs)
include_directories(
    ${NUTTX_EXPORT_PATH}/include
    ${NUTTX_EXPORT_PATH}/arch/chip
)

# C++ and C flags
set(CMAKE_C_FLAGS       "${CMAKE_C_FLAGS} ${AC_HW_FLAGS}")
set(CMAKE_CXX_FLAGS     "${CMAKE_CXX_FLAGS} ${AC_HW_FLAGS}")

set(CMAKE_SKIP_RPATH ON)
set(BUILD_SHARED_LIBS OFF)

# generate binary
set(FMU_NAME ${PROJECT_NAME})
add_executable(${FMU_NAME} empty.cc)
# nuttx_export_libs: force build Nuttx first
add_dependencies(${FMU_NAME} nuttx_export_libs)
# add all Nuttx libraries
set(NUTTX_LIBS)
list(APPEND NUTTX_LIBS sched drivers boards c mm arch xx apps fs binfmt board gcc)

# same as '-Wl,--output=${FMU_NAME}.elf'
# set(FMU_NAME_ELF ${PROJECT_BINARY_DIR}/${FMU_NAME}.elf)
# set_target_properties(${FMU_NAME} PROPERTIES OUTPUT_NAME ${FMU_NAME_ELF})
target_link_libraries(${FMU_NAME}
        -nostartfiles
        -nodefaultlibs
        -nostdlib
        -nostdinc++
        -fno-exceptions
        -fno-rtti
        -Wl,--print-memory-usage
        -Wl,--script=${NUTTX_EXPORT_PATH}/scripts/flash.ld
        -Wl,-Map=${FMU_NAME}.map
        -Wl,--output=${FMU_NAME}.elf
        -Wl,--warn-common
        -Wl,--gc-sections
)
target_link_libraries(${FMU_NAME} -Wl,--start-group)
target_link_libraries(${FMU_NAME} ${NUTTX_LIBS})
# "LLVM low level C++ Library" to "GNU low level libsupc++"
# target_link_libraries(${FMU_NAME} supc++)
target_link_libraries(${FMU_NAME} -Wl,--end-group)

add_custom_command(
        TARGET ${FMU_NAME}
        POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} ARGS -S -O binary ${CMAKE_BINARY_DIR}/${FMU_NAME}.elf ${CMAKE_BINARY_DIR}/${FMU_NAME}.bin
)

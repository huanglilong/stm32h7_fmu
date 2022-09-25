# ref: https://github.com/PX4/PX4-Autopilot
# ref: https://nuttx.apache.org/docs/latest/guides/cpp_cmake.html
cmake_minimum_required(VERSION 3.16)

# default board config
set(NUTTX_BOARD_CONFIG "fmu-h743vi" CACHE STRING "" FORCE)
message(STATUS "Board config: ${NUTTX_BOARD_CONFIG}")

# Nuttx Path
set(NUTTX_SRC_PATH "${CMAKE_SOURCE_DIR}/nuttx/nuttx" CACHE STRING "" FORCE)
set(NUTTX_APP_PATH "${CMAKE_SOURCE_DIR}/nuttx/apps" CACHE STRING "" FORCE)

# Toolchain
set(CMAKE_TOOLCHAIN_FILE cmake/toolchain_arm_none_eabi.cmake)

# linker flags
set(MCU_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/scripts/flash.ld")

# cmake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# FMU libraries source files and paths
define_property(GLOBAL PROPERTY FMU_MODULE_LIBRARIES
        BRIEF_DOCS "FMU module libs"
        FULL_DOCS "List of all FMU module libraries"
)
define_property(GLOBAL PROPERTY FMU_MODULE_PATHS
        BRIEF_DOCS "FMU module paths"
        FULL_DOCS "List of all paths for FMU modules"
)
define_property(GLOBAL PROPERTY FMU_SRC_FILES
        BRIEF_DOCS "all source file for FMU modules and libs"
        FULL_DOCS "all source file from fmu_add_{module, library}"
)

# include cmakes
include(fmu_add_library)
include(fmu_add_module)
# all FMU modules and libraries
set(config_module_list)

# Project
project(fmu_nuttx C CXX ASM)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# C++ and C flags
set(CMAKE_C_FLAGS       "${CMAKE_C_FLAGS} ${AC_HW_FLAGS}")
set(CMAKE_CXX_FLAGS     "${CMAKE_CXX_FLAGS} ${AC_HW_FLAGS}")

set(CMAKE_SKIP_RPATH ON)
set(BUILD_SHARED_LIBS OFF)

# Build Nuttx for external board configs
add_subdirectory(nuttx ${CMAKE_BINARY_DIR}/nuttx)
include_directories(
    ${NUTTX_SRC_PATH}/include
    ${NUTTX_SRC_PATH}/include/cxx
    ${NUTTX_SRC_PATH}/arch/arm/src/armv7-m
    ${NUTTX_SRC_PATH}/arch/arm/src/chip
    ${NUTTX_SRC_PATH}/arch/arm/src/common
    ${NUTTX_APP_PATH}/include
)

# file(RELATIVE_PATH board_support_src_rel ${CMAKE_SOURCE_DIR}/src ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG})
# list(APPEND config_module_list ${board_support_src_rel}/src)
add_subdirectory(${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/src)
# Build all FMU Modules and libraries
foreach(module ${config_module_list})
        add_subdirectory(src/${module})
endforeach()

# generate binary
set(FMU_NAME ${PROJECT_NAME})
add_executable(${FMU_NAME} empty.cc)
# nuttx_export_libs: force build Nuttx first
# add_dependencies(${FMU_NAME} nuttx_export_libs)
# add all Nuttx libraries
set(NUTTX_LIBS)
list(APPEND NUTTX_LIBS nuttx_sched nuttx_drivers nuttx_boards nuttx_c nuttx_mm nuttx_arch nuttx_xx nuttx_apps nuttx_fs nuttx_binfmt)

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
        -Wl,--script=${MCU_LINKER_SCRIPT}
        -Wl,-Map=${FMU_NAME}.map
        -Wl,--output=${FMU_NAME}.elf
        -Wl,--warn-common
        -Wl,--gc-sections
)
target_link_libraries(${FMU_NAME} -Wl,--start-group)
target_link_libraries(${FMU_NAME} gcc)
target_link_libraries(${FMU_NAME} ${NUTTX_LIBS})
target_link_libraries(${FMU_NAME} drivers_board)
# "LLVM low level C++ Library" to "GNU low level libsupc++"
# target_link_libraries(${FMU_NAME} supc++)
target_link_libraries(${FMU_NAME} -Wl,--end-group)

add_custom_command(
        TARGET ${FMU_NAME}
        POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} ARGS -S -O binary ${CMAKE_BINARY_DIR}/${FMU_NAME}.elf ${CMAKE_BINARY_DIR}/${FMU_NAME}.bin
)

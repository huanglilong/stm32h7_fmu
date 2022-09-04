cmake_minimum_required(VERSION 3.2)

# Nuttx Path
set(NUTTX_PATH "${CMAKE_SOURCE_DIR}/nuttx-export-10.4.0")

# Toolchain
include(cmake/stm32f4discovery.cmake)

# Project
project(HelloCpp
        VERSION 1.0
        DESCRIPTION "Hello world for Nuttx!"
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_STANDARD 99)

# TODO build flags
set(AC_COMMON_FLAGS "${AC_COMMON_FLAGS} -Wall -Wshadow -Wundef -fno-strict-aliasing -Os")
set(AC_COMMON_FLAGS "${AC_COMMON_FLAGS} -D_DEBUG -D_LIBCPP_BUILD_STATIC -D_LIBCPP_NO_EXCEPTIONS ")
set(AC_COMMON_FLAGS "${AC_COMMON_FLAGS} -nostartfiles -nodefaultlibs -fno-exceptions -fcheck-new -fno-rtti -pedantic ")
set(AC_COMMON_FLAGS "${AC_COMMON_FLAGS} -nostdlib -nostdinc++")

# fix: https://github.com/apache/incubator-nuttx/issues/5530
set(AC_DEFINES "${AC_DEFINES} -D__NuttX__ -DCONFIG_WCHAR_BUILTIN")

include_directories(
    src
    ${NUTTX_PATH}/include
    ${NUTTX_PATH}/arch/chip
)

set(EXE_NAME hellocpp)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${AC_HW_FLAGS} ${AC_DEFINES}")
set(CMAKE_CXX_FLAGS     "${AC_HW_FLAGS} ${AC_DEFINES} ${AC_COMMON_FLAGS} ${AC_CXX_EXTRA_FLAGS}")
if (PARAM_DEBUG)
    set(CMAKE_CXX_FLAGS     "${CMAKE_CXX_FLAGS} -g")
endif()

set(CMAKE_SKIP_RPATH ON)
set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_LINKER} ${AC_LINKER_FLAGS} -o ${EXE_NAME}.elf <OBJECTS> <LINK_LIBRARIES>")
set(BUILD_SHARED_LIBS OFF)
add_subdirectory(src)

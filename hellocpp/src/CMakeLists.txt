set(H_FILES hello_world.h)

set(S_FILES hello_world.cc)

link_directories(${EXE_NAME} ${NUTTX_PATH}/libs)

add_executable(${EXE_NAME} ${S_FILES} main.cc ${H_FILES})

add_custom_command(
        TARGET ${EXE_NAME}
        POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} ARGS -S -O binary ${CMAKE_BINARY_DIR}/${EXE_NAME}.elf ${CMAKE_BINARY_DIR}/${EXE_NAME}.bin
)

target_link_libraries(${EXE_NAME} --start-group)

target_link_libraries(${EXE_NAME} sched)
target_link_libraries(${EXE_NAME} drivers)
target_link_libraries(${EXE_NAME} boards)
target_link_libraries(${EXE_NAME} c)
target_link_libraries(${EXE_NAME} mm)
target_link_libraries(${EXE_NAME} arch)
target_link_libraries(${EXE_NAME} xx)
target_link_libraries(${EXE_NAME} apps)
target_link_libraries(${EXE_NAME} fs)
target_link_libraries(${EXE_NAME} binfmt)
target_link_libraries(${EXE_NAME} board)
target_link_libraries(${EXE_NAME} gcc)
# "LLVM low level C++ Library" to "GNU low level libsupc++"
target_link_libraries(${EXE_NAME} supc++)

target_link_libraries(${EXE_NAME} --end-group)
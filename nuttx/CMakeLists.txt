# Build Nuttx
# Ref: PX4 platforms/nuttx/NuttX/CMakeLists.txt

# config Nuttx
add_custom_command(
      OUTPUT ${NUTTX_SRC_PATH}/.config
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/scripts/Make.defs ${NUTTX_SRC_PATH}/Make.defs
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/configs/nsh/defconfig ${NUTTX_SRC_PATH}/defconfig
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/configs/nsh/defconfig ${NUTTX_SRC_PATH}/.config
      COMMAND make olddefconfig
      DEPENDS
        ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/scripts/Make.defs
        ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/configs/nsh/defconfig
      WORKING_DIRECTORY ${NUTTX_SRC_PATH}
)

# Build Nuttx and generates nuttx-export-10.4.0 directory
add_custom_command(
      OUTPUT ${CMAKE_BINARY_DIR}/nuttx-export-10.4.0
      COMMAND make
      COMMAND make export
      COMMAND tar -xzf ${NUTTX_SRC_PATH}/nuttx-export-10.4.0.tar.gz -C ${CMAKE_BINARY_DIR}
      DEPENDS
        ${NUTTX_SRC_PATH}/.config
      WORKING_DIRECTORY ${NUTTX_SRC_PATH}
)
add_custom_target(nuttx_export_libs DEPENDS ${CMAKE_BINARY_DIR}/nuttx-export-10.4.0)

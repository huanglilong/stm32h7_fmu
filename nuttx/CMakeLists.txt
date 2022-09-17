# Build Nuttx
# Ref: PX4 platforms/nuttx/NuttX/CMakeLists.txt

# Config Nuttx
add_custom_command(
      OUTPUT ${NUTTX_SRC_PATH}/.config
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/scripts/Make.defs ${NUTTX_SRC_PATH}/Make.defs
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/configs/nsh/defconfig ${NUTTX_SRC_PATH}/.config
      COMMAND make olddefconfig
      DEPENDS
        ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/scripts/Make.defs
        ${CMAKE_SOURCE_DIR}/boards/${NUTTX_BOARD_CONFIG}/configs/nsh/defconfig
      COMMENT "Board configuration for Nuttx."
      WORKING_DIRECTORY ${NUTTX_SRC_PATH}
)

# Build and export Nuttx
add_custom_command(
      OUTPUT ${CMAKE_BINARY_DIR}/nuttx-export-10.4.0.tar.gz
      COMMAND make --no-print-directory --silent
      COMMAND make export --no-print-directory --silent
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${NUTTX_SRC_PATH}/nuttx-export-10.4.0.tar.gz ${CMAKE_BINARY_DIR}
      COMMENT "Build and export Nuttx."
      DEPENDS
        ${NUTTX_SRC_PATH}/.config
      WORKING_DIRECTORY ${NUTTX_SRC_PATH}
)

# Extract and distclean Nuttx
add_custom_command(
      OUTPUT  ${CMAKE_BINARY_DIR}/nuttx-export-10.4.0
      COMMAND tar -xzf ${NUTTX_SRC_PATH}/nuttx-export-10.4.0.tar.gz -C ${CMAKE_BINARY_DIR}
      # TODO(llhuang) COMMAND make distclean -C ${NUTTX_SRC_PATH}
      COMMENT "Extract and distclean Nuttx."
      DEPENDS
        ${CMAKE_BINARY_DIR}/nuttx-export-10.4.0.tar.gz
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# Build Nuttx
add_custom_target(nuttx_export_libs DEPENDS ${CMAKE_BINARY_DIR}/nuttx-export-10.4.0)

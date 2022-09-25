# PX4: cmake/px4_add_library.cmake

#=============================================================================
#
#	fmu_add_library
#
#	Like add_library but with FMU platform dependencies
#

include(fmu_list_make_absolute)

function(fmu_add_library target)
  add_library(${target} EXCLUDE_FROM_ALL ${ARGN})
  target_compile_definitions(${target} PRIVATE MODULE_NAME="${target}")
  # all FMU libraries have access to parameters and uORB
	# add_dependencies(${target} uorb_headers parameters)
	# target_link_libraries(${target} PRIVATE prebuild_targets)

  set_property(GLOBAL APPEND PROPERTY FMU_MODULE_PATHS ${CMAKE_CURRENT_SOURCE_DIR})
  fmu_list_make_absolute(ABS_SRCS ${CMAKE_CURRENT_SOURCE_DIR} ${ARGN})
  set_property(GLOBAL APPEND PROPERTY FMU_SRC_FILES ${ABS_SRCS})
endfunction()

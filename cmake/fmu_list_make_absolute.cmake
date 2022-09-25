# Ref: PX4

# cmake include guard
if(fmu_list_make_absolute_included)
  return()
endif()
set(fmu_list_make_absolute_included true)

#=============================================================================
#
#	fmu_list_make_absolute
#
#	prepend a prefix to each element in a list, if the element is not an abolute
#	path
#

# convert file path to absolute path
function(fmu_list_make_absolute var prefix)
  set(list_var "")
  foreach(f ${ARGN})
    if(IS_ABSOLUTE ${f})
      list(APPEND list_var "${f}")
    else()
      list(APPEND list_var "${prefix}/${f}")
    endif()
  endforeach()
  set(${var} "${list_var}" PARENT_SCOPE)
endfunction()

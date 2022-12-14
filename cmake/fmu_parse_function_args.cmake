# Ref: PX4

#=============================================================================
#
#	px4_parse_function_args
#
#	This function simplifies usage of the cmake_parse_arguments module.
#	It is intended to be called by other functions.
#
#	Usage:
#		px4_parse_function_args(
#			NAME <name>
#			[ OPTIONS <list> ]
#			[ ONE_VALUE <list> ]
#			[ MULTI_VALUE <list> ]
#			REQUIRED <list>
#			ARGN <ARGN>)
#
#	Input:
#		NAME		: the name of the calling function
#		OPTIONS		: boolean flags
#		ONE_VALUE	: single value variables
#		MULTI_VALUE	: multi value variables
#		REQUIRED	: required arguments
#		ARGN		: the function input arguments, typically ${ARGN}
#
#	Output:
#		The function arguments corresponding to the following are set:
#		${OPTIONS}, ${ONE_VALUE}, ${MULTI_VALUE}
#
#	Example:
#		function test()
#			px4_parse_function_args(
#				NAME TEST
#				ONE_VALUE NAME
#				MULTI_VALUE LIST
#				REQUIRED NAME LIST
#				ARGN ${ARGN})
#			message(STATUS "name: ${NAME}")
#			message(STATUS "list: ${LIST}")
#		endfunction()
#
#		test(NAME "hello" LIST a b c)
#
#		OUTPUT:
#			name: hello
#			list: a b c
#

# cmake include guard
if(fmu_parse_function_args_included)
  return()
endif()
set(px4_parse_function_args_included true)

include(CMakeParseArguments)
function(fmu_parse_function_args)
  cmake_parse_arguments(IN "" "NAME" "OPTIONS;ONE_VALUE;MULTI_VALUE;REQUIRED;ARGN" "${ARGN}")
  cmake_parse_arguments(OUT "${IN_OPTIONS}" "${IN_ONE_VALUE}" "${IN_MULTI_VALUE}" "${IN_ARGN}")
  # unparsed args
  if(OUT_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "${IN_NAME}: unparsed ${OUT_UNPARSED_ARGUMENTS}")
  endif()
  # required args
  foreach(arg ${IN_REQUIRED})
    if(NOT OUT_${arg})
      if(NOT "${OUT_${arg}}" STREQUAL "0")
        message(FATAL_ERROR "${IN_NAME} requires argument ${arg}\nARGN: ${IN_ARGN}")
      endif()
    endif()
  endforeach()
  # return all args
  foreach(arg ${IN_OPTIONS} ${IN_ONE_VALUE} ${IN_MULTI_VALUE})
    set(${arg} ${OUT_${arg}} PARENT_SCOPE)
  endforeach()
endfunction()

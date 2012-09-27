#
#  Generated from roslisp/cmake/roslisp-extras.cmake.in
#

if(roslisp_SOURCE_DIR)
  find_program_required(ROSLISP_MAKE_NODE_BIN make_node_exec PATHS
    ${roslisp_SOURCE_DIR}/scripts)
else()
  find_program_required(ROSLISP_MAKE_NODE_BIN make_node_exec PATHS
    /opt/ros/groovy/share/common-lisp/ros/roslisp/scripts)
endif()

# Build up a list of executables, in order to make them depend on each
# other, to avoid building them in parallel, because it's not safe to do
# that.
if(NOT ${ROSLISP_EXECUTABLES})
  set(${ROSLISP_EXECUTABLES})
endif()

macro(rosbuild_add_lisp_executable _output _system_name _entry_point)
  set(_targetname _roslisp_${_output})
  string(REPLACE "/" "_" _targetname ${_targetname})
  # Add dummy custom command to get make clean behavior right.
  add_custom_command(OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/${_output} ${CMAKE_CURRENT_SOURCE_DIR}/${_output}.lisp
    COMMAND echo -n)
  add_custom_target(${_targetname} ALL
                     DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_output} ${CMAKE_CURRENT_SOURCE_DIR}/${_output}.lisp
                     COMMAND ${roslisp_make_node_exe} ${PROJECT_NAME} ${_system_name} ${_entry_point} ${CMAKE_CURRENT_SOURCE_DIR}/${_output})
  # Make this executable depend on all previously declared executables, to
  # serialize them.
  add_dependencies(${_targetname} rosbuild_precompile ${roslisp_executables})
  # Add this executable to the list of executables on which all future
  # executables will depend.
  list(APPEND ROSLISP_EXECUTABLES ${_targetname})
endmacro(rosbuild_add_lisp_executable)

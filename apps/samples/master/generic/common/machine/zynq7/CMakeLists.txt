collect (APP_SOURCES platform_info.c)
collect (APP_INC_DIRS ${CMAKE_CURRENT_SOURCE_DIR})
collect (APP_INC_DIRS ${OPENAMP_ROOT_DIR}/obsolete/system/zynq7/generic)

set (_linker_script "${APP_LINKER_SCRIPT}")
if ("${_linker_script}" STREQUAL "")
  set (_linker_script "${CMAKE_CURRENT_SOURCE_DIR}/linker_${PROJECT_ROLE}.ld")
endif ("${_linker_script}" STREQUAL "")
set_property (GLOBAL PROPERTY APP_LINKER_SCRIPT "${_linker_script}")

set (_app "echo_test")
set (_cflags "${CMAKE_C_FLAGS} ${APP_EXTRA_C_FLAGS}")

collector_list (_list APP_INC_DIRS)
include_directories (${_list} ${CMAKE_CURRENT_SOURCE_DIR})

collector_list (_list APP_LIB_DIRS)
link_directories (${_list})

collector_list (_list APP_SOURCES)
list (APPEND _list "${CMAKE_CURRENT_SOURCE_DIR}/echo_test.c")
add_executable (${_app}.out ${_list})

set_source_files_properties(${_list} PROPERTIES COMPILE_FLAGS "${_cflags}")

get_property (_linker_script GLOBAL PROPERTY APP_LINKER_SCRIPT)
get_property (_deps GLOBAL PROPERTY APP_LIB_DEPS)
set (_deps "${_deps} ${PLATFORM_LIB_DEPS}")
string (STRIP "${_deps}" _deps)
target_link_libraries(${_app}.out -Wl,-Map=${_app}.map -Wl,--gc-sections -T\"${_linker_script}\" -Wl,--start-group ${_deps} -Wl,--end-group)

install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${_app}.out DESTINATION bin)

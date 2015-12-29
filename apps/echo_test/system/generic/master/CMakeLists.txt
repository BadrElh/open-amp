set (_app "echo_test")
set (_cflags "${CMAKE_C_FLAGS} ${APP_EXTRA_C_FLAGS}")
set (_fw_dir "${APP_ROOT}/firmware")

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
set (_deps "${_deps} -lstdc++ ${PLATFORM_LIB_DEPS}")
string (STRIP "${_deps}" _deps)
target_link_libraries(${_app}.out -Wl,-Map=${_app}.map -Wl,--gc-sections -T\"${_linker_script}\" -Wl,--start-group ${_fw_dir}/firmware1.o ${_fw_dir}/firmware2.o ${_deps} -Wl,--end-group)

add_custom_target (${_app}.bin ALL
  ${CROSS_PREFIX}objcopy -O binary ${_app}.out ${_app}.bin
  DEPENDS ${_app}.out)

add_dependencies (${_app}.out ${_fw_dir}/firmware1.o ${_fw_dir}/firmware2.o)

install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${_app}.bin DESTINATION bin)

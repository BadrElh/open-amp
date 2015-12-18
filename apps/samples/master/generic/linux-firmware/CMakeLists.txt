
file (GLOB _c_srcs *.c)
file (GLOB _asm_srcs *.S *.s)

include_directories (${CMAKE_CURRENT_SOURCE_DIR})

add_executable (firmware-lnx ${_c_srcs} ${_asm_srcs})

set (_cflags "${CMAKE_C_FLAGS}")
set_source_files_properties(${_asm_srcs} PROPERTIES COMPILE_FLAGS "${_cflags}")

target_link_libraries(firmware-lnx -nostartfiles -T\"${CMAKE_CURRENT_SOURCE_DIR}/link_remote.ld\" -L\"${CMAKE_CURRENT_SOURCE_DIR}/lib/${CROSS_PREFIX}\" -Wl,--start-group -lc -lm -lstdc++ -lzlib -lfdt -Wl,--end-group)

add_dependencies (firmware-lnx image.ub)

add_custom_command (OUTPUT image.ub
  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/image.ub image.ub)

add_custom_target (lnx-fw-bin-gen ALL
  DEPENDS firmware-lnx firmware1.o firmware2.o)

add_custom_target (firmware1.o ALL cp firmware-lnx firmware1
  COMMAND ${CROSS_PREFIX}objcopy -I binary -O elf32-littlearm -B arm firmware1 firmware1.o
  DEPENDS firmware-lnx)

add_custom_target (firmware2.o ALL cp firmware-lnx firmware2
  COMMAND ${CROSS_PREFIX}objcopy -I binary -O elf32-littlearm -B arm firmware2 firmware2.o
  DEPENDS firmware-lnx)

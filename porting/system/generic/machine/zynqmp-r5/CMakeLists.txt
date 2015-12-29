
if ("${PROJECT_ROLE}" STREQUAL "master")
  set (_ecflags "-D\"BAREMETAL_MASTER=1\"")
else ("${PROJECT_ROLE}" STREQUAL "master")
  set (_ecflags "-D\"BAREMETAL_MASTER=0\"")
endif ("${PROJECT_ROLE}" STREQUAL "master")

set_property (GLOBAL APPEND_STRING PROPERTY "PROJECT_LIB_EXTRA_CFLAGS" "${_ecflags}")

collect (PROJECT_LIB_SOURCES baremetal.c)


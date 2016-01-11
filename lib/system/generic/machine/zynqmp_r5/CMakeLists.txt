
if (WITH_REMOTEPROC_MASTER)
  set (_ecflags "-D\"BAREMETAL_MASTER=1\"")
else (WITH_REMOTEPROC_MASTER)
  set (_ecflags "-D\"BAREMETAL_MASTER=0\"")
endif (WITH_REMOTEPROC_MASTER)

set_property (GLOBAL APPEND_STRING PROPERTY "PROJECT_LIB_EXTRA_CFLAGS" "${_ecflags}")

collect (PROJECT_LIB_SOURCES machine.c)
collect (PROJECT_LIB_SOURCES remoteproc_zynqmp.c)


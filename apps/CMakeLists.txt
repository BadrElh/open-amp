collector_create (APP_SOURCES "")
collector_create (APP_LIB_DIRS "")
collector_create (APP_INC_DIRS "")
collect (APP_LIB_DIRS "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
collect (APP_INC_DIRS "${OPENAMP_ROOT_DIR}/include")
collect (APP_INC_DIRS "${OPENAMP_ROOT_DIR}/include/porting/system/${PROJECT_SYSTEM}/machine/${PROJECT_MACHINE}")

set_property (GLOBAL PROPERTY APP_LIB_DEPS "-lopen_amp")
add_subdirectory (samples)

# vim: expandtab:ts=2:sw=2:smartindent

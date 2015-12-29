collector_create (APP_SOURCES "")
collector_create (APP_LIB_DIRS "")
collector_create (APP_INC_DIRS "")
collect (APP_LIB_DIRS "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
collect (APP_INC_DIRS "${OPENAMP_ROOT_DIR}/include")
collect (APP_INC_DIRS "${OPENAMP_ROOT_DIR}/include/porting/system/${PROJECT_SYSTEM}/machine/${PROJECT_MACHINE}")

set_property (GLOBAL PROPERTY APP_LIB_DEPS "-lopen_amp")

set (APP_ROOT "${CMAKE_CURRENT_BINARY_DIR}")
set (APP_BIN_DIR "${CMAKE_CURRENT_BINARY_DIR}/bin")

option (WITH_ECHO_TEST "Include echo test" ON)
option (WITH_MATRIX_MULTIPLY "Include matrix multiply" ON)
option (WITH_RPC_DEMO "Include proxy app demo" ON)
option (WITH_FUNCTION_TEST_SUITE "Include function test suite" OFF)
option (WITH_LINUX_FIRMWARE "Include Linux firmware" OFF)

add_subdirectory (common)

if (WITH_LINUX_FIRMWARE)
  add_subdirectory (linux-firmware)
endif (WITH_LINUX_FIRMWARE)

if (WITH_ECHO_TEST)
  add_subdirectory (echo_test)
endif (WITH_ECHO_TEST)

if (WITH_MATRIX_MULTIPLY)
  add_subdirectory (matrix_multiply)
endif (WITH_MATRIX_MULTIPLY)

if (WITH_RPC_DEMO)
  add_subdirectory (rpc_demo)
endif (WITH_RPC_DEMO)

if (WITH_FUNCTION_TEST_SUITE)
  add_subdirectory (func_test_suite)
endif (WITH_FUNCTION_TEST_SUITE)



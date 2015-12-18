set (PROJECT_VER_MAJOR  0)
set (PROJECT_VER_MINOR  1)
set (PROJECT_VER_PATCH  0)
set (PROJECT_VER        0.1.0)

if (NOT CMAKE_BUILD_TYPE)
  set (CMAKE_BUILD_TYPE Debug)
endif (NOT CMAKE_BUILD_TYPE)

set (_host "${CMAKE_HOST_SYSTEM_NAME}/${CMAKE_HOST_SYSTEM_PROCESSOR}")
message ("-- Host:    ${_host}")

set (_target "${CMAKE_SYSTEM_NAME}/${CMAKE_SYSTEM_PROCESSOR}")
message ("-- Target:  ${_target}")

if (NOT DEFINED MACHINE)
  set (MACHINE "Generic")
endif (NOT DEFINED MACHINE)
message ("-- Machine: ${MACHINE}")

string (TOLOWER ${CMAKE_SYSTEM_NAME}      PROJECT_SYSTEM)
string (TOUPPER ${CMAKE_SYSTEM_NAME}      PROJECT_SYSTEM_UPPER)
string (TOLOWER ${CMAKE_SYSTEM_PROCESSOR} PROJECT_PROCESSOR)
string (TOUPPER ${CMAKE_SYSTEM_PROCESSOR} PROJECT_PROCESSOR_UPPER)
string (TOLOWER ${MACHINE}                PROJECT_MACHINE)
string (TOUPPER ${MACHINE}                PROJECT_MACHINE_UPPER)

option (WITH_STATIC_LIB "Build with a static library" ON)

if ("${PROJECT_SYSTEM}" STREQUAL "linux")
  option (WITH_SHARED_LIB "Build with a shared library" ON)
  option (WITH_TESTS      "Install test applications" ON)
endif ("${PROJECT_SYSTEM}" STREQUAL "linux")

if (WITH_TESTS AND (${_host} STREQUAL ${_target}))
  option (WITH_TESTS_EXEC "Run test applications during build" ON)
endif (WITH_TESTS AND (${_host} STREQUAL ${_target}))

# Set if the OpenAMP role is remote or master
if (NOT DEFINED PROJECT_ROLE)
  set (PROJECT_ROLE "remote")
endif (NOT DEFINED PROJECT_ROLE)
message ("-- Role: ${PROJECT_ROLE}")

# Select which components are in the openamp lib
option (WITH_VIRTIO         "Build with virtio" ON)
option (WITH_RPMSG          "Build with rpmsg" ON)
option (WITH_REMOTEPROC     "Build with remoteproc" ON)
option (WITH_PROXY          "Build with proxy(access device controlled by other processor)" ON)
if ("${PROJECT_ROLE}" STREQUAL "master")
  option (WITH_LINUXREMOTE  "The remote is Linux" ON)
endif ("${PROJECT_ROLE}" STREQUAL "master")
option (WITH_APPS           "Build with sample applicaitons" OFF)
if (WITH_APPS)
  option (WITH_BENCHMARK    "Build benchmark app" OFF)
endif (WITH_APPS)
option (WITH_OBSOLETE       "Build obsolete system libs" OFF)

# Set the complication flags
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra")

if ("${PROJECT_ROLE}" STREQUAL "master")
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D\"MASTER=1\"")
else ("${PROJECT_ROLE}" STREQUAL "master")
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D\"MASTER=0\"")
endif ("${PROJECT_ROLE}" STREQUAL "master")

if (WITH_LINUXREMOTE)
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DOPENAMP_REMOTE_LINUX_ENABLE")
endif (WITH_LINUXREMOTE)

if (WITH_BENCHMARK)
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DOPENAMP_BENCHMARK_ENABLE")
endif (WITH_BENCHMARK)

message ("-- C_FLAGS : ${CMAKE_C_FLAGS}")
# vim: expandtab:ts=2:sw=2:smartindent
